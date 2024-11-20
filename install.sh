#!/bin/bash

# Define color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'

echo -e "${RED}This is my own personal script PLEASE only use this if you are curious${NC}"
echo -e "${RED}This script is built ONLY for CachyOS as some packages are only available there.${NC}"

# Update the system
echo -e "${GREEN}Starting system update and software installation...${NC}"
sudo pacman -Syu
sudo pacman -S --needed yay

# Install all required software packages in one chonky command
yay -S --needed \
  libreoffice-fresh kdenlive vscodium flatpak discover obs-studio plasma intellij-idea-community-edition arduino-ide gst-libav gst-plugins-good gst-plugins-bad gst-plugins-ugly gamemode lib32-gamemode mangohud lib32-mangohud steam git curl wget base-devel fastfetch btop appimagelauncher godot davinci-resolve

# Configure and install Flatpaks
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
flatpak install flathub io.freetubeapp.FreeTube io.github.shiftey.Desktop com.github.tchx84.Flatseal sh.cider.Cider io.github.everestapi.Olympus io.github.fastrizwaan.WineZGUI com.usebottles.bottles io.github.zen_browser.zen

# Prompt for reboot
echo -e "${RED}Installation complete!${NC} ${GREEN}Rebooting the system is recommended.${NC}"
read -p "Would you like to reboot now? (y/n): " answer

if [[ "$answer" =~ ^[Yy]$ ]]; then
    echo "Rebooting now..."
    sudo reboot
else
    echo "Reboot skipped. Please remember to reboot later."
fi
