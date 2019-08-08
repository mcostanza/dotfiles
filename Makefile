EXCLUDE := README.md
FILES := $(shell ls)
SOURCES := $(filter-out $(EXCLUDE),$(FILES))
DOTFILES := $(patsubst %, ${HOME}/.%, $(SOURCES))
NVIM_CONFIG := ${HOME}/.config/nvim/init.vim
NVIM_PLUG := ${HOME}/.local/share/nvim/site/autoload/plug.vim
VIM_PLUG := ${HOME}/.vim/autoload/plug.vim

.PHONY: vim-install uninstall dotfiles

dotfiles: $(DOTFILES) ## Links the the dotfiles in this directory to your $HOME, existing files will be ignored
nvim-config: $(NVIM_CONFIG)
install: dotfiles nvim-config vim-install

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
