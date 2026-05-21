#!/usr/bin/env python3
"""
Patch syntax-highlight colors in SyntaxHighlightLabelView.class inside the OculiX IDE JAR.

The class hard-codes light-mode colours for all token types.
On a dark background (#0A1028) these are unreadable:
  - Keywords:    rgb(128,  0,  0)  #800000  dark red
  - Strings:     rgb(128, 64,  0)  #804000  dark brown
  - Identifiers: rgb( 63,127,127)  #3F7F7F  dark teal

This script replaces them with dark-theme-friendly colours using same-size
byte sequences so no JVM offset tables (exception handlers, line numbers,
stack-map frames) need to be rewritten.

Replacements:
  Keywords:    rgb(128,  0,  0) → rgb(  0,200,  0) #00C800  bright green
  Strings:     rgb(128, 64,  0) → rgb(210,120,  0) #D27800  golden amber
  Identifiers: rgb( 63,127,127) → rgb(  0,127,200) #007FC8  sky blue

Colour rationale:
  Green keywords and amber strings are clearly distinct.
  Sky blue identifiers read well on dark navy and contrast with both
  green and amber without competing for attention.
  Vivid blue (#0000F6) was tried first for keywords but had poor contrast
  against the EditorPane's programmatic selection bg rgb(170,200,255).

Encoding verification (all same byte counts):
  sipush 128  iconst_0    iconst_0    = 0x11 0x80  0x03  0x03        (5 bytes)
  iconst_0    sipush 200  iconst_0    = 0x03  0x11 0xC8  0x03        (5 bytes) ✓

  sipush 128  bipush  64  iconst_0    = 0x11 0x80  0x10 0x40  0x03   (6 bytes)
  sipush 210  bipush 120  iconst_0    = 0x11 0xD2  0x10 0x78  0x03   (6 bytes) ✓

  bipush  63  bipush 127  bipush 127  = 0x10 0x3F  0x10 0x7F  0x10 0x7F  (6 bytes)
  iconst_0    bipush 127  sipush 200  = 0x03  0x10 0x7F  0x11 0xC8      (6 bytes) ✓
"""

import sys
import zipfile
import os

ENTRY = "org/sikuli/ide/SyntaxHighlightLabelView.class"

# (old_bytes, new_bytes, label, expected_count)
PATCHES = [
    # Keywords: rgb(128,0,0) dark red  →  rgb(0,200,0) bright green
    (
        bytes([0x11, 0x00, 0x80, 0x03, 0x03]),
        bytes([0x03, 0x11, 0x00, 0xC8, 0x03]),
        "keyword red→green",
        2,
    ),
    # Strings: rgb(128,64,0) dark brown  →  rgb(210,120,0) golden amber
    (
        bytes([0x11, 0x00, 0x80, 0x10, 0x40, 0x03]),
        bytes([0x11, 0x00, 0xD2, 0x10, 0x78, 0x03]),
        "string brown→amber",
        2,
    ),
    # Identifiers: rgb(63,127,127) dark teal  →  rgb(0,127,200) sky blue
    (
        bytes([0x10, 0x3F, 0x10, 0x7F, 0x10, 0x7F]),
        bytes([0x03, 0x10, 0x7F, 0x11, 0x00, 0xC8]),
        "identifier teal→sky-blue",
        1,
    ),
]


def patch_class(data: bytes) -> bytes:
    for old, new, label, expected in PATCHES:
        assert len(old) == len(new), f"Patch {label}: byte lengths differ!"
        count = data.count(old)
        if count != expected:
            print(
                f"  WARNING: {label} — expected {expected} occurrence(s), "
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
