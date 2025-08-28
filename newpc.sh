#!/bin/bash

# Function to check if a command exists
command_exists() {
    command -v "$1" &> /dev/null
}

# Check if dialog is installed
if ! command_exists dialog; then
    echo "Error: 'dialog' is not installed/accessible. 'dialog' is needed to continue."

    # Ask the user if they want to install dialog
    read -p "Do you want to install 'dialog'? (y/n): " install_choice
    if [[ "$install_choice" == "y" || "$install_choice" == "Y" ]]; then
        echo "Installing 'dialog'..."
        sudo pacman -S dialog
        if ! command_exists dialog; then
            echo "Failed to install 'dialog'. Exiting."
            exit 1
        fi
    else
        echo "Exiting. 'dialog' is required to proceed."
        exit 1
    fi
fi

clear

RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'

show_message() {
    local title=$1
    local msg=$2

    dialog --title "${title}" --msgbox "${msg}" 10 50
}

exit_script() {
    clear
    exit 0
}

update_system() {
    clear
    flatpak update -y
    dialog --title "Installing System Packages" --infobox "Please type sudo password and press Enter" 5 50
    sudo dialog --title "Installing System Packages" --infobox "Thanks" 5 50
    sudo pacman -Syu --noconfirm
    show_message "System update" "System updated successfully!" "$GREEN"
}

install_system_packages() {
    clear
    sudo pacman -S --needed base-devel git curl wget nano vim networkmanager ufw system-config-printer noto-fonts noto-fonts-cjk noto-fonts-emoji gnome-firmware gdm gnome-backgrounds gnome-control-center gnome-keyring networkmanager xdg-user-dirs-gtk steam --noconfirm
    show_message "Package Install" "System packages installed successfully!" "$GREEN"
}

install_flatpaks() {

        dialog --title "Flatpak Not Found" --yesno "Flatpak is not installed. Do you want to install it now?" 10 60
        if [ $? -eq 0 ]; then
            # Install Flatpak
            sudo pacman -S --noconfirm flatpak
            flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
            show_message "Flatpak Installed" "Flatpak has been installed successfully!"
        else
            show_message "Flatpak Not Installed" "Flatpak is required to proceed. Exiting."
            exit 1
        fi



    clear
    local flatpaks=(
        com.github.k4zmu2a.spacecadetpinball
        com.github.tchx84.Flatseal
        com.obsproject.Studio
        com.orama_interactive.Pixelorama
        com.surfshark.Surfshark
        com.usebottles.bottles
        com.valvesoftware.Steam
        com.valvesoftware.Steam.Utility.protontricks.Locale
        com.vscodium.codium
        com.vysp3r.ProtonPlus
        de.haeckerfelix.Fragments
        info.cemu.Cemu
        io.freetubeapp.FreeTube
        io.github.everestapi.Olympus
        io.github.fastrizwaan.WineZGUI
        io.github.flattool.Ignition
        io.github.flattool.Warehouse
        io.github.nokse22.ultimate-tic-tac-toe
        io.github.shiftey.Desktop
        io.gitlab.adhami3310.Impression
        org.gimp.GIMP
        org.onlyoffice.desktopeditors
        sh.ppy.osu
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
            show_message "Unexpected choice. Please try again." "$RED"
            ;;
    esac
done
