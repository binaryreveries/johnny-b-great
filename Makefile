PROJECT=johnnybgreat
DIR := $(abspath $(dir $(lastword $(MAKEFILE_LIST))))

AMX_MOD_X_VERSION ?= 1.8.2
RELEASE=amxmodx-$(AMX_MOD_X_VERSION)
RELEASE_URL=https://github.com/alliedmodders/amxmodx/archive/$(RELEASE)

BUILD_DIR=$(DIR)/build/$(RELEASE)
PLUGIN_DIR=$(BUILD_DIR)/amxmodx-$(RELEASE)/plugins
OUT_DIR=$(BUILD_DIR)/compiled

SRC=$(DIR)/$(PROJECT).sma
PLUGIN=$(PROJECT).amxx

ARTIFACT=$(BUILD_DIR)/compiled/$(PLUGIN)

PC=./amxxpc
UNAME_S := $(shell uname -s)
ifeq ($(UNAME_S),Darwin)
    PC=./amxxpc_osx
endif

.PHONY: all amxmodx clean

default: all

all: $(ARTIFACT)

amxmodx: $(PLUGIN_DIR)

$(ARTIFACT):

clean:
	rm -rf "$(OUT_DIR)"

clean-amxmodx:
	rm -rf "$(BUILD_DIR)"

$(ARTIFACT): $(PLUGIN_DIR) $(OUT_DIR)
	cd "$(PLUGIN_DIR)" && $(PC) "$(SRC)" -o"$(ARTIFACT)"

$(OUT_DIR):
	mkdir -p "$(OUT_DIR)"

$(PLUGIN_DIR):
	mkdir -p "$(BUILD_DIR)"
	curl --location "$(RELEASE_URL).tar.gz" --output "$(RELEASE).tar.gz"
	tar xzvf "$(RELEASE).tar.gz" --directory "$(BUILD_DIR)"
