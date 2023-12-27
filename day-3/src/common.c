#include "common.h"


long file_size(const char* filename) {
    FILE* file = fopen(filename, "r");
    if (file == NULL) {
        fclose(file);
        return -1;
    }

    if (fseek(file, 0, SEEK_END)) {
        fclose(file);
        return -1;
    }

    long size = ftell(file);
    if (size == -1) {
        fclose(file);
        return -1;
    }

    fclose(file);
    return size;
}


int read_input(const char* filename, char* buffer, size_t size) {
    FILE* file = fopen(filename, "r");
    if (file == NULL) {
        fclose(file);
        return -1;
    }

    if (fread(buffer, 1, size, file) != size) {
        fclose(file);
        return -1;
    }

    fclose(file);
    return 0;
}


bool is_digit(char c) {
    return c >= '0' && c <= '9';
}

bool is_symbol(char c) {
    return c != '.' && ((c >= '!' && c <= '/') || (c >= ':' && c <= '@') ||
           (c >= '[' && c <= '`') || (c >= '{' && c <= '~'));
}

int char_to_digit(char c) {
    return c - '0';
}
