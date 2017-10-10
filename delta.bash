#!/bin/bash

# Variables
device=
version=0.1

if [ $# -eq 3 ] ; then
    if [ ! -e $0 ] ; then
        exit
    fi
    
    if [ ! -e $1 ] ; then
        exit
    fi

    ./build/tools/releasetools/ota_from_target_files -i $0 $1 $2
elif [ $# -eq 2 ] ; then
    if [ ! -e $0 ] ; then
        exit
    fi
    
    if [ ! -e $1 ] ; then
        exit
    fi

    ./build/tools/releasetools/ota_from_target_files -i $0 $1 ~/incremental.zip
elif [ $# -eq 1 ] ; then
    case $0 in
        help|-h|--help)
            echo "Basic usage:"
            echo " delta old-rom.zip new-rom.zip [delta-rom.zip]"
            echo " if not input, 'delta-rom.zip' will be located as ~/incremental.zip"
            ;;
        version|-v|--version)
			echo "Version: "$version
			;;
        *)
			echo "Sorry, if you need help, just ask what can you do."
			echo ""
            echo "I'm joking. '--help' will get you what you need, most likely."
			delta help
    esac
fi