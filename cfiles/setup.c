#include <stdio.h>
#include <stdlib.h>

int main() {
    int result = system("pip install -r requirements.txt > /dev/null 2>&1");
    if (result == -1) {
        perror("Error executing pip install");
        return 1;
    }

    printf("\nSuccessfully installed dependencies...\n");

    result = system("python3 setup.py build_ext --inplace > /dev/null 2>&1");
    if (result == -1) {
        perror("Error executing setup.py build");
        return 1;
    }

    printf("\nSuccessfully compiled c modules...\n");

    printf("\nRun ./bin/execute to run the server\n\n");

    return 0;
}
