#  
# MIT License
#
# Copyright (c) 2020 PCSX-Redux authors
# 
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.
#
#

PREFIX = mipsel-linux-gnu
BUILD ?= Release

ROOTDIR := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))

CC = $(PREFIX)-gcc

TYPE ?= cpe
LDSCRIPT ?= $(ROOTDIR)/$(TYPE).ld

ARCHFLAGS = -march=mips1 -mabi=32 -EL -fno-pic -mno-shared -mno-abicalls -mfp32
ARCHFLAGS += -fno-stack-protector -nostdlib -ffreestanding
CPPFLAGS += -mno-gpopt -fomit-frame-pointer -ffunction-sections
CPPFLAGS += -fno-builtin -fno-strict-aliasing -Wno-attributes
CPPFLAGS += $(ARCHFLAGS)
CPPFLAGS += -I$(ROOTDIR)

LDFLAGS += -Wl,-Map=$(TARGET).map -nostdlib -T$(LDSCRIPT) -static -Wl,--gc-sections
LDFLAGS += $(ARCHFLAGS)
#LDFLAGS += -Xlinker --defsym=TLOAD_ADDR=0x80018000
#LDFLAGS += -Xlinker --defsym=_TLOAD_ADDR=0x80018000

# MOD
#CPPFLAGS_Release += -Os
#LDFLAGS_Release += -Os

CPPFLAGS_Release += -Os
LDFLAGS_Release += -Os

CPPFLAGS_Debug += -O0

LDFLAGS += -g
CPPFLAGS += -g

CPPFLAGS += $(CPPFLAGS_$(BUILD))
LDFLAGS += $(LDFLAGS_$(BUILD))

OBJS += $(addsuffix .o, $(basename $(SRCS)))

all: dep $(TARGET).$(TYPE)

$(TARGET).$(TYPE): $(TARGET).elf
	$(PREFIX)-objcopy -O binary $< $@

$(TARGET).elf: $(OBJS)
	$(CC) -g -o $(TARGET).elf $(OBJS) $(LDFLAGS)

%.o: %.s
	$(CC) $(ARCHFLAGS) -I$(ROOTDIR) -g -c -o $@ $<

%.dep: %.c
	$(CC) $(CPPFLAGS) $(CFLAGS) -M -MT $(addsuffix .o, $(basename $@)) -MF $@ $<

%.dep: %.cc
	$(CXX) $(CPPFLAGS) $(CXXFLAGS) -M -MT $(addsuffix .o, $(basename $@)) -MF $@ $<

# A bit broken, but that'll do in most cases.
%.dep: %.s
	touch $@

DEPS := $(patsubst %.cc,%.dep,$(filter %.cc,$(SRCS)))
DEPS += $(patsubst %.c,%.dep,$(filter %.c,$(SRCS)))
DEPS += $(patsubst %.s,%.dep,$(filter %.s,$(SRCS)))

dep: $(DEPS)

clean:
	rm -f $(OBJS) $(TARGET).elf $(TARGET).map $(TARGET).$(TYPE) $(DEPS)

ifneq ($(MAKECMDGOALS), clean)
ifneq ($(MAKECMDGOALS), deepclean)
-include $(DEPS)
endif
endif

.PHONY: clean dep all