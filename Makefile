.PHONY: init
init: 
	@echo "-> init start bootstrap script"
	@./bootstrap.sh

.PHONY: bundle
bundle:
	@echo "-> bundle"
	@brew bundle

.PHONY: dump
dump:
	@echo "-> dump"
	@brew bundle dump --force

.PHONY: update
update:
	@echo "-> update"
	@brew update
