#!/bin/bash

##########################################################################
# WSL Oh My Zsh Configuration Setup Script
##########################################################################
# This script will replicate your macOS Oh My Zsh configuration on WSL Ubuntu
# Prerequisites: WSL with Ubuntu and Oh My Zsh already installed
##########################################################################

set -e  # Exit on error

echo "=========================================="
echo "WSL Oh My Zsh Configuration Setup"
echo "=========================================="

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to print colored messages
print_info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if Oh My Zsh is installed
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    print_error "Oh My Zsh is not installed. Please install it first:"
    echo "sh -c \"\$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)\""
    exit 1
fi

print_info "Oh My Zsh found. Proceeding with configuration..."

##########################################################################
# 1. Update and Install Required Packages
##########################################################################
print_info "Updating package list and installing required packages..."
sudo apt-get update
sudo apt-get install -y \
    git \
    curl \
    wget \
    zsh \
    bat \
    neovim \
    python3 \
    python3-pip \
    docker.io \
    docker-compose \
    unzip

# On Ubuntu, bat is installed as batcat, the plugin handles this

##########################################################################
# 2. Install Starship Prompt
##########################################################################
print_info "Installing Starship prompt..."
if ! command -v starship &> /dev/null; then
    curl -sS https://starship.rs/install.sh | sh -s -- -y
    print_info "Starship installed successfully"
else
    print_info "Starship is already installed"
fi

##########################################################################
# 3. Install Zsh Plugins (zsh-syntax-highlighting and zsh-autosuggestions)
##########################################################################
print_info "Installing zsh-syntax-highlighting..."
if [ ! -d "/usr/share/zsh-syntax-highlighting" ]; then
    sudo apt-get install -y zsh-syntax-highlighting
else
    print_info "zsh-syntax-highlighting already installed"
fi

print_info "Installing zsh-autosuggestions..."
if [ ! -d "/usr/share/zsh-autosuggestions" ]; then
    sudo apt-get install -y zsh-autosuggestions
else
    print_info "zsh-autosuggestions already installed"
fi

##########################################################################
# 4. Install Custom Oh My Zsh Plugin (zsh-bat)
##########################################################################
print_info "Installing zsh-bat custom plugin..."
ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
if [ ! -d "$ZSH_CUSTOM/plugins/zsh-bat" ]; then
    git clone https://github.com/fdellwing/zsh-bat.git "$ZSH_CUSTOM/plugins/zsh-bat"
    print_info "zsh-bat plugin installed"
else
    print_info "zsh-bat plugin already exists, updating..."
    cd "$ZSH_CUSTOM/plugins/zsh-bat" && git pull
fi

##########################################################################
# 5. Create Custom Theme
##########################################################################
print_info "Creating custom Oh My Zsh theme..."
mkdir -p "$ZSH_CUSTOM/themes"

cat > "$ZSH_CUSTOM/themes/custom-robbyrussell.zsh-theme" << 'THEME_EOF'
# Git status indicators
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg_bold[green]%} ✅%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg_bold[red]%} 🔴%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_ADDED="%{$fg_bold[green]%} 🟢%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_MODIFIED="%{$fg_bold[blue]%} 📝%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DELETED="%{$fg_bold[red]%} 🗑️%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_RENAMED="%{$fg_bold[magenta]%} 📎%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_UNMERGED="%{$fg_bold[yellow]%} ⚡%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$fg_bold[cyan]%} 🆕%{$reset_color%}"
# Git branch/status display function
git_custom_status() {
  local branch=$(git_current_branch)
  if [ -n "$branch" ]; then
    echo -n "%{$fg_bold[yellow]%}‹${branch}›%{$reset_color%}"

    if [ -n "$(git status --porcelain 2>/dev/null)" ]; then
      # Repository is dirty
      if [ -n "$(git status --porcelain 2>/dev/null | grep '^??')" ]; then
        # Has untracked files
        echo -n "${ZSH_THEME_GIT_PROMPT_UNTRACKED}"
      fi
      if [ -n "$(git status --porcelain 2>/dev/null | grep '^[MADRC]')" ]; then
        # Has staged changes
        echo -n "${ZSH_THEME_GIT_PROMPT_ADDED}"
      fi
      if [ -n "$(git status --porcelain 2>/dev/null | grep '^[ MADRC][MD]')" ]; then
        # Has modifications
        echo -n "${ZSH_THEME_GIT_PROMPT_MODIFIED}"
      fi
    else
      # Repository is clean
      echo -n "${ZSH_THEME_GIT_PROMPT_CLEAN}"
    fi
  fi
}

