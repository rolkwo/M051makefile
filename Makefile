BINARY_NAME=dudzik.elf

# Sorry, Nuvoton's driver compiles with warnings, so Werror is not here...
CCFLAGS=-mcpu=cortex-m0 -march=armv6-m -specs=nano.specs -mthumb -g3 -Wall -fdata-sections -ffunction-sections -DINIT_SYSCLK_AT_BOOTING
LDFLAGS=-mcpu=cortex-m0 -march=armv6-m -specs=nano.specs -T M051BSP/Library/Device/Nuvoton/M051Series/Source/GCC/gcc_arm.ld -Wl,--gc-sections,-Map=build/memory.map
CC=arm-none-eabi-gcc
AS=arm-none-eabi-gcc
LD=arm-none-eabi-gcc

INCLUDES=M051BSP/Library/Device/Nuvoton/M051Series/Include/ M051BSP/Library/StdDriver/inc/ M051BSP/Library/CMSIS/Include/ inc
INC_PARAMS=$(foreach d, $(INCLUDES), -I$d)

SOURCES=$(wildcard src/*.c )
OBJECTS=$(patsubst src/%.c,build/%.o,$(SOURCES))


SOURCES_DRV=$(wildcard M051BSP/Library/StdDriver/src/*.c )
#OBJECTS_DRV=$(patsubst M051BSP/Library/StdDriver/src/%.c,build/%.o,$(SOURCES_DRV))
OBJECTS_DRV=
OBJECTS_DRV+=build/acmp.o
OBJECTS_DRV+=build/adc.o
OBJECTS_DRV+=build/clk.o
OBJECTS_DRV+=build/ebi.o
OBJECTS_DRV+=build/FMC.o
OBJECTS_DRV+=build/gpio.o
OBJECTS_DRV+=build/i2c.o
OBJECTS_DRV+=build/pwm.o
#OBJECTS_DRV+=build/retarget.o
OBJECTS_DRV+=build/spi.o
OBJECTS_DRV+=build/sys.o
OBJECTS_DRV+=build/timer.o
OBJECTS_DRV+=build/uart.o
OBJECTS_DRV+=build/wdt.o
OBJECTS_DRV+=build/wwdt.o


all: dir $(BINARY_NAME)
	@echo " "
	arm-none-eabi-size build/$(BINARY_NAME)
	
dir:
	mkdir -p build

$(BINARY_NAME): build/system_M051Series.o build/startup_M051Series.o $(OBJECTS) $(OBJECTS_DRV)
	$(LD) $(LDFLAGS) $^ -o build/$@

build/startup_M051Series.o: M051BSP/Library/Device/Nuvoton/M051Series/Source/GCC/startup_M051Series.S
	$(AS) -c -D__STARTUP_CLEAR_BSS $< -o $@
	
build/system_M051Series.o: M051BSP/Library/Device/Nuvoton/M051Series/Source/system_M051Series.c
	$(CC) -c $(CCFLAGS) $< $(INC_PARAMS) -o $@
	
#build/_syscalls.o: M051BSP/Library/Device/Nuvoton/M051Series/Source/GCC/_syscalls.c
#	$(CC) -c $(CCFLAGS) $< $(INC_PARAMS) -o $@

$(OBJECTS_DRV): build/%.o : M051BSP/Library/StdDriver/src/%.c
	$(CC) -c $< $(CCFLAGS) $(INC_PARAMS) -o $@
	
$(OBJECTS): build/%.o : src/%.c
	$(CC) -c $< $(CCFLAGS) $(INC_PARAMS) -o $@

clean: 
	rm build/*.elf build/*.map build/*.o
	
	
	