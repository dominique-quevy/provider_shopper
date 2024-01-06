#!/bin/bash -x
clear
echo "-----"
echo "nano \$HOME/.bashrc"
echo "normally this line must be appended to .bashrc: "
echo "  export PATH=\"/workspaces/provider_shopper/flutter/bin:\$PATH\""
#echo $PATH
which flutter
echo "-----"
echo ""
echo "-----"
flutter --version
echo "-----"
echo ""
read -p 'switch back to flutter 3.13.1 as the next of Flutlab.io (Y/n)? ' flutter_downgrade
if [ $flutter_downgrade == "Y" ]
then
    echo "----- use flutter 3.13.1"
    dart pub cache clean
    flutter pub cache clean
    # wget https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_3.13.1-stable.tar.xz
    # tar xf flutter_linux_3.13.1-stable.tar.xz
    # rm -v flutter_linux_3.13.1-stable.tar.xz
    cd /workspaces/provider_shopper/flutter/bin
    git checkout 3.13.1 
    cd /workspaces/provider_shopper
    dart pub get
    flutter pub get
    flutter config --enable-web
fi
echo "-----"
echo ""
echo "-----"
flutter --version
echo "-----"
echo ""
echo "-----"
echo "flutter --help"
echo "-----"
echo ""
echo "-----"
cd /workspaces/provider_shopper
echo "ls -ahl"
echo "-----"
echo ""
