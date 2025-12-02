# If not running interactively, don't do anything (leave this at the top of this file)
[[ $- != *i* ]] && return

# All the default Omarchy aliases and functions
# (don't mess with these directly, just overwrite them here!)
source ~/.local/share/omarchy/default/bash/rc

source ~/.bash_aliases

# Add your own exports, aliases, and functions here.
#
# Make an alias for invoking commands you use constantly
# alias p='python'

# Generated for envman. Do not edit.
[ -s "$HOME/.config/envman/load.sh" ] && source "$HOME/.config/envman/load.sh"

export PATH="$PATH:$HOME/scripts"
export PATH=$PATH:/usr/local/go/bin
export PATH=$PATH:$HOME/go/bin

bind -x '"\C-f":"tmux-sessionizer"'

alias ff="fzf --preview 'bat --style=numbers --color=always {}'"
alias fv='nvim $(fzf --preview="bat --color=always {}")'
alias nv='nvim .'


# Alias para iniciar o daemon do tablet wacom 
alias tablet='otd-daemon'

if command -v fzf &> /dev/null; then
  if [[ -f /usr/share/fzf/completion.bash ]]; then
    source /usr/share/fzf/completion.bash
  fi
  if [[ -f /usr/share/fzf/key-bindings.bash ]]; then
    source /usr/share/fzf/key-bindings.bash
  fi
fi

