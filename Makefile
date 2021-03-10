.PHONY: setup clean
.DEFAULT_GOAL := build

MOS_EXE := $(shell which mos)
BRW_EXE := $(shell which brew)
ESP_TOOL := $(shell which esptool.py)
UNAME := $(shell uname)
FIRMWARE_FILE := build/fw.zip
SOURCE_FILES := src/*.c 
IP_ADDRESS := 192.168.1.248

ENVIRONMENT = .venv
FLASHED = build/.flashed

erase: $(ESP_TOOL)
	$(ESP_TOOL) erase_flash

build: $(MOS_EXE) $(SOURCE_FILES)
	$(MOS_EXE) build --local --verbose

$(FLASHED):
	touch $(FLASHED)

flash: $(MOS_EXE) $(FIRMWARE_FILE) $(FLASHED)
	mos flash 

console: $(MOS_EXE)
	$(MOS_EXE) console

udp: $(MOS_EXE)
	$(MOS_EXE) console --port udp://:1993/

$(MOS_EXE):
	ifeq ($(UNAME), Darwin)
	$(BRW_EXE) tap cesanta/mos
	$(BRW_EXE) install mos
	endif

clean:
	git clean -xfd

post: $(FIRMWARE_FILE) $(FLASHED)
	curl -v -F file=@build/fw.zip http://$(IP_ADDRESS)/update