#include <stdio.h>
#include <stdbool.h>

long file_size(const char* filename);
int read_input(const char* filename, char* buffer, size_t size);

bool is_digit(char c);
bool is_symbol(char c);
int char_to_digit(char c);
