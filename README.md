# Package Installer Menu for Debian-Based Systems

## Overview

The **Package Installer Menu** is a Bash-based terminal utility designed to simplify the process of installing commonly used packages on Debian-based Linux distributions (such as Ubuntu and Linux Mint). It uses the `dialog` utility to present users with an interactive, menu-driven interface, making package management more accessible and user-friendly.

This project serves as an educational tool to demonstrate Bash scripting and user interaction via terminal-based GUI components.

## Features

- Interactive menu-driven interface using `dialog`
- Select multiple packages for installation
- Automated installation using `apt`
- Easily customizable script for adding/removing packages
- Clear and minimal interface suitable for beginners

## Prerequisites

To run this script, ensure the following:

- A Debian-based Linux system
- `dialog` utility installed:
  ```bash
  sudo apt install dialog
