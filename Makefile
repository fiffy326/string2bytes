PROGRAM := string2bytes
VERSION := 1.0.0

MANPAGE := $(PROGRAM).1

# Install paths
PREFIX    := /usr/local
MANPREFIX := $(PREFIX)/share/man

BUILD_DIR := ./build
SRC_DIRS  := ./src

SRCS := $(shell find $(SRC_DIRS) -name '*.c')
OBJS := $(SRCS:%=$(BUILD_DIR)/%.o)
DEPS := $(OBJS:.o=.d)

INC_DIRS := $(shell find $(SRC_DIRS) -type d)
INC_FLAGS := $(addprefix -I,$(INC_DIRS))

# Flags
override MAKEFLAGS += -j$(shell nproc) -l$(shell nproc)
override CPPFLAGS  += $(INC_FLAGS) -MMD -MP
override CFLAGS    += -pipe -march=native -pedantic -Wall -Werror -Wextra -O3
override LDFLAGS   +=

# Tools
CC := gcc

all: $(PROGRAM)

$(PROGRAM): $(OBJS)
	$(CC) $(OBJS) -o $@ $(LDFLAGS)

$(BUILD_DIR)/%.c.o: %.c
	mkdir -p $(dir $@)
	$(CC) $(CPPFLAGS) $(CFLAGS) -c $< -o $@

clang:
	$(MAKE) CC=clang

clang-static:
	$(MAKE) CC=clang LDFLAGS=-static

gcc:
	$(MAKE) CC=gcc

gcc-static:
	$(MAKE) CC=gcc LDFLAGS=-static

clean:
	rm -rf $(BUILD_DIR)
	rm -f $(PROGRAM)

install: all
	mkdir -p $(DESTDIR)$(PREFIX)/bin
	mkdir -p $(DESTDIR)$(MANPREFIX)/man1
	cp -f $(PROGRAM) $(DESTDIR)$(PREFIX)/bin
	chmod 755 $(DESTDIR)$(MANPREFIX)/man1
	sed "s/VERSION/$(VERSION)/g" < ./man/man1/$(MANPAGE) > $(DESTDIR)$(MANPREFIX)/man1/$(MANPAGE)
	chmod 644 $(DESTDIR)$(MANPREFIX)/man1/$(MANPAGE)

uninstall:
	rm -f $(DESTDIR)$(PREFIX)/bin/$(PROGRAM) \
		$(DESTDIR)$(MANPREFIX)/man1/$(MANPAGE)

run: all
	./$(PROGRAM)

.PHONY: all clean run install uninstall clang clang-static gcc gcc-static

-include $(DEPS)
