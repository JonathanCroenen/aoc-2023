#include <stdlib.h>
#include <string.h>

#include "common.h"

struct num {
    int value;
    size_t step;
};

void parse_number(
    const char* input,
    size_t x, size_t y,
    size_t width,
    struct num* num
) {
    size_t current_x = x;
    while (current_x - 1 >= 0 && is_digit(input[y * (width + 1) + current_x - 1])) {
        --current_x;
    }

    int number = char_to_digit(input[y * (width + 1) + current_x]);

    while (current_x + 1 < width && is_digit(input[y * (width + 1) + current_x + 1])) {
        number = number * 10 + char_to_digit(input[y * (width + 1) + current_x + 1]);
        ++current_x;
    }

    *num = (struct num) {
        .value = number,
        .step = current_x - x,
    };
}

int find_gear_ratio(
    const char* input,
    size_t x, size_t y,
    size_t width, size_t height
) {
    int total = 1;
    int nth_number = 0;

    for (int j = -1; j <= 1; ++j) {
        for (int i = -1; i <= 1; ++i) {
            int new_x = x + i;
            int new_y = y + j;

            if (new_x < 0 || new_x >= width || new_y < 0 || new_y >= height) {
                continue;
            }

            if (is_digit(input[new_y * (width + 1) + new_x])) {
                struct num num;
                parse_number(input, new_x, new_y, width, &num);

                total *= num.value;
                ++nth_number;

                i += num.step;
            }
        }
    }

    if (nth_number == 2) {
        return total;
    }

    return 0;
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
            if (input[y * (line_len + 1) + x] != '*') {
                continue;
            }

            total += find_gear_ratio(input, x, y, line_len, num_lines);
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
