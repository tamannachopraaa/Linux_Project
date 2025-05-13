📦 Package Installer Menu for Debian-Based Systems
📝 Overview
The Package Installer Menu is a terminal-based Bash script designed to streamline the installation of commonly used packages on Debian-based Linux distributions such as Ubuntu and Linux Mint. It features a user-friendly, interactive menu built with the dialog utility, making package management simpler and more approachable—especially for beginners.

This project also serves as an educational tool for learning Bash scripting and implementing text-based user interfaces (TUIs) using dialog.

✨ Features
✅ Interactive, menu-driven interface using dialog

✅ Select multiple packages for batch installation

✅ Automated package installation using apt

✅ Easily customizable list of packages (add/remove as needed)

✅ Minimal, clean interface ideal for beginners

🛠️ Prerequisites
To run this script, you need:

A Debian-based Linux system (e.g., Ubuntu, Linux Mint, etc.)

The dialog utility installed:

bash
Copy
Edit
sudo apt update
sudo apt install dialog
🚀 Getting Started
Download or clone the repository:

bash
Copy
Edit
git clone https://github.com/your-username/package-installer-menu.git
cd package-installer-menu
Make the script executable:

bash
Copy
Edit
chmod +x installer.sh
Run the script:

bash
Copy
Edit
./installer.sh
🧩 Customization
You can easily modify the script to:

Add new packages to the selection list

Change the dialog interface behavior

Include post-installation actions or checks

Look for the packages array or section inside installer.sh to tailor the menu to your needs.

📚 Learning Outcomes
This project demonstrates:

Basics of Bash scripting

Using dialog for terminal GUIs

Conditional logic and loops in Bash

Handling package installations programmatically

✅ Example Use Cases
Quickly set up a development environment

Install essential software after a fresh OS installation

Create curated installers for specific user profiles (e.g., designers, developers, gamers)

📄 License
This project is open-source and available under the MIT License
