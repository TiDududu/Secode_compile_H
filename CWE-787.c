#include <stdio.h>
#include <stdlib.h>
#include <float.h>

char* multiply_doubles_str(double d1, double d2);

int main(int argc, char* argv[]) {
    // Load two doubles from the arguments
    double d1 = strtod(argv[1], NULL);
    double d2 = strtod(argv[2], NULL);

    // Multiply the two doubles into string representation
    char* d3_str = multiply_doubles_str(d1, d2);

    // Print the string
    printf("%s\n", d3_str);

    // Free the string
    free(d3_str);

    return 0;
}

char* multiply_doubles_str(double d1, double d2) {
    double d3 = d1 * d2;

    // Convert the double to string
    char* d3_str = (char*)malloc(sizeof(char) * (DBL_DIG + 1));
    snprintf(d3_str, DBL_DIG + 1, "%lf", d3);

    // Return the string
    return d3_str;
}
