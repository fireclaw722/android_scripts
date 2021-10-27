#!/bin/bash

# Variables
export version=0.9.1 device buildDate updaterDate releaseType romName=graphene romVers fileName

cleanMka() {
    cd ~/android/$romName/$romVers

    # Save build_date and build_number for multi-device builds
    # delete them manually to run with new build-number/date
    mv out/build_date.txt ./
    mv out/build_number.txt ./

    # Clean ROM build
    if ! make clean ; then
        m clean
    fi

    # Restore build_date and build_number
    mv build_date.txt out/
    mv build_number.txt out/

    # Clean 4 series
    cd ~/android/$romName/$romVers/kernel/google/coral
    if ! make clean ; then
        m clean
    fi

    # Clean 3, 3a series
    cd ~/android/$romName/$romVers/kernel/google/crosshatch
    if ! make clean ; then
        m clean
    fi

    # Clean 4a 5G & 5
    cd ~/android/$romName/$romVers/kernel/google/redbull
    if ! make clean ; then
        m clean
    fi

    # Clean 4a
    cd ~/android/$romName/$romVers/kernel/google/sunfish
    if ! make clean ; then
        m clean
    fi

    # Clean 5a
    cd ~/android/$romName/$romVers/kernel/google/barbet
    if ! make clean ; then
        m clean
    fi
}

setupEnv() {
    cd ~/android/$romName/$romVers
    source script/envsetup.sh
    choosecombo release $device user
    export OFFICIAL_BUILD=true
}

buildKernel() {
    # Get the correct directory per device
    if [[ "$device" = "blueline" || "$device" = "bonito" || "$device" = "crosshatch" || "$device" = "sargo" ]] ; then
        if ! cd ~/android/$romName/$romVers/kernel/google/crosshatch ; then
            echo "Kernel directory does not exist"
            echo "Ensure that the right tags have been synced, or try syncing the dev branch"
            exit
        fi
    elif [[ "$device" = "coral" || "$device" = "flame" ]] ; then
        if ! cd ~/android/$romName/$romVers/kernel/google/coral ; then
            echo "Kernel directory does not exist"
            echo "Ensure that the right tags have been synced, or try syncing the dev branch"
            exit
        fi
    elif [[ "$device" = "sunfish" || "$device" = "barbet" ]] ; then
        if ! cd ~/android/$romName/$romVers/kernel/google/$device ; then
            echo "Kernel directory does not exist"
            echo "Ensure that the right tags have been synced, or try syncing the dev branch"
            exit
        fi
    elif [[ "$device" = "bramble" || "$device" = "redfin" ]] ; then
        if ! cd ~/android/$romName/$romVers/kernel/google/redbull ; then
            echo "Kernel directory does not exist"
            echo "Ensure that the right tags have been synced, or try syncing the dev branch"
            exit
        fi
    fi

    # Get Ready
    git submodule sync
    git submodule update --init --recursive

    # Build
    if [[ "$device" = "blueline" || "$device" = "bonito" || "$device" = "crosshatch" || "$device" = "coral" || "$device" = "sunfish" || "$device" = "bramble" || "$device" = "redfin" || "$device" = "barbet" ]] ; then
        if ! ./build.sh $device ; then
            exit
        fi
    elif [[ "$device" = "sargo" ]] ; then
        if ! ./build.sh bonito ; then
            exit
        fi
    elif [[ "$device" = "flame" ]] ; then
        if ! ./build.sh coral ; then
            exit
        fi
    fi
}

buildDevice() {
    cd ~/android/$romName/$romVers

    # Build target_files
    if ! m target-files-package ; then
        exit
    fi

    # Build ota-tools
    if ! m otatools-package ; then
        exit
    fi
}

saveFiles() {
    cd ~/android/$romName/$romVers

    if ! script/release.sh $device ; then
        exit
    fi

    mkdir ~/android/$romName/$romVers/releases/$BUILD_NUMBER/

    if ! mv out/release-$device-$BUILD_NUMBER/ releases/$BUILD_NUMBER/release-$device-$BUILD_NUMBER/ ; then
        echo "Moving release failed"
        exit
    fi

    # Don't generate incremental for experimental builds
    if [[ "$releaseType" = "release" ]] ; then
        if ! script/generate_delta.sh $device $(ls releases | tail -n2 | head -n1) $BUILD_NUMBER ; then
            exit
        fi
    fi
}
# supported devices
if [[ "$1" = "blueline" || "$1" = "bonito" || "$1" = "crosshatch" || "$1" = "coral" || "$1" = "sunfish" || "$1" = "bramble" || "$1" = "redfin" || "$1" = "sargo" || "$1" = "flame" || "$1" = "barbet" ]] ; then
    export device=$1
else
    echo "Device" $1 "is currently not supported"
    echo "please enter a supported device and try again"
    exit
fi

# versions
if [[ "$2" = "11" || "$2" = "12" ]] ; then
    export romVers=$2
else
    echo "Version" $2 "is currently not supported"
    echo "please enter a supported version and try again"
    exit
fi

cd ~/android/$romName/$romVers

# run build
setupEnv
cleanMka
setupEnv
buildKernel
buildDevice
saveFiles

# cleanup
cleanMka