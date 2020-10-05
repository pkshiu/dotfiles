#!/usr/bin/env zsh

# ref
# https://github.com/joshtronic/dotfiles/blob/master/zshrc

export DOTFILES=$HOME/dotfiles
export INCLUDES=$HOME/zfiles

echo "ZSH HERE..."
source DOTFILES/env
source DOTFILES/alias

HISTFILE=$HOME/.zsh_history
HISTSIZE=1000000
SAVEHIST=1000000

# select menu below command line with highlight, instead of just cycling through, so you can cursor select
zstyle ':completion:*' menu select

zstyle ':completion:*' completer _complete

# ignore case when matching dir names?
zstyle ':completion:*' matcher-list '' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}' '+l:|=* r:|=*'

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

PROMPT='%~ %# '

# plugins=(git colorize pip python brew osx zsh-completions zsh-syntax-highlighting)

# clone to local: https://github.com/zsh-users/zsh-completions
source $INCLUDES/zsh-completions/zsh-completions.plugin.zsh

autoload -Uz compinit && compinit

# with zsh-completions, complete directories and files...?
autoload -U compinit && compinit

# additional internal module?
zmodload -i zsh/complist

# get more colors? the dots colors do not work without this in the git prompt
autoload -U colors && colors # Enable colors in prompt

setopt AUTO_CD
setopt NO_CASE_GLOB
setopt prompt_subst

git_prompt() {
  BRANCH=$(git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/*\(.*\)/\1/')

  if [ ! -z $BRANCH ]; then
    echo -n "%F{yellow}$BRANCH"

    if [ ! -z "$(git status --short)" ]; then
      echo " %F{red}✗"
    fi
  fi
}

PS1='%F{white}%~$(git_prompt)%F{244}%# %F{reset}'



## FROM HERE:
# https://joshdick.net/2017/06/08/my_git_prompt_for_zsh_revisited.html
# https://github.com/joshdick/dotfiles/blob/main/zshrc.symlink also for full file
#
# Only appears if your current directory is a Git repository.
# Shows number of commits ahead and behind upstream, as applicable.
# Shows if a merge is currently taking place.
# Shows a “traffic light” representation of git status:
# Red (●) means there are untracked changes.
# Yellow (●) means there are unstaged changes.
# Green (●) means there are staged changes.

# Echoes a username/host string when connected over SSH (empty otherwise)
ssh_info() {
  [[ "$SSH_CONNECTION" != '' ]] && echo '%(!.%{$fg[red]%}.%{$fg[yellow]%})%n%{$reset_color%}@%{$fg[green]%}%m%{$reset_color%}:' || echo ''
}

# Echoes information about Git repository status when inside a Git repository
git_info() {

  # Exit if not inside a Git repository
  ! git rev-parse --is-inside-work-tree > /dev/null 2>&1 && return

  # Git branch/tag, or name-rev if on detached head
  local GIT_LOCATION=${$(git symbolic-ref -q HEAD || git name-rev --name-only --no-undefined --always HEAD)#(refs/heads/|tags/)}

  local AHEAD="%{$fg[red]%}⇡NUM%{$reset_color%}"
  local BEHIND="%{$fg[cyan]%}⇣NUM%{$reset_color%}"
  local MERGING="%{$fg[magenta]%}⚡︎%{$reset_color%}"
  local UNTRACKED="%{$fg[red]%}●%{$reset_color%}"
  local MODIFIED="%{$fg[yellow]%}●%{$reset_color%}"
  local STAGED="%{$fg[green]%}●%{$reset_color%}"

  local -a DIVERGENCES
  local -a FLAGS

  local NUM_AHEAD="$(git log --oneline @{u}.. 2> /dev/null | wc -l | tr -d ' ')"
  if [ "$NUM_AHEAD" -gt 0 ]; then
    DIVERGENCES+=( "${AHEAD//NUM/$NUM_AHEAD}" )
  fi

  local NUM_BEHIND="$(git log --oneline ..@{u} 2> /dev/null | wc -l | tr -d ' ')"
  if [ "$NUM_BEHIND" -gt 0 ]; then
    DIVERGENCES+=( "${BEHIND//NUM/$NUM_BEHIND}" )
  fi

  local GIT_DIR="$(git rev-parse --git-dir 2> /dev/null)"
  if [ -n $GIT_DIR ] && test -r $GIT_DIR/MERGE_HEAD; then
    FLAGS+=( "$MERGING" )
  fi

  if [[ -n $(git ls-files --other --exclude-standard 2> /dev/null) ]]; then
    FLAGS+=( "$UNTRACKED" )
  fi

  if ! git diff --quiet 2> /dev/null; then
    FLAGS+=( "$MODIFIED" )
  fi

  if ! git diff --cached --quiet 2> /dev/null; then
    FLAGS+=( "$STAGED" )
  fi

  local -a GIT_INFO
  GIT_INFO+=( "\033[38;5;15m±" )
  [ -n "$GIT_STATUS" ] && GIT_INFO+=( "$GIT_STATUS" )
  [[ ${#DIVERGENCES[@]} -ne 0 ]] && GIT_INFO+=( "${(j::)DIVERGENCES}" )
  [[ ${#FLAGS[@]} -ne 0 ]] && GIT_INFO+=( "${(j::)FLAGS}" )
  GIT_INFO+=( "\033[38;5;15m$GIT_LOCATION%{$reset_color%}" )
  echo "${(j: :)GIT_INFO}"

}

# Use ❯ as the non-root prompt character; # for root
# Change the prompt character color if the last command had a nonzero exit code
PS1='
%m $(ssh_info)%{$fg[magenta]%}%~%u $(git_info) %(?.%{$fg[blue]%}.%{$fg[red]%})%(!.#.$)%{$reset_color%} '




