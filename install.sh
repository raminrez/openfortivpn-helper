#!/bin/bash

# VPN Management Script Installer
# Installs openfortivpn and sets up the vpn management script
# Version: 1.0.0

set -euo pipefail

# Color definitions
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
INSTALL_DIR="/usr/local/bin"
FALLBACK_INSTALL_DIR="$HOME/bin"
SCRIPT_NAME="vpn"
CONFIG_DIR="$HOME/.config/openfortivpn"
BREW_PACKAGE="openfortivpn"

# Helper functions
print_error() {
    echo -e "${RED}✗ Error:${NC} $1" >&2
}

print_success() {
    echo -e "${GREEN}✓${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}⚠${NC} $1"
}

print_info() {
    echo -e "${BLUE}ℹ${NC} $1"
}

print_banner() {
    echo -e "${BLUE}"
    cat << "EOF"
╔═══════════════════════════════════════╗
║      VPN Management Script Installer  ║
║              Version 1.0.0           ║
╚═══════════════════════════════════════╝
EOF
    echo -e "${NC}"
    echo ""
}

check_macos() {
    if [[ "$OSTYPE" != "darwin"* ]]; then
        print_error "This installer is designed for macOS only."
        exit 1
    fi
}

check_homebrew() {
    if ! command -v brew >/dev/null 2>&1; then
        print_info "Homebrew not found. Installing Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        
        # Add Homebrew to PATH if not already there
        if [[ ":$PATH:" != *":/opt/homebrew/bin:"* ]]; then
            echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> "$HOME/.zprofile"
            eval "$(/opt/homebrew/bin/brew shellenv)"
        fi
    fi
}

install_openfortivpn() {
    print_info "Checking openfortivpn installation..."
    
    if command -v openfortivpn >/dev/null 2>&1; then
        local version=$(openfortivpn --version | head -n1)
        print_success "openfortivpn already installed: $version"
    else
        print_info "Installing openfortivpn via Homebrew..."
        brew install "$BREW_PACKAGE"
        print_success "openfortivpn installed successfully"
    fi
}

create_directories() {
    print_info "Creating necessary directories..."
    
    # Create config directory
    mkdir -p "$CONFIG_DIR"
    print_success "Created config directory: $CONFIG_DIR"
    
    # Create log directory (same as config)
    print_success "Log directory ready: $CONFIG_DIR"
}

install_script() {
    print_info "Installing vpn script..."
    
    local install_target
    local script_path="$(pwd)/$SCRIPT_NAME"
    
    # Check if script exists
    if [[ ! -f "$script_path" ]]; then
        print_error "Script not found: $script_path"
        exit 1
    fi
    
    # Make script executable
    chmod +x "$script_path"
    
    # Try to install in /usr/local/bin first
    if [[ -w "$INSTALL_DIR" ]] || sudo -v 2>/dev/null; then
        if [[ -w "$INSTALL_DIR" ]]; then
            cp "$script_path" "$INSTALL_DIR/$SCRIPT_NAME"
            print_success "Installed to $INSTALL_DIR/$SCRIPT_NAME"
        else
            sudo cp "$script_path" "$INSTALL_DIR/$SCRIPT_NAME"
            print_success "Installed to $INSTALL_DIR/$SCRIPT_NAME (with sudo)"
        fi
        install_target="$INSTALL_DIR/$SCRIPT_NAME"
    else
        # Fallback to user directory
        mkdir -p "$FALLBACK_INSTALL_DIR"
        cp "$script_path" "$FALLBACK_INSTALL_DIR/$SCRIPT_NAME"
        print_success "Installed to $FALLBACK_INSTALL_DIR/$SCRIPT_NAME"
        install_target="$FALLBACK_INSTALL_DIR/$SCRIPT_NAME"
        
        # Add to PATH if not already there
        if [[ ":$PATH:" != *":$FALLBACK_INSTALL_DIR:"* ]]; then
            echo "export PATH=\"\$PATH:$FALLBACK_INSTALL_DIR\"" >> "$HOME/.zshrc"
            print_info "Added $FALLBACK_INSTALL_DIR to PATH in .zshrc"
            print_warning "Please run 'source ~/.zshrc' or restart your terminal"
        fi
    fi
    
    # Verify installation
    if command -v "$SCRIPT_NAME" >/dev/null 2>&1; then
        print_success "Script installed and accessible as '$SCRIPT_NAME'"
    else
        print_warning "Installation complete, but script not found in PATH"
        print_info "You may need to restart your terminal or run:"
        echo "    export PATH=\"\$PATH:$(dirname "$install_target")\""
    fi
}

