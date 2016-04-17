CC = avr-gcc
CXX = avr-g++
AR = avr-ar
OBJCOPY = avr-objcopy
OBJDUMP = avr-objdump
AVRSIZE = avr-size
AVRDUDE = avrdude

MCU = atmega2560
F_CPU = 16000000UL
AVRDUDE_OPTIONS = -p $(MCU) -c usbasp

avr_CFLAGS = -mmcu=$(MCU) -DF_CPU=$(F_CPU) -DAVR
avr_LDFLAGS = -mmcu=$(MCU) -Wl,-u,vfprintf -lprintf_flt -lm -Wl,-u,vfscanf -lscanf_flt -lm

LDFLAGS = -g -Wl,--gc-sections $(avr_LDFLAGS)
EXTERN_OBJECTS = ../../build_avr/*.o ../../../io/build_avr/*.o

EXTERN_INCLUDES = ../../src ../../../io/src
CPPFLAGS = -DIEEE754 -DNDEBUG -DAVR
CFLAGS = -c -std=c11 -Wall -Wpedantic -Wextra $(addprefix -I, $(EXTERN_INCLUDES)) $(avr_CFLAGS)
CXXFLAGS = -c -std=c++11 -Wall -Wextra -g $(addprefix -I, $(EXTERN_INCLUDES))

DEPS =

BUILDDIR = build
SRCDIR = src

SOURCES = $(wildcard $(SRCDIR)/*.c $(SRCDIR)/*.cpp)
OBJECTS = $(addprefix $(BUILDDIR)/, $(addsuffix .o, $(notdir $(basename $(SOURCES)))))

TARGET = $(lastword $(subst /, ,$(CURDIR)))

.PHONY: all
all: $(TARGET).eep

$(BUILDDIR):
	mkdir -p $(BUILDDIR)


$(BUILDDIR)/%.o: $(SRCDIR)/%.c $(BUILDIR)
	$(CC) $< -o $@ $(CFLAGS) $(CPPFLAGS)

$(BUILDDIR)/%.o: $(SRCDIR)/%.cpp $(BUILDDIR)
	$(CXX) $< -o $@ $(CXXFLAGS) $(CPPFLAGS)

$(TARGET).eep: $(BUILDDIR)/$(TARGET).o
	$(OBJCOPY) -j .eeprom --change-section-lma .eeprom=0 -O ihex $< $@

.PHONY: eeprom
flash: $(TARGET).eep
	$(AVRDUDE) $(AVRDUDE_OPTIONS) -Ueeprom:w:$<:i

.PHONY: clean
clean:
	rm -f $(BUILDDIR)/*
	rm -f $(TARGET).eep
	rm -fd $(BUILDDIR)
