default: help

.PHONY: help
help: # Show help for each of the Makefile recipes.
	@grep -E '^[a-zA-Z0-9 -]+:.*#'  Makefile | sort | while read -r l; do printf "\033[1;32m$$(echo $$l | cut -f 1 -d':')\033[00m:$$(echo $$l | cut -f 2- -d'#')\n"; done

.PHONY: link
link: # Creates symbolic links.
	ln -sf ${PWD}/shell.sh ~/.shell.sh
	ln -sf ${PWD}/shell.d ~/.shell.d
	ln -sf ${PWD}/shell.functions.d ~/.shell.functions.d
	ln -sf ${PWD}/shell.private.d ~/.shell.private.d
	ln -sf ${PWD}/vim/vimrc ~/.vimrc
	ln -sf ${PWD}/vim/coc-settings.json ~/.vim/coc-settings.json
	ln -sf ${PWD}/vim/coc-settings.json ~/.config/nvim/coc-settings.json
	ln -sf ${PWD}/tmux/tmux.conf ~/.tmux.conf
	ln -sf ${PWD}/ack/ackrc ~/.ackrc
	ln -sf ${PWD}/zsh/zshrc ~/.zshrc
	ln -sf ${PWD}/ag/ignore ~/.ignore
	ln -sf ${PWD}/VSCode/settings.json  '~/Library/Application Support/Code/User/settings.json'
	mkdir -p ~/.claude
	ln -sf ${PWD}/.claude/CLAUDE.md ~/.claude/CLAUDE.md

.PHONY: private-files-backup
private-files-backup: # Backup private config files (ssh keys etc).
	./private-files/private-files-backup.sh

.PHONY: private-files-restore
private-files-restore: # Restore private config files (ssh keys etc).
	./private-files/private-files-restore.sh

.PHONY: install-binaries
install-binaries: # Install dotfiles binaries to /usr/local/bin.
	./scripts/install-binaries.sh

.PHONY: setup
setup: # Setup the local machine.
	./setup.sh

.PHONY: test-shell.d
test-shell.d: # Test and time the shell configuration file.
	./scripts/test-shell.d.sh
