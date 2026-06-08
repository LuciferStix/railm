GO ?= go
BUILD ?= build
RAILAPI ?= .
VERSION ?= 

TARGETS = \
	$(BUILD)/railapi-linux-amd64-$(VERSION) \
	$(BUILD)/railapi-linux-arm64-$(VERSION) \
	$(BUILD)/railapi-darwin-arm64-$(VERSION)

.PHONY: build build-minimal run clean help

help:
	@echo "Usage: make [options] [envs]"
	@echo "  Options:"
	@echo "    help                                 Prints help."
	@echo "    build [VERSION]                      Builds server binaries for multiple platforms."
	@echo "    |- build-minimal                     Builds server binaries for current platform."
	@echo "    run [PORT,                           Run server."
	@echo "         TURSO_DATABASE_URL,"
	@echo "         TURSO_DATABASE_TOKEN]"
	@echo
	@echo "    clean [VERSION]                      Cleans build artifacts."
	@echo
	@echo "  Environment Variables:"
	@echo "    PORT (default: 3000)                 Url for Railapi hosted server."
	@echo "    TURSO_DATABASE_URL                   Url for TursoDB."
	@echo "    TURSO_DATABASE_TOKEN                 Token for TursoDB."
	@echo "    VERSION                              Build Version."

build: $(TARGETS)

build-minimal: $(BUILD)/server

run: $(BUILD)/server
	./$<
	
$(BUILD)/server: $(RAILAPI)/cmd/server/main.go
	$(GO) build -o $@ $<

$(BUILD)/railapi-linux-amd64-$(VERSION): $(RAILAPI)/cmd/server/main.go
	GOOS=linux GOARCH=amd64 $(GO) build -o $@ $<

$(BUILD)/railapi-linux-arm64-$(VERSION): $(RAILAPI)/cmd/server/main.go
	GOOS=linux GOARCH=arm64 $(GO) build -o $@ $<

$(BUILD)/railapi-darwin-arm64-$(VERSION): $(RAILAPI)/cmd/server/main.go
	GOOS=linux GOARCH=arm64 $(GO) build -o $@ $<

clean:
	rm -rf $(BUILD)/server
	rm -rf $(TARGETS)