# Main prompt
PROMPT='%{$fg_bold[cyan]%}%c%{$reset_color%} $(git_custom_status) %{$fg_bold[red]%}➜ %{$reset_color%}'
THEME_EOF

print_info "Custom theme created"

##########################################################################
# 6. Configure Starship
##########################################################################
print_info "Configuring Starship prompt..."
mkdir -p "$HOME/.config"

cat > "$HOME/.config/starship.toml" << 'STARSHIP_EOF'
##########################################################################
# STARSHIP PROMPT CONFIGURATION - DevOps Focus
##########################################################################
# Optimized for: Kubernetes, Cloud Providers, Terraform, Docker, Git
# Docs: https://starship.rs/config/

# Timeout for starship to execute commands (in milliseconds)
command_timeout = 1000

# Format of the prompt
format = """
[┌─](bold blue) $username$hostname$kubernetes$terraform$aws$gcloud$azure$docker_context$git_branch$git_status
[└─](bold blue) $directory$character"""

# Alternative format (single line):
# format = "$username$hostname$kubernetes$terraform$aws$gcloud$azure$docker_context$directory$git_branch$git_status$character"

##########################################################################
# PROMPT CHARACTER
##########################################################################
[character]
success_symbol = "[❯](bold green)"
error_symbol = "[❯](bold red)"
vimcmd_symbol = "[❮](bold green)"

##########################################################################
# DIRECTORY
##########################################################################
[directory]
truncation_length = 3
truncate_to_repo = true
style = "bold cyan"
format = "[$path]($style)[$read_only]($read_only_style) "
read_only = " 🔒"

##########################################################################
# KUBERNETES
##########################################################################
[kubernetes]
disabled = false
format = '[$symbol$context( \($namespace\))]($style) '
symbol = "☸️ "
style = "bold blue"
# Only show when in kubeconfig contexts
detect_files = ['k8s', 'Dockerfile', 'deployment.yaml', 'kustomization.yaml']
detect_folders = ['k8s', '.kube']

[kubernetes.context_aliases]
"arn:aws:eks:.*:.*:cluster/(?P<cluster>[\\w-]+)" = "eks-$cluster"
"gke_.*_(?P<cluster>[\\w-]+)" = "gke-$cluster"

##########################################################################
# CLOUD PROVIDERS
##########################################################################

# AWS
[aws]
disabled = false
format = '[$symbol($profile )(\($region\) )]($style)'
symbol = "☁️ "
style = "bold yellow"

[aws.region_aliases]
us-east-1 = "use1"
us-east-2 = "use2"
us-west-1 = "usw1"
us-west-2 = "usw2"
eu-west-1 = "euw1"
eu-central-1 = "euc1"
ap-southeast-1 = "apse1"

# Google Cloud
[gcloud]
disabled = true
format = '[$symbol$account(@$domain)(\($region\))]($style) '
symbol = "️📊 "
style = "bold blue"

# Azure
[azure]
disabled = false
format = '[$symbol($subscription)]($style) '
symbol = "️🔹 "
style = "bold blue"

##########################################################################
# INFRASTRUCTURE AS CODE
##########################################################################

# Terraform
[terraform]
disabled = false
format = '[$symbol$workspace]($style) '
symbol = "💠 "
style = "bold purple"

