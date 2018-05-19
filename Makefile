# Bare metal Raspberry Pi

TARGET := RaspberryPi-1
CPREFIX := arm-none-eabi-
CC := $(CPREFIX)gcc
LD := $(CPREFIX)gcc
OBJCOPY := $(CPREFIX)objcopy


ifeq ($(TARGET), RaspberryPi-1)
	CFLAGS := -Ofast -mfpu=vfp -mfloat-abi=hard -march=armv6zk -mtune=arm1176jzf-s -fno-builtin
	LFLAGS := -Os -mfpu=vfp -mfloat-abi=hard -march=armv6zk -mtune=arm1176jzf-s -nostartfiles -nostdlib
else ifeq ($(TARGET), RaspberryPi-2)
	CFLAGS := -O2 -mfpu=neon-vfpv4 -mfloat-abi=hard -march=armv7-a -mtune=cortex-a7
	LFLAGS := -O2 -mfpu=neon-vfpv4 -mfloat-abi=hard -march=armv7-a -mtune=cortex-a7 -nostartfiles
else
$(error Unsupported TARGET)
endif

c_source := src/main.c \
		src/cstartup.c \
		src/sys_timer.c

asm_source := src/start.s

object := $(c_source:.c=.o) $(asm_source:.s=.o)

kernel_elf := kernel.elf
kernel_bin := boot/kernel.img

all: $(kernel_bin)

$(kernel_bin): $(kernel_elf)
	$(OBJCOPY) $< -O binary $@

$(kernel_elf): $(object)
	$(LD) $(LFLAGS) -o $@ $^

clean:
	-rm -f $(kernel_bin) $(kernel_elf) $(object)


.s.o:
	$(CC) $(CFLAGS) -c -o $@ $<

.c.o:
	$(CC) $(CFLAGS) -c -o $@ $<

print:
	@echo "TARGET = $(TARGET)"
	@echo "cc = $(CC)"
	@echo "ld = $(LD)"
	@echo "CFLAGS = $(CFLAGS)"
