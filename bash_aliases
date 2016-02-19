alias l='ls -alF'
alias lsd='ls -alF | grep '^d''
alias d=less
alias em=emacs

alias da='django-admin.py'
alias mg='./manage.py'

# for python code coverage, note: this has -k in it
alias cover="coverage run --source='.' manage.py test --failfast -k"

# Safe is better
alias cp='cp -iv'
alias mv='mv -iv'

# OSX
alias finder='open -a Finder ./'

alias dev='cddev ~/proj/dj/wmidev'
alias kdev='cddev ~/proj/dj/kndev'
alias adev='cddev ~/proj/dj/avdev'
alias cdev='cddev ~/proj/dj/cmcdev'
alias 3dev='cddev ~/proj/dj/341dev'
alias jsc='/System/Library/Frameworks/JavaScriptCore.framework/Versions/Current/Resources/jsc'
alias grepy='grep -ir --include=*.py'

alias weat='/Users/pk/webapps/piglowserver/bin/python /Users/pk/webapps/piglowserver/src/weather.py'

alias da_create_1='da_create 1.0 django-1.0-beta_1 impdev'
alias da_create_96='da_create 0.96 django-0.96.2 imp96dev'

#
# cddev env_name dir
#
function cddev()
{
     # handle path/path/path

     case ${2%%/*} in
     bin | logs ) cd $1/apache2/$2;;

     * ) cd $1/$2;;
     esac


}



#
# daset -- setup django environment at current dir for 1.0 beta django
# include imperial library
#
function daset()
{
    implib=$HOME/proj/dj/impdev
    # djlib=$HOME/extlib/Django-1.0-beta_1
    djlib=$HOME/extlib/python

    if [ -e settings.py ]
    then
        h=`pwd`
        export PYTHONPATH=$h:$implib:$djlib
        export DJANGO_SETTINGS_MODULE=settings
        export PATH=$djlib/django/bin:$PATH

        echo "Django 1.1 environment setup for " `pwd`
    else
        echo "No Django environment!"
    fi
}

#
# daset.1 -- setup django environment at current dir for 1.1
# include imperial library
#
function daset.1()
{
    # implib=$HOME/proj/dj/impdev
    # djlib=$HOME/extlib/Django-1.0-beta_1
    h=`pwd`
    if [ -e $h/django ]
    then
        echo 'django 1.1 found'
    else
        echo 'No django 1.1 found'
        exit
    fi

    if [ -e settings.py ]
    then
        h=`pwd`
        export PYTHONPATH=$h
        export DJANGO_SETTINGS_MODULE=settings
        export PATH=$h/django/bin:$PATH

        echo "Django 1.1 environment setup for " `pwd`
    else
        echo "No Django environment!"
    fi
}




#
# daset3 -- setup django environment at current dir
# new version allows for multiple Imperial and Django versions
#
function daset3()
{
    echo 'Setting up runtime for django app...'

    if [ ! -e settings.py ]
    then
        echo "No Django environment!"
	return 1
    fi

    if [ ! -e lib ]
    then
        echo "No local lib directory for libraries."
	return 1
    fi

    if [ ! -e lib/imperial ]
    then
        echo "No imperial local library."
	return 1
    fi

    if [ ! -e lib/django ]
    then
        echo "No django local library."
	return 1
    fi

    if [ -e settings.py ]
    then
        h=`pwd`
        export PYTHONPATH=$h:$h/lib
        export DJANGO_SETTINGS_MODULE=settings
        echo "pythonpath= $PYTHONPATH"

        export PATH=$h/lib/django/bin:$PATH
        echo "path= $PATH"
        echo "Django environment setup for " `pwd`
    else
        echo "No Django environment!"
    fi
}


#
# Create a django runtime environment, new style.
# Takes three arguments: version-description  django-lib-name implib-name
# Easiest use in alias
# e.g.
#      da_create 1.0 django-0.96.2 imp96dev
#
function da_create()
{
    ver=$1
    djlib=$2
    implib=$3

    echo "Creating django $ver environment..."

    if [ ! -e lib ]
    then
        mkdir lib
    fi

    if [ -h lib/imperial ]
    then
        unlink lib/imperial
    elif [ -e lib/imperial ]
    then
        echo "imperial exists as a file or directory?"
	return 1
    fi

    ln -s $HOME/proj/dj/${implib}/imperial lib/imperial
    echo "Imperial Library linked for django $ver"


    if [ -h lib/django ]
    then
        unlink lib/django
    elif [ -e lib/django ]
    then
        echo "django exists as a file or directory?"
	return 1
    fi

    ln -s $HOME/extlib/${djlib}/django lib/django
    echo "Django Library linked for django $ver"
}


