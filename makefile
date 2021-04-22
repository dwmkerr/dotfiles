# Creates symbolic links.
link:
	ln -sf $(pwd)/shell.sh ~/.shell.sh
	ln -sf $(pwd)/shell.d ~/.shell.d
	ln -sf $(pwd)/vim/vimrc ~/.vimrc
	ln -sf $(pwd)/vim/coc-settings.json ~/.vim/coc-settings.json
	ln -sf $(pwd)/vim/coc-settings.json ~/.config/nvim/coc-settings.json
	ln -sf $(pwd)/tmux/tmux.conf ~/.tmux.conf
	ln -sf $(pwd)/ack/ackrc ~/.ackrc
	ln -sf $(pwd)/zsh/zshrc ~/.zshrc
	ln -sf $(pwd)/ag/agignore ~/.agignore

# Backup private config files (ssh keys etc).
private-files-backup:
	./private-files/private-files-backup.sh

# Restore private config files (ssh keys etc).
private-files-restore:
	./private-files/private-files-restore.sh
