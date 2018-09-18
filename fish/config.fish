set -x LANG en_US.UTF-8
set -x LC_CTYPE en_US.UTF-8

set PATH ~/anaconda3/bin $PATH

thefuck --alias | source

if test -f $HOME/.autojump/share/autojump/autojump.fish; . $HOME/.autojump/share/autojump/autojump.fish; end

