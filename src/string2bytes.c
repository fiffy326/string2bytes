#include <stdio.h>
#include <stdlib.h>
#include <string.h>

void print_c_byte_array(const char* buffer) {
    size_t length = strlen(buffer);
    printf("static const char BYTES[] = { ");
    for (size_t i = 0; i < length; i++) {
        printf("0x%02hhX", buffer[i]);
        if (i < (length - 1)) {
            printf(", ");
        }
    }
    printf(", 0x00 };\n");
}

int main(int argc, char** argv) {
    char buffer[BUFSIZ];
    int c, i;

    if (argc > 2) {
        fprintf(stderr, "Error: Too many arguments were provided.\n"
                "See 'man string2bytes' for usage info.\n");
        exit(EXIT_FAILURE);
    }

    if (argc == 2)
        strcpy(buffer, argv[1]);
    else {
        i = 0;
        while ((c = getchar()) != EOF) {
            buffer[i] = c;
            i++;
        }
    }

    print_c_byte_array(buffer);
    return 0;
}
