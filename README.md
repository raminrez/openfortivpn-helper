# VPN Management Script for macOS

A simple command-line tool for managing OpenFortiVPN connections on macOS.

## Features

- **Simple CLI**: Easy-to-use commands for VPN management
- **Status Monitoring**: Check connection status and view logs
- **Configuration Management**: Edit VPN settings with your preferred editor
- **Process Management**: Start, stop, and restart VPN connections

## Quick Start

1. **Install the script:**
   ```bash
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

```ini
# OpenFortiVPN Configuration
host = vpn.example.com
port = 443
username = your-username
password = your-password
# trusted-cert = sha256:abcd1234...
```

## Installation

Run the installer script:

```bash
./install.sh
```

This will:
1. Install OpenFortiVPN via Homebrew
2. Install the VPN management script
3. Create configuration template
4. Set up necessary directories

## Requirements

- macOS
- Homebrew (will be installed automatically if missing)
- OpenFortiVPN (installed automatically)

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

## Troubleshooting

### VPN won't start
- Check your configuration: `vpn config`
- Verify OpenFortiVPN is installed: `which openfortivpn`
- Check logs: `vpn logs`

### Configuration issues
- Edit configuration: `vpn config`
- Ensure required fields (host, username, password) are set
- Check file permissions (should be 600)

## File Structure

```
forticlient-helper/
├── vpn                 # Main VPN management script
├── install.sh          # Installation script
├── config_template     # Configuration template
├── README.md          # This file
└── LICENSE            # License file
```

## License

This project is licensed under the MIT License - see the LICENSE file for details.
