LUA_VERSION ?= 5.3

CFLAGS += -fPIC -O2
CPPFLAGS += -Isrc
LDFLAGS += -O2


CFLAGS += $(shell pkg-config lua$(LUA_VERSION) --cflags-only-other)
CPPFLAGS += $(shell pkg-config lua$(LUA_VERSION) --cflags-only-I)
LDFLAGS += $(shell pkg-config lua$(LUA_VERSION) --libs-only-L)
LDFLAGS += $(shell pkg-config lua$(LUA_VERSION) --libs-only-other)
LDLIBS += $(shell pkg-config lua$(LUA_VERSION) --libs-only-l)


lib_objs := \
  src/lua_syslog.o

syslog.so:LDFLAGS += --retain-symbols-file syslog.map
syslog.so: $(lib_objs)
	$(LD) $(LDFLAGS) -shared -o syslog.so $(lib_objs) $(LDLIBS)

%.o: %.c src/lua_syslog.h
	$(CC) $(CFLAGS) $(CPPFLAGS) -c $< -o $@

install: syslog.so
	install -d $(DESTDIR)/usr/lib/lua/$(LUA_VERSION)
	install syslog.so $(DESTDIR)/usr/lib/lua/$(LUA_VERSION)/syslog.so

.PHONY: install
.SECONDARY: $(lib_objs)
