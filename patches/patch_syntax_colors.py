#!/usr/bin/env python3
"""
Patch syntax-highlight colors in SyntaxHighlightLabelView.class inside the OculiX IDE JAR.

The class hard-codes light-mode colours for keyword and string tokens.
On a dark background (#0A1028) these are barely readable:
  - Keywords: rgb(128, 0, 0)  #800000  dark red
  - Strings:  rgb(128, 64, 0) #804000  dark brown

This script replaces them with dark-theme-friendly colours using same-size
byte sequences so no JVM offset tables (exception handlers, line numbers,
stack-map frames) need to be rewritten.

Replacements:
  Keywords: rgb(128,0,0)  → rgb(0,0,246)   #0000F6  vivid blue
  Strings:  rgb(128,64,0) → rgb(210,120,0) #D27800  golden amber

Encoding verification (all same byte counts):
  sipush 128  iconst_0    iconst_0    = 0x11 0x00 0x80  0x03  0x03  (5 bytes)
  iconst_0    iconst_0    sipush 246  = 0x03  0x03  0x11 0x00 0xF6  (5 bytes) ✓

  sipush 128  bipush 64   iconst_0    = 0x11 0x00 0x80  0x10 0x40  0x03  (6 bytes)
  sipush 210  bipush 120  iconst_0    = 0x11 0x00 0xD2  0x10 0x78  0x03  (6 bytes) ✓
"""

import sys
import zipfile
import shutil
import os

ENTRY = "org/sikuli/ide/SyntaxHighlightLabelView.class"

# Before → after byte sequences (R, G, B push instructions only)
PATCHES = [
    # Keywords: rgb(128,0,0) dark red  →  rgb(0,0,246) vivid blue
    (
        bytes([0x11, 0x00, 0x80, 0x03, 0x03]),
        bytes([0x03, 0x03, 0x11, 0x00, 0xF6]),
        "keyword red→blue",
    ),
    # Strings: rgb(128,64,0) dark brown  →  rgb(210,120,0) golden amber
    (
        bytes([0x11, 0x00, 0x80, 0x10, 0x40, 0x03]),
        bytes([0x11, 0x00, 0xD2, 0x10, 0x78, 0x03]),
        "string brown→amber",
    ),
]

# Expected occurrences of each pattern (2 per colour: Python + SikuliX keywords)
EXPECTED_COUNT = 2


def patch_class(data: bytes) -> bytes:
    for old, new, label in PATCHES:
        assert len(old) == len(new), f"Patch {label}: byte lengths differ!"
        count = data.count(old)
        if count != EXPECTED_COUNT:
            print(
                f"  WARNING: {label} — expected {EXPECTED_COUNT} occurrences, "
                f"found {count}. Skipping this patch.",
                file=sys.stderr,
            )
            continue
        data = data.replace(old, new)
        print(f"  Patched {count}x {label}")
    return data


def main():
    if len(sys.argv) != 2:
        print(f"Usage: {sys.argv[0]} <path-to-oculixide-jar>", file=sys.stderr)
        sys.exit(1)

    jar_path = sys.argv[1]
    tmp_path = jar_path + ".patching"

    with zipfile.ZipFile(jar_path, "r") as zin:
        if ENTRY not in zin.namelist():
            print(f"ERROR: {ENTRY} not found in {jar_path}", file=sys.stderr)
            sys.exit(1)

        original = zin.read(ENTRY)
        patched = patch_class(original)

        if patched == original:
            print("  No changes made (patterns not found or already patched).")
            return

        # Rewrite the JAR, replacing the patched class entry cleanly
        with zipfile.ZipFile(tmp_path, "w", compression=zipfile.ZIP_DEFLATED) as zout:
            for item in zin.infolist():
                if item.filename == ENTRY:
                    zout.writestr(item, patched)
                else:
                    zout.writestr(item, zin.read(item.filename))

    os.replace(tmp_path, jar_path)
    print(f"  {jar_path} updated.")


if __name__ == "__main__":
    main()
