#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <stdbool.h>

#include "common.h"

struct num {
    int value;
    size_t len;
};

bool find_number(
    const char* input,
    size_t start_x, size_t start_y,
    size_t width,
    struct num* num
) {
    char start_char = input[start_y * (width + 1) + start_x];
    if (!is_digit(start_char)) {
        return false;
    }

    int current_total = 0;
    int current_digit = 0;

    for (size_t x = start_x; x < width; ++x) {
        char current_char = input[start_y * (width + 1) + x];

        if (is_digit(current_char)) {
            current_digit++;
            current_total *= 10;
            current_total += char_to_digit(current_char);
        } else {
            break;
        }
    }

    if (current_digit == 0) {
        return false;
    }

    num->value = current_total;
    num->len = current_digit;

    return true;
}

bool symbol_in_neighbors(
    const char* input,
    size_t x, size_t y,
    size_t width, size_t height
) {
    for (int i = -1; i <= 1; ++i) {
        for (int j = -1; j <= 1; ++j) {
            if (i == 0 && j == 0) {
                continue;
            }

            long neighbor_x = x + i;
            long neighbor_y = y + j;

            if (neighbor_x >= width || neighbor_y >= height ||
                neighbor_x < 0 || neighbor_y < 0) {
                continue;
            }

            char current_char = input[neighbor_y * (width + 1) + neighbor_x];
            if (is_symbol(current_char)) {
                return true;
            }
        }
    }

    return false;
}

int solve(const char* input) {
    char* line_end = strchr(input, '\n');
    if (line_end == NULL) {
        return -1;
    }

    size_t line_len = line_end - input;
    size_t buffer_len = strlen(input);
    size_t num_lines = buffer_len / (line_len + 1);

    int total = 0;

    for (size_t y = 0; y < num_lines; ++y) {
        for (size_t x = 0; x < line_len; ++x) {
            struct num num;
            if (!find_number(input, x, y, line_len, &num)) {
                continue;
            }

            for (size_t i = 0; i < num.len; ++i) {
                if (symbol_in_neighbors(input, x + i, y, line_len, num_lines)) {
                    total += num.value;
                    break;
                }
            }

            x += num.len;
        }
    }

    return total;
}


int main() {
    const char* input_file = "input/input.txt";

    long size = file_size(input_file);
    if (size == -1) {
        return EXIT_FAILURE;
    }

    char* buffer = malloc(size);
    if (buffer == NULL) {
        return EXIT_FAILURE;
    }

    if (read_input(input_file, buffer, size)) {
        return EXIT_FAILURE;
    }

    int solution = solve(buffer);
    printf("%d\n", solution);

    return EXIT_SUCCESS;
}
