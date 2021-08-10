BINARY_NAME=dudzik.elf

# Sorry, Nuvoton's driver compiles with warnings, so Wall is not here...
CCFLAGS=-mcpu=cortex-m0 -march=armv6-m -mthumb -g -Werror -nostdlib -fdata-sections -ffunction-sections
LDFLAGS=-mcpu=cortex-m0 -march=armv6-m -T M051BSP/Library/Device/Nuvoton/M051Series/Source/GCC/gcc_arm.ld -Wl,-nostdlib,--gc-sections,-lgcc,-lm,-Map=build/memory.map

CC=arm-none-eabi-gcc
AS=arm-none-eabi-gcc
LD=arm-none-eabi-gcc

INCLUDES=M051BSP/Library/Device/Nuvoton/M051Series/Include/ M051BSP/Library/StdDriver/inc/ M051BSP/Library/CMSIS/Include/ inc
INC_PARAMS=$(foreach d, $(INCLUDES), -I$d)

SOURCES=$(wildcard src/*.c )
OBJECTS=$(patsubst src/%.c,build/%.o,$(SOURCES))

SOURCES_DRV=$(wildcard M051BSP/Library/StdDriver/src/*.c )
OBJECTS_DRV=$(patsubst M051BSP/Library/StdDriver/src/%.c,build/%.o,$(SOURCES_DRV))

all: dir $(BINARY_NAME)
	@echo " "
	arm-none-eabi-size build/$(BINARY_NAME)
	
dir:
	mkdir -p build

$(BINARY_NAME): $(OBJECTS_DRV) build/system_M051Series.o build/startup_M051Series.o $(OBJECTS)
	$(LD) $(LDFLAGS) $^ -o build/$@

build/startup_M051Series.o: M051BSP/Library/Device/Nuvoton/M051Series/Source/GCC/startup_M051Series.S
	$(AS) -c -D__SKIP_LIBC_INIT_ARRAY $< -o $@
	
build/system_M051Series.o: M051BSP/Library/Device/Nuvoton/M051Series/Source/system_M051Series.c
	$(CC) -c $(CCFLAGS) $< $(INC_PARAMS) -o $@

$(OBJECTS_DRV): build/%.o : M051BSP/Library/StdDriver/src/%.c
	$(CC) -c $< $(CCFLAGS) $(INC_PARAMS) -o $@
	
$(OBJECTS): build/%.o : src/%.c
	$(CC) -c $< $(CCFLAGS) $(INC_PARAMS) -o $@

clean: 
	rm build/*.elf build/*.map build/*.o
	
	
	