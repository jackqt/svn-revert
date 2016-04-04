#!/bin/sh

usage() {
    printf "Usage: `basename $0` [-h] [PATH] [FILE]" 1>&2; exit 1;
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

    printf "Finding missing files in current SVN repo..."
    MISSING_FILES=`svn st $REVERT_PATH|grep \!|awk '{print $2}'`
    MISSING_FILES_LEN=`printf "${#MISSING_FILES}"`
    if [ "$?" -eq "0" ];then
        if [ "$MISSING_FILES_LEN" -eq "0" ]
        then
            printf "Zero missing files in svn repo: `dirname $REVERT_PATH`\n"
            exit 0
        fi
        printf "SVN Missing files to be revert:\n"
        for line in $MISSING_FILES
        do
            printf "\t$line\n"
        done

        ANSWER=""
        while true; do
            printf "\n"
            read -p "Do you wish to revert all these file? (y/n) " yn
            case $yn in
                [Yy]* )
                    ANSWER="y"
                    break;;
                [Nn]* )
                    ANSWER="n"
                    exit;;
                * ) printf "Please answer yes or no. \n";;
            esac
        done

        if [ "$ANSWER" == "n" ]
        then
            exit 0
        fi

        trap "exit 1" SIGINT
        for line in $MISSING_FILES
        do
            printf "\nReverting file:$line, continuing...\n"
            svn revert $line
        done;

        printf "\nMissing files reverted in path: $REVERT_PATH"
    fi
}

while getopts h o
do	case "$o" in
        h)	usage
            exit 0;;
    esac
done


revert $1
