CC := gcc
CFLAGS := -Wall -Werror -I.
LIBRARY_NAME := sylib
SOURCE_FILES := sylib.c sylib.h

$(LIBRARY_NAME).a: $(SOURCE_FILES:.c=.o)
	ar rcs $@ $^

%.o: %.c
	$(CC) $(CFLAGS) -c -o $@ $<
