EXCLUDE := README.md Makefile Brewfile vscode-settings.json vscode-keybindings.json config
FILES := $(shell ls)
BREW_PREFIX := $(shell brew --prefix)
SOURCES := $(filter-out $(EXCLUDE),$(FILES))
DOTFILES := $(patsubst %, ${HOME}/.%, $(SOURCES))
NVIM_CONFIG := ${HOME}/.config/nvim/init.vim
NVIM_PLUG := ${HOME}/.local/share/nvim/site/autoload/plug.vim
VIM_PLUG := ${HOME}/.vim/autoload/plug.vim
VSCODE_PATH := ${HOME}/Library/Application\ Support/Code/User
VSCODE_EXTENSIONS_FILE := vscode/extensions.txt
SSH_CONFIG := ${HOME}/.ssh/config

.PHONY: update vim-install brew-install brew-bundle uninstall dotfiles git-user vscode-config vscode-extensions save-vscode-extensions

dotfiles: $(DOTFILES) ## Links the the dotfiles in this directory to your $HOME, existing files will be ignored
git-user: ${HOME}/.gituser ## Set up your git user config so your commits have your name and email on them
nvim-config: $(NVIM_CONFIG)
install: dotfiles brew-install brew-bundle yarn nvim-config vim-install git-user vscode-config vscode-extensions ssh-config
ssh-config: ${SSH_CONFIG}

yarn:
	nodenv install -s
	nodenv exec npm install yarn --quiet --silent -g

$(NVIM_CONFIG):
	mkdir -p ${HOME}/.config/nvim
	ln -s $(PWD)/config/nvim/init.vim $@

$(SSH_CONFIG):
	mkdir -p ${HOME}/.ssh
	ln -s $(PWD)/ssh/config $@
	chmod 644 $@


$(DOTFILES): $(addprefix ${HOME}/., %) : ${PWD}/%
	-ln -s $< $@ || echo "could not link $< -- you may have an existing dotfile"

$(NVIM_PLUG) $(VIM_PLUG):
	@curl -fLo $@ --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

${HOME}/.gituser:
	@read -p "Enter Your Full Name for Git Commits: " name; \
		read -p "Enter Your Email for Git Commits: " email; \
		git config -f ~/.gituser user.name "$$name"; \
		git config -f ~/.gituser user.email "$$email"

use-modern-bash: dotfiles brew-install ## Install recent version of bash and use instead of macos catalina's zsh
	@echo "Trusting bash 5 to use as shell, press enter to continue"; read
	sudo bash -c 'echo "${BREW_PREFIX}/bin/bash" >> /etc/shells'
	chsh -s "${BREW_PREFIX}/bin/bash"
	. ~/.bashrc

brew-install: ## Install brew, you should only need to do this once
	@if which brew; then brew update; else /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)";  fi;

brew-bundle: ## Installs all the applications listed in the Brewfile
	- brew bundle

vscode-config:
	mkdir -p $(VSCODE_PATH)
	- ln -s ${PWD}/vscode/keybindings.json $(VSCODE_PATH)
	- ln -s ${PWD}/vscode/settings.json $(VSCODE_PATH)

vscode-extensions: ## Install some shared vscode extensions
	xargs -n1 code --install-extension < $(VSCODE_EXTENSIONS_FILE)

save-vscode-extensions: ## Save your current extensions
	code --list-extensions > $(VSCODE_EXTENSIONS_FILE)

uninstall: ## Uninstalls the currently linked files in your $HOME
	@echo $(DOTFILES) | xargs -n 1 sh -c 'unlink $$0 || true'

vim-install: $(NVIM_PLUG) $(VIM_PLUG) ## Install vim/nvim/macvim plugins
	@echo "Installing vim plugins"
	@nvim +PlugInstall +qa
	@vim +PlugInstall +qa
	@`brew --prefix macvim`/MacVim.app/Contents/bin/mvim +PlugInstall +qa

update: ## Pull down the latest via git, be careful if you have local changes!
	@git pull

.PHONY: help
help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

# custom
.PHONY: fonts macos-settings bash-local install-all

fonts: ## Install fonts
	cp -f ${PWD}/config/fonts/* ${HOME}/Library/Fonts

macos-settings: ## Customize mac os settings, taken from yadr
	${PWD}/config/macos-settings

bash-local: ## terminal customizations
	ln -si ${PWD}/config/.bash.local ${HOME}/.bash.local
	ln -si ${PWD}/config/bash ${HOME}/bash

install-all: install fonts macos-settings bash-local
