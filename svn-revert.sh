#!/bin/sh -x

usage() {
    echo "Usage: `basename $0` [-h] [PATH] [FILE]" 1>&2; exit 1;
}

# check argument is path or file
# return: Integer Return 0 if argument is path or file, otherwise 1
isPathOrFile() {
    if [ -f $1 ];then
        return 0
    else
        if [ -d $1 ];then
            return 0
        else
            return 1
        fi
    fi
}


# Get the Real Path/File name from the first argument
# return: string Return an available Path/File name if exist, current
# dir if empty
getRealRevertPath() {
    if [ "$1" == "" ]; then
        REVERT_PATH="."
    else
        isPathOrFile $1
        if [ "$?" -ne "0" ]
        then
            usage
        else
            REVERT_PATH=$1
        fi
    fi
}

revert() {
    REVERT_PATH=""
    getRealRevertPath $1

    if [ "$?" -ne "0" ]
    then
        exit $?
    fi
    echo "Finding missing files in current SVN repo..."
    MISSING_FILES=`svn st $REVERT_PATH|grep \!|awk '{print $2}'`
    MISSING_FILES_LEN=`echo "${#MISSING_FILES}"`
    if [ "$?" -eq "0" ];then
        if [ "$MISSING_FILES_LEN" -eq "0" ]
        then
            echo "Zero missing files in svn repo: `dirname $REVERT_PATH`"
            exit 0
        fi
        echo "SVN Missing files to be revert:"
        for line in $MISSING_FILES
        do
            echo "    $line"
        done
        while true; do
            echo ""
            read -p "Do you wish to revert all these file? (y/n)" yn
            case $yn in
                [Yy]* )
                    for line in $MISSING_FILES
                    do
                        echo "Reverting file:$line, continuing..."
                        svn revert $line
                    done;

                    break;;
                [Nn]* )
                    exit;;
                * ) echo "Please answer yes or no.";;
            esac
        done
        echo ""
        echo "Missing files reverted in path: $REVERT_PATH"
        echo ""
        echo "SVN status $REVERT_PATH:"
        svn st $REVERT_PATH
    fi
}

while getopts h o
do	case "$o" in
        h)	usage
            exit 0;;
    esac
done

revert $1
