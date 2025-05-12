#!/bin/bash

# Package Installer Menu using dialog
# Dependencies: dialog, apt, dpkg

LOG_FILE="/var/log/package_installer.log"
TEMP_DIR="/tmp/package_installer"
PACKAGES=("git" "curl" "vim" "htop" "wget")

# Check if run as root
check_root() {
    if [[ $EUID -ne 0 ]]; then
        dialog --msgbox "Please run this script as root or with sudo!" 8 40
        clear
        exit 1
    fi
}

# Create temporary working directory
initialize_temp_dir() {
    mkdir -p "$TEMP_DIR"
}

# Display log file using dialog
view_log_file() {
    if [[ -f "$LOG_FILE" ]]; then
        dialog --textbox "$LOG_FILE" 20 70
    else
        dialog --msgbox "Log file not found!" 6 40
    fi
}

# Validate menu selection to package name
validate_package() {
    case $1 in
        1) echo "git" ;;
        2) echo "curl" ;;
        3) echo "vim" ;;
        4) echo "htop" ;;
        5) echo "wget" ;;
        *) echo "" ;;
    esac
}

# Install selected package from preset list
install_package() {
    selection=$(dialog --menu "Choose a package to install:" 15 50 6 \
        1 "git" 2 "curl" 3 "vim" 4 "htop" 5 "wget" 3>&1 1>&2 2>&3)

    pkg=$(validate_package "$selection")
    if [[ -n $pkg ]]; then
        dialog --infobox "Updating package list..." 5 40
        apt-get update >> "$LOG_FILE" 2>&1

        dialog --infobox "Installing $pkg, please wait..." 5 50
        sleep 1
        if apt-get install -y "$pkg" >> "$LOG_FILE" 2>&1; then
            echo "$(date): Installed $pkg" >> "$LOG_FILE"
            dialog --msgbox "$pkg installed successfully." 6 40
            touch "$TEMP_DIR/$pkg.installed"
        else
            dialog --msgbox "Error installing $pkg." 6 40
        fi
    fi
}

# Remove selected package with purge
remove_package() {
    selection=$(dialog --menu "Choose a package to remove:" 15 50 6 \
        1 "git" 2 "curl" 3 "vim" 4 "htop" 5 "wget" 3>&1 1>&2 2>&3)

    pkg=$(validate_package "$selection")
    if [[ -n $pkg ]]; then
        if dpkg -l "$pkg" | awk '$1 == "ii" {print $2}' | grep -qw "$pkg"; then
            dialog --infobox "Removing $pkg, please wait..." 5 50
            sleep 1
            if apt-get purge -y "$pkg" >> "$LOG_FILE" 2>&1; then
                echo "$(date): Removed $pkg" >> "$LOG_FILE"
                dialog --msgbox "$pkg removed successfully." 6 40
                rm -f "$TEMP_DIR/$pkg.installed"
            else
                dialog --msgbox "Error removing $pkg." 6 40
            fi
        else
            dialog --msgbox "$pkg is not installed." 6 40
        fi
    fi
}

# Check if a package is installed
check_status() {
    pkg=$(dialog --inputbox "Enter the package name to check:" 8 40 3>&1 1>&2 2>&3)

    if [[ -z $pkg ]]; then
        dialog --msgbox "Package name cannot be empty." 6 40
        return
    fi

    if dpkg -l "$pkg" | awk '$1 == "ii" {print $2}' | grep -qw "$pkg"; then
        dialog --msgbox "$pkg is installed." 6 40
    else
        dialog --msgbox "$pkg is NOT installed." 6 40
    fi
}

# Backup the log file to the temporary directory
backup_log() {
    if [[ -f "$LOG_FILE" ]]; then
        cp "$LOG_FILE" "$TEMP_DIR/backup.log"
        dialog --msgbox "Log file backed up to $TEMP_DIR/backup.log" 6 60
    else
        dialog --msgbox "No log file to backup." 6 40
    fi
}

# Show currently logged-in users
show_users() {
    who > "$TEMP_DIR/users.txt"
    dialog --textbox "$TEMP_DIR/users.txt" 15 50
}

# Show currently running processes
show_processes() {
    ps -eo pid,user,cmd --sort=-%mem | head -n 20 > "$TEMP_DIR/processes.txt"
    dialog --textbox "$TEMP_DIR/processes.txt" 20 70
}

# Additional Operations Menu
extras_menu() {
    while true; do
        opt=$(dialog --menu "Extra Operations" 15 50 5 \
            1 "Backup Log File" \
            2 "Show Logged-in Users" \
            3 "Show Top Running Processes" \
            4 "Back to Main Menu" \
            3>&1 1>&2 2>&3)

        case $opt in
            1) backup_log ;;
            2) show_users ;;
            3) show_processes ;;
            4) break ;;
            *) break ;;
        esac
    done
}

# Install custom user-provided package
install_custom_package() {
    pkg=$(dialog --inputbox "Enter the name of the package to install:" 8 40 3>&1 1>&2 2>&3)

    if [[ -z $pkg ]]; then
        dialog --msgbox "Package name cannot be empty." 6 40
        return
    fi

    dialog --infobox "Updating package list..." 5 40
    apt-get update >> "$LOG_FILE" 2>&1

    dialog --infobox "Installing $pkg, please wait..." 5 50
    sleep 1
    if apt-get install -y "$pkg" >> "$LOG_FILE" 2>&1; then
        echo "$(date): Installed $pkg" >> "$LOG_FILE"
        dialog --msgbox "$pkg installed successfully." 6 40
        touch "$TEMP_DIR/$pkg.installed"
    else
        dialog --msgbox "Error installing $pkg. It may not exist." 6 50
    fi
}

# Show detailed package information
view_package_info() {
    pkg=$(dialog --inputbox "Enter the package name to get info:" 8 40 3>&1 1>&2 2>&3)

    if [[ -z $pkg ]]; then
        dialog --msgbox "Package name cannot be empty." 6 40
        return
    fi

    apt-cache show "$pkg" > "$TEMP_DIR/pkginfo.txt" 2>/dev/null
    if [[ -s "$TEMP_DIR/pkginfo.txt" ]]; then
        dialog --textbox "$TEMP_DIR/pkginfo.txt" 20 70
    else
        dialog --msgbox "Package information not found for '$pkg'." 6 50
    fi
}

# Main Menu
main_menu() {
    while true; do
        option=$(dialog --clear --backtitle "Package Installer System" \
            --title "Main Menu" \
            --menu "Choose an option:" 18 60 9 \
            1 "Install Package" \
            2 "Remove Package" \
            3 "Check Package Status" \
            4 "View Log File" \
            5 "Extras (Users/Processes/Backup)" \
            6 "Exit" \
            7 "Install Custom Package" \
            8 "View Package Info" \
            3>&1 1>&2 2>&3)

        case $option in
            1) install_package ;;
            2) remove_package ;;
            3) check_status ;;
            4) view_log_file ;;
            5) extras_menu ;;
            6) clear; exit 0 ;;
            7) install_custom_package ;;
            8) view_package_info ;;
            *) break ;;
        esac
    done
}

# Start script
check_root
initialize_temp_dir
main_menu
