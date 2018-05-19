
#include "gpio.h"
#include "sys_timer.h"

int kmain(void)
{
    volatile unsigned int *gpio = (volatile unsigned int *) GPIO_BASE;
    
    gpio[LED_GPFSEL] |= (1 << LED_GPFBIT);

    for (;;) {

        sleep_microsec(250000);
        
        gpio[LED_GPCLR] = (1 << LED_GPIO_BIT);

        sleep_microsec(250000);

        gpio[LED_GPSET] = (1 << LED_GPIO_BIT);
    }

    return 0;
}

void exit(int code)
{
    for (;;) {
        (void) 0;
    }
}
