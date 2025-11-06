# VS Code Configuration

This directory contains my Visual Studio Code settings and extensions list.

## Files

- **`settings.json`** - VS Code user settings (sanitized, no credentials)
- **`extensions.txt`** - List of installed VS Code extensions
- **`EXCLUDED_SETTINGS.md`** - Private settings excluded from version control (credentials, IPs)

## Installation

### On macOS

1. **Backup your current settings** (optional):
   ```bash
   cp ~/Library/Application\ Support/Code/User/settings.json ~/Library/Application\ Support/Code/User/settings.json.backup
   ```

2. **Create a symlink to the dotfiles settings**:
   ```bash
   ln -sf ~/dotfiles/vscode/settings.json ~/Library/Application\ Support/Code/User/settings.json
   ```

3. **Install extensions**:
   ```bash
   cat ~/dotfiles/vscode/extensions.txt | xargs -L 1 code --install-extension
   ```

### On Windows/WSL

1. **Backup your current settings** (optional):
   ```powershell
   # In PowerShell
   Copy-Item "$env:APPDATA\Code\User\settings.json" "$env:APPDATA\Code\User\settings.json.backup"
   ```

2. **Copy settings** (or create a symlink):
   ```powershell
   # In PowerShell - Copy method
   Copy-Item "path\to\dotfiles\vscode\settings.json" "$env:APPDATA\Code\User\settings.json"

   # OR create a symbolic link (requires admin privileges)
   New-Item -ItemType SymbolicLink -Path "$env:APPDATA\Code\User\settings.json" -Target "path\to\dotfiles\vscode\settings.json"
   ```

3. **Install extensions**:
   ```powershell
   # In PowerShell
   Get-Content "path\to\dotfiles\vscode\extensions.txt" | ForEach-Object { code --install-extension $_ }
   ```

   Or in WSL:
   ```bash
   cat ~/dotfiles/vscode/extensions.txt | xargs -L 1 code --install-extension
   ```

## Key Settings Explained

### Theme & Appearance
- **Color Theme**: Catppuccin Mocha (dark theme)
- **Icon Theme**: Material Icon Theme
- **Sidebar**: Located on the right side
- **Transparency**: Set to 240/255 (using GlassIt extension)

### Editor Behavior
- **Auto Save**: Enabled with delay
- **File Conflicts**: Automatically overwrite on disk
- **Inline Suggestions**: Suppressed (for better Copilot experience)

### Terminal
- **Default Profile (Windows)**: Ubuntu (WSL)
- Configured profiles for PowerShell, CMD, Git Bash, and WSL

### Language-Specific Settings
- **Docker Compose**: 2 spaces, YAML formatter
- **Terraform**: 2 spaces indentation
- **GitHub Actions**: YAML formatter

### GitHub Copilot
- Enabled for most file types
- Disabled for: plaintext, markdown, scminput, groovy, terraform

### Security & Git
- Workspace trust: Open untrusted files
- Git sync: No confirmation required
- RedHat telemetry: Disabled

## Featured Extensions

### DevOps & Infrastructure
- AWS Toolkit
- Kubernetes Tools & Templates
- Terraform
- Docker/Containers
- Jenkins Pipeline Support

### Programming Languages
- Python (with Pylance, debugpy)
- Go
- Bash IDE

### Productivity
- GitHub Copilot & Copilot Chat
- Claude Code (Anthropic)
- Shell Format
- Rainbow CSV
- Remote SSH/WSL/Containers

### Themes
- Catppuccin
- Aura Spirit Dracula
- Material Icon Theme

## Private Configuration

See `EXCLUDED_SETTINGS.md` for settings that contain sensitive information and need to be configured manually:
- Jenkins credentials
- Remote SSH hosts
- Private server IPs

## Keeping Extensions Updated

To update your extensions list after installing new extensions:

```bash
# Update the extensions list
code --list-extensions > ~/dotfiles/vscode/extensions.txt

# Commit the changes
cd ~/dotfiles
git add vscode/extensions.txt
git commit -m "Update VS Code extensions list"
```

## Syncing Settings

If you prefer VS Code's built-in Settings Sync instead of dotfiles:
1. Press `Ctrl+Shift+P` (or `Cmd+Shift+P` on macOS)
2. Type "Settings Sync: Turn On"
3. Sign in with your GitHub or Microsoft account

However, using dotfiles gives you:
- Version control over changes
- Easy review of what changed
- Independence from cloud services
- Ability to maintain multiple profiles
