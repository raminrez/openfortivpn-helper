# VPN Management Script for macOS

A simple command-line tool to run OpenFortiVPN interactively on macOS. This project provides an installer and a single `vpn` command to manage VPN connections in the foreground.

Important: This version supports only interactive foreground connections (you must enter the one-time password and any password prompts in your terminal). Background / unattended startup is not supported.

## Quick Start

1. Clone the repository:

   ```bash
   git clone https://github.com/your-username/vpn-management.git
   cd vpn-management
   ```

2. Run the installer:

   ```bash
   ./install.sh
   ```

3. Configure your VPN:

   ```bash
   vpn config
   ```

4. Start the VPN (interactive; you will be prompted for OTP/password):

   ```bash
   vpn start
   ```

5. Check status:
   ```bash
   vpn status
   ```

## Features

- Unified CLI: `vpn` command for install, config, start, stop and logs
- Interactive foreground connections only (OTP and password entered in terminal)
- Simple process control: stop/kill commands available
- Persistent logs: written to `~/.config/openfortivpn/vpn.log`
- Installer uses Homebrew to install openfortivpn if missing

## Installation

### Prerequisites

- macOS
- Homebrew (installer will attempt to install it if missing)
- sudo access (for installing the script and starting/stopping the VPN)

### Run the installer

```bash
./install.sh
```

The installer will:

- Install openfortivpn via Homebrew (if needed)
- Create `~/.config/openfortivpn` and a config template
- Install the `vpn` script to `/usr/local/bin` (or `~/bin` fallback)
- Set secure permissions on the config file

## Configuration

Open the configuration template:

```bash
vpn config
```

Edit `~/.config/openfortivpn/config` with your VPN server details:

```ini
host = your-vpn-server.com
port = 443

username = your-username
# password = your-password  # Optional: leave empty to enter interactively

# trusted-cert = sha256:your_certificate_hash
# dns = 8.8.8.8
# route = 10.0.0.0/255.0.0.0
```

To get the certificate hash:

```bash
openfortivpn your-vpn-server.com:443 --check-cert
```

## Usage

Available commands (foreground / interactive):

- `vpn start` — Start VPN (interactive; enter OTP/password in terminal)
- `vpn stop` — Stop VPN processes
- `vpn kill` — Force kill all openfortivpn processes
- `vpn restart` — Restart (stop then start)
- `vpn status` — Show whether VPN is running and basic info
- `vpn logs` — Show last lines of the VPN log and tail it
- `vpn config` — Create/edit VPN configuration
- `vpn help` — Show help

Examples:

Start:

```bash
vpn start
# Follow prompts for OTP/password in the terminal.
```

Check logs:

```bash
vpn logs
```

Stop:

```bash
vpn stop
```

## Logs and Troubleshooting

Logs are stored at `~/.config/openfortivpn/vpn.log`.

If the VPN fails to connect:

1. Run `vpn start` in the foreground and watch the output.
2. Check `vpn logs` for recent output.
3. Verify host/port, username, and trusted-cert in the config.
4. For permission issues, ensure you have sudo access: `sudo -v`

## Security Notes

- The installer sets the config file permissions to 600 by default.
- Avoid storing plain passwords in the config if possible. Enter them interactively.
- Use `trusted-cert` to pin the VPN server certificate for better security.

## File structure

After installation:

```
~/.config/openfortivpn/
├── config
└── vpn.log

/usr/local/bin/vpn   # installed script
```

## Contributing & Issues

Report issues and feature requests with reproduction steps and logs. Include macOS version and openfortivpn version when possible.

## License

MIT
