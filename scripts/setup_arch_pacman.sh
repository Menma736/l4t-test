#!/bin/bash

# Script to setup pacman in Arch Linux rootfs
# Usage: ./setup_arch_pacman.sh <rootfs_path>

ROOTFS="${1:-.}"

error() {
  echo -e "\e[91m[ERROR]\e[0m $1" 1>&2
  exit 1
}

warning() {
  echo -e "\e[93m[WARNING]\e[0m $1" 1>&2
}

status() {
  echo -e "\e[96m[INFO]\e[0m $1" 1>&2
}

[ -d "$ROOTFS" ] || error "Rootfs directory not found: $ROOTFS"
[ -d "$ROOTFS/var/lib/pacman" ] || error "Not an Arch Linux rootfs: $ROOTFS"

status "Setting up pacman in $ROOTFS"

# Initialize pacman keyring
status "Initializing pacman-key (this may take a while)..."
sudo arch-chroot "$ROOTFS" pacman-key --init 2>/dev/null || warning "pacman-key --init may have issues"

# Populate pacman keys
status "Populating pacman keys..."
sudo arch-chroot "$ROOTFS" pacman-key --populate archlinux 2>/dev/null || warning "pacman-key --populate may have issues"

# Update pacman cache
status "Updating pacman database..."
sudo arch-chroot "$ROOTFS" pacman -Sy --noconfirm 2>/dev/null || warning "pacman -Sy had issues, database may be outdated"

status "Pacman setup completed"
