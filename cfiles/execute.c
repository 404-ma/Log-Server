#include <stdio.h>
#include <stdlib.h>

int main() {
    int result;

    result = system("python3 main.py");
    if (result == -1) {
        perror("Error executing main.py");
        return 1;
    }
}
