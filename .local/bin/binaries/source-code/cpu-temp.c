#include <stdio.h>
#include <unistd.h>

int main() {
    const char *file_path = ""; /* put your hwmon sensos here. For example `/sys/devices/pci0000:00/0000:00:18.3/hwmon/hwmon3/temp1_input` */
    FILE *file;

    while (1) {
        file = fopen(file_path, "r");
        if (file == NULL) {
            break;
        }

        int temperature;
        fscanf(file, "%d", &temperature);
        fclose(file);

        printf("%d\n", temperature / 1000);
        fflush(stdout);

        usleep(300000);
    }

    return 0;
}
