if [ $(arch) = "arm64" ]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
else
  eval "$(/usr/local/bin/brew shellenv)"
fi

source ~/.colors;
source ~/.exports;

eval "$(rbenv init -)"
eval "$(nodenv init -)"
eval "$(pyenv init - --path)"

alias tilt="/usr/local/bin/tilt"

if [ -z $ZSH_NAME ]; then
  # `brew install bash-completion`
  if [ -f $(brew --prefix)/etc/bash_completion ]; then
    . $(brew --prefix)/etc/bash_completion
  fi

  if [ -f `brew --prefix`/etc/bash_completion.d/git-completion.bash ]; then
    . `brew --prefix`/etc/bash_completion.d/git-completion.bash
  fi

  if [ -f `brew --prefix`/etc/bash_completion.d/git-prompt.sh ]; then
    . `brew --prefix`/etc/bash_completion.d/git-prompt.sh
  fi
fi

# Include your own customizations!
[[ -f ~/.bash.local ]] && source ~/.bash.local
[ -f ~/.fzf.bash ] && source ~/.fzf.bash

# [Apple Changed the default CFLAGS for clang in XCode 12](https://developer.apple.com/documentation/xcode-release-notes/xcode-12-release-notes)
# Makes Ruby 2.6.7 possible to compile
export CFLAGS="-Wno-error=implicit-function-declaration"

alias tilt=$(brew --prefix)/bin/tilt
