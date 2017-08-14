# bashrc is for interactive non login shell
# Therefore set environments and other things that are required
# for running commands but nothing that is visual.

# virtualenv wrapper
export WORKON_HOME=$HOME/webapps
source /usr/local/bin/virtualenvwrapper.sh

### Added by the Heroku Toolbelt
export PATH="/usr/local/heroku/bin:$PATH"

export NVM_DIR="/Users/pk/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