# Pulumi
[pulumi]
disabled = false
format = '[$symbol$stack]($style) '
symbol = "🧊 "
style = "bold yellow"

# Helm
[helm]
disabled = false
format = '[$symbol($version )]($style)'
symbol = "⎈ "
style = "bold purple"

##########################################################################
# CONTAINERS & ORCHESTRATION
##########################################################################

# Docker
[docker_context]
disabled = false
format = '[$symbol$context]($style) '
symbol = "🐳 "
style = "bold blue"
only_with_files = true
detect_files = ['docker-compose.yml', 'docker-compose.yaml', 'Dockerfile']

##########################################################################
# VERSION CONTROL
##########################################################################

# Git Branch
[git_branch]
disabled = false
format = "[$symbol$branch(:$remote_branch)]($style) "
symbol = " "
style = "bold purple"

# Git Status
[git_status]
disabled = false
format = '([\[$all_status$ahead_behind\]]($style) )'
style = "bold red"
conflicted = "🏳"
ahead = "⇡${count}"
behind = "⇣${count}"
diverged = "⇕⇡${ahead_count}⇣${behind_count}"
up_to_date = "✓"
untracked = "?${count}"
stashed = "$${count}"
modified = "!${count}"
staged = "+${count}"
renamed = "»${count}"
deleted = "✘${count}"

# Git Commit
[git_commit]
disabled = false
commit_hash_length = 7
tag_symbol = "🏷 "
style = "bold green"

# Git State (rebase, merge, etc.)
[git_state]
disabled = false
format = '[\($state( $progress_current of $progress_total)\)]($style) '
style = "bold yellow"

##########################################################################
# PROGRAMMING LANGUAGES (commonly used in DevOps)
##########################################################################

# Python
[python]
disabled = false
format = '[${symbol}${pyenv_prefix}(${version} )(\($virtualenv\) )]($style)'
symbol = "🐍 "
style = "bold yellow"

# Node.js
[nodejs]
disabled = false
format = '[$symbol($version )]($style)'
symbol = "⬢ "
style = "bold green"

# Go
[golang]
disabled = false
format = '[$symbol($version )]($style)'
symbol = "🐹 "
style = "bold cyan"

# Rust
[rust]
disabled = false
format = '[$symbol($version )]($style)'
symbol = "🦀 "
style = "bold red"

##########################################################################
# SYSTEM INFO
##########################################################################

# Username
[username]
disabled = false
show_always = false
format = "[$user]($style)@"
style_user = "bold green"
style_root = "bold red"

# Hostname
[hostname]
disabled = false
ssh_only = true
format = "[$hostname]($style) "
style = "bold green"

# Command Duration
[cmd_duration]
disabled = false
min_time = 2000
format = "took [$duration]($style) "
style = "bold yellow"

# Time
[time]
disabled = true
format = '🕙[\[ $time \]]($style) '
style = "bold white"
time_format = "%T"

# Battery
[battery]
disabled = false
full_symbol = "🔋"
charging_symbol = "⚡"
discharging_symbol = "💀"

[[battery.display]]
threshold = 10
style = "bold red"

[[battery.display]]
threshold = 30
style = "bold yellow"

##########################################################################
# PACKAGE MANAGERS
##########################################################################

[package]
disabled = true
symbol = "📦 "
format = "[$symbol$version]($style) "
style = "bold yellow"

##########################################################################
# OS & SHELL
##########################################################################

[os]
disabled = true
format = "[$symbol]($style)"

[os.symbols]
Macos = "🍎"
Linux = "🐧"
Windows = "🪟"

[shell]
disabled = true
format = "[$indicator]($style) "
bash_indicator = "bsh"
zsh_indicator = "zsh"
fish_indicator = "fsh"
STARSHIP_EOF

print_info "Starship configuration created"

##########################################################################
# 7. Create .zshrc Configuration
##########################################################################
print_info "Creating .zshrc configuration..."

