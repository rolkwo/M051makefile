BINARY_NAME=dudzik.elf

CCFLAGS=-mcpu=cortex-m0 -march=armv6-m -mthumb -g -Wall -Werror -D XMC1100_Q024x0064 -nostdlib -fdata-sections -ffunction-sections
LDFLAGS=-mcpu=cortex-m0 -march=armv6-m -T XMC1100_series/Source/GCC/XMC1100x0064.ld -Wl,-nostdlib,--gc-sections,-lgcc,-lm,-Map=build/memory.map

CC=arm-none-eabi-gcc
AS=arm-none-eabi-gcc
LD=arm-none-eabi-gcc

INCLUDES=XMC1100_series/Include/ CMSIS/Include/ XMCLib/inc/ inc
INC_PARAMS=$(foreach d, $(INCLUDES), -I$d)

SOURCES=$(wildcard src/*.c )
OBJECTS=$(patsubst src/%.c,build/%.o,$(SOURCES))

SOURCES_XMC=$(wildcard XMCLib/src/*.c )
OBJECTS_XMC=$(patsubst XMCLib/src/%.c,build/%.o,$(SOURCES_XMC))

all: $(BINARY_NAME)
	@echo " "
	arm-none-eabi-size build/$(BINARY_NAME)

$(BINARY_NAME): $(OBJECTS_XMC) build/system_XMC1100.o build/startup_XMC1100.o $(OBJECTS)
	$(LD) $(LDFLAGS) $^ -o build/$@

build/startup_XMC1100.o: XMC1100_series/Source/GCC/startup_XMC1100.S
	$(AS) -c -D__SKIP_LIBC_INIT_ARRAY $< -o $@
	
build/system_XMC1100.o: XMC1100_series/Source/system_XMC1100.c
	$(CC) -c $(CCFLAGS) $< $(INC_PARAMS) -o $@

$(OBJECTS_XMC): build/%.o : XMCLib/src/%.c
	$(CC) -c $< $(CCFLAGS) $(INC_PARAMS) -o $@
	
$(OBJECTS): build/%.o : src/%.c
	$(CC) -c $< $(CCFLAGS) $(INC_PARAMS) -o $@

clean: 
	rm build/*.elf build/*.map build/*.o
	
	
	