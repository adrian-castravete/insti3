#!/bin/bash

dependencies() {
  echo "Installing dependencies..."
  sudo apt-tget update
  sudo apt-get install git build-essential gcc make autoconf pkg-config \
    libev-dev libstartup-notification0-dev libxcb-keysyms1-dev xmlto \
    libxkbcommon-x11-dev libyajl-dev libconfuse-dev libnl-genl-3-dev asciidoc
  sudo apt-get install lxterminal dmenu dunst arandr xfce4-settings \
    xfce4-screenshooter xfce4-taskmanager xfce4-power-manager pnmixer feh
}

git_submodules() {
  if ! [[ -e "i3/configure.ac" && -e "i3status/configure.ac" ]]
  then
    echo "Updating submodules..."
    git submodule update --init --recursive
  fi
}

build_i3() {
  echo "Building i3..."
  cd i3
  autoreconf -fi
  mkdir -p build
  cd build
  ../configure
  make -j8
  cd ../..
}

build_i3status() {
  echo "Building i3status..."
  cd i3status
  autoreconf -fi
  mkdir -p build
  cd build
  ../configure
  make -j8
  cd ../..
}

install_i3() {
  echo "Installing i3..."
  cd i3/build
  sudo make install
  cd ..
  rm -r build
  cd ..
}

install_i3status() {
  echo "Installing i3status..."
  cd i3status/build
  sudo make install
  cd ..
  rm -r build
  cd ..
}

copy_settings() {
  echo "Copying settings..."
}

dependencies
git_submodules

build_i3
build_i3status

install_i3
install_i3status

copy_settings
