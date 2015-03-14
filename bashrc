# bashrc is for interactive non login shell
# Therefore set environments and other things that are required
# for running commands but nothing that is visual.

# virtualenv wrapper
export WORKON_HOME=$HOME/webapps
source /usr/local/bin/virtualenvwrapper.sh

### Added by the Heroku Toolbelt
export PATH="/usr/local/heroku/bin:$PATH"
