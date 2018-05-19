#include "sys_timer.h"

#define RPI_SYSTIMER_BASE       0x20003000

struct sys_timer {
    u32 control_status;
    u32 counter_lo;
    u32 counter_hi;
    u32 compare0;
    u32 compare1;
    u32 compare2;
    u32 compare3;
};

void sleep_microsec(u32 usec)
{
    volatile struct sys_timer *timer =
        (volatile struct sys_timer *) RPI_SYSTIMER_BASE;
    
    u32 now = timer->counter_lo;

    while ( (timer->counter_lo - now) < usec ) {
        (void) 0;
    }
}
