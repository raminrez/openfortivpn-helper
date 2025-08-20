# VPN Management Script for macOS

A simple command-line tool for managing OpenFortiVPN connections on macOS.

**Repository**: https://github.com/raminrez/openfortivpn-helper

This is a helper tool that makes it easy to configure and use the [openfortivpn](https://github.com/adrienverge/openfortivpn) VPN CLI tool.

## Features

- **Simple CLI**: Easy-to-use commands for VPN management
- **Status Monitoring**: Check connection status and view logs
- **Configuration Management**: Edit VPN settings with your preferred editor
- **Process Management**: Start, stop, and restart VPN connections
- **Security**: Proper file permissions and security recommendations

## Quick Start

1. **Clone and install:**

   ```bash
   git clone https://github.com/raminrez/openfortivpn-helper.git
   cd openfortivpn-helper
   ./install.sh
   ```

2. **Configure your VPN:**

   ```bash
   vpn config
   ```

3. **Start your VPN:**

   ```bash
   vpn start
   ```

## Available Commands

- `vpn start` - Start VPN connection
- `vpn stop` - Stop VPN gracefully
- `vpn kill` - Force kill all VPN processes
- `vpn restart` - Restart VPN connection
- `vpn status` - Show current VPN status
- `vpn logs` - Show VPN logs and real-time monitoring
- `vpn config` - Create/edit VPN configuration
- `vpn help` - Show help message

## Configuration

The script uses OpenFortiVPN configuration files located at:

- Config: `~/.config/openfortivpn/config`
- Logs: `~/.config/openfortivpn/vpn.log`

### Configuration File Format

The installer creates a comprehensive configuration template with security recommendations:

```ini
# OpenFortiVPN Configuration File
# Edit this file with your VPN connection details

# VPN Server Details
host = your-vpn-server.com
port = 443

# Authentication
username = your-username
# You can add password here, but it's recommended to leave it out
# and enter it interactively for security
# password = your-password

# SSL Certificate (optional but recommended for security)
# Get this by running: openfortivpn your-vpn-server.com:443 --check-cert
# trusted-cert = sha256:your_certificate_hash

# Optional Settings
# Set routes to add when tunnel is up
# route = 10.0.0.0/255.0.0.0
# route = 192.168.1.0/255.255.255.0

# DNS servers
# dns = 8.8.8.8
# dns = 8.8.4.4

# Additional options
# pppd-use-peerdns = 1
# pppd-log = /tmp/openfortivpn-pppd.log
# pppd-ipparam = vpn.company.com

# Disable insecure SSL protocols
# insecure-ssl = 0
```

## Installation

Run the installer script:

```bash
./install.sh
```

This will:

1. Install OpenFortiVPN via Homebrew
2. Install the VPN management script to `/usr/local/bin` (or `~/bin` as fallback)
3. Create a comprehensive configuration template
4. Set up necessary directories with proper permissions
5. Configure secure file permissions (600 for config, 700 for directories)

### Installation Locations

The script will be installed to:

- **Primary**: `/usr/local/bin/vpn` (if you have write access)
- **Fallback**: `~/bin/vpn` (if primary location requires sudo)

If installed to the fallback location, the installer will automatically add `~/bin` to your PATH in `.zshrc`.

## Requirements

- macOS
- Homebrew (will be installed automatically if missing)
- OpenFortiVPN (installed automatically)
- sudo access (for VPN operations)

## Examples

```bash
# Start VPN
vpn start

# Check status
vpn status

# View logs
vpn logs

# Edit configuration
vpn config

# Stop VPN
vpn stop
```

## Security Features

- **Secure Permissions**: Configuration files are set to 600 permissions (readable only by owner)
- **Directory Protection**: Config directories are set to 700 permissions
- **Interactive Password**: Recommended to enter passwords interactively rather than storing in config
- **SSL Certificate Pinning**: Support for trusted-cert to prevent man-in-the-middle attacks

## Troubleshooting

### VPN won't start

- Check your configuration: `vpn config`
- Verify OpenFortiVPN is installed: `which openfortivpn`
- Check logs: `vpn logs`
- Ensure you have sudo access

### Configuration issues

- Edit configuration: `vpn config`
- Ensure required fields (host, username) are set
- Check file permissions (should be 600)
- Consider using interactive password entry for security

### Installation issues

- If script is not found, check your PATH: `echo $PATH`
- If installed to `~/bin`, restart your terminal or run: `source ~/.zshrc`
- Verify installation: `which vpn`

## File Structure

```
openfortivpn-helper/
├── vpn                 # Main VPN management script
├── install.sh          # Installation script
├── config_template     # Configuration template
├── README.md          # This file
└── LICENSE            # License file
```

After installation:

```
~/.config/openfortivpn/
├── config             # VPN configuration (permissions: 600)
└── vpn.log           # VPN connection logs

/usr/local/bin/vpn    # VPN management script (or ~/bin/vpn)
```

## Contributing

Feel free to submit issues and enhancement requests!

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Credits

This helper tool is built on top of [openfortivpn](https://github.com/adrienverge/openfortivpn), a client for Fortinet's proprietary PPP+SSL VPN solution.

---

**Repository**: https://github.com/raminrez/openfortivpn-helper
