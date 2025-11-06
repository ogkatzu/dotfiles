# WSL Oh My Zsh Setup Instructions

This guide will help you replicate your macOS Oh My Zsh configuration on your new Windows PC with WSL (Ubuntu).

## Prerequisites

1. **WSL with Ubuntu installed** on your Windows PC
2. **Oh My Zsh already installed** in WSL

If you haven't installed Oh My Zsh yet, run this command in WSL:
```bash
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```

## Installation Steps

### 1. Transfer the Setup Script to WSL

You have several options to transfer the `setup-wsl-zsh.sh` script to your WSL environment:

#### Option A: Copy via Windows File System
1. Copy `setup-wsl-zsh.sh` to a location accessible from Windows (e.g., your Downloads folder)
2. From WSL, access it via the mounted Windows drive:
   ```bash
   cp /mnt/c/Users/YourWindowsUsername/Downloads/setup-wsl-zsh.sh ~/
   ```

#### Option B: Create the file directly in WSL
1. Open WSL terminal
2. Create and edit the file:
   ```bash
   nano ~/setup-wsl-zsh.sh
   ```
3. Copy and paste the contents of `setup-wsl-zsh.sh` from your Mac
4. Save with `Ctrl+O`, then exit with `Ctrl+X`
5. Make it executable:
   ```bash
   chmod +x ~/setup-wsl-zsh.sh
   ```

#### Option C: Clone from Git Repository
1. Push your dotfiles to GitHub/GitLab
2. Clone in WSL:
   ```bash
   git clone <your-repo-url> ~/dotfiles
   cd ~/dotfiles/wsl
   ```

### 2. Fix Line Endings (IMPORTANT!)

When transferring files from Windows to WSL, you may encounter line ending issues (CRLF vs LF). Fix this before running the script:

```bash
# Install dos2unix if not already installed
sudo apt-get update && sudo apt-get install -y dos2unix

# Fix line endings
dos2unix ~/setup-wsl-zsh.sh

# OR use sed if dos2unix is not available
sed -i 's/\r$//' ~/setup-wsl-zsh.sh

# Make it executable
chmod +x ~/setup-wsl-zsh.sh
```

If you cloned from git, the line endings should already be correct.

### 3. Run the Setup Script

Once the script is in your WSL home directory and line endings are fixed:

```bash
cd ~
./setup-wsl-zsh.sh
```

Or if you cloned from git:
```bash
cd ~/dotfiles/wsl
./setup-wsl-zsh.sh
```

The script will:
- Install all required packages (bat, neovim, docker, etc.)
- Install Starship prompt
- Install zsh-syntax-highlighting and zsh-autosuggestions
- Clone and install the zsh-bat plugin
- Create your custom Oh My Zsh theme
- Configure Starship with your DevOps-focused settings
- Create a complete `.zshrc` matching your Mac configuration
- Optionally install pyenv for Python version management

### 3. Restart Your Terminal

After the script completes, either:
- Close and reopen your WSL terminal, OR
- Run: `source ~/.zshrc`

## What Gets Installed

### Packages
- `git`, `curl`, `wget`, `zsh`
- `bat` (syntax-highlighted cat replacement)
- `neovim` (modern Vim alternative)
- `python3` and `python3-pip`
- `docker.io` and `docker-compose`
- `zsh-syntax-highlighting`
- `zsh-autosuggestions`

### Oh My Zsh Plugins
- git
- z (directory jumper)
- ssh-agent
- docker
- docker-compose
- zsh-bat (custom plugin)
- terraform
- kubectl
- golang

### Starship Prompt Features
The Starship configuration is optimized for DevOps work and shows:
- Kubernetes context and namespace
- AWS/Azure/GCloud information
- Terraform workspace
- Docker context
- Git branch and status
- Python/Node.js/Go/Rust versions
- Command duration
- Directory path

### Aliases
- `dcdown` - docker compose down
- `dcup` - docker compose up -d --build
- `zshconf` - nvim ~/.zshrc
- `vi` - nvim

## Optional: Install Additional Tools

### pyenv (Python Version Management)
The script will prompt you to install pyenv. If you choose yes, after installation you can:
```bash
pyenv install 3.11.0
pyenv global 3.11.0
```

### kubectl (Kubernetes CLI)
```bash
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
```

### Terraform
```bash
wget -O- https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt update && sudo apt install terraform
```

### AWS CLI
```bash
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
```

## Troubleshooting

### Colors not showing correctly
Make sure your Windows Terminal is using a Nerd Font for proper icon display:
1. Install a Nerd Font (e.g., FiraCode Nerd Font, Hack Nerd Font)
2. In Windows Terminal settings, set the font for your WSL profile

### Docker permission issues
If you encounter Docker permission errors:
```bash
sudo usermod -aG docker $USER
newgrp docker
```

### Starship not found
If Starship isn't recognized after installation:
```bash
# Add to PATH manually
export PATH="$HOME/.cargo/bin:$PATH"
```

## Backup

Your original `.zshrc` is automatically backed up to `~/.zshrc.backup.TIMESTAMP` before the script makes changes.

## Additional Customization

After setup, you can further customize:
- `~/.zshrc` - Main Zsh configuration
- `~/.config/starship.toml` - Starship prompt configuration
- `~/.oh-my-zsh/custom/` - Custom themes, plugins, and aliases

## Notes

- The setup uses Ubuntu package paths for plugins (different from macOS Homebrew paths)
- On Ubuntu, the `bat` command is `batcat`, but the zsh-bat plugin handles this automatically
- Docker commands may require `sudo` unless you add your user to the docker group

Enjoy your new WSL setup! 🚀
