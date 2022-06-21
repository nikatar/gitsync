#!/bin/bash

function _folder ()
{
    if [ "$2" = "i" ]; then
        if [ -d "$1" ]; then
            echo "The folder $1 already exists"
            exit 1
        fi
    elif [ "$2" = "n" ]; then
        if [ -d "$1" ]; then
            return 0
	else
	    echo "The folder $1 does not exists"
	    exit 1
        fi
    fi
}

function create ()
{
    _folder $2 "i"
    echo "Cloning '$1'"
    git clone --mirror $1 $2 &> /dev/null
    cd $2
    echo "Setting remote '$3'"
    git remote set-url --push origin $3 &> /dev/null
    echo "Done.";
}

function push ()
{
    _folder $1 "n"
    cd $1
    echo "Pushing '$(pwd)'"
    git push --mirror  &> /dev/null
    echo "Pushed.";
}

function pull ()
{
    _folder $1 "n"
    cd $1
    echo "Pulling '$(pwd)'"
    git fetch -p origin &> /dev/null
    echo "Pulled.";
}

function sync ()
{
    _folder $1 "n"
    cd $1
    echo "Syncing '$(pwd)'"
    git fetch -p origin &> /dev/null
    git push --mirror &> /dev/null
    echo "Synced.";
}

function delete()
{
    _folder $1 "n"
    echo "Deleting '$(pwd)/$1'"
    rm -rf $1
    echo "Deleted."
}

function help ()
{
    echo "Creating (Create a new local mirror)"
    echo "  Command: gitsync create <source> <folder> <target>"
    echo "  Arguments:"
    echo "      <source> = Source Git repository"
    echo "      <folder> = The local name for the repository"
    echo "      <target> = Target Git repository"
    echo ""
    echo "Push (Push the local mirror)"
    echo "  Command: gitsync push <folder>"
    echo "  Arguments:"
    echo "      <folder> = The local name for the repository"
    echo ""
    echo "Pull (Pull to local mirror)"
    echo "  Command: gitsync pull <folder>"
    echo "  Arguments:"
    echo "      <folder> = The local name for the repository"
    echo ""
    echo "Sync (Fetch original and push mirror)"
    echo "  Command: gitsync sync <folder>"
    echo "  Arguments:"
    echo "      <folder> = The local name for the repository"
    echo ""
    echo "Delete (Remove local mirror)"
    echo "  Command: gitsync delete <folder>"
    echo "  Arguments:"
    echo "      <folder> = The local name for the repository"
}

cd $(pwd)
if [ "${1}" = "create" ]
then
    if [ -n "${2}" ] || [ -n "${3}" ] || [ -n "${4}" ];
    then
        create ${2} ${3} ${4}
    fi
elif [ "${1}" = "push" ]
then
    if [ -n "${2}" ];
    then
        sync ${2}
    fi
elif [ "${1}" = "pull" ]
then
    if [ -n "${2}" ];
    then
        pull ${2}
    fi
elif [ "${1}" = "sync" ]
then
    if [ -n "${2}" ];
    then
        sync ${2}
    fi
elif [ "${1}" = "delete" ]
then
    if [ -n "${2}" ];
    then
        delete ${2}
    fi
elif [ "${1}" = "help" ]
then
    help
else
    help
fi
