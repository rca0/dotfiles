.PHONY: init
init: 
	@echo "-> init start bootstrap script"
	@bash -c ./bootstrap.sh

.PHONY: bundle
bundle:
	@echo "-> bundle"
	@bash -c brew bundle

.PHONY: dump
dump:
	@echo "-> dump"
	@bash -c brew bundle dump --force

.PHONY: update
update:
	@echo "-> update"
	@bash -c brew update
