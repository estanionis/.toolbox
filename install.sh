#!/bin/bash

# Function to check if a command is installed
check_installed() {
    command -v "$1" >/dev/null 2>&1
}

# Install required programs for Linux
install_linux() {
    echo "Checking for required packages..."
    required_packages=("git" "docker" "docker-compose" "curl")

    for package in "${required_packages[@]}"; do
        if ! check_installed "$package"; then
            echo "$package is not installed. Installing..."
            sudo apt-get install -y "$package"
        else
            echo "$package is already installed."
        fi
    done

    # Install VSCode
    if ! check_installed "code"; then
        echo "Installing Visual Studio Code..."
        curl -L -o vscode.deb "https://go.microsoft.com/fwlink/?LinkID=760868"
        sudo dpkg -i vscode.deb
        sudo apt-get install -f  # Fix missing dependencies
        rm vscode.deb
    else
        echo "Visual Studio Code is already installed."
    fi

    # Install VSCode extensions
    code --install-extension ms-python.python
    code --install-extension ms-vscode.cpptools
    code --install-extension ms-dotnettools.csharp
    code --install-extension dbaeumer.vscode-eslint

    echo "All required packages and applications are installed on Linux."
}

# Install required programs for macOS
install_mac() {
    echo "Checking for required packages..."
    required_packages=("git" "docker" "curl")

    for package in "${required_packages[@]}"; do
        if ! check_installed "$package"; then
            echo "$package is not installed. Installing..."
            brew install "$package"
        else
            echo "$package is already installed."
        fi
    done

    # Install VSCode
    if ! check_installed "code"; then
        echo "Installing Visual Studio Code..."
        brew install --cask visual-studio-code
    else
        echo "Visual Studio Code is already installed."
    fi

    # Install VSCode extensions
    code --install-extension ms-python.python
    code --install-extension ms-vscode.cpptools
    code --install-extension ms-dotnettools.csharp
    code --install-extension dbaeumer.vscode-eslint

    echo "All required packages and applications are installed on macOS."
}

# Install required programs for Windows using Git Bash
install_windows() {
    echo "Checking for required applications..."

    required_apps=("git" "docker" "vscode")

    for app in "${required_apps[@]}"; do
        if ! check_installed "$app"; then
            echo "$app is not installed. Downloading installer..."
            case "$app" in
                "git")
                    curl -L -o git-installer.exe "https://github.com/git-for-windows/git/releases/latest/download/Git-2.47.0-64-bit.exe"
                    echo "Running Git installer..."
                    ./git-installer.exe /SILENT
                    ;;
                "docker")
                    curl -L -o docker-installer.exe "https://desktop.docker.com/win/stable/Docker%20Desktop%20Installer.exe"
                    echo "Running Docker installer..."
                    ./docker-installer.exe install
                    ;;
                "vscode")
                    curl -L -o vscode-installer.exe "https://code.visualstudio.com/sha/download?build=stable&os=win32-x64-user"
                    echo "Running VSCode installer..."
                    ./vscode-installer.exe /verysilent
                    ;;
            esac
        else
            echo "$app is already installed."
        fi
    done

    # Install VSCode extensions
    code --install-extension ms-python.python
    code --install-extension ms-vscode.cpptools
    code --install-extension ms-dotnettools.csharp
    code --install-extension dbaeumer.vscode-eslint

    echo "All required applications are installed on Windows."
}

# Determine OS and install required programs
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    install_linux
elif [[ "$OSTYPE" == "darwin"* ]]; then
    install_mac
else
    echo "Detected Windows environment. Installing via Git Bash..."
    install_windows
fi

echo "Setup completed successfully."
