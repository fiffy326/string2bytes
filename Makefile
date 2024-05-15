VERSION := 1.0.0

PROGRAM := string2bytes
MANPAGE := string2bytes.1

PREFIX := /usr/local
MANPREFIX := $(PREFIX)/share/man

BUILD_DIR := ./build
SRC_DIRS := ./src

SRCS := $(shell find $(SRC_DIRS) -name '*.c')
OBJS := $(SRCS:%=$(BUILD_DIR)/%.o)
DEPS := $(OBJS:.o=.d)

INC_DIRS := $(shell find $(SRC_DIRS) -type d)
INC_FLAGS := $(addprefix -I,$(INC_DIRS))

CFLAGS := $(INC_FLAGS) -std=c99 -pedantic -Wall -Werror -Wextra -MMD -MP -O3
LDFLAGS := -static

all: $(PROGRAM)

$(PROGRAM): $(OBJS)
	$(CC) $(OBJS) -o $@ $(LDFLAGS)

$(BUILD_DIR)/%.c.o: %.c
	mkdir -p $(dir $@)
	$(CC) $(CFLAGS) -c $< -o $@

run:
	./$(PROGRAM)

clean:
	rm -rf $(BUILD_DIR)
	rm -f $(PROGRAM)

install: all
	mkdir -p $(DESTDIR)$(PREFIX)/bin
	cp -f $(PROGRAM) $(DESTDIR)$(PREFIX)/bin
	chmod 755 $(DESTDIR)$(MANPREFIX)/man1
	sed "s/VERSION/$(VERSION)/g" < ./man/man1/$(MANPAGE) > $(DESTDIR)$(MANPREFIX)/man1/$(MANPAGE)
	chmod 644 $(DESTDIR)$(MANPREFIX)/man1/$(MANPAGE)

uninstall:
	rm -f $(DESTDIR)$(PREFIX)/bin/$(PROGRAM) \
		$(DESTDIR)$(MANPREFIX)/man1/$(MANPAGE)

.PHONY: all run clean install uninstall

-include $(DEPS)
