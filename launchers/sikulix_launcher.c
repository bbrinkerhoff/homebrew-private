/*
 * Compiled Mach-O launcher for SikuliX.app.
 *
 * A shell script loses the macOS Launch Services bundle association when it
 * exec()s Java, so the JVM registers its own dock slot and produces a
 * duplicate icon. A compiled binary keeps the same PID through execv(), so
 * macOS maintains the bundle-to-process mapping and Java inherits the
 * bundle's dock entry instead of creating a new one.
 */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <libgen.h>
#include <mach-o/dyld.h>

int main(int argc, char *argv[]) {
    char execPath[4096];
    uint32_t size = sizeof(execPath);
    if (_NSGetExecutablePath(execPath, &size) != 0) {
        fprintf(stderr, "SikuliX: could not resolve executable path\n");
        return 1;
    }

    char *dir = dirname(execPath);
    char jarPath[4096], iconPath[4096], dockIcon[4096];
    snprintf(jarPath,  sizeof(jarPath),  "%s/../Resources/sikulixide.jar", dir);
    snprintf(iconPath, sizeof(iconPath), "%s/../Resources/AppIcon.icns",   dir);
    snprintf(dockIcon, sizeof(dockIcon), "-Xdock:icon=%s", iconPath);

    const char *java = "/opt/homebrew/opt/openjdk@21/bin/java";
    if (access(java, X_OK) != 0) {
        fprintf(stderr, "SikuliX: Java 21 not found at %s\n"
                        "Install it with: brew install openjdk@21\n", java);
        return 1;
    }

    int fixed = 7;
    char **args = malloc((fixed + argc) * sizeof(char *));
    args[0] = (char *)java;
    args[1] = "-Dapple.awt.application.name=SikuliX";
    args[2] = "-Xdock:name=SikuliX";
    args[3] = dockIcon;
    args[4] = "-Dapple.laf.useScreenMenuBar=true";
    args[5] = "-jar";
    args[6] = jarPath;
    for (int i = 1; i < argc; i++) args[fixed - 1 + i] = argv[i];
    args[fixed - 1 + argc] = NULL;

    execv(java, args);
    fprintf(stderr, "SikuliX: execv failed\n");
    return 1;
}
