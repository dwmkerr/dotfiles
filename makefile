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
	# Identity files hold live GitHub tokens, so no other account on the machine
	# may read them.
	chmod 700 shell.private.d
	chmod 600 shell.private.d/*.identity 2>/dev/null || true
	mkdir -p ~/.local/bin
	ln -sfn ${PWD}/shell.functions.d/identity/asid ~/.local/bin/asid
	ln -sfn ${PWD}/vim/vimrc ~/.vimrc
	mkdir -p ~/.vim ~/.config/nvim
	ln -sfn ${PWD}/vim/coc-settings.json ~/.vim/coc-settings.json
	ln -sfn ${PWD}/vim/coc-settings.json ~/.config/nvim/coc-settings.json
	ln -sfn ${PWD}/tmux/tmux.conf ~/.tmux.conf
	ln -sfn ${PWD}/ack/ackrc ~/.ackrc
	ln -sfn ${PWD}/zsh/zshrc ~/.zshrc
	ln -sfn ${PWD}/zsh/zshenv ~/.zshenv
	ln -sfn ${PWD}/bash/bashrc ~/.bashrc
	ln -sfn ${PWD}/bash/bash_profile ~/.bash_profile
	ln -sfn ${PWD}/ag/ignore ~/.ignore
	mkdir -p ~/Library/Application\ Support/Code/User/ && ln -sfn ${PWD}/vscode/settings.json  ~/Library/Application\ Support/Code/User/settings.json || echo "error: can't link VSCode settings.json"
	mkdir -p ~/.claude
	ln -sfn ${PWD}/claude/CLAUDE.md ~/.claude/CLAUDE.md || echo "error: can't link CLAUDE.md"
	ln -sfn ${PWD}/claude/settings.json ~/.claude/settings.json || echo "error: can't link claude settings.json"
	ln -sfn ${PWD}/claude/statusline.sh ~/.claude/statusline.sh || echo "error: can't link claude statusline.sh"
	mkdir -p ~/.claude/hooks
	ln -sfn ${PWD}/claude/hooks/tmux-notify.sh ~/.claude/hooks/tmux-notify.sh || echo "error: can't link tmux-notify.sh"
	mkdir -p ~/.config/opencode/plugin
	ln -sfn ${PWD}/opencode/plugin/tmux-notify.js ~/.config/opencode/plugin/tmux-notify.js || echo "error: can't link opencode tmux-notify.js"

.PHONY: iterm-profiles
# Profiles share nearly all their keys, so the common ones live in base.json and
# each overlay holds only what differs. A change to the keyboard map, colours or
# font is then made in one place.
iterm-profiles: # Install iTerm2 dynamic profiles.
	@mkdir -p ~/Library/Application\ Support/iTerm2/DynamicProfiles
	@jq -s '.[0] as $$base | {Profiles: [.[1:][] | $$base * .]}' \
		terminal/iTerm2/base.json terminal/iTerm2/profiles/*.json \
		> ~/Library/Application\ Support/iTerm2/DynamicProfiles/dotfiles.json
	@echo "Installed $$(jq '.Profiles | length' ~/Library/Application\ Support/iTerm2/DynamicProfiles/dotfiles.json) profiles"

.PHONY: private-files-backup
private-files-backup: # Backup private config files (ssh keys etc). Pass FILTER=<glob> to limit.
	./private-files/private-files-backup.sh "$(FILTER)"

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
