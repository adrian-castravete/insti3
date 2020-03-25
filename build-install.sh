#!/bin/bash

dependencies() {
  echo "Installing dependencies..."
  sudo apt-get update

  # needed
  sudo apt-get install --no-install-recommends -y git build-essential gcc make \
    autoconf automake pkg-config libev-dev libstartup-notification0-dev \
    libxcb-keysyms1-dev libpam0g-dev libxkbcommon-x11-dev libyajl-dev \
    libconfuse-dev libnl-genl-3-dev libxcb1-dev libxcb-xkb-dev \
    libxcb-cursor-dev libxcb-xinerama0-dev libxcb-randr0-dev libxcb-shape0-dev \
    libxcb-util0-dev libxcb-icccm4-dev libxcb-xrm-dev libpulse-dev \
    libcairo-dev libpango1.0-dev libasound-dev \
    asciidoc xmlto gpm curl

  # my changes
  sudo apt-get install --no-install-recommends rxvt-unicode-256color dmenu \
    dunst arandr xfce4-screenshooter lxtask xfce4-power-manager pnmixer feh \
    sxiv sxhkd lxappearance pcmanfm file-roller p7zip-full lxterminal surf
}

git_submodules() {
  echo "Updating submodules..."
  git submodule update --init --recursive
}

build() {
  name=$1
  echo "Building $name..."
  cd $name
  autoreconf -fi &&
  mkdir -p build &&
  cd build &&
  ../configure &&
  make -j8 || exit 1
  cd ../..
}

install() {
  name=$1
  echo "Installing $name..."
  cd $name/build
  sudo make install || exit 1
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
