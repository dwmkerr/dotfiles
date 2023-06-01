# Creates symbolic links.
.PHONY: link
link:
	ln -sf ${PWD}/shell.sh ~/.shell.sh
	ln -sf ${PWD}/shell.d ~/.shell.d
	ln -sf ${PWD}/vim/vimrc ~/.vimrc
	ln -sf ${PWD}/vim/coc-settings.json ~/.vim/coc-settings.json
	ln -sf ${PWD}/vim/coc-settings.json ~/.config/nvim/coc-settings.json
	ln -sf ${PWD}/tmux/tmux.conf ~/.tmux.conf
	ln -sf ${PWD}/ack/ackrc ~/.ackrc
	ln -sf ${PWD}/zsh/zshrc ~/.zshrc
	ln -sf ${PWD}/ag/ignore ~/.ignore
	ln -sf ${PWD}/VSCode/settings.json  '~/Library/Application Support/Code/User/settings.json'

# Backup private config files (ssh keys etc).
.PHONY: private-files-backup
private-files-backup:
	./private-files/private-files-backup.sh

# Restore private config files (ssh keys etc).
.PHONY: private-files-restore
private-files-restore:
	./private-files/private-files-restore.sh

.PHONY: setup
setup:
	./setup.sh
