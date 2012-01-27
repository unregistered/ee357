################################################################################
# Automatically-generated file. Do not edit!
################################################################################

-include ../makefile.local

# Add inputs and outputs from these tool invocations to the build variables 
C_SRCS_QUOTED += \
"../Sources/TWR-MCF5225X_sysinit.c" \
"../Sources/console_io_cf.c" \
"../Sources/exceptions.c" \
"../Sources/main.c" \
"../Sources/uart_support.c" 

C_SRCS += \
../Sources/TWR-MCF5225X_sysinit.c \
../Sources/console_io_cf.c \
../Sources/exceptions.c \
../Sources/main.c \
../Sources/uart_support.c 

OBJS += \
./Sources/TWR-MCF5225X_sysinit_c.obj \
./Sources/console_io_cf_c.obj \
./Sources/exceptions_c.obj \
./Sources/main_c.obj \
./Sources/uart_support_c.obj 

OBJS_QUOTED += \
"./Sources/TWR-MCF5225X_sysinit_c.obj" \
"./Sources/console_io_cf_c.obj" \
"./Sources/exceptions_c.obj" \
"./Sources/main_c.obj" \
"./Sources/uart_support_c.obj" 

C_DEPS += \
./Sources/TWR-MCF5225X_sysinit_c.d \
./Sources/console_io_cf_c.d \
./Sources/exceptions_c.d \
./Sources/main_c.d \
./Sources/uart_support_c.d 

OBJS_OS_FORMAT += \
./Sources/TWR-MCF5225X_sysinit_c.obj \
./Sources/console_io_cf_c.obj \
./Sources/exceptions_c.obj \
./Sources/main_c.obj \
./Sources/uart_support_c.obj 


# Each subdirectory must supply rules for building sources it contributes
Sources/TWR-MCF5225X_sysinit_c.obj: ../Sources/TWR-MCF5225X_sysinit.c
	@echo 'Building file: $<'
	@echo 'Invoking: ColdFire Compiler'
	"$(CF_ToolsDirEnv)/mwccmcf" @@"Sources/TWR-MCF5225X_sysinit.args" -o "Sources/TWR-MCF5225X_sysinit_c.obj" "$<" -MD -gccdep
	@echo 'Finished building: $<'
	@echo ' '

Sources/%.d: ../Sources/%.c
	@echo 'Regenerating dependency file: $@'
	
	@echo ' '

Sources/console_io_cf_c.obj: ../Sources/console_io_cf.c
	@echo 'Building file: $<'
	@echo 'Invoking: ColdFire Compiler'
	"$(CF_ToolsDirEnv)/mwccmcf" @@"Sources/console_io_cf.args" -o "Sources/console_io_cf_c.obj" "$<" -MD -gccdep
	@echo 'Finished building: $<'
	@echo ' '

Sources/exceptions_c.obj: ../Sources/exceptions.c
	@echo 'Building file: $<'
	@echo 'Invoking: ColdFire Compiler'
	"$(CF_ToolsDirEnv)/mwccmcf" @@"Sources/exceptions.args" -o "Sources/exceptions_c.obj" "$<" -MD -gccdep
	@echo 'Finished building: $<'
	@echo ' '

Sources/main_c.obj: ../Sources/main.c
	@echo 'Building file: $<'
	@echo 'Invoking: ColdFire Compiler'
	"$(CF_ToolsDirEnv)/mwccmcf" @@"Sources/main.args" -o "Sources/main_c.obj" "$<" -MD -gccdep
	@echo 'Finished building: $<'
	@echo ' '

Sources/uart_support_c.obj: ../Sources/uart_support.c
	@echo 'Building file: $<'
	@echo 'Invoking: ColdFire Compiler'
	"$(CF_ToolsDirEnv)/mwccmcf" @@"Sources/uart_support.args" -o "Sources/uart_support_c.obj" "$<" -MD -gccdep
	@echo 'Finished building: $<'
	@echo ' '


