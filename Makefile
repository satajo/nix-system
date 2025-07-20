.DEFAULT_GOAL := help

.PHONY: build
build: format ## Build the new configuration, but neither activate it nor add it to the GRUB boot menu.
	nixos-rebuild build --flake .#$$(hostname) --show-trace

.PHONY: help
help: ## Print this help message.
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

.PHONY: format
format: ## Format all of .nix configuration files.
	nix fmt .

.PHONY: switch
switch: format ## Build the new configuration and make it the boot default.
	sudo nixos-rebuild switch --flake .#$$(hostname)

.PHONY: test
test: format ## Build and activate the new configuration, but do not add it to the GRUB boot menu.
	sudo nixos-rebuild test --flake .#$$(hostname)


.PHONY: regenerate-hardware-config
regenerate-hardware-config: ## Re-generate the hardware-configuration.nix for the current host.
	nixos-generate-config --show-hardware-config > host/$$(hostname)/hardware-configuration.nix
	nix fmt host/$$(hostname)/hardware-configuration.nix