create_config_template() {
    print_info "Creating configuration template..."
    
    local config_file="$CONFIG_DIR/config"
    
    if [[ ! -f "$config_file" ]]; then
        {
            echo "# OpenFortiVPN Configuration File"
            echo "# Edit this file with your VPN connection details"
            echo ""
            echo "# VPN Server Details"
            echo "host = your-vpn-server.com"
            echo "port = 443"
            echo ""
            echo "# Authentication"
            echo "username = your-username"
            echo "# You can add password here, but it's recommended to leave it out"
            echo "# and enter it interactively for security"
            echo "# password = your-password"
            echo ""
            echo "# SSL Certificate (optional but recommended for security)"
            echo "# Get this by running: openfortivpn your-vpn-server.com:443 --check-cert"
            echo "# trusted-cert = sha256:your_certificate_hash"
            echo ""
            echo "# Optional Settings"
            echo "# Set routes to add when tunnel is up"
            echo "# route = 10.0.0.0/255.0.0.0"
            echo "# route = 192.168.1.0/255.255.255.0"
            echo ""
            echo "# DNS servers"
            echo "# dns = 8.8.8.8"
            echo "# dns = 8.8.4.4"
            echo ""
            echo "# Additional options"
            echo "# pppd-use-peerdns = 1"
            echo "# pppd-log = /tmp/openfortivpn-pppd.log"
            echo "# pppd-ipparam = vpn.company.com"
            echo ""
            echo "# Disable insecure SSL protocols"
            echo "# insecure-ssl = 0"
        } > "$config_file"
        print_success "Configuration template created: $config_file"
        print_warning "Remember to edit this file with your VPN details!"
    else
        print_success "Configuration file already exists: $config_file"
    fi
}

setup_permissions() {
    print_info "Setting up permissions..."
    
    # Ensure config file is readable only by user
    if [[ -f "$CONFIG_DIR/config" ]]; then
        chmod 600 "$CONFIG_DIR/config"
        print_success "Configuration file permissions set to 600"
    fi
    
    # Ensure directories have correct permissions
    chmod 700 "$CONFIG_DIR"
    print_success "Configuration directory permissions set to 700"
}

show_completion_message() {
    echo ""
    print_success "Installation completed successfully!"
    echo ""
    print_info "Next steps:"
    echo "1. Edit your VPN configuration:"
    echo "   vpn config"
    echo ""
    echo "2. Fill in your VPN details in the configuration file"
    echo ""
    echo "3. Start your VPN connection:"
    echo "   vpn start"
    echo ""
    echo "4. Check the status:"
    echo "   vpn status"
    echo ""
    print_info "Available commands:"
    echo "  vpn start      - Start VPN"
    echo "  vpn stop       - Stop VPN"
    echo "  vpn restart    - Restart VPN"
    echo "  vpn status     - Check VPN status"
    echo "  vpn logs       - View logs"
    echo "  vpn config     - Edit configuration"
    echo "  vpn help       - Show help"
}

# Main installation process
main() {
    print_banner
    
    # Check if running on macOS
    check_macos
    
    # Check and install Homebrew if needed
    check_homebrew
    
    # Install openfortivpn
    install_openfortivpn
    
    # Create necessary directories
    create_directories
    
    # Install the vpn script
    install_script
    
    # Create configuration template
    create_config_template
    
    # Setup permissions
    setup_permissions
    
    # Show completion message
    show_completion_message
}

# Run if script is executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi
