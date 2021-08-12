#include "M051Series.h"

#include "gpio.h"

int main(void)
{
  GPIO_SetMode(P1, 0x02, GPIO_PMD_OUTPUT);
  P11 = 1;
}




