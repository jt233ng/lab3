
/* C wrapper functions for the RP2040 SDK
 * Incline functions gpio_set_dir and gpio_put.
 */
 
#include "hardware/gpio.h"

void link_gpio_set_dir(int pin, int dir)
{
	gpio_set_dir(pin, dir); //wir machen die link damit damit inline probleme nciht auftauchen bl braucht ja etwas wo er hin zurück springen kann
}

void link_gpio_init(int pin)
{
		gpio_init(pin);
}

void link_gpio_pull_up(int pin)
{
	gpio_pull_up(pin);
}