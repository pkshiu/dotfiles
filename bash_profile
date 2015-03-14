# real work is in .bashrc because we want it for both interactive and
# non interactive shells
if [ -f ~/.bashrc ]; then
    . ~/.bashrc
fi

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# simple version
export PS1='\h [\w]\$ '

if [ -f $(brew --prefix)/etc/bash_completion ]; then
  source $(brew --prefix)/etc/bash_completion
  source $(brew --prefix)/etc/bash_completion.d/git-prompt.sh

  # monochrome version
  # PS1="\h:[\w:]\$(__git_ps1 \"(%s)\")\$ "
  # color version
  PS1="\[\e[1;32m\]\h:\[\e[0m\]\w:\[\e[1;34m\]\$(__git_ps1 \"(%s)\")\[\e[0m\]$ "
fi

