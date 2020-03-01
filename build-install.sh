#!/bin/bash

dependencies() {
  echo "Installing dependencies..."
  sudo apt-get update

  # needed
  sudo apt-get install git build-essential gcc make autoconf pkg-config \
    libev-dev libstartup-notification0-dev libxcb-keysyms1-dev libpam0g-dev \
    libxkbcommon-x11-dev libyajl-dev libconfuse-dev libnl-genl-3-dev \
    asciidoc xmlto

  # my changes
  sudo apt-get install lxterminal dmenu dunst arandr xfce4-settings \
    xfce4-screenshooter xfce4-taskmanager xfce4-power-manager pnmixer feh
}

git_submodules() {
  echo "Updating submodules..."
  git submodule update --init --recursive
}

build() {
  name=$1
  echo "Building $name..."
  cd $name
  autoreconf -fi
  mkdir -p build
  cd build
  ../configure
  make -j8
  cd ../..
}

install() {
  name=$1
  echo "Installing $name..."
  cd $name/build
  sudo make install
  cd ..
  rm -r build
  cd ..
}

dependencies
git_submodules

build i3
build i3status
build i3lock

install i3
install i3status
install i3lock
