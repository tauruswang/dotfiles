set PATH ~/anaconda3/bin $PATH

thefuck --alias | source

if test -f $HOME/.autojump/share/autojump/autojump.fish; . $HOME/.autojump/share/autojump/autojump.fish; end

eval (pipenv --completion)
