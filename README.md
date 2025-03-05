# CursorFig1

Cross-platform configuration and automation tools for development environment setup, including AWS EC2 instance creation and v2ray server configuration.

## Directory Structure

```
CursorFig1/
├── aws/                    # AWS-related scripts and configurations
│   ├── create_ec2.sh      # EC2 instance creation script
│   └── ec2_setup.sh       # EC2 instance setup script
├── config/                 # Configuration files
│   ├── linux/             # Linux-specific configurations
│   ├── macos/             # macOS-specific configurations
│   └── windows/           # Windows-specific configurations
├── scripts/               # Setup scripts
│   ├── setup.sh          # Unix-based systems setup script
│   └── setup.ps1         # Windows setup script
└── security/             # Security configurations
    ├── allowlist/        # Allowed operations and patterns
    └── denylist/         # Blocked operations and patterns
```

## Prerequisites

### All Platforms
- Git
- Node.js (v18 or later)
- Python 3
- AWS CLI (if using AWS features)

### Platform-Specific
- **Windows**: PowerShell 5.1+, Windows Package Manager (winget)
- **macOS**: Homebrew
- **Linux**: apt, dnf, or pacman (depending on distribution)

## Installation

1. Clone the repository:
```bash
git clone https://github.com/your-username/CursorFig1.git
cd CursorFig1
```

2. Run the appropriate setup script:

### Unix-based systems (macOS, Linux):
```bash
chmod +x scripts/setup.sh
./scripts/setup.sh
```

### Windows:
```powershell
# Run as Administrator
.\scripts\setup.ps1
```

## AWS EC2 Setup

1. Configure AWS CLI:
```bash
aws configure
```

2. Create EC2 instance:
```bash
chmod +x aws/create_ec2.sh
./aws/create_ec2.sh
```

3. Setup v2ray on EC2:
```bash
chmod +x aws/ec2_setup.sh
./aws/ec2_setup.sh
```

## Security

### Allowlist
- Network ports and protocols
- Approved applications and executables
- Safe file extensions and directories
- Trusted domains

### Denylist
- Dangerous network ports and protocols
- Suspicious applications
- Unsafe file patterns
- Blocked commands and configurations

## Cross-Platform Compatibility

### macOS
- Supports both Intel and Apple Silicon
- Uses Homebrew for package management
- Compatible with macOS 11.0 (Big Sur) and later

### Linux
- Supports major distributions (Ubuntu, Fedora, Debian, Arch)
- Handles different package managers (apt, dnf, pacman)
- Systemd and non-systemd compatible

### Windows
- Windows 10/11 support
- PowerShell automation
- WSL2 integration
- Uses Windows Package Manager (winget)

## Troubleshooting

### Common Issues

1. Permission errors:
   - Unix: Run with sudo/root privileges
   - Windows: Run PowerShell as Administrator

2. Package manager issues:
   - macOS: Reinstall Homebrew
   - Linux: Update package cache
   - Windows: Update winget

3. AWS CLI errors:
   - Verify credentials in ~/.aws/credentials
   - Check region in ~/.aws/config
   - Ensure proper IAM permissions

## Contributing

1. Fork the repository
2. Create a feature branch
3. Commit your changes
4. Push to the branch
5. Create a Pull Request

## License

MIT License - See LICENSE file for details