# Backup existing .zshrc
if [ -f "$HOME/.zshrc" ]; then
    cp "$HOME/.zshrc" "$HOME/.zshrc.backup.$(date +%Y%m%d_%H%M%S)"
    print_info "Existing .zshrc backed up"
fi

cat > "$HOME/.zshrc" << 'ZSHRC_EOF'
# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH

# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time Oh My Zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
# ZSH_THEME="agnoster"  # Disabled to use Starship prompt
ZSH_THEME=""

plugins=(git z ssh-agent docker docker-compose zsh-bat terraform kubectl golang)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
   export EDITOR='vim'
else
   export EDITOR='nvim'
fi

# Compilation flags
# export ARCHFLAGS="-arch $(uname -m)"

# Set personal aliases, overriding those provided by Oh My Zsh libs,
# plugins, and themes. Aliases can be placed here, though Oh My Zsh
# users are encouraged to define aliases within a top-level file in
# the $ZSH_CUSTOM folder, with .zsh extension. Examples:
# - $ZSH_CUSTOM/aliases.zsh
# - $ZSH_CUSTOM/macos.zsh
# For a full list of active aliases, run `alias`.
#
# Example aliases
alias dcdown="docker compose down"
alias dcup="docker compose up -d --build"
alias zshconf="nvim ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
alias vi=nvim

# Zsh syntax highlighting (Ubuntu path)
if [ -f /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]; then
    source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi

# Zsh autosuggestions (Ubuntu path)
if [ -f /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]; then
    source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh
fi

##########################################################################
# STARSHIP PROMPT
##########################################################################
# Initialize Starship prompt (replaces Oh My Zsh themes)
eval "$(starship init zsh)"
ZSHRC_EOF

print_info ".zshrc configuration created"

##########################################################################
# 8. Optional: Install pyenv (if you want Python version management)
##########################################################################
read -p "Do you want to install pyenv for Python version management? (y/n) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    print_info "Installing pyenv..."

    # Install dependencies
    sudo apt-get install -y make build-essential libssl-dev zlib1g-dev \
        libbz2-dev libreadline-dev libsqlite3-dev wget curl llvm \
        libncursesw5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev \
        libffi-dev liblzma-dev

    # Install pyenv
    if [ ! -d "$HOME/.pyenv" ]; then
        curl https://pyenv.run | bash

        # Add pyenv to .zshrc
        cat >> "$HOME/.zshrc" << 'PYENV_EOF'

# pyenv config
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init --path)"
eval "$(pyenv init -)"
PYENV_EOF
        print_info "pyenv installed successfully"
    else
        print_info "pyenv is already installed"
    fi
fi

##########################################################################
# 9. Set Zsh as Default Shell
##########################################################################
if [ "$SHELL" != "$(which zsh)" ]; then
    print_info "Setting Zsh as default shell..."
    chsh -s $(which zsh)
    print_info "Default shell changed to Zsh. You may need to restart your session."
else
    print_info "Zsh is already the default shell"
fi

##########################################################################
# Completion
##########################################################################
echo ""
echo "=========================================="
print_info "Setup completed successfully!"
echo "=========================================="
echo ""
echo "Configuration Summary:"
echo "  ✓ Oh My Zsh plugins installed (zsh-bat)"
echo "  ✓ Custom theme created (custom-robbyrussell)"
echo "  ✓ Starship prompt installed and configured"
echo "  ✓ zsh-syntax-highlighting installed"
echo "  ✓ zsh-autosuggestions installed"
echo "  ✓ .zshrc configured with all settings"
echo "  ✓ Starship configuration created"
echo ""
echo "Next steps:"
echo "  1. Close and reopen your terminal (or run: source ~/.zshrc)"
echo "  2. If you installed pyenv, you may want to install a Python version:"
echo "     pyenv install 3.11.0"
echo "     pyenv global 3.11.0"
echo ""
echo "Your old .zshrc has been backed up to ~/.zshrc.backup.*"
echo ""
print_info "Enjoy your new WSL setup! 🚀"
