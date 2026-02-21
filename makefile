default: help

.PHONY: help
help: # Show help for each of the Makefile recipes.
	@grep -E '^[a-zA-Z0-9 -]+:.*#'  Makefile | sort | while read -r l; do printf "\033[1;32m$$(echo $$l | cut -f 1 -d':')\033[00m:$$(echo $$l | cut -f 2- -d'#')\n"; done

.PHONY: link
link: # Creates symbolic links.
	ln -sfn ${PWD}/shell.sh ~/.shell.sh
	ln -sfn ${PWD}/shell.d ~/.shell.d
	ln -sfn ${PWD}/shell.functions.d ~/.shell.functions.d
	ln -sfn ${PWD}/shell.private.d ~/.shell.private.d
	ln -sfn ${PWD}/vim/vimrc ~/.vimrc
	ln -sfn ${PWD}/vim/coc-settings.json ~/.vim/coc-settings.json
	ln -sfn ${PWD}/vim/coc-settings.json ~/.config/nvim/coc-settings.json
	ln -sfn ${PWD}/tmux/tmux.conf ~/.tmux.conf
	ln -sfn ${PWD}/ack/ackrc ~/.ackrc
	ln -sfn ${PWD}/zsh/zshrc ~/.zshrc
	ln -sfn ${PWD}/ag/ignore ~/.ignore
	mkdir -p ~/Library/Application\ Support/Code/User/ && ln -sfn ${PWD}/VSCode/settings.json  ~/Library/Application\ Support/Code/User/settings.json || echo "error: can't link VSCode settings.json"
	mkdir -p ~/.claude
	ln -sfn ${PWD}/claude/CLAUDE.md ~/.claude/CLAUDE.md || echo "error: can't link CLAUDE.md"
	ln -sfn ${PWD}/claude/settings.json ~/.claude/settings.json || echo "error: can't link claude settings.json"
	ln -sfn ${PWD}/claude/statusline.sh ~/.claude/statusline.sh || echo "error: can't link claude statusline.sh"

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
