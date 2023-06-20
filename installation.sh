#!/bin/bash

install_for_windows() {
    echo "Start installation process for Windows..."

    git clone --branch windows https://github.com/dzungvu/bundletool-script.git

    # Specify the path and filename of the zip file
    zip_file="$(pwd)/bundletool-script/jdk-17.0.7/lib/modules.zip"

    # Specify the destination directory for the extracted files
    destination_dir="$(pwd)/bundletool-script/jdk-17.0.7/lib"

    # Unzip the file
    unzip "$zip_file" -d "$destination_dir"

    chmod +x bundletool-script/genApks.sh
}

install_for_mac() {
    echo "Start installation process for MacOS..."
    if [[ $(uname -p) == 'arm' ]]; then
        echo "Mac chipset ARM"
        git clone --branch mac-arm https://github.com/dzungvu/bundletool-script.git
    else
        echo "Mac chipset x86_64"
        git clone --branch mac-x86_64 https://github.com/dzungvu/bundletool-script.git
    fi

    # Specify the path and filename of the zip file
    zip_file="$(pwd)/bundletool-script/jdk-17.0.7.jdk/Contents/Home/lib/modules.zip"

    # Specify the destination directory for the extracted files
    destination_dir="$(pwd)/bundletool-script/jdk-17.0.7.jdk/Contents/Home/lib"

    # Unzip the file
    unzip "$zip_file" -d "$destination_dir"
    
    chmod +x bundletool-script/genApks.sh
}

install_for_linux() {
    echo "Start installation process for Linux..."

    git clone --branch linux https://github.com/dzungvu/bundletool-script.git

    # Specify the path and filename of the zip file
    zip_file="$(pwd)/bundletool-script/jdk-17.0.7/lib/modules.zip"

    # Specify the destination directory for the extracted files
    destination_dir="$(pwd)/bundletool-script/jdk-17.0.7/lib"

    # Unzip the file
    unzip "$zip_file" -d "$destination_dir"
    
    chmod +x bundletool-script/genApks.sh
}


# Check the value of OSTYPE variable
if [[ "$OSTYPE" == "linux-gnu" ]]; then
    install_for_linux
elif [[ "$OSTYPE" == "darwin"* ]]; then
    install_for_mac
elif [[ "$OSTYPE" == "msys" || "$OSTYPE" == "cygwin" || "$OSTYPE" == "win32" ]]; then
    install_for_windows
else
    echo "Unknown operating system"
fi
