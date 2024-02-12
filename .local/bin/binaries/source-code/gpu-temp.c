#include <stdio.h>
#include <unistd.h>
#include <time.h>
#include <stdlib.h>

int main() {
    const char *file_path = ""; /* put here you hwmon sensor. For example `/sys/devices/pci0000:00/0000:00:03.1/0000:2b:00.0/0000:2c:00.0/0000:2d:00.0/hwmon/hwmon2/temp2_input` */
    FILE *file;

    int notify_interval = 30;
    int notify_timer = notify_interval * 1000000;
    int check_temp_period = 300000;
    int temp_threshold = 80;

    struct timespec last_notify_time;
    clock_gettime(CLOCK_MONOTONIC, &last_notify_time);

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

        usleep(check_temp_period);

        if (temperature >= temp_threshold * 1000) {
            struct timespec current_time;
            clock_gettime(CLOCK_MONOTONIC, &current_time);
            long elapsed = (current_time.tv_sec - last_notify_time.tv_sec) * 1000000 +
                           (current_time.tv_nsec - last_notify_time.tv_nsec) / 1000;
        }
    }

    return 0;
}

