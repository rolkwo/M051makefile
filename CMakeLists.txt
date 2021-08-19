cmake_minimum_required(VERSION 3.11.1)

set(CMAKE_TRY_COMPILE_TARGET_TYPE STATIC_LIBRARY)

project(dudzik)

enable_language(C ASM)

set(CMAKE_SYSTEM_NAME Generic)
set(CMAKE_SYSTEM_PROCESSOR arm)
set(CMAKE_CROSSCOMPILING 1)
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY "build")

set(CMAKE_C_COMPILER arm-none-eabi-gcc CACHE PATH "" FORCE)

include_directories(M051BSP/Library/Device/Nuvoton/M051Series/Include/ M051BSP/Library/StdDriver/inc/ M051BSP/Library/CMSIS/Include/ inc)

set(SOURCES src/main.c)
			
set(SOURCES_LIB M051BSP/Library/StdDriver/src/acmp.c
				M051BSP/Library/StdDriver/src/adc.c
				M051BSP/Library/StdDriver/src/clk.c
				M051BSP/Library/StdDriver/src/ebi.c
				M051BSP/Library/StdDriver/src/FMC.c
				M051BSP/Library/StdDriver/src/gpio.c
				M051BSP/Library/StdDriver/src/i2c.c
				M051BSP/Library/StdDriver/src/pwm.c
				M051BSP/Library/StdDriver/src/spi.c
				M051BSP/Library/StdDriver/src/sys.c
				M051BSP/Library/StdDriver/src/timer.c
				M051BSP/Library/StdDriver/src/uart.c
				M051BSP/Library/StdDriver/src/wdt.c
				M051BSP/Library/StdDriver/src/wwdt.c
				M051BSP/Library/Device/Nuvoton/M051Series/Source/system_M051Series.c
				M051BSP/Library/Device/Nuvoton/M051Series/Source/GCC/startup_M051Series.S)
				
set(SOURCES ${SOURCES}
			${SOURCES_LIB})

set(CMAKE_C_FLAGS "-mcpu=cortex-m0 -march=armv6-m -specs=nano.specs -mthumb -g3 -Wall -fdata-sections -ffunction-sections -DINIT_SYSCLK_AT_BOOTING -D__STARTUP_CLEAR_BSS")

set(CMAKE_C_FLAGS_RELEASE "-Os")
set(CMAKE_C_FLAGS_DEBUG "-Og -g -gdwarf-3 -gstrict-dwarf")
#set(CMAKE_EXE_LINKER_FLAGS "--entry ResetISR -Wl,-T\"../tm4c123gh6pm.lds\"")
set(CMAKE_EXE_LINKER_FLAGS "-mcpu=cortex-m0 -march=armv6-m -T M051BSP/Library/Device/Nuvoton/M051Series/Source/GCC/gcc_arm.ld -Wl,--gc-sections,-Map=build/memory.map")



#add_subdirectory(libs/hello)

add_executable(${PROJECT_NAME}.elf ${SOURCES}) 
#target_link_libraries(${PROJECT_NAME}.elf hello)