/*
 * Compiled Mach-O launcher for OculiX.app.
 * See sikulix_launcher.c for rationale.
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
        fprintf(stderr, "OculiX: could not resolve executable path\n");
        return 1;
    }

    char *dir = dirname(execPath);
    char jarPath[4096], iconPath[4096], dockIcon[4096];
    snprintf(jarPath,  sizeof(jarPath),  "%s/../Resources/oculixide.jar", dir);
    snprintf(iconPath, sizeof(iconPath), "%s/../Resources/AppIcon.icns",  dir);
    snprintf(dockIcon, sizeof(dockIcon), "-Xdock:icon=%s", iconPath);

    const char *java = "/opt/homebrew/opt/openjdk@21/bin/java";
    if (access(java, X_OK) != 0) {
        fprintf(stderr, "OculiX: Java 21 not found at %s\n"
                        "Install it with: brew install openjdk@21\n", java);
        return 1;
    }

    int fixed = 7;
    char **args = malloc((fixed + argc) * sizeof(char *));
    args[0] = (char *)java;
    args[1] = "-Dapple.awt.application.name=OculiX";
    args[2] = "-Xdock:name=OculiX";
    args[3] = dockIcon;
    args[4] = "-Dapple.laf.useScreenMenuBar=true";
    args[5] = "-jar";
    args[6] = jarPath;
    for (int i = 1; i < argc; i++) args[fixed - 1 + i] = argv[i];
    args[fixed - 1 + argc] = NULL;

    execv(java, args);
    fprintf(stderr, "OculiX: execv failed\n");
    return 1;
}
