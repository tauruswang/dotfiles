# User configuration

# export PATH=$HOME/bin:$PATH
# export MANPATH="/usr/local/man:$MANPATH"

# add Anaconda3 2.1.0 path by xashes (2015-02-08)
export PATH="$HOME/anaconda3/bin:$PATH"
export PATH="/usr/local/opt/icu4c/bin:$PATH"
export PATH="/usr/local/opt/icu4c/sbin:$PATH"

# add racket path by xashes
# export PATH="/Applications/Racket v6.1.1/bin:$PATH"

# add postgres path by xashes at (2015-05-08)
# export PATH=$PATH:/Applications/Postgres.app/Contents/Versions/9.4/bin


# You may need to manually set your language environment
export LANG=en_US.UTF-8
export LC_CTYPE=en_US.UTF-8


# pyenv
# eval "$(pyenv init -)"
# eval "$(pyenv virtualenv-init -)"

# virtualenvwrapper
export WORKON_HOME=$HOME/anaconda3/envs
export PROJECT_HOME=$HOME/Workspace
source $HOME/anaconda3/bin/virtualenvwrapper.sh

# add for pipenv
eval "$(pipenv --completion)"

# add for autoenv
source $(which activate.sh)

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/dsa_id"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
