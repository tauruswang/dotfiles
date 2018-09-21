set -x LANG en_US.UTF-8
set -x LC_CTYPE en_US.UTF-8

set -x PATH ~/anaconda3/bin $PATH
set -x WORKON_HOME ~/.local/share/virtualenvs

thefuck --alias | source

if test -f $HOME/.autojump/share/autojump/autojump.fish; . $HOME/.autojump/share/autojump/autojump.fish; end

set -x RQDATAC_CONF rqdatac://license:VBQPRCg-JXUEbbe4TTds3c4tza5iIA1UoX-jtLVLeNpW9BKhzqRL5Q2M5rR0i5lrx5FrpYGLWXfJ-Om84f00gEXA2mHQaVhpq1xCWgUa2OQTtIK-QziCyfjmxvdmxCj0GiAZFtUaiTIfQhE9lBNiOXy-uzPquFelU4lLTNI6NhY=I4eQ6OQ1HorEbJ59z88sRhjyB7XSpnxKXiGcq49ujWhHoqWqqgAg4LKjuhCbjPCRPIVepzNz8MyRY5FB-cW_C6UexcG_tq5398J6wwc9yxTV-h-Ii75iwJVX1Xu2M4c9d6Cfy_t3R2ldgJtPZfDNyA6bNapWhFqFPw8_3zqbMOI=@rqdatad-pro.ricequant.com:16004
