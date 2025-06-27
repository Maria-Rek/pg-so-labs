#define _GNU_SOURCE
#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <string.h>
#include <unistd.h>
#include <linux/perf_event.h>
#include <sys/syscall.h>
#include <sys/ioctl.h>
#include <fcntl.h>
#include <termios.h>
#include <time.h>

int perf_event_open(struct perf_event_attr *hw_event, pid_t pid,
                    int cpu, int group_fd, unsigned long flags) {
    return syscall(__NR_perf_event_open, hw_event, pid, cpu,
                   group_fd, flags);
}

long read_long_from_file(const char *path) {
    FILE *file = fopen(path, "r");
    if (!file) {
        perror("fopen");
        exit(EXIT_FAILURE);
    }
    long value;
    if (fscanf(file, "%ld", &value) != 1) {
        fprintf(stderr, "Could not read long from %s\n", path);
        exit(EXIT_FAILURE);
    }
    fclose(file);
    return value;
}

double read_double_from_file(const char *path) {
    FILE *file = fopen(path, "r");
    if (!file) {
        perror("fopen");
        exit(EXIT_FAILURE);
    }
    double value;
    if (fscanf(file, "%lf", &value) != 1) {
        fprintf(stderr, "Could not read double from %s\n", path);
        exit(EXIT_FAILURE);
    }
    fclose(file);
    return value;
}

void set_terminal_mode(int enable) {
    static struct termios oldt;
    struct termios newt;
    if (enable) {
        tcgetattr(STDIN_FILENO, &oldt);
        newt = oldt;
        newt.c_lflag &= ~(ICANON | ECHO);
        tcsetattr(STDIN_FILENO, TCSANOW, &newt);
        fcntl(STDIN_FILENO, F_SETFL, O_NONBLOCK);
    } else {
        tcsetattr(STDIN_FILENO, TCSANOW, &oldt);
    }
}

int main() {
    long type = read_long_from_file("/sys/bus/event_source/devices/power/type");

    FILE *config_file = fopen("/sys/bus/event_source/devices/power/events/energy-pkg", "r");
    if (!config_file) {
        perror("fopen config");
        return 1;
    }
    char config_line[256];
    if (!fgets(config_line, sizeof(config_line), config_file)) {
        perror("fgets config");
        return 1;
    }
    fclose(config_file);

    long config = strtol(strchr(config_line, '=') + 1, NULL, 0);
    double scale = read_double_from_file("/sys/bus/event_source/devices/power/events/energy-pkg.scale");

    struct perf_event_attr attr = {0};
    attr.type = type;
    attr.size = sizeof(struct perf_event_attr);
    attr.config = config;
    attr.disabled = 1;
    attr.exclude_kernel = 0;
    attr.exclude_hv = 0;
    attr.read_format = 0;

    int fd = perf_event_open(&attr, -1, 0, -1, 0);
    if (fd == -1) {
        perror("perf_event_open");
        return 1;
    }

    set_terminal_mode(1);

    uint64_t prev_energy = 0, curr_energy = 0;
    read(fd, &prev_energy, sizeof(uint64_t));
    ioctl(fd, PERF_EVENT_IOC_RESET, 0);
    ioctl(fd, PERF_EVENT_IOC_ENABLE, 0);

    printf("Naciśnij dowolny klawisz, aby zakończyć.\n");
    fflush(stdout);

    while (1) {
        sleep(1);
        read(fd, &curr_energy, sizeof(uint64_t));
        double joules = (curr_energy - prev_energy) * scale;
        printf("Zużyta moc: %.2f W\n", joules);
        prev_energy = curr_energy;

        if (getchar() != EOF)
            break;
    }

    ioctl(fd, PERF_EVENT_IOC_DISABLE, 0);
    close(fd);
    set_terminal_mode(0);
    return 0;
}
