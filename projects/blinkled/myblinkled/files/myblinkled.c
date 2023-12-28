/*
 * Blink LED using libgpiod
 *
 * Author: Mahmood Hosseini
 * Email: mahmood.hossieni.eng@gmail.com
 *
 * Instructions:
 * - Adjust GPIO_CHIP and GPIO_LINE according to your system and setup.
 * - Compile the program using: gcc -o blink_led blink_led.c -lgpiod
 * - Run the compiled program with superuser privileges: sudo ./blink_led
 */
#include <gpiod.h>
#include <stdio.h>
#include <unistd.h>

#define GPIO_CHIP "gpiochip0"  // Adjust this according to your system
#define GPIO_LINE 13           // Adjust this according to your setup

int main() {
    struct gpiod_chip *chip;
    struct gpiod_line *line;

    // Open the GPIO chip
    chip = gpiod_chip_open_by_name(GPIO_CHIP);
    if (!chip) {
        perror("Opening GPIO chip failed");
        return 1;
    }

    // Get the GPIO line
    line = gpiod_chip_get_line(chip, GPIO_LINE);
    if (!line) {
        perror("Getting GPIO line failed");
        gpiod_chip_close(chip);
        return 1;
    }

    // Request the GPIO line
    if (gpiod_line_request_output(line, "BlinkLED", GPIOD_LINE_ACTIVE_STATE_LOW) < 0) {
        perror("Requesting GPIO line failed");
        gpiod_chip_close(chip);
        return 1;
    }

    // Blink the LED
    while(1){
        gpiod_line_set_value(line, 1);  // Turn the LED on
        usleep(200000);                 // Sleep for 1 second
        gpiod_line_set_value(line, 0);  // Turn the LED off
        usleep(200000);                 // Sleep for 1 second
    }

    // Release the GPIO line
    gpiod_line_release(line);

    // Close the GPIO chip
    gpiod_chip_close(chip);

    return 0;
}
