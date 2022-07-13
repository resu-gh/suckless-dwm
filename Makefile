include config.mk

.DEFAULT_GOAL := help

.SILENT: help
.PHONY: help # print help
help:
	grep '^.PHONY: .* #' $(firstword $(MAKEFILE_LIST)) |\
	sed 's/\.PHONY: \(.*\) # \(.*\)/\1 # \2/' |\
	awk 'BEGIN {FS = "#"}; {printf "%-30s%s\n", $$1, $$2}'

.SILENT: build
.PHONY: build # @combo [clean deps compile]
build: clean deps compile bin

.SILENT: deps
.PHONY: deps # install required dependencies
deps:
	$(PKGC) $(DEPS)

.PHONY: bin # copy bin
bin:
	if [ ! -d "$(BIN_PREFIX)" ]; then mkdir -p "$(BIN_PREFIX)"; fi
	for file in bin/*; do \
		cp -f $$file $(BIN_PREFIX); \
		chmod 755 $(BIN_PREFIX)/$$(basename $(notdir $$file)); \
	done

.PHONY: compile # compile dwm
compile:
	rm -f $(DWM_PREFIX)/config.h
	make -C $(DWM_PREFIX)
	sudo make -C $(DWM_PREFIX) install
	sudo make -C $(DWM_PREFIX) clean
	rm -f $(DWM_PREFIX)/config.h

.PHONY: clean # uninstall dwm
clean:
	sudo make -C $(DWM_PREFIX) uninstall
	for file in bin/*; do rm -f $(BIN_PREFIX)/$$(basename $(notdir $$file)); done
