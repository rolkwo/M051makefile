#include "M051Series.h"

#include "gpio.h"
#include "uart.h"

volatile uint32_t del;

void delay(uint32_t millisecond);

int main(void)
{
  SystemCoreClockUpdate();

  SysTick_Config(SystemCoreClock / 1000);

  UART_Open(UART0, 115200);

  GPIO_SetMode(P3, 1 << 6, GPIO_PMD_OUTPUT);

  while(1)
  {
    P36 = 0;
    delay(100);
    P36 = 1;
    delay(900);

    const uint8_t buf[] = "bla bla bla";

    UART_Write(UART0, buf, sizeof(buf));
  }
}

void delay(uint32_t millisecond)
{
  del = millisecond;

  while(del > 0)
  {

  }
}

void SysTick_Handler(void)
{
  if(del > 0)
  {
    del--;
  }
}

