OS = $(shell uname -s)

DWM_PREFIX = $(CURDIR)/dwm
BIN_PREFIX = ${HOME}/.local/bin

ifeq "$(OS)" "Linux"
	ID = $(shell grep -w 'ID' /etc/os-release | cut -d '=' -f 2 | tr -d '"')
endif

ifdef ID
	ifeq "$(ID)" "void"
		PKGC = sudo xbps-install -y
		DEPS = $(shell cat ./deps/linux/void)
	endif
endif

ifndef PKGC
	$(error unknown package manager command)
endif
ifndef DEPS
	$(error unknown dependencies file)
endif
