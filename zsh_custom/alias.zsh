# Python tools - added at 2015-02-10
alias ipqt='ipython qtconsole&'
alias junote='jupyter notebook&'
# Emacs
alias ed='emacs --daemon'
alias et='emacsclient -t'
alias ec='emacsclient -c &'

# Thefuck
alias fuck='eval $(thefuck $(fc -ln -1 | tail -n 1)); fc -R'
alias FUCK='fuck'


# Linux only
# ----------------------------------------------------------
# Custom keymap
alias xmod='xmodmap ~/.Xmodmap'

# sudo using user $PATH
alias sudoa='sudo env PATH=$PATH'

# xMind
# alias xmind='cd ~/Applications/xMind/XMind_Linux_64bit/ && ./XMind'
