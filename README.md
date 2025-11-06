# Dotfiles

My personal dotfiles for macOS and WSL (Ubuntu). Optimized for DevOps workflows with Kubernetes, Docker, Terraform, and cloud platforms.

## What's Included

### Shell Configuration
- **`.zshrc`** - Zsh configuration with Oh My Zsh
- **`.config/starship.toml`** - Starship prompt configuration (DevOps-focused)

### Oh My Zsh Customizations
- **`.oh-my-zsh/custom/themes/`** - Custom themes
  - `custom-robbyrussell.zsh-theme` - Enhanced Robbyrussell theme with git status indicators
- **`.oh-my-zsh/custom/plugins/`** - Custom plugins
  - `zsh-bat` - Replaces cat with bat for syntax highlighting

### WSL Setup
- **`wsl/setup-wsl-zsh.sh`** - Automated setup script for WSL Ubuntu
- **`wsl/WSL-SETUP-README.md`** - Detailed installation instructions

## Features

### Zsh Plugins
- git
- z (directory jumper)
- ssh-agent
- docker
- docker-compose
- zsh-bat
- terraform
- kubectl
- golang

### Starship Prompt Indicators
- Kubernetes context and namespace
- AWS/Azure/Google Cloud info
- Terraform workspace
- Docker context
- Git branch and detailed status
- Programming language versions (Python, Node.js, Go, Rust)
- Command execution duration
- SSH hostname

### Aliases
```bash
dcdown   # docker compose down
dcup     # docker compose up -d --build
zshconf  # nvim ~/.zshrc
vi       # nvim
```

## Installation

### macOS

1. Clone this repository:
   ```bash
   git clone <your-repo-url> ~/dotfiles
   cd ~/dotfiles
   ```

2. Backup your existing dotfiles:
   ```bash
   mv ~/.zshrc ~/.zshrc.backup
   mv ~/.config/starship.toml ~/.config/starship.toml.backup
   ```

3. Create symlinks:
   ```bash
   ln -s ~/dotfiles/.zshrc ~/.zshrc
   ln -s ~/dotfiles/.config/starship.toml ~/.config/starship.toml
   ln -s ~/dotfiles/.oh-my-zsh/custom/themes/custom-robbyrussell.zsh-theme ~/.oh-my-zsh/custom/themes/
   ln -s ~/dotfiles/.oh-my-zsh/custom/plugins/zsh-bat ~/.oh-my-zsh/custom/plugins/
   ```

4. Install dependencies:
   ```bash
   # Install Homebrew (if not already installed)
   /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

   # Install packages
   brew install starship bat neovim zsh-syntax-highlighting zsh-autosuggestions
   ```

5. Reload your shell:
   ```bash
   source ~/.zshrc
   ```

### WSL (Ubuntu)

See the detailed instructions in `wsl/WSL-SETUP-README.md`.

Quick start:
```bash
git clone <your-repo-url> ~/dotfiles
cd ~/dotfiles/wsl
chmod +x setup-wsl-zsh.sh
./setup-wsl-zsh.sh
```

## Requirements

### macOS
- Oh My Zsh
- Homebrew
- Starship
- bat (batcat)
- Neovim
- zsh-syntax-highlighting
- zsh-autosuggestions

### WSL Ubuntu
All requirements are installed automatically by the setup script.

## Customization

### Adding Your Own Aliases
Edit `.zshrc` and add your aliases to the aliases section, or create a custom file:
```bash
echo 'alias myalias="my command"' > ~/.oh-my-zsh/custom/aliases.zsh
```

### Modifying Starship Prompt
Edit `.config/starship.toml` to customize the prompt appearance and modules.

### Changing Theme
To use a different Oh My Zsh theme, edit `.zshrc` and set:
```bash
ZSH_THEME="theme-name"
```
And comment out the Starship initialization at the bottom.

## File Structure

```
dotfiles/
├── .zshrc                          # Main Zsh configuration
├── .config/
│   └── starship.toml              # Starship prompt config
├── .oh-my-zsh/
│   └── custom/
│       ├── themes/
│       │   └── custom-robbyrussell.zsh-theme
│       └── plugins/
│           └── zsh-bat/           # Custom bat plugin
├── wsl/
│   ├── setup-wsl-zsh.sh          # WSL setup script
│   └── WSL-SETUP-README.md       # WSL installation guide
└── README.md                      # This file
```

## Notes

### macOS-specific
- Uses Homebrew paths for plugins (`/opt/homebrew/share/`)
- Includes pyenv configuration
- Includes bun completions
- Includes Docker Desktop completions

### WSL-specific
- Uses apt package paths for plugins (`/usr/share/`)
- The setup script handles all path differences automatically
- bat is installed as `batcat` but aliased to `cat`

## Keeping Your Dotfiles Updated

After making changes to your dotfiles in your home directory, sync them back to the repo:

```bash
# Update from home directory
cp ~/.zshrc ~/dotfiles/
cp ~/.config/starship.toml ~/dotfiles/.config/
cp ~/.oh-my-zsh/custom/themes/*.zsh-theme ~/dotfiles/.oh-my-zsh/custom/themes/

# Commit and push
cd ~/dotfiles
git add .
git commit -m "Update dotfiles"
git push
```

Or use the included update script (if you create one).

## License

Feel free to use these dotfiles as inspiration for your own configuration!

## Credits

- [Oh My Zsh](https://ohmyz.sh/)
- [Starship](https://starship.rs/)
- [zsh-bat plugin](https://github.com/fdellwing/zsh-bat)
