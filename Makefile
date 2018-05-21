# Bare metal Raspberry Pi

TARGET := RaspberryPi-1
CPREFIX := arm-none-eabi-
CC := $(CPREFIX)gcc
LD := $(CPREFIX)ld
AS := $(CPREFIX)as
OBJCOPY := $(CPREFIX)objcopy


ifeq ($(TARGET), RaspberryPi-1)
	CFLAGS = -Wall -Wextra -Ofast -mfpu=vfp -mfloat-abi=hard -march=armv6zk -mtune=arm1176jzf-s -fno-tree-loop-distribute-patterns
	ASFLAGS = -mfpu=vfp -mfloat-abi=hard -march=armv6zk
	LFLAGS = -O2 -nostdlib
else ifeq ($(TARGET), RaspberryPi-2)
	CFLAGS = -O2 -mfpu=neon-vfpv4 -mfloat-abi=hard -march=armv7-a -mtune=cortex-a7
	LFLAGS = -O2 -mfpu=neon-vfpv4 -mfloat-abi=hard -march=armv7-a -mtune=cortex-a7 -nostartfiles
else
$(error Unsupported target: $(TARGET))
endif

c_source := src/main.c \
		src/cstartup.c \
		src/sys_timer.c

asm_source := src/start.s

object := $(c_source:.c=.o) $(asm_source:.s=.o)

kernel_elf := kernel.elf
kernel_bin := boot/kernel.img

LINKER_SCRIPT := ld/rasp-link.ld
LINKER_MAP := ld/rasp-link.map

all: $(kernel_bin)

$(kernel_bin): $(kernel_elf)
	$(OBJCOPY) $< -O binary $@

$(kernel_elf): $(object)
	$(LD) $(LFLAGS) -T $(LINKER_SCRIPT) -Map=$(LINKER_MAP) -o $@ $^

clean:
	-rm -f $(kernel_bin) $(kernel_elf) $(object) $(LINKER_MAP)


.s.o:
	$(AS) $(ASFLAGS) -c -o $@ $<

.c.o:
	$(CC) $(CFLAGS) -c -o $@ $<

print:
	@echo "TARGET = $(TARGET)"
	@echo "cc = $(CC)"
	@echo "ld = $(LD)"
	@echo "CFLAGS = $(CFLAGS)"
