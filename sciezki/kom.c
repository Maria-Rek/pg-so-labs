#define _GNU_SOURCE
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/stat.h>
#include <dirent.h>
#include <string.h>

#define MAX_PATH 1024

// Dodaje segment katalogu na początek ścieżki
void prepend(char *path, const char *name) {
    char temp[MAX_PATH];
    snprintf(temp, sizeof(temp), "/%s%s", name, path);
    strncpy(path, temp, MAX_PATH);
}

int main() {
    struct stat current_stat, parent_stat;
    char path[MAX_PATH] = "";
    char *current = ".";
    char *parent = "..";

    // Alokujemy pamięć na nazwę katalogu
    char cwd[MAX_PATH];
    if (!getcwd(cwd, sizeof(cwd))) {
        perror("getcwd");
        return 1;
    }

    while (1) {
        // Dane o katalogu bieżącym
        if (lstat(current, &current_stat) == -1) {
            perror("lstat current");
            return 1;
        }

        // Dane o katalogu nadrzędnym
        if (lstat(parent, &parent_stat) == -1) {
            perror("lstat parent");
            return 1;
        }

        // Jeśli jesteśmy w root (czyli ten sam inode i device)
        if (current_stat.st_ino == parent_stat.st_ino &&
            current_stat.st_dev == parent_stat.st_dev) {
            break;
        }

        // Przechodzimy do katalogu nadrzędnego
        if (chdir(parent) == -1) {
            perror("chdir");
            return 1;
        }

        // Szukamy naszej nazwy w katalogu nadrzędnym
        DIR *dir = opendir(".");
        if (!dir) {
            perror("opendir");
            return 1;
        }

        struct dirent *entry;
        while ((entry = readdir(dir)) != NULL) {
            struct stat entry_stat;
            if (lstat(entry->d_name, &entry_stat) == -1)
                continue;

            if (entry_stat.st_ino == current_stat.st_ino &&
                entry_stat.st_dev == current_stat.st_dev) {
                prepend(path, entry->d_name);
                break;
            }
        }

        closedir(dir);
    }

    // Jeśli ścieżka jest pusta, to jesteśmy w /
    if (strlen(path) == 0)
        strcpy(path, "/");

    printf("%s\n", path);
    return 0;
}
