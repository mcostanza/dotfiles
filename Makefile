EXCLUDE := README.md
FILES := $(shell ls)
SOURCES := $(filter-out $(EXCLUDE),$(FILES))
DOTFILES := $(patsubst %, ${HOME}/.%, $(SOURCES))
NVIM_CONFIG := ${HOME}/.config/nvim/init.vim
NVIM_PLUG := ${HOME}/.local/share/nvim/site/autoload/plug.vim
VIM_PLUG := ${HOME}/.vim/autoload/plug.vim
VSCODE_PATH := ${HOME}/Library/Application\ Support/Code/User
VSCODE_EXTENSIONS_FILE := vscode/extensions.txt

.PHONY: vim-install uninstall dotfiles fonts macos-settings

dotfiles: $(DOTFILES) ## Links the the dotfiles in this directory to your $HOME, existing files will be ignored
nvim-config: $(NVIM_CONFIG)
install: dotfiles nvim-config vim-install vscode-config vscode-extensions fonts macos-settings

$(NVIM_CONFIG):
	mkdir -p ${HOME}/.config/nvim
	ln -s $(PWD)/config/nvim/init.vim $@

$(DOTFILES): $(addprefix ${HOME}/., %) : ${PWD}/%
	-ln -s $< $@ || echo "could not link $< -- you may have an existing dotfile"

$(NVIM_PLUG) $(VIM_PLUG):
	@curl -fLo $@ --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

uninstall: ## Uninstalls the currently linked files in your $HOME
	@echo $(DOTFILES) | xargs -n 1 sh -c 'unlink $$0 || true'

vim-install: $(NVIM_PLUG) $(VIM_PLUG) ## Install vim/nvim/macvim plugins
	@echo "Installing vim plugins"
	@nvim +PlugInstall +qa
	@vim +PlugInstall +qa
	@/Applications/MacVim.app/Contents/bin/mvim +PlugInstall +qa

vscode-config: ## Install vscode config
	mkdir -p $(VSCODE_PATH)
	ln -si ${PWD}/vscode/keybindings.json $(VSCODE_PATH)
	ln -si ${PWD}/vscode/settings.json $(VSCODE_PATH)

vscode-extensions: ## Install some shared vscode extensions
	xargs -n1 code --install-extension < $(VSCODE_EXTENSIONS_FILE)

fonts: ## Install fonts
	cp -f ./fonts/* ${HOME}/Library/Fonts

macos-settings: ## Customize mac os settings, taken from yadr
	./macos-settings

.PHONY: help
help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
