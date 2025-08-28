#!/bin/bash
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'

# Exit on any error
set -e

# Function to check for errors
check_error() {
    if [ $? -ne 0 ]; then
        echo -e "${RED}Error: $1 failed. Exiting.${NC}"
        exit 1
    fi
}

# Add Cider Collective repository
echo -e "${GREEN}Adding https://repo.cider.sh...${NC}"
TEMP_KEY_FILE=$(mktemp)
curl -s https://repo.cider.sh/ARCH-GPG-KEY > "$TEMP_KEY_FILE"
sudo pacman-key --add "$TEMP_KEY_FILE"
check_error "adding GPG key"
sudo pacman-key --lsign-key A0CD6B993438E22634450CDD2A236C3F42A61682
check_error "signing GPG key"
sudo tee -a /etc/pacman.conf << EOF
# Cider Collective Repository
[cidercollective]
SigLevel = Required TrustedOnly
Server = https://repo.cider.sh/arch
EOF
check_error "adding repository to pacman.conf"
rm "$TEMP_KEY_FILE"

# Update system and install packages
echo -e "${GREEN}Synchronizing package databases and installing packages...${NC}"
sudo pacman -Syu --noconfirm
check_error "pacman synchronization"
sudo pacman -S --noconfirm iio-sensor-proxy fprintd linux-firmware cider flatpak base-devel git curl wget nano fwupd fwupdmgr neovim networkmanager ufw system-config-printer noto-fonts noto-fonts-cjk noto-fonts-emoji gnome-firmware gdm gnome-backgrounds gnome-control-center gnome-keyring xdg-user-dirs-gtk steam yay
check_error "pacman package installation"

# Install Flatpaks
echo -e "${GREEN}Adding Flathub remote...${NC}"
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
check_error "adding flathub remote"

echo -e "${GREEN}Installing Flatpak packages...${NC}"
local flatpaks=(
    com.github.k4zmu2a.spacecadetpinball
    com.github.tchx84.Flatseal
    com.orama_interactive.Pixelorama
    com.usebottles.bottles
    io.github.everestapi.Olympus
    io.github.shiftey.Desktop
    sh.ppy.osu
)
flatpak install --assumeyes flathub "${flatpaks[@]}"
check_error "flatpak installation"

# Final steps
echo -e "${GREEN}System installation completed successfully!${NC}"
echo -e "${GREEN}Rebooting in 5 seconds...${NC}"
sleep 5
sudo reboot