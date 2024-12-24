#!/bin/bash

# Check if dialog is installed 
if ! command -v dialog &> /dev/null; then
    echo "Error: 'dialog' is not installed/accessible. 'dialog' is needed to continue."
    exit 1
fi
clear

# Color codes (we'll keep them for consistency, but dialog will handle messages)
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'

show_message() {
    local title=$1
    local msg=$2
    local color=$3
    
    dialog --title "${title}" --msgbox "${msg}" 10 50
}

exit_script() {
    clear
    exit 0
}

update_system() {
    clear
    dialog --title "Updating System" --infobox "Updating system..." 5 40
    flatpak update
    dialog --title "Installing System Packages" --infobox "Please type sudo password and press Enter" 5 50
    sudo dialog --title "Installing System Packages" --infobox "Thanks bro" 5 50
    yay -Syu
    show_message "System update" "System updated successfully!" "$GREEN"
}

install_system_packages() {
    clear
    dialog --title "Installing System Packages" --infobox "Please type sudo password and press Enter" 5 50
    sudo pacman -S --needed yay --noconfirm
    dialog --title "Installing System Packages" --infobox "Thanks bro" 5 50

    local packages=(
        flatpak
        discover
        plasma
        git
        curl
        wget
        base-devel
        fastfetch
        btop
        intellij-idea-community-edition
        libreoffice-fresh
	    steam
        ark  
        audacity  
        dolphin  
        gwenview  
        kate  
        kdeconnect  
        okular  
        partitionmanager  
        plasma-systemmonitor  
        alacritty  
        btop  
        git  
        nano  
        vim  
        appimagelauncher  
        discover  
        networkmanager  
        ufw  
        system-config-printer  
        noto-fonts  
        noto-fonts-cjk  
        noto-fonts-emoji  
        cachyos-emerald-kde-theme-git  
        cachyos-iridescent-kde  
        cachyos-nord-kde-theme-git  
        cachyos-kde-settings  
        ffmpegthumbs  
        yt-dlp  
    )
    yay -S --needed "${packages[@]}" --noconfirm
    show_message "Package Install" "System packages installed successfully!" "$GREEN"
}

install_flatpaks() {
    clear
    dialog --title "Installing Flatpaks" --infobox "Installing Flatpaks..." 5 50
    local flatpaks=(
        io.freetubeapp.FreeTube
        io.github.shiftey.Desktop
        com.github.tchx84.Flatseal
        sh.cider.Cider
        io.github.everestapi.Olympus
        io.github.fastrizwaan.WineZGUI
        com.usebottles.bottles
        io.github.zen_browser.zen
        com.orama_interactive.Pixelorama
        com.vscodium.codium
        io.github.flattool.Warehouse
        org.kde.kdenlive
        com.obsproject.Studio
        org.godotengine.Godot
    )
    flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
    flatpak install --assumeyes flathub "${flatpaks[@]}"
    show_message "Installing Flatpaks" "Flatpaks installed successfully!" "$GREEN"
}

# Prompt for reboot
prompt_reboot() {
    dialog --title "Reboot?" --yesno "Are you sure you want to reboot?" 7 50
    if [ $? -eq 0 ]; then
        show_message "Reboot :)" "Rebooting..." "$GREEN"
        reboot
    fi
}

open_github() {
    xdg-open "https://github.com/Logboy2000/NewPC" &>/dev/null
    show_message "Opening GitHub" "GitHub should now be open in your default browser." "$GREEN"
}


# Create a menu using dialog
while true; do
    # Use dialog to create a menu with arrow keys
    CHOICE=$(dialog --clear --no-cancel --title "Logan's Epic Install Script" \
        --menu "This script is designed for CachyOS ONLY" 15 50 5 \
        "0" "About" \
        "1" "Update System/Flatpaks" \
        "2" "Install System Packages" \
        "3" "Install Flatpaks" \
        "4" "Reboot" \
        "5" "GitHub" \
        "6" "Exit" \
        3>&1 1>&2 2>&3)

    # Check if the user made a selection or canceled
    if [ $? -eq 1 ]; then
        exit_script
    fi

    case $CHOICE in
        0)
            show_message "About this script" "This is a personal script I wrote for getting started on a new machine" "$GREEN"
            ;;
        1)
            update_system
            ;;
        2)
            install_system_packages
            ;;
        3)
            install_flatpaks
            ;;
        4)
            prompt_reboot
            ;;
        5)
            open_github
            ;;
        6)
            exit_script
            ;;
        *)
            show_message "If you see this something went terribly wrong" "$RED"
            ;;
    esac
done
