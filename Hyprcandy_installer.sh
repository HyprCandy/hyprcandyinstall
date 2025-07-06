#!/bin/bash

# HyprCandy Installer Script
# This script installs Hyprland and related packages from AUR

#set -e  # Exit on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
MAGENTA='\033[1;35m'
LIGHT_BLUE='\033[1;34m'
LIGHT_GREEN='\033[1;32m'
LIGHT_RED='\033[1;31m'
NC='\033[0m' # No Color

# Global variables
DISPLAY_MANAGER=""
DISPLAY_MANAGER_SERVICE=""
SHELL_CHOICE=""

# Function to display multicolored ASCII art
show_ascii_art() {
    clear
    echo
    # HyprCandy in gradient colors
    echo -e "${PURPLE}██╗  ██╗██╗   ██╗██████╗ ██████╗  ${MAGENTA}██████╗ █████╗ ███╗   ██╗██████╗ ██╗   ██╗${NC}"
    echo -e "${PURPLE}██║  ██║╚██╗ ██╔╝██╔══██╗██╔══██╗${MAGENTA}██╔════╝██╔══██╗████╗  ██║██╔══██╗╚██╗ ██╔╝${NC}"
    echo -e "${LIGHT_BLUE}███████║ ╚████╔╝ ██████╔╝██████╔╝${CYAN}██║     ███████║██╔██╗ ██║██║  ██║ ╚████╔╝${NC}"
    echo -e "${BLUE}██╔══██║  ╚██╔╝  ██╔═══╝ ██╔══██╗${CYAN}██║     ██╔══██║██║╚██╗██║██║  ██║  ╚██╔╝${NC}"
    echo -e "${BLUE}██║  ██║   ██║   ██║     ██║  ██║${LIGHT_GREEN}╚██████╗██║  ██║██║ ╚████║██████╔╝   ██║${NC}"
    echo -e "${GREEN}╚═╝  ╚═╝   ╚═╝   ╚═╝     ╚═╝  ╚═╝${LIGHT_GREEN} ╚═════╝╚═╝  ╚═╝╚═╝  ╚═══╝╚═════╝    ╚═╝${NC}"
    echo
    # Installer in different colors
    echo -e "${BLUE}██╗███╗   ██╗███████╗████████╗ ${LIGHT_RED}█████╗ ██╗     ██╗     ███████╗██████╗${NC}"
    echo -e "${BLUE}██║████╗  ██║██╔════╝╚══██╔══╝${LIGHT_RED}██╔══██╗██║     ██║     ██╔════╝██╔══██╗${NC}"
    echo -e "${RED}██║██╔██╗ ██║███████╗   ██║   ${LIGHT_RED}███████║██║     ██║     █████╗  ██████╔╝${NC}"
    echo -e "${RED}██║██║╚██╗██║╚════██║   ██║   ${CYAN}██╔══██║██║     ██║     ██╔══╝  ██╔══██╗${NC}"
    echo -e "${LIGHT_RED}██║██║ ╚████║███████║   ██║   ${CYAN}██║  ██║███████╗███████╗███████╗██║  ██║${NC}"
    echo -e "${CYAN}╚═╝╚═╝  ╚═══╝╚══════╝   ╚═╝   ╚═╝  ╚═╝╚══════╝╚══════╝╚══════╝╚═╝  ╚═╝${NC}"
    echo
    # Decorative line with gradient
    echo -e "${PURPLE}════════════════════${MAGENTA}════════════════════${CYAN}════════════════════${YELLOW}═════════${NC}"
    echo -e "${WHITE}                    Welcome to the HyprCandy Installer!${NC}"
    echo -e "${PURPLE}════════════════════${MAGENTA}════════════════════${CYAN}════════════════════${YELLOW}═════════${NC}"
    echo
}

# Function to print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Function to choose display manager
choose_display_manager() {
    print_status "Choose your display manager:"
    echo "1) SDDM with Sugar Candy theme (HyprCandy automatic background set according to applied wallpaper)"
    echo "2) GDM with GDM settings app (GNOME Display Manager and customization app)"
    echo
    
    while true; do
        echo -e "${YELLOW}Enter your choice (1 for SDDM, 2 for GDM):${NC}"
        read -r dm_choice
        case $dm_choice in
            1)
                DISPLAY_MANAGER="sddm"
                DISPLAY_MANAGER_SERVICE="sddm"
                print_status "Selected SDDM with Sugar Candy theme and HyprCandy automatic background setting"
                break
                ;;
            2)
                DISPLAY_MANAGER="gdm"
                DISPLAY_MANAGER_SERVICE="gdm"
                print_status "Selected GDM with GDM settings app"
                break
                ;;
            *)
                print_error "Invalid choice. Please enter 1 or 2."
                ;;
        esac
    done
}

# Function to choose shell
choose_shell() {
    print_status "Choose your shell: you can also rerun the script to switch from either or regenerate HyprCandy's default shell setup"
    echo "1) Fish - A modern shell with builtin fzf search, intelligent autosuggestions and syntax highlighting (Fisher plugins + Starship prompt)"
    echo "2) Zsh - Powerful shell with extensive customization (Zsh plugins + Oh My Zsh + Starship prompt)"
    echo
    
    while true; do
        echo -e "${YELLOW}Enter your choice (1 for Fish, 2 for Zsh):${NC}"
        read -r shell_choice
        case $shell_choice in
            1)
                SHELL_CHOICE="fish"
                print_status "Selected Fish shell with builtin features, plugins and Starship configuration"
                break
                ;;
            2)
                SHELL_CHOICE="zsh"
                print_status "Selected Zsh with plugins, Oh My Zsh integration and Starship configuration"
                break
                ;;
            *)
                print_error "Invalid choice. Please enter 1 or 2."
                ;;
        esac
    done
}

# Function to install yay
install_yay() {
    print_status "Installing yay..."
    cd /tmp
    git clone https://aur.archlinux.org/yay.git
    cd yay
    makepkg -si --noconfirm
    cd /tmp
    rm -rf yay
    print_success "yay installed successfully!"
}

# Function to install paru
install_paru() {
    print_status "Installing paru..."
    cd /tmp
    git clone https://aur.archlinux.org/paru.git
    cd paru
    makepkg -si --noconfirm
    cd /tmp
    rm -rf paru
    print_success "paru installed successfully!"
}

# Check if AUR helper is installed or install one
check_or_install_aur_helper() {
    if command -v yay &> /dev/null; then
        AUR_HELPER="yay"
        print_status "Found yay - using as AUR helper"
    elif command -v paru &> /dev/null; then
        AUR_HELPER="paru"
        print_status "Found paru - using as AUR helper"
    else
        print_warning "No AUR helper found. You need to install one."
        echo
        echo "Available AUR helpers:"
        echo "1) yay - Yet Another Yogurt (Go-based, fast)"
        echo "2) paru - Paru is based on yay (Rust-based, feature-rich)"
        echo
        while true; do
            echo -e "${YELLOW}Choose which AUR helper to install (1 for yay, 2 for paru):${NC}"
            read -r choice
            case $choice in
                1)
                    # Check if base-devel and git are installed
                    print_status "Ensuring base-devel and git are installed..."
                    sudo pacman -S --needed --noconfirm base-devel git
                    install_yay
                    AUR_HELPER="yay"
                    break
                    ;;
                2)
                    # Check if base-devel and git are installed
                    print_status "Ensuring base-devel and git are installed..."
                    sudo pacman -S --needed --noconfirm base-devel git
                    install_paru
                    AUR_HELPER="paru"
                    break
                    ;;
                *)
                    print_error "Invalid choice. Please enter 1 or 2."
                    ;;
            esac
        done
    fi
}

# Function to build package list based on display manager choice
build_package_list() {
    packages=(
        # Hyprland ecosystem
        "hyprland"
        "hyprcursor"
        "hyprgraphics"
        "hypridle"
        "hyprland-protocols"
        "hyprland-qt-support"
        "hyprland-qtutils"
        "hyprlang"
        "hyprlock"
        "hyprpaper"
        "hyprpicker"
        "hyprpolkitagent"
        "hyprsunset"
        "hyprsysteminfo"
        "hyprutils"
        "hyprwayland-scanner"
        
        # GNOME components (always include gnome-control-center and gnome-tweaks)
        "gnome-control-center"
        "gnome-tweaks"
        "gnome-software"
        "mutter"
        
        # Terminal and file manager
        "kitty"
        "nautilus"
        
        # Qt and GTK theming
        "qt5ct"
        "qt6ct"
        "nwg-look"
        
        # System utilities
        "network-manager-applet"
        "blueman"
        "nwg-displays"
        "nwg-dock-hyprland"
        "wlogout"
        "uwsm"
        
        # Application launchers and menus
        "rofi-wayland"
        "rofi-emoji"
        "rofi-nerdy"
        
        # Wallpaper and screenshot tools
        "swww"
        "grimblast-git"
        "wob"
        "wf-recorder"
        "slurp"
        "swappy"
        
        # System tools
        "gnome-disk-utility"
        "brightnessctl"
        "playerctl"
        
        # System monitoring
        "btop"
        "nvtop"
        "htop"
        
        # Customization and theming
        "ags-hyprpanel-git"
        "matugen-bin"
        "python-pywal16"
        
        # Applications
        "gedit"
        
        # Utilities
        "zip"
        "7zip"
        "wtype"
        "cava"
        "downgrade"
        "ntfs-3g"
        "fuse"
        "video-trimmer"
        "eog"
        "pyprland"
        "inotify-tools"
        
        # Fonts and emojis
        "nerd-fonts"
        "powerline-fonts"
        "noto-fonts-emoji"
        "noto-color-emoji-fontconfig"
        "awesome-terminal-fonts"
        
        # Clipboard
        "cliphist"
        "python-pywalfox"
        
        # Browser and themes
        "firefox"
        "adw-gtk-theme"
        "adwaita-qt6"
        "adwaita-qt-git"
        "tela-circle-icon-theme-all"
        
        # Cursor themes
        "bibata-cursor-theme"
        
        # Package management
        "octopi"
        
        # System info
        "fastfetch"
        
        # GTK development libraries
        "gtkmm-4.0"
        "gtksourceview3"
        "gtksourceview4"
        "gtksourceview5"

        # Fun stuff
        "cmatrix"
        "pipes.sh"
        
        # Configuration management
        "stow"
    )
    
    # Add display manager specific packages
    if [ "$DISPLAY_MANAGER" = "sddm" ]; then
        packages+=("sddm" "sddm-sugar-candy-git")
        print_status "Added SDDM and Sugar Candy theme to package list"
    elif [ "$DISPLAY_MANAGER" = "gdm" ]; then
        packages+=("gdm" "gdm-settings")
        print_status "Added GDM and GDM settings to package list"
    fi
    
    # Add shell specific packages
    if [ "$SHELL_CHOICE" = "fish" ]; then
        packages+=(
            "fish"
            "fisher"
            "starship"
        )
        print_status "Added Fish shell and modern tools to package list"
    elif [ "$SHELL_CHOICE" = "zsh" ]; then
        packages+=(
            "zsh"
            "zsh-completions"
            "zsh-autosuggestions"
            "zsh-history-substring-search"
            "zsh-syntax-highlighting"
            "starship"
            "oh-my-zsh-git"
        )
        print_status "Added Zsh and Oh My Zsh ecosystem with Starship to package list"
    fi
}

# Function to install packages
install_packages() {
    print_status "Starting installation of ${#packages[@]} packages using $AUR_HELPER..."
    
    # Install packages in batches to avoid potential issues
    local batch_size=10
    local total=${#packages[@]}
    local installed=0
    local failed=()
    
    for ((i=0; i<total; i+=batch_size)); do
        local batch=("${packages[@]:i:batch_size}")
        print_status "Installing batch $((i/batch_size + 1)): ${batch[*]}"
        
        if $AUR_HELPER -S --noconfirm --needed "${batch[@]}"; then
            installed=$((installed + ${#batch[@]}))
            print_success "Batch $((i/batch_size + 1)) installed successfully"
        else
            print_warning "Some packages in batch $((i/batch_size + 1)) failed to install"
            # Try installing packages individually to identify failures
            for pkg in "${batch[@]}"; do
                if ! $AUR_HELPER -S --noconfirm --needed "$pkg"; then
                    failed+=("$pkg")
                    print_error "Failed to install: $pkg"
                else
                    installed=$((installed + 1))
                fi
            done
        fi
        
        # Small delay between batches
        sleep 2
    done
    
    print_status "Installation completed!"
    print_success "Successfully installed: $installed packages"
    
    if [ ${#failed[@]} -gt 0 ]; then
        print_warning "Failed to install ${#failed[@]} packages:"
        printf '%s\n' "${failed[@]}"
        echo
        print_status "You can try installing failed packages manually:"
        echo "$AUR_HELPER -S ${failed[*]}"
    fi
}

# Function to setup Fish shell configuration
setup_fish() {
    print_status "Setting up Fish shell configuration..."
    
    # Set Fish as default shell
    if command -v fish &> /dev/null; then
        print_status "Setting Fish as default shell..."
        chsh -s $(which fish)
        print_success "Fish set as default shell"
    else
        print_error "Fish not found. Please install Fish first."
        return 1
    fi
    
    # Create Fish config directory
    mkdir -p "$HOME/.config/fish"
    
    # Install Fisher (Fish plugin manager) and popular plugins
    if command -v fish &> /dev/null; then
        print_status "Installing Fisher and essential Fish plugins..."
        
        # Install Fisher
        fish -c "curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher install jorgebucaran/fisher"
        
        # Install essential plugins
        fish -c "fisher install jorgebucaran/autopair.fish"
        fish -c "fisher install franciscolourenco/done"
        fish -c "fisher install jethrokuan/z"
        fish -c "fisher install jorgebucaran/nvm.fish"
        fish -c "fisher install PatrickF1/fzf.fish"
        
        print_success "Fisher and plugins installed"
    fi
    
    # Configure Starship prompt
    if command -v starship &> /dev/null; then
        print_status "Configuring Starship prompt for Fish..."
        
        # Add Starship to Fish config
        echo 'starship init fish | source' >> "$HOME/.config/fish/config.fish"
        
        # Create Starship config
        mkdir -p "$HOME/.config"
        cat > "$HOME/.config/starship.toml" << 'EOF'
# Starship Configuration for HyprCandy
format = """
$username\
$hostname\
$directory\
$git_branch\
$git_state\
$git_status\
$git_metrics\
$fill\
$nodejs\
$python\
$rust\
$golang\
$php\
$java\
$kotlin\
$haskell\
$swift\
$cmd_duration $jobs $time\
$line_break\
$character"""

[directory]
style = "blue"
read_only = " 🔒"
truncation_length = 4
truncate_to_repo = false

[character]
success_symbol = "[✔](green)"
error_symbol = "[x](red)"
vimcmd_symbol = "[❮](green)"

[git_branch]
symbol = "🌱 "
truncation_length = 4
truncation_symbol = ""
style = "bold green"

[git_status]
ahead = "⇡${count}"
diverged = "⇕⇡${ahead_count}⇣${behind_count}"
behind = "⇣${count}"
deleted = "x"

[nodejs]
symbol = "💠 "
style = "bold green"

[python]
symbol = "🐍 "
style = "bold yellow"

[rust]
symbol = "⚙️ "
style = "bold red"

[time]
format = '🕙[\[ $time \]]($style) '
time_format = "%T"
disabled = false
style = "bright-white"

[cmd_duration]
format = "⏱️ [$duration]($style) "
style = "yellow"

[jobs]
symbol = "⚡ "
style = "bold blue"
EOF
        
        print_success "Starship configured for Fish"
    fi
    
    # Add useful Fish functions and aliases
    cat > "$HOME/.config/fish/config.fish" << 'EOF'
# HyprCandy Fish Configuration

# Initialize Starship prompt
if type -q starship
    starship init fish | source
end

# Set environment variables
set -x EDITOR micro
set -x BROWSER firefox
set -x TERMINAL kitty

# Add local bin to PATH
if test -d ~/.local/bin
    set -x PATH ~/.local/bin $PATH
end

# Aliases
alias ll="ls -alF"
alias la="ls -A"
alias l="ls -CF"
alias ..="cd .."
alias ...="cd ../.."
alias grep="grep --color=auto"
alias fgrep="fgrep --color=auto"
alias egrep="egrep --color=auto"
alias update="sudo pacman -Syu"
alias install="sudo pacman -S"
alias search="pacman -Ss"
alias remove="sudo pacman -R"
alias autoremove="sudo pacman -Rs (pacman -Qtdq)"
alias cls="clear"
alias h="history"
alias j="jobs -l"
alias df="df -h"
alias du="du -h"
alias mkdir="mkdir -pv"
alias wget="wget -c"

# Git aliases
alias g="git clone"
alias ga="git add ."
alias gc="git commit -m"
alias gp="git push"
alias gl="git pull"
alias gs="git status"
alias gd="git diff"
alias gco="git checkout"
alias gb="git branch"
alias glog="git log --oneline --graph --decorate"

# System information
alias sysinfo="fastfetch"
alias weather="curl wttr.in"

# Fun stuff
alias matrix="cmatrix"
alias pipes="pipes.sh"

# Start HyprCandy fastfetch
fastfetch

# Welcome message
function fish_greeting
end

EOF
    
    print_success "Fish shell configuration completed!"
}

# Function to setup Zsh configuration
setup_zsh() {
    print_status "Setting up Zsh shell configuration..."
    
    # Set Zsh as default shell
    if command -v zsh &> /dev/null; then
        print_status "Setting Zsh as default shell..."
        chsh -s $(which zsh)
        print_success "Zsh set as default shell"
    else
        print_error "Zsh not found. Please install Zsh first."
        return 1
    fi
    
    # Install Oh My Zsh if not already installed
    if [ ! -d "$HOME/.oh-my-zsh" ]; then
        print_status "Installing Oh My Zsh..."
        RUNZSH=no sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
        print_success "Oh My Zsh installed"
    fi
    
    # Configure Starship prompt
    if command -v starship &> /dev/null; then
        print_status "Configuring Starship prompt for Zsh..."
        
        # Create Starship config (same as Fish setup)
        mkdir -p "$HOME/.config"
        cat > "$HOME/.config/starship.toml" << 'EOF'
# Starship Configuration for HyprCandy
format = """
$username\
$hostname\
$directory\
$git_branch\
$git_state\
$git_status\
$git_metrics\
$fill\
$nodejs\
$python\
$rust\
$golang\
$php\
$java\
$kotlin\
$haskell\
$swift\
$cmd_duration $jobs $time\
$line_break\
$character"""

[directory]
style = "blue"
read_only = " 🔒"
truncation_length = 4
truncate_to_repo = false

[character]
success_symbol = "[✔](green)"
error_symbol = "[x](red)"
vimcmd_symbol = "[❮](green)"

[git_branch]
symbol = "🌱 "
truncation_length = 4
truncation_symbol = ""
style = "bold green"

[git_status]
ahead = "⇡${count}"
diverged = "⇕⇡${ahead_count}⇣${behind_count}"
behind = "⇣${count}"
deleted = "x"

[nodejs]
symbol = "💠 "
style = "bold green"

[python]
symbol = "🐍 "
style = "bold yellow"

[rust]
symbol = "⚙️ "
style = "bold red"

[time]
format = '🕙[\[ $time \]]($style) '
time_format = "%T"
disabled = false
style = "bright-white"

[cmd_duration]
format = "⏱️ [$duration]($style) "
style = "yellow"

[jobs]
symbol = "⚡ "
style = "bold blue"
EOF
        
        # Create .zshrc with Starship configuration
        cat > "$HOME/.zshrc" << 'EOF'
# HyprCandy Zsh Configuration with Oh My Zsh and Starship

# Oh My Zsh configuration
export ZSH="$HOME/.oh-my-zsh"

# Set environment variables
export EDITOR=micro
export BROWSER=firefox
export TERMINAL=kitty

# Add local bin to PATH
if [ -d "$HOME/.local/bin" ]; then
    export PATH="$HOME/.local/bin:$PATH"
fi

# Initialize Starship prompt
if command -v starship > /dev/null 2>&1; then
    eval "$(starship init zsh)"
fi

# Source Oh My Zsh
source $ZSH/oh-my-zsh.sh

# Aliases
alias ll="ls -alF"
alias la="ls -A"
alias l="ls -CF"
alias ..="cd .."
alias ...="cd ../.."
alias grep="grep --color=auto"
alias fgrep="fgrep --color=auto"
alias egrep="egrep --color=auto"
alias update="sudo pacman -Syu"
alias install="sudo pacman -S"
alias search="pacman -Ss"
alias remove="sudo pacman -R"
alias autoremove="sudo pacman -Rs $(pacman -Qtdq)"
alias c="clear"
alias h="history"
alias j="jobs -l"
alias df="df -h"
alias du="du -h"
alias mkdir="mkdir -pv"
alias wget="wget -c"

# Git aliases
alias g="git clone"
alias ga="git add ."
alias gc="git commit -m"
alias gp="git push"
alias gl="git pull"
alias gs="git status"
alias gd="git diff"
alias gco="git checkout"
alias gb="git branch"
alias glog="git log --oneline --graph --decorate"

# System information
alias sysinfo="fastfetch"
alias weather="curl wttr.in"

# Fun stuff
alias matrix="cmatrix"
alias pipes="pipes.sh"

# Start HyprCandy fastfetch
fastfetch

# Source HyprCandy Zsh setup if it exists
if [ -f ~/.hyprcandy-zsh.zsh ]; then
    source ~/.hyprcandy-zsh.zsh
fi
EOF
        
        print_success "Starship configured for Zsh"
    fi
    
    print_success "Zsh shell configuration completed!"
}
    
# Function to automatically setup Hyprcandy configuration
setup_hyprcandy() {
    print_status "Setting up Hyprcandy configuration..."
    
    # Check if stow is available
    if ! command -v stow &> /dev/null; then
        print_error "stow is not installed. Cannot proceed with configuration setup."
        return 1
    fi
    
    # In case of updates, remove existing .hyprcandy folder before cloning
    if [ -d "$HOME/.hyprcandy" ]; then
        echo "🗑️  Removing existing .hyprcandy folder to clone updated dotfiles..."
        rm -rf "$HOME/.hyprcandy"
        sleep 2
    else
        echo "✅ .hyprcandy dotfiles folder doesn't exist — seems to be a fresh install."
        sleep 2
    fi

    # Clone Hyprcandy repository
    hyprcandy_dir="$HOME/.hyprcandy"
    echo "🌐 Cloning Hyprcandy repository into $hyprcandy_dir..."
    git clone https://github.com/HyprCandy/Hyprcandy.git "$hyprcandy_dir"

    
    # Go to the home directory
    cd "$HOME"

    # Remove present .zshrc file (removed .zshrc from list since it's now handled by the script) 
    rm -rf .face.icon .hyprcandy-zsh.zsh .icons HyprCandy

    # Ensure ~/.config exists, then remove specified subdirectories
    [ -d "$HOME/.config" ] || mkdir -p "$HOME/.config"
    cd "$HOME/.config" || exit 1
    rm -rf btop cava fastfetch gtk-3.0 gtk-4.0 htop hypr hyprcandy hyprpanel kitty matugen micro nvtop nwg-dock-hyprland nwg-look qt5ct qt6ct rofi uwsmm wlogout xsettingsd

    # Go to the home directory
    cd "$HOME"

    # Safely remove existing .zshrc, .hyprcandy-zsh.zsh and .icons files (only if they exist)
    # [ -f "$HOME/.zshrc" ] && rm -f "$HOME/.zshrc"
    [ -f "$HOME/.face.icon" ] && rm -f "$HOME/.face.icon"
    [ -f "$HOME/.hyprcandy-zsh.zsh" ] && rm -f "$HOME/.hyprcandy-zsh.zsh"
    [ -f "$HOME/.icons" ] && rm -f "$HOME/.icons"
    [ -f "$HOME/HyprCandy" ] && rm -f "$HOME/HyprCandy"

    # 📁 Create Screenshots and Recordings directories if they don't exist
    echo "📁 Ensuring directories for screenshots and recordings exist..."
    mkdir -p "$HOME/Pictures/Screenshots" "$HOME/Videos/Recordings"
    echo "✅ Created ~/Pictures/Screenshots and ~/Videos/Recordings (if missing)"

    # Return to the home directory
    cd "$HOME"
    
    # Change to the hyprcandy dotfiles directory
    cd "$hyprcandy_dir" || { echo "❌ Error: Could not find Hyprcandy directory"; exit 1; }

    # Define only the configs to be stowed
    config_dirs=(".face.icon" ".config" ".icons" ".hyprcandy-zsh.zsh")

    # Add files/folders to exclude from deletion
    preserve_items=("HyprCandy" ".git")

    if [ ${#config_dirs[@]} -eq 0 ]; then
        echo "❌ No configuration directories specified."
        exit 1
    fi

    echo "🔍 Found configuration directories: ${config_dirs[*]}"
    echo "📦 Automatically installing all configurations..."

    # Backup: remove everything not in the allowlist
    for item in * .*; do
        # Skip special entries
        [[ "$item" == "." || "$item" == ".." ]] && continue

        # Skip allowed config items
        if [[ " ${config_dirs[*]} " == *" $item "* ]]; then
            continue
        fi

        # Skip explicitly preserved items
        if [[ " ${preserve_items[*]} " == *" $item "* ]]; then
            echo "❎ Preserving: $item"
            continue
        fi

        echo "🗑️  Removing: $item"
        rm -rf "$item"
    done

    # Stow all configurations at once
    if stow -v -t "$HOME" . 2>/dev/null; then
        echo "✅ Successfully stowed all configurations"
    else
        echo "⚠️  Stow operation failed — attempting restow..."
        if stow -R -v -t "$HOME" . 2>/dev/null; then
            echo "✅ Successfully restowed all configurations"
        else
            echo "❌ Failed to stow configurations"
        fi
    fi

    # Final summary
    echo
    echo "✅ Installation completed. Successfully installed: $stow_success"
    if [ ${#stow_failed[@]} -ne 0 ]; then
        echo "❌ Failed to install: ${stow_failed[*]}"
    fi

### ✅ Setup hook scripts and needed services
echo "📁 Creating background hook scripts..."
mkdir -p "$HOME/.config/hyprcandy/hooks" "$HOME/.config/systemd/user"

#!/bin/bash

# ═══════════════════════════════════════════════════════════════
#                    Gaps OUT Increase Script
# ═══════════════════════════════════════════════════════════════

# File: ~/.config/hyprcandy/hooks/hyprland_gaps_out_increase.sh
cat > "$HOME/.config/hyprcandy/hooks/hyprland_gaps_out_increase.sh" << 'EOF'
#!/bin/bash

CONFIG_FILE="$HOME/.config/hyprcustom/custom.conf"

# Get current gaps_out value
CURRENT_GAPS_OUT=$(grep -E "^\s*gaps_out\s*=" "$CONFIG_FILE" | sed 's/.*gaps_out\s*=\s*\([0-9]*\).*/\1/')

# Increment value
NEW_GAPS_OUT=$((CURRENT_GAPS_OUT + 1))

# Update the file
sed -i "s/^\(\s*gaps_out\s*=\s*\)[0-9]*/\1$NEW_GAPS_OUT/" "$CONFIG_FILE"

# Force apply gaps using hyprctl (immediate effect)
hyprctl keyword general:gaps_out $NEW_GAPS_OUT

# Also reload config to ensure persistence
hyprctl reload

echo "🔼 Gaps OUT increased: gaps_out=$NEW_GAPS_OUT"
notify-send "Gaps OUT Increased" "gaps_out: $NEW_GAPS_OUT" -t 2000
EOF

# ═══════════════════════════════════════════════════════════════
#                    Gaps OUT Decrease Script
# ═══════════════════════════════════════════════════════════════

# File: ~/.config/hyprcandy/hooks/hyprland_gaps_out_decrease.sh
cat > "$HOME/.config/hyprcandy/hooks/hyprland_gaps_out_decrease.sh" << 'EOF'
#!/bin/bash

CONFIG_FILE="$HOME/.config/hyprcustom/custom.conf"

# Get current gaps_out value
CURRENT_GAPS_OUT=$(grep -E "^\s*gaps_out\s*=" "$CONFIG_FILE" | sed 's/.*gaps_out\s*=\s*\([0-9]*\).*/\1/')

# Decrement value (minimum 0)
NEW_GAPS_OUT=$((CURRENT_GAPS_OUT > 0 ? CURRENT_GAPS_OUT - 1 : 0))

# Update the file
sed -i "s/^\(\s*gaps_out\s*=\s*\)[0-9]*/\1$NEW_GAPS_OUT/" "$CONFIG_FILE"

# Force apply gaps using hyprctl (immediate effect)
hyprctl keyword general:gaps_out $NEW_GAPS_OUT

# Also reload config to ensure persistence
hyprctl reload

echo "🔽 Gaps OUT decreased: gaps_out=$NEW_GAPS_OUT"
notify-send "Gaps OUT Decreased" "gaps_out: $NEW_GAPS_OUT" -t 2000
EOF

# ═══════════════════════════════════════════════════════════════
#                    Gaps IN Increase Script
# ═══════════════════════════════════════════════════════════════

# File: ~/.config/hyprcandy/hooks/hyprland_gaps_in_increase.sh
cat > "$HOME/.config/hyprcandy/hooks/hyprland_gaps_in_increase.sh" << 'EOF'
#!/bin/bash

CONFIG_FILE="$HOME/.config/hyprcustom/custom.conf"

# Get current gaps_in value
CURRENT_GAPS_IN=$(grep -E "^\s*gaps_in\s*=" "$CONFIG_FILE" | sed 's/.*gaps_in\s*=\s*\([0-9]*\).*/\1/')

# Increment value
NEW_GAPS_IN=$((CURRENT_GAPS_IN + 1))

# Update the file
sed -i "s/^\(\s*gaps_in\s*=\s*\)[0-9]*/\1$NEW_GAPS_IN/" "$CONFIG_FILE"

# Force apply gaps using hyprctl (immediate effect)
hyprctl keyword general:gaps_in $NEW_GAPS_IN

# Also reload config to ensure persistence
hyprctl reload

echo "🔼 Gaps IN increased: gaps_in=$NEW_GAPS_IN"
notify-send "Gaps IN Increased" "gaps_in: $NEW_GAPS_IN" -t 2000
EOF

# ═══════════════════════════════════════════════════════════════
#                    Gaps IN Decrease Script
# ═══════════════════════════════════════════════════════════════

# File: ~/.config/hyprcandy/hooks/hyprland_gaps_in_decrease.sh
cat > "$HOME/.config/hyprcandy/hooks/hyprland_gaps_in_decrease.sh" << 'EOF'
#!/bin/bash

CONFIG_FILE="$HOME/.config/hyprcustom/custom.conf"

# Get current gaps_in value
CURRENT_GAPS_IN=$(grep -E "^\s*gaps_in\s*=" "$CONFIG_FILE" | sed 's/.*gaps_in\s*=\s*\([0-9]*\).*/\1/')

# Decrement value (minimum 0)
NEW_GAPS_IN=$((CURRENT_GAPS_IN > 0 ? CURRENT_GAPS_IN - 1 : 0))

# Update the file
sed -i "s/^\(\s*gaps_in\s*=\s*\)[0-9]*/\1$NEW_GAPS_IN/" "$CONFIG_FILE"

# Force apply gaps using hyprctl (immediate effect)
hyprctl keyword general:gaps_in $NEW_GAPS_IN

# Also reload config to ensure persistence
hyprctl reload

echo "🔽 Gaps IN decreased: gaps_in=$NEW_GAPS_IN"
notify-send "Gaps IN Decreased" "gaps_in: $NEW_GAPS_IN" -t 2000
EOF

# ═══════════════════════════════════════════════════════════════
#                Border Increase Script with Force Options
# ═══════════════════════════════════════════════════════════════

# File: ~/.config/hyprcandy/hooks/hyprland_border_increase.sh
cat > ~/.config/hyprcandy/hooks/hyprland_border_increase.sh << 'EOF'
#!/bin/bash

CONFIG_FILE="$HOME/.config/hyprcustom/custom.conf"

# Get current border_size value
CURRENT_BORDER=$(grep -E "^\s*border_size\s*=" "$CONFIG_FILE" | sed 's/.*border_size\s*=\s*\([0-9]*\).*/\1/')

# Increment value
NEW_BORDER=$((CURRENT_BORDER + 1))

# Update the file
sed -i "s/^\(\s*border_size\s*=\s*\)[0-9]*/\1$NEW_BORDER/" "$CONFIG_FILE"

# Force apply border using hyprctl (immediate effect)
hyprctl keyword general:border_size $NEW_BORDER

# Also reload config to ensure persistence
hyprctl reload

echo "🔼 Border increased: border_size=$NEW_BORDER"
notify-send "Border Increased" "border_size: $NEW_BORDER" -t 2000
EOF

# ═══════════════════════════════════════════════════════════════
#                Border Decrease Script with Force Options
# ═══════════════════════════════════════════════════════════════

# File: ~/.config/hyprcandy/hooks/hyprland_border_decrease.sh
cat > ~/.config/hyprcandy/hooks/hyprland_border_decrease.sh << 'EOF'
#!/bin/bash

CONFIG_FILE="$HOME/.config/hyprcustom/custom.conf"

# Get current border_size value
CURRENT_BORDER=$(grep -E "^\s*border_size\s*=" "$CONFIG_FILE" | sed 's/.*border_size\s*=\s*\([0-9]*\).*/\1/')

# Decrement value (minimum 0)
NEW_BORDER=$((CURRENT_BORDER > 0 ? CURRENT_BORDER - 1 : 0))

# Update the file
sed -i "s/^\(\s*border_size\s*=\s*\)[0-9]*/\1$NEW_BORDER/" "$CONFIG_FILE"

# Force apply border using hyprctl (immediate effect)
hyprctl keyword general:border_size $NEW_BORDER

# Also reload config to ensure persistence
hyprctl reload

echo "🔽 Border decreased: border_size=$NEW_BORDER"
notify-send "Border Decreased" "border_size: $NEW_BORDER" -t 2000
EOF

# ═══════════════════════════════════════════════════════════════
#                Rounding Increase Script with Force Options
# ═══════════════════════════════════════════════════════════════

# File: ~/.config/hyprcandy/hooks/hyprland_rounding_increase.sh
cat > ~/.config/hyprcandy/hooks/hyprland_rounding_increase.sh << 'EOF'
#!/bin/bash

CONFIG_FILE="$HOME/.config/hyprcustom/custom.conf"


# Get current rounding value
CURRENT_ROUNDING=$(grep -E "^\s*rounding\s*=" "$CONFIG_FILE" | sed 's/.*rounding\s*=\s*\([0-9]*\).*/\1/')

# Increment value
NEW_ROUNDING=$((CURRENT_ROUNDING + 1))

# Update the file
sed -i "s/^\(\s*rounding\s*=\s*\)[0-9]*/\1$NEW_ROUNDING/" "$CONFIG_FILE"

# Force apply rounding using hyprctl (immediate effect)
hyprctl keyword decoration:rounding $NEW_ROUNDING

# Also reload config to ensure persistence
hyprctl reload

echo "🔼 Rounding increased: rounding=$NEW_ROUNDING"
notify-send "Rounding Increased" "rounding: $NEW_ROUNDING" -t 2000
EOF

# ═══════════════════════════════════════════════════════════════
#                Rounding Decrease Script with Force Options
# ═══════════════════════════════════════════════════════════════

# File: ~/.config/hyprcandy/hooks/hyprland_rounding_decrease.sh
cat > ~/.config/hyprcandy/hooks/hyprland_rounding_decrease.sh << 'EOF'
#!/bin/bash

CONFIG_FILE="$HOME/.config/hyprcustom/custom.conf"

# Get current rounding value
CURRENT_ROUNDING=$(grep -E "^\s*rounding\s*=" "$CONFIG_FILE" | sed 's/.*rounding\s*=\s*\([0-9]*\).*/\1/')

# Decrement value (minimum 0)
NEW_ROUNDING=$((CURRENT_ROUNDING > 0 ? CURRENT_ROUNDING - 1 : 0))

# Update the file
sed -i "s/^\(\s*rounding\s*=\s*\)[0-9]*/\1$NEW_ROUNDING/" "$CONFIG_FILE"

# Force apply rounding using hyprctl (immediate effect)
hyprctl keyword decoration:rounding $NEW_ROUNDING

# Also reload config to ensure persistence
hyprctl reload

echo "🔽 Rounding decreased: rounding=$NEW_ROUNDING"
notify-send "Rounding Decreased" "rounding: $NEW_ROUNDING" -t 2000
EOF

# ═══════════════════════════════════════════════════════════════
#                     Make scripts executable
# ═══════════════════════════════════════════════════════════════

chmod +x "$HOME/.config/hyprcandy/hooks/hyprland_gaps_out_increase.sh"
chmod +x "$HOME/.config/hyprcandy/hooks/hyprland_gaps_out_decrease.sh"
chmod +x "$HOME/.config/hyprcandy/hooks/hyprland_gaps_in_increase.sh"
chmod +x "$HOME/.config/hyprcandy/hooks/hyprland_gaps_in_decrease.sh"
chmod +x "$HOME/.config/hyprcandy/hooks/hyprland_border_increase.sh"
chmod +x "$HOME/.config/hyprcandy/hooks/hyprland_border_decrease.sh"
chmod +x "$HOME/.config/hyprcandy/hooks/hyprland_rounding_increase.sh"
chmod +x "$HOME/.config/hyprcandy/hooks/hyprland_rounding_decrease.sh"

echo "✅ Hyprland adjustment scripts created and made executable!"

### 🧹 Create clear_swww.sh
cat > "$HOME/.config/hyprcandy/hooks/clear_swww.sh" << 'EOF'
#!/bin/bash
CACHE_DIR="$HOME/.cache/swww"
[ -d "$CACHE_DIR" ] && rm -rf "$CACHE_DIR"
EOF
chmod +x "$HOME/.config/hyprcandy/hooks/clear_swww.sh"

### 🧼 Create update_background.sh
cat > "$HOME/.config/hyprcandy/hooks/update_background.sh" << 'EOF'
#!/bin/bash

# Update local background.png
if command -v magick >/dev/null && [ -f "$HOME/.config/background" ]; then
    magick "$HOME/.config/background[0]" "$HOME/.config/background.png"
fi

sleep 1

# Update SDDM background with sudo
if command -v magick >/dev/null && [ -f "$HOME/.config/background" ]; then
    sudo magick "$HOME/.config/background[0]" "/usr/share/sddm/themes/sugar-candy/Backgrounds/Mountain.jpg"
fi

sleep 1

# Restart portals
# Setup Timers
_sleep1="1"
_sleep2="2"
_sleep3="3"

# Kill all possible running xdg-desktop-portals
killall -e xdg-desktop-portal-hyprland
killall -e xdg-desktop-portal-gtk
killall -e xdg-desktop-portal

# Set required environment variables
dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP=hyprland
sleep $_sleep1

# Stop all services
systemctl --user stop xdg-desktop-portal
systemctl --user stop xdg-desktop-portal-gtk
systemctl --user stop xdg-desktop-portal-hyprland
sleep $_sleep2

# Start xdg-desktop-portal-hyprland
/usr/lib/xdg-desktop-portal &
/usr/lib/xdg-desktop-portal-gtk &
/usr/lib/xdg-desktop-portal-hyprland &
sleep $_sleep3

# Start required services
systemctl --user start xdg-desktop-portal
systemctl --user start xdg-desktop-portal-gtk
systemctl --user start xdg-desktop-portal-hyprland
EOF
chmod +x "$HOME/.config/hyprcandy/hooks/update_background.sh"

### 👀 Create watch_background.sh
cat > "$HOME/.config/hyprcandy/hooks/watch_background.sh" << 'EOF'
#!/bin/bash

CONFIG_BG="$HOME/.config/background"
HOOKS_DIR="$HOME/.config/hyprcandy/hooks"

# ⏳ Wait for background file to exist
while [ ! -f "$CONFIG_BG" ]; do
    echo "⏳ Waiting for background file to appear..."
    sleep 0.5
done

inotifywait -m -e close_write "$CONFIG_BG" | while read -r file; do
    echo "🎯 Detected background update: $file"
    "$HOOKS_DIR/clear_swww.sh"
    "$HOOKS_DIR/update_background.sh"
done
EOF
chmod +x "$HOME/.config/hyprcandy/hooks/watch_background.sh"

### 🔧 Create background-watcher.service
cat > "$HOME/.config/systemd/user/background-watcher.service" << 'EOF'
[Unit]
Description=Watch ~/.config/background, clear swww cache and update background images
After=graphical-session.target

[Service]
ExecStart=%h/.config/hyprcandy/hooks/watch_background.sh
Restart=on-failure

[Install]
WantedBy=default.target
EOF

### 🎮 Create hyprpanel_idle_monitor.sh
cat > "$HOME/.config/hyprcandy/hooks/hyprpanel_idle_monitor.sh" << 'EOF'
#!/bin/bash

# Script to monitor hyprpanel and manage idle inhibitor accordingly
# When hyprpanel is not running, enable idle inhibitor
# When hyprpanel is running, disable idle inhibitor (only our own, not hyprpanel's)

IDLE_INHIBITOR_PID=""
CHECK_INTERVAL=5  # Check every 5 seconds
INHIBITOR_WHO="HyprCandy-Monitor"  # Unique identifier for our inhibitor

# Function to check if hyprpanel has its own idle inhibitor active
has_hyprpanel_inhibitor() {
    # Check for existing systemd-inhibit processes that might be from hyprpanel
    # Look for inhibitors with "hyprpanel" or similar in the why/who field
    systemd-inhibit --list 2>/dev/null | grep -i "hyprpanel\|panel" >/dev/null 2>&1
}

# Function to check if our specific inhibitor is running
has_our_inhibitor() {
    systemd-inhibit --list 2>/dev/null | grep "$INHIBITOR_WHO" >/dev/null 2>&1
}

# Function to start idle inhibitor (only if hyprpanel doesn't have one)
start_idle_inhibitor() {
    # Don't start our inhibitor if hyprpanel already has one active
    if has_hyprpanel_inhibitor; then
        echo "$(date): Hyprpanel appears to have its own idle inhibitor active, not starting ours"
        return
    fi
    
    # Don't start if our inhibitor is already running
    if has_our_inhibitor; then
        echo "$(date): Our idle inhibitor is already active"
        return
    fi
    
    if [ -z "$IDLE_INHIBITOR_PID" ] || ! kill -0 "$IDLE_INHIBITOR_PID" 2>/dev/null; then
        echo "$(date): Starting idle inhibitor..."
        systemd-inhibit --what=idle --who="$INHIBITOR_WHO" --why="Hyprpanel not running" sleep infinity &
        IDLE_INHIBITOR_PID=$!
        echo "$(date): Idle inhibitor started with PID: $IDLE_INHIBITOR_PID"
    fi
}

# Function to stop our idle inhibitor (only our own, never hyprpanel's)
stop_idle_inhibitor() {
    if [ -n "$IDLE_INHIBITOR_PID" ] && kill -0 "$IDLE_INHIBITOR_PID" 2>/dev/null; then
        echo "$(date): Stopping our idle inhibitor..."
        kill "$IDLE_INHIBITOR_PID"
        IDLE_INHIBITOR_PID=""
        echo "$(date): Our idle inhibitor stopped"
    fi
}

# Function to check if hyprpanel is running
is_hyprpanel_running() {
    pgrep -f "gjs" > /dev/null 2>&1
}

# Cleanup function
cleanup() {
    echo "$(date): Cleaning up..."
    stop_idle_inhibitor
    exit 0
}

# Set up signal handlers
trap cleanup SIGTERM SIGINT

echo "$(date): Starting hyprpanel idle monitor..."
echo "$(date): Will only manage our own inhibitor (WHO=$INHIBITOR_WHO)"

# Main monitoring loop
while true; do
    if is_hyprpanel_running; then
        # Hyprpanel is running, stop our idle inhibitor if it's running
        # (hyprpanel can manage its own inhibitor)
        if [ -n "$IDLE_INHIBITOR_PID" ] && kill -0 "$IDLE_INHIBITOR_PID" 2>/dev/null; then
            echo "$(date): Hyprpanel detected, stopping our idle inhibitor"
            stop_idle_inhibitor
        fi
    else
        # Hyprpanel is not running, start our idle inhibitor if needed
        # But only if hyprpanel doesn't have its own inhibitor still active
        if [ -z "$IDLE_INHIBITOR_PID" ] || ! kill -0 "$IDLE_INHIBITOR_PID" 2>/dev/null; then
            if ! has_hyprpanel_inhibitor; then
                echo "$(date): Hyprpanel not detected and no hyprpanel inhibitor found, starting our idle inhibitor"
                start_idle_inhibitor
            else
                echo "$(date): Hyprpanel not running but hyprpanel inhibitor still active, waiting..."
            fi
        fi
    fi
    
    sleep "$CHECK_INTERVAL"
done
EOF
chmod +x "$HOME/.config/hyprcandy/hooks/hyprpanel_idle_monitor.sh"

### 🔧 Create hyprpanel-idle-monitor.service
cat > "$HOME/.config/systemd/user/hyprpanel-idle-monitor.service" << 'EOF'
[Unit]
Description=Monitor gjs and manage idle inhibitor
After=graphical-session.target hyprland-session.target
Wants=graphical-session.target
PartOf=graphical-session.target
Requisite=graphical-session.target

[Service]
Type=simple
ExecStart=%h/.config/hyprcandy/hooks/hyprpanel_idle_monitor.sh
Restart=always
RestartSec=10
KillMode=mixed
KillSignal=SIGTERM
TimeoutStopSec=10

[Install]
WantedBy=graphical-session.target
EOF

### 🛡️ Create safe hyprpanel killer script
cat > "$HOME/.config/hyprcandy/hooks/kill_hyprpanel_safe.sh" << 'EOF'
#!/bin/bash

# Safe hyprpanel killer - preserves swww-daemon

echo "🔄 Safely closing hyprpanel while preserving swww-daemon..."

# Method 1: Try graceful shutdown first
if pgrep -f "hyprpanel" > /dev/null; then
    echo "📱 Attempting graceful shutdown..."
    hyprpanel -q
    sleep 1
    
    # Check if it's still running
    if pgrep -f "hyprpanel" > /dev/null; then
        echo "⚠️  Graceful shutdown failed, trying systemd stop..."
        systemctl --user stop hyprpanel.service
        sleep 1
        
        # If still running, force kill (but only hyprpanel processes)
        if pgrep -f "hyprpanel" > /dev/null; then
            echo "🔨 Force killing hyprpanel processes..."
            # Kill only gjs processes that are running hyprpanel
            pkill -f "gjs.*hyprpanel"
        fi
    fi
fi

# Verify swww-daemon is still running
if ! pgrep -f "swww-daemon" > /dev/null; then
    echo "🔄 swww-daemon not found, restarting it..."
    swww-daemon &
    sleep 1
    
    # Restore current wallpaper if it exists
    if [ -f "$HOME/.config/background" ]; then
        echo "🖼️  Restoring wallpaper..."
        swww img "$HOME/.config/background" --transition-type fade --transition-duration 1
    fi
fi

echo "✅ hyprpanel safely closed, swww-daemon preserved"
EOF
chmod +x "$HOME/.config/hyprcandy/hooks/kill_hyprpanel_safe.sh"

### 🔧 Create hyprpanel restart script for keybind compatibility
cat > "$HOME/.config/hyprcandy/hooks/restart_hyprpanel.sh" << 'EOF'
#!/bin/bash

# Script to properly restart hyprpanel via systemd
# This ensures clean shutdown and restart, compatible with your keybind

echo "🔄 Restarting hyprpanel via systemd..."

# Stop the service (this will kill hyprpanel cleanly)
systemctl --user stop hyprpanel.service

# Wait a moment for clean shutdown
sleep 0.5

# Start the service again
systemctl --user start hyprpanel.service

echo "✅ Hyprpanel restarted"
EOF
chmod +x "$HOME/.config/hyprcandy/hooks/restart_hyprpanel.sh"

### 🎛️ Create hyprpanel.service for faster startup
cat > "$HOME/.config/systemd/user/hyprpanel.service" << 'EOF'
[Unit]
Description=Hyprpanel - Modern Hyprland panel
After=graphical-session.target hyprland-session.target
Wants=graphical-session.target
PartOf=graphical-session.target
Requisite=graphical-session.target

[Service]
Type=simple
ExecStart=/usr/bin/hyprpanel
Restart=on-failure
RestartSec=1
Environment=DISPLAY=:0
KillMode=mixed
KillSignal=SIGTERM
TimeoutStopSec=5
# Don't restart if manually stopped (allows keybind control)
RestartPreventExitStatus=143

[Install]
WantedBy=graphical-session.target
EOF

### 🔄 Update existing reload section to include hyprpanel service
echo "🔄 Reloading and enabling all services (background-watcher, hyprpanel-idle-monitor, and hyprpanel)..."
systemctl --user daemon-reexec
systemctl --user daemon-reload
systemctl --user enable --now background-watcher.service &>/dev/null
systemctl --user enable --now hyprpanel-idle-monitor.service &>/dev/null
systemctl --user enable --now hyprpanel.service &>/dev/null
echo "✅ All set! All 3 services are running and monitoring for changes."

    # 🛠️ GNOME Window Button Layout Adjustment
    echo
    echo "🛠️ Disabling GNOME titlebar buttons..."

    # Check if 'gsettings' is available on the system
    if command -v gsettings >/dev/null 2>&1; then
        # Run the command to change the window button layout (e.g., remove minimize/maximize buttons)
        gsettings set org.gnome.desktop.wm.preferences button-layout ":close" \
            && echo "✅ GNOME button layout updated." \
            || echo "❌ Failed to update GNOME button layout."
    else
        echo "⚠️  'gsettings' not found. Skipping GNOME button layout configuration."
    fi
    
    # 📁 Copy HyprCandy folder to ~/Pictures
    echo
    echo "📁 Attempting to copy 'HyprCandy' images folder to ~/Pictures..."
    if [ -d "$hyprcandy_dir/HyprCandy" ]; then
        if [ -d "$HOME/Pictures" ]; then
            cp -r "$hyprcandy_dir/HyprCandy" "$HOME/Pictures/"
            echo "✅ 'HyprCandy' copied successfully to ~/Pictures"
        else
            echo "⚠️  Skipped copy: '$HOME/Pictures' directory does not exist."
        fi
    else
        echo "⚠️  'HyprCandy' folder not found in $hyprcandy_dir"
    fi

    # Change Start Button Icon
    # ⚙️ Step 1: Remove old grid.svg from nwg-dock-hyprland
    echo "🔄 Replacing 'grid.svg' in /usr/share/nwg-dock-hyprland/images..."

    if cd /usr/share/nwg-dock-hyprland/images 2>/dev/null; then
        sudo rm -f grid.svg && echo "🗑️  Removed old grid.svg"
    else
        echo "❌ Failed to access /usr/share/nwg-dock-hyprland/images"
        exit 1
    fi

    # 🏠 Step 2: Return to home
    cd "$HOME" || exit 1

    # 📂 Step 3: Copy new grid.svg from custom SVG folder
    SVG_SOURCE="$HOME/Pictures/HyprCandy/Dock-SVGs/grid.svg"
    SVG_DEST="/usr/share/nwg-dock-hyprland/images"

    if [ -f "$SVG_SOURCE" ]; then
        sudo cp "$SVG_SOURCE" "$SVG_DEST" && echo "✅ grid.svg copied successfully."
    else
        echo "❌ grid.svg not found at $SVG_SOURCE"
        exit 1
    fi

    # 🔐 Add sudoers entry for background script
    echo
    echo "🔐 Adding sudoers entry for background script..."
    
    # Get the current username
    USERNAME=$(whoami)
    
    # Create the sudoers entries for background script and required commands
    SUDOERS_ENTRIES=(
        "$USERNAME ALL=(ALL) NOPASSWD: $HOME/.config/hyprcandy/hooks/update_background.sh"
        "$USERNAME ALL=(ALL) NOPASSWD: /usr/bin/magick * /usr/share/sddm/themes/sugar-candy/Backgrounds/Mountain.jpg"
        "$USERNAME ALL=(ALL) NOPASSWD: /usr/bin/cp * /usr/share/sddm/themes/sugar-candy/Backgrounds/Mountain.jpg"
    )
    
    # Add all entries to sudoers safely using visudo
    printf '%s\n' "${SUDOERS_ENTRIES[@]}" | sudo EDITOR='tee -a' visudo -f /etc/sudoers.d/hyprcandy-background
    
    # Set proper permissions on the sudoers file
    sudo chmod 440 /etc/sudoers.d/hyprcandy-background
    
    echo "✅ Sudoers entry added: $SUDOERS_ENTRY"
    
    # 🎨 Update wlogout style.css with correct username
    echo
    echo "🎨 Updating wlogout style.css with current username..."
    
    WLOGOUT_STYLE="$HOME/.config/wlogout/style.css"
    
    if [ -f "$WLOGOUT_STYLE" ]; then
        # Replace $USERNAME with actual username in the background image path
        sed -i "s|\$USERNAME|$USERNAME|g" "$WLOGOUT_STYLE"
        echo "✅ Updated wlogout style.css with username: $USERNAME"
    else
        echo "⚠️  wlogout style.css not found at $WLOGOUT_STYLE"
    fi
}

# Function to enable display manager and prompt for reboot
enable_display_manager() {
    print_status "Enabling $DISPLAY_MANAGER display manager..."
    
    # Disable other display managers first
    print_status "Disabling other display managers..."
    sudo systemctl disable lightdm 2>/dev/null || true
    sudo systemctl disable lxdm 2>/dev/null || true
    if [ "$DISPLAY_MANAGER" != "sddm" ]; then
        sudo systemctl disable sddm 2>/dev/null || true
    fi
    if [ "$DISPLAY_MANAGER" != "gdm" ]; then
        sudo systemctl disable gdm 2>/dev/null || true
    fi
    
    # Enable the selected display manager
    if sudo systemctl enable "$DISPLAY_MANAGER_SERVICE"; then
        print_success "$DISPLAY_MANAGER has been enabled successfully!"
    else
        print_error "Failed to enable $DISPLAY_MANAGER. You may need to enable it manually."
        print_status "Run: sudo systemctl enable $DISPLAY_MANAGER_SERVICE"
    fi
    
    # Additional SDDM configuration if selected
    if [ "$DISPLAY_MANAGER" = "sddm" ]; then
        print_status "Configuring SDDM with Sugar Candy theme..."
        
        # Create SDDM config directory if it doesn't exist
        sudo mkdir -p /etc/sddm.conf.d/
        
        # Configure SDDM to use Sugar Candy theme
        if [ -d "/usr/share/sddm/themes/sugar-candy" ]; then
            sudo tee /etc/sddm.conf.d/sugar-candy.conf > /dev/null << EOF
[Theme]
Current=sugar-candy

[General]
Background=$HOME/.config/background.png
EOF
            
            print_success "SDDM configured to use Sugar Candy theme with custom auto-updating background"
        else
            print_warning "Sugar Candy theme not found. SDDM will use default theme."
        fi
    fi
}

# Function to setup default "custom.conf" file
setup_custom_config() {
# Create the custom settings directory and files if it doesn't already exist
        if [ ! -d "$HOME/.config/hyprcustom" ]; then
            mkdir -p "$HOME/.config/hyprcustom" && touch "$HOME/.config/hyprcustom/custom.conf" && touch "$HOME/.config/hyprcustom/custom_lock.conf"
            echo "📁 Created the custom settings directory with 'custom.conf' and 'custom_lock.conf' files to keep your personal Hyprland and Hyprlock changes safe ..."
            
            # Add default content to the custom.conf file
            cat > "$HOME/.config/hyprcustom/custom.conf" << 'EOF'
# ██╗  ██╗██╗   ██╗██████╗ ██████╗  ██████╗ █████╗ ███╗   ██╗██████╗ ██╗   ██╗
# ██║  ██║╚██╗ ██╔╝██╔══██╗██╔══██╗██╔════╝██╔══██╗████╗  ██║██╔══██╗╚██╗ ██╔╝
# ███████║ ╚████╔╝ ██████╔╝██████╔╝██║     ███████║██╔██╗ ██║██║  ██║ ╚████╔╝ 
# ██╔══██║  ╚██╔╝  ██╔═══╝ ██╔══██╗██║     ██╔══██║██║╚██╗██║██║  ██║  ╚██╔╝  
# ██║  ██║   ██║   ██║     ██║  ██║╚██████╗██║  ██║██║ ╚████║██████╔╝   ██║   
# ╚═╝  ╚═╝   ╚═╝   ╚═╝     ╚═╝  ╚═╝ ╚═════╝╚═╝  ╚═╝╚═╝  ╚═══╝╚═════╝    ╚═╝   

#[IMPORTANT]#
# Your custom settings mad in this file are safe from resets after rerunning the script.
# To reset, delete the 'hyprcustom' folder (not just the 'custom.conf' file) before rerunning the script to regenerate the default setup.
#[IMPORTANT]#

# ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
# ┃                           Autostart                         ┃
# ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

exec-once = bash -c "mkfifo /tmp/$HYPRLAND_INSTANCE_SIGNATURE.wob && tail -f /tmp/$HYPRLAND_INSTANCE_SIGNATURE.wob | wob & disown" &
exec-once = dbus-update-activation-environment --systemd DBUS_SESSION_BUS_ADDRESS DISPLAY XAUTHORITY &
exec-once = hash dbus-update-activation-environment 2>/dev/null &
exec-once = systemctl --user import-environment &
# Panel
exec-once = systemctl --user start hyprpanel &
# Start Polkit
exec-once = systemctl --user start hyprpolkitagent &
# Using hypridle to start hyprlock
exec-once = hypridle &
# Dock
exec-once = ~/.config/nwg-dock-hyprland/launch.sh &
# Pyprland
exec-once = /usr/bin/pypr &
# Launch updater
exec-once = /usr/bin/octopi-notifier &
# Systrat-networkmanager
exec-once = nm-applet &
# Load cliphist history
exec-once = wl-paste --watch cliphist store
# Restart xdg
exec-once = ~/.config/hpr/scripts/xdg.sh
# Restore wallaper
#exec-once = ~/.config/hpr/scripts/wallpaper-restore.sh

# ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
# ┃                           Animations                        ┃
# ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

source = ~/.config/hypr/conf/animations/silent.conf

# ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
# ┃                        Hypraland-colors                     ┃
# ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

source = ~/.config/hypr/colors.conf

# ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
# ┃                         Env-variables                       ┃
# ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

# After using nwg-look, also change the cursor settings here to maintain changes after every reboot
env = XCURSOR_THEME,Bibata-Modern-Classic
env = XCURSOR_SIZE,18
env = HYPRCURSOR_THEME,Bibata-Modern-Classic
env = HYPRCURSOR_SIZE,18

# XDG Desktop Portal
env = XDG_CURRENT_DESKTOP,Hyprland
env = XDG_SESSION_TYPE,wayland
env = XDG_SESSION_DESKTOP,Hyprland
# GTK
env = GTK_USE_PORTAL,1
# QT
env = QT_QPA_PLATFORM,wayland;xcb
env = QT_QPA_PLATFORMTHEME,gtk3
env = QT_WAYLAND_DISABLE_WINDOWDECORATION,0
env = QT_AUTO_SCREEN_SCALE_FACTOR,1
# GDK
env = GDK_DEBUG,portals
env = GDK_SCALE,1
# Toolkit Backend
env = GDK_BACKEND,wayland,x11,*
env = CLUTTER_BACKEND,wayland
# Mozilla
env = MOZ_ENABLE_WAYLAND,1
# Ozone
env = OZONE_PLATFORM,wayland
env = ELECTRON_OZONE_PLATFORM_HINT,wayland
# Extra
env = GTK_THEME,adw-gtk3-dark
env = WLR_DRM_NO_ATOMIC,1

# ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
# ┃                           Keyboard                          ┃
# ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

input {
    kb_layout = $LAYOUT
    kb_variant = 
    kb_model =
    kb_options =
    numlock_by_default = true
    mouse_refocus = false

    follow_mouse = 1
    touchpad {
        # for desktop
        natural_scroll = false

        # for laptop
        # natural_scroll = yes
        # middle_button_emulation = true
        # clickfinger_behavior = false
        scroll_factor = 1.0  # Touchpad scroll factor
    }
    sensitivity = 0 # Pointer speed: -1.0 - 1.0, 0 means no modification.
}

# ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
# ┃                             Layout                          ┃
# ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

general {
    gaps_in = 4
    gaps_out = 6	
    gaps_workspaces = 50    # Gaps between workspaces
    border_size = 2
    col.active_border = $primary $source_color $source_color $primary 90deg
    col.inactive_border = $background
    layout = dwindle
    resize_on_border = true
    allow_tearing = true
}

group:groupbar:col.active = $primary
group:groupbar:col.inactive = $source_color

dwindle {
    pseudotile = true
    preserve_split = true
}

master {
    new_status = slave
    new_on_active = after
    smart_resizing = true
    drop_at_cursor = true
}

gestures {
  workspace_swipe = true
  workspace_swipe_fingers = 3
  workspace_swipe_distance = 500
  workspace_swipe_invert = true
  workspace_swipe_min_speed_to_force = 30
  workspace_swipe_cancel_ratio = 0.5
  workspace_swipe_create_new = true
  workspace_swipe_forever = true
}

binds {
  workspace_back_and_forth = true
  allow_workspace_cycles = true
  pass_mouse_when_bound = false
}

# ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
# ┃                          Decorations                        ┃
# ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

decoration {
    rounding = 10
    rounding_power = 2
    active_opacity = 0.85
    inactive_opacity = 0.85
    fullscreen_opacity = 1.0

    blur {
    enabled = true
    size = 2
    passes = 4
    new_optimizations = on
    ignore_opacity = true
    xray = false
    vibrancy = 0.1696
    noise = 0.01
    popups = true
    popups_ignorealpha = 0.8
    }

    shadow {
        enabled = true
        range = 6
        render_power = 4
        color = $source_color
    }
}

# ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
# ┃                      Window & layer rules                   ┃
# ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

windowrule = suppressevent maximize, class:.* #nofocus,class:^$,title:^$,xwayland:1,floating:1,fullscreen:0,pinned:0
# Pavucontrol floating
windowrule = float,class:(.*org.pulseaudio.pavucontrol.*)
windowrule = size 700 600,class:(.*org.pulseaudio.pavucontrol.*)
windowrule = center,class:(.*org.pulseaudio.pavucontrol.*)
windowrule = pin,class:(.*org.pulseaudio.pavucontrol.*)
# Browser Picture in Picture
windowrule = float, title:^(Picture-in-Picture)$
windowrule = pin, title:^(Picture-in-Picture)$
windowrule = move 69.5% 4%, title:^(Picture-in-Picture)$
# Waypaper
windowrule = float,class:(.*waypaper.*)
windowrule = size 900 700,class:(.*waypaper.*)
windowrule = center,class:(.*waypaper.*)
windowrule = pin,class:(.*waypaper.*)w
# Blueman Manager
windowrule = float,class:(blueman-manager)
windowrule = size 800 600,class:(blueman-manager)
windowrule = center,class:(blueman-manager)
# nwg-look
windowrule = float,class:(nwg-look)
windowrule = size 700 600,class:(nwg-look)
windowrule = move 25% 10%-,class:(nwg-look)
windowrule = pin,class:(nwg-look)
# nwg-displays
windowrule = float,class:(nwg-displays)
windowrule = size 900 600,class:(nwg-displays)
windowrule = move 15% 10%-,class:(nwg-displays)
windowrule = pin,class:(nwg-displays)
# System Mission Center
windowrule = float, class:(io.missioncenter.MissionCenter)
windowrule = pin, class:(io.missioncenter.MissionCenter)
windowrule = center, class:(io.missioncenter.MissionCenter)
windowrule = size 900 600, class:(io.missioncenter.MissionCenter)
# System Mission Center Preference Window
windowrule = float, class:(missioncenter), title:^(Preferences)$
windowrule = pin, class:(missioncenter), title:^(Preferences)$
windowrule = center, class:(missioncenter), title:^(Preferences)$
# Gnome Calculator
windowrule = float,class:(org.gnome.Calculator)
windowrule = size 700 600,class:(org.gnome.Calculator)
windowrule = center,class:(org.gnome.Calculator)
# Emoji Picker Smile
windowrule = float,class:(it.mijorus.smile)
windowrule = pin, class:(it.mijorus.smile)
windowrule = move 100%-w-40 90,class:(it.mijorus.smile)
# Hyprland Share Picker
windowrule = float, class:(hyprland-share-picker)
windowrule = pin, class:(hyprland-share-picker)
windowrule = center, title:class:(hyprland-share-picker)
windowrule = size 600 400,class:(hyprland-share-picker)
# General floating
windowrule = float,class:(dotfiles-floating)
windowrule = size 1000 700,class:(dotfiles-floating)
windowrule = center,class:(dotfiles-floating)
# Float Necessary Windows
windowrule = float, class:^(org.pulseaudio.pavucontrol)
windowrule = float, class:^()$,title:^(Picture in picture)$
windowrule = float, class:^()$,title:^(Save File)$
windowrule = float, class:^()$,title:^(Open File)$
windowrule = float, class:^(LibreWolf)$,title:^(Picture-in-Picture)$
##windowrule = float, class:^(blueman-manager)$
windowrule = float, class:^(xdg-desktop-portal-hyprland|xdg-desktop-portal-gtk|xdg-desktop-portal-kde)(.*)$
windowrule = float, class:^(hyprpolkitagent|polkit-gnome-authentication-agent-1|org.org.kde.polkit-kde-authentication-agent-1)(.*)$
windowrule = float, class:^(CachyOSHello)$
windowrule = float, class:^(zenity)$
windowrule = float, class:^()$,title:^(Steam - Self Updater)$
# Increase the opacity
windowrule = opacity 1.0, class:^(zen)$
# # windowrule = opacity 1.0, class:^(discord|armcord|webcord)$
# # windowrule = opacity 1.0, title:^(QQ|Telegram)$
# # windowrule = opacity 1.0, title:^(NetEase Cloud Music Gtk4)$
# General window rules
windowrule = float, title:^(Picture-in-Picture)$
windowrule = size 460 260, title:^(Picture-in-Picture)$
windowrule = move 65%- 10%-, title:^(Picture-in-Picture)$
windowrule = float, title:^(imv|mpv|danmufloat|termfloat|nemo|ncmpcpp)$
windowrule = move 25%-, title:^(imv|mpv|danmufloat|termfloat|nemo|ncmpcpp)$
windowrule = size 960 540, title:^(imv|mpv|danmufloat|termfloat|nemo|ncmpcpp)$
windowrule = pin, title:^(danmufloat)$
windowrule = rounding 5, title:^(danmufloat|termfloat)$
windowrule = animation slide right, class:^(kitty|Alacritty)$
windowrule = noblur, class:^(org.mozilla.firefox)$
# Decorations related to floating windows on workspaces 1 to 10
##windowrule = bordersize 2, floating:1, onworkspace:w[fv1-10]
windowrule = bordercolor $primary, floating:1, onworkspace:w[fv1-10]
##windowrule = rounding 8, floating:1, onworkspace:w[fv1-10]
# Decorations related to tiling windows on workspaces 1 to 10
##windowrule = bordersize 3, floating:0, onworkspace:f[1-10]
##windowrule = rounding 4, floating:0, onworkspace:f[1-10]
windowrule = tile, title:^(Microsoft-edge)$
windowrule = tile, title:^(Brave-browser)$
windowrule = tile, title:^(Chromium)$
windowrule = float, title:^(pavucontrol)$
windowrule = float, title:^(blueman-manager)$
windowrule = float, title:^(nm-connection-editor)$
windowrule = float, title:^(qalculate-gtk)$
# idleinhibit
windowrule = idleinhibit fullscreen,class:([window]) # Available modes: none, always, focus, fullscreen
### no blur for specific classes
##windowrulev2 = noblur,class:^(?!(nautilus|nwg-look|nwg-displays|zen))
## Windows Rules End #

windowrulev2 = opacity 1.0 $& 1.0 $& 1,class:^(nautilus)$
windowrulev2 = opacity 1.0 $& 1.0 $& 1,class:^(zen)$
# # windowrulev2 = opacity 1.0 $& 1.0 $& 1,class:^(Brave-browser)$
windowrulev2 = opacity 1.0 $& 1.0 $& 1,class:^(code-oss)$
windowrulev2 = opacity 1.0 $& 1.0 $& 1,class:^([Cc]ode)$
# # windowrulev2 = opacity 1.0 $& 1.0 $& 1,class:^(code-url-handler)$
# # windowrulev2 = opacity 1.0 $& 1.0 $& 1,class:^(code-insiders-url-handler)$
windowrulev2 = opacity 1.0 $& 1.0 $& 1,class:^(kitty)$
# # windowrulev2 = opacity 1.0 $& 1.0 $& 1,class:^(org.kde.dolphin)$
# # windowrulev2 = opacity 1.0 $& 1.0 $& 1,class:^(org.kde.ark)$
windowrulev2 = opacity 1.0 $& 1.0 $& 1,class:^(nwg-look)$
windowrulev2 = opacity 1.0 $& 1.0 $& 1,class:^(qt5ct)$
windowrulev2 = opacity 1.0 $& 1.0 $& 1,class:^(qt6ct)$
windowrulev2 = opacity 1.0 $& 1.0 $& 1,class:^(kvantummanager)$
# # windowrulev2 = opacity 1.0 $& 1.0 $& 1,class:^(org.pulseaudio.pavucontrol)$
# # windowrulev2 = opacity 1.0 $& 1.0 $& 1,class:^(blueman-manager)$
# # windowrulev2 = opacity 1.0 $& 1.0 $& 1,class:^(nm-applet)$
# # windowrulev2 = opacity 1.0 $& 1.0 $& 1,class:^(nm-connection-editor)$
# # windowrulev2 = opacity 1.0 $& 1.0 $& 1,class:^(org.kde.polkit-kde-authentication-agent-1)$
# # windowrulev2 = opacity 1.0 $& 1.0 $& 1,class:^(polkit-gnome-authentication-agent-1)$
# # windowrulev2 = opacity 1.0 $& 1.0 $& 1,class:^(org.freedesktop.impl.portal.desktop.gtk)$
# # windowrulev2 = opacity 1.0 $& 1.0 $& 1,class:^(org.freedesktop.impl.portal.desktop.hyprland)$
# # windowrulev2 = opacity 1.0 $& 1.0 $& 1,class:^([Ss]team)$
# # windowrulev2 = opacity 1.0 $& 1.0 $& 1,class:^(steamwebhelper)$
windowrulev2 = opacity 1.0 $& 1.0 $& 1,class:^([Ss]potify)$
windowrulev2 = opacity 1.0 $& 1.0 $& 1,initialTitle:^(Spotify Free)$
windowrulev2 = opacity 1.0 $& 1.0 $& 1,initialTitle:^(Spotify Premium)$
# # 
# # windowrulev2 = opacity 1.0 1.0,class:^(com.github.rafostar.Clapper)$ # Clapper-Gtk
# # windowrulev2 = opacity 1.0 1.0,class:^(com.github.tchx84.Flatseal)$ # Flatseal-Gtk
# # windowrulev2 = opacity 1.0 1.0,class:^(hu.kramo.Cartridges)$ # Cartridges-Gtk
# # windowrulev2 = opacity 1.0 1.0,class:^(com.obsproject.Studio)$ # Obs-Qt
# # windowrulev2 = opacity 1.0 1.0,class:^(gnome-boxes)$ # Boxes-Gtk
# # windowrulev2 = opacity 1.0 1.0,class:^(vesktop)$ # Vesktop
# # windowrulev2 = opacity 1.0 1.0,class:^(discord)$ # Discord-Electron
# # windowrulev2 = opacity 1.0 1.0,class:^(WebCord)$ # WebCord-Electron
# # windowrulev2 = opacity 1.0 1.0,class:^(ArmCord)$ # ArmCord-Electron
# # windowrulev2 = opacity 1.0 1.0,class:^(app.drey.Warp)$ # Warp-Gtk
# # windowrulev2 = opacity 1.0 1.0,class:^(net.davidotek.pupgui2)$ # ProtonUp-Qt
# # windowrulev2 = opacity 1.0 1.0,class:^(yad)$ # Protontricks-Gtk
# # windowrulev2 = opacity 1.0 1.0,class:^(Signal)$ # Signal-Gtk
# # windowrulev2 = opacity 1.0 1.0,class:^(io.github.alainm23.planify)$ # planify-Gtk
# # windowrulev2 = opacity 1.0 1.0,class:^(io.gitlab.theevilskeleton.Upscaler)$ # Upscaler-Gtk
# # windowrulev2 = opacity 1.0 1.0,class:^(com.github.unrud.VideoDownloader)$ # VideoDownloader-Gtk
# # windowrulev2 = opacity 1.0 1.0,class:^(io.gitlab.adhami3310.Impression)$ # Impression-Gtk
# # windowrulev2 = opacity 1.0 1.0,class:^(io.missioncenter.MissionCenter)$ # MissionCenter-Gtk
# # windowrulev2 = opacity 1.0 1.0,class:^(io.github.flattool.Warehouse)$ # Warehouse-Gtk
windowrulev2 = float,class:^(org.kde.dolphin)$,title:^(Progress Dialog — Dolphin)$
windowrulev2 = float,class:^(org.kde.dolphin)$,title:^(Copying — Dolphin)$
windowrulev2 = float,title:^(About Mozilla Firefox)$
windowrulev2 = float,class:^(firefox)$,title:^(Picture-in-Picture)$
windowrulev2 = float,class:^(firefox)$,title:^(Library)$
windowrulev2 = float,class:^(kitty)$,title:^(top)$
windowrulev2 = float,class:^(kitty)$,title:^(btop)$
windowrulev2 = float,class:^(kitty)$,title:^(htop)$
windowrulev2 = float,class:^(vlc)$
windowrulev2 = float,class:^(kvantummanager)$
windowrulev2 = float,class:^(qt5ct)$
windowrulev2 = float,class:^(qt6ct)$
windowrulev2 = float,class:^(nwg-look)$
windowrulev2 = float,class:^(org.kde.ark)$
windowrulev2 = float,class:^(org.pulseaudio.pavucontrol)$
windowrulev2 = float,class:^(blueman-manager)$
windowrulev2 = float,class:^(nm-applet)$
windowrulev2 = float,class:^(nm-connection-editor)$
windowrulev2 = float,class:^(org.kde.polkit-kde-authentication-agent-1)$

windowrulev2 = float,class:^(Signal)$ # Signal-Gtk
windowrulev2 = float,class:^(com.github.rafostar.Clapper)$ # Clapper-Gtk
windowrulev2 = float,class:^(app.drey.Warp)$ # Warp-Gtk
windowrulev2 = float,class:^(net.davidotek.pupgui2)$ # ProtonUp-Qt
windowrulev2 = float,class:^(yad)$ # Protontricks-Gtk
windowrulev2 = float,class:^(eog)$ # Imageviewer-Gtk
windowrulev2 = float,class:^(io.github.alainm23.planify)$ # planify-Gtk
windowrulev2 = float,class:^(io.gitlab.theevilskeleton.Upscaler)$ # Upscaler-Gtk
windowrulev2 = float,class:^(com.github.unrud.VideoDownloader)$ # VideoDownloader-Gkk
windowrulev2 = float,class:^(io.gitlab.adhami3310.Impression)$ # Impression-Gtk
windowrulev2 = float,class:^(io.missioncenter.MissionCenter)$ # MissionCenter-Gtk
windowrulev2 = float,class:(clipse) # ensure you have a floating window class set if you want this behavior
windowrulev2 = size 622 652,class:(clipse) # set the size of the window as necessary
#windowrulev2 = noborder, fullscreen:1

# common modals
windowrule = float,initialtitle:^(Open File)$
windowrule = float,initialTitle:^(Open File)$
windowrule = float,title:^(Choose Files)$
windowrule = float,title:^(Save As)$
windowrule = float,title:^(Confirm to replace files)$
windowrule = float,title:^(File Operation Progress)$
windowrulev2 = float,class:^(xdg-desktop-portal-gtk)$

# Workspaces Rules https://wiki.hyprland.org/0.45.0/Configuring/Workspace-Rules/ #
# workspace = 1, default:true, monitor:$priMon
# workspace = 6, default:true, monitor:$secMon
# Workspace selectors https://wiki.hyprland.org/0.45.0/Configuring/Workspace-Rules/#workspace-selectors
# workspace = r[1-5], monitor:$priMon
# workspace = r[6-10], monitor:$secMon
# workspace = special:scratchpad, on-created-empty:$applauncher
# no_gaps_when_only deprecated instead workspaces rules with selectors can do the same
# Smart gaps from 0.45.0 https://wiki.hyprland.org/0.45.0/Configuring/Workspace-Rules/#smart-gaps
#workspace = w[t1], gapsout:0, gapsin:0
#workspace = w[tg1], gapsout:0, gapsin:0
workspace = f[1], gapsout:0, gapsin:0
#windowrulev2 = bordersize 2, floating:0, onworkspace:w[t1]
#windowrulev2 = rounding 10, floating:0, onworkspace:w[t1]
#windowrulev2 = bordersize 2, floating:0, onworkspace:w[tg1]
#windowrulev2 = rounding 10, floating:0, onworkspace:w[tg1]
#windowrulev2 = bordersize 2, floating:0, onworkspace:f[1]
#windowrulev2 = rounding 10, floating:0, onworkspace:f[1]
#windowrulev2 = rounding 0, fullscreen:1
windowrulev2 = noborder, fullscreen:1
#workspace = w[tv1-10], gapsout:6, gapsin:2
#workspace = f[1], gapsout:6, gapsin:2

workspace = 1, layoutopt:orientation:left
workspace = 2, layoutopt:orientation:right
workspace = 3, layoutopt:orientation:left
workspace = 4, layoutopt:orientation:right
workspace = 5, layoutopt:orientation:left
workspace = 6, layoutopt:orientation:right
workspace = 7, layoutopt:orientation:left
workspace = 8, layoutopt:orientation:right
workspace = 9, layoutopt:orientation:left
workspace = 10, layoutopt:orientation:right
# Workspaces Rules End #

# Layers Rules #
layerrule = animation slide top, logout_dialog
layerrule = blur,rofi
layerrule = ignorezero,rofi
layerrule = blur,notifications
layerrule = ignorezero,notifications
#layerrule = blur,swaync-notification-window
#layerrule = ignorezero,swaync-notification-window
#layerrule = blur,swaync-control-center
#layerrule = ignorezero,swaync-control-center
layerrule = blur,logout_dialog
layerrule = blur,nwg-dock
layerrule = ignorezero,nwg-dock
layerrule = blur,gtk-layer-shell
layerrule = ignorezero,gtk-layer-shell
layerrule = blur,bar-0
layerrule = ignorezero,bar-0
layerrule = blur,dashboardmenu
layerrule = ignorezero,dashboardmenu
layerrule = blur,calendarmenu
layerrule = ignorezero,calendarmenu
layerrule = blur,notificationsmenu
layerrule = ignorezero,notificationsmenu
layerrule = blur,networkmenu
layerrule = ignorezero,networkmenu
layerrule = blur,mediamenu
layerrule = ignorezero,mediamenu
layerrule = blur,energymenu
layerrule = ignorezero,energymenu
layerrule = blur,bluetoothmenu
layerrule = ignorezero,bluetoothmenu
layerrule = blur,audiomenu
layerrule = ignorezero,audiomenu
layerrule = blur,hyprmenu
layerrule = ignorezero,hyprmenu
# layerrule = animation popin 50%, waybar
# Layers Rules End #

# ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
# ┃                         Misc-settings                       ┃
# ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

misc {
    disable_hyprland_logo = true
    disable_splash_rendering = false
    initial_workspace_tracking = 1
}
EOF

            # Add default content to the custom_lock.conf file
            cat > "$HOME/.config/hyprcustom/custom_lock.conf" << 'EOF'
# ██╗  ██╗██╗   ██╗██████╗ ██████╗ ██╗      ██████╗  ██████╗██╗  ██╗
# ██║  ██║╚██╗ ██╔╝██╔══██╗██╔══██╗██║     ██╔═══██╗██╔════╝██║ ██╔╝
# ███████║ ╚████╔╝ ██████╔╝██████╔╝██║     ██║   ██║██║     █████╔╝ 
# ██╔══██║  ╚██╔╝  ██╔═══╝ ██╔══██╗██║     ██║   ██║██║     ██╔═██╗ 
# ██║  ██║   ██║   ██║     ██║  ██║███████╗╚██████╔╝╚██████╗██║  ██╗
# ╚═╝  ╚═╝   ╚═╝   ╚═╝     ╚═╝  ╚═╝╚══════╝ ╚═════╝  ╚═════╝╚═╝  ╚═╝

source = ~/.config/hypr/colors.conf

general {
    ignore_empty_input = true
    hide_cursor = true
}

background {
    monitor =
    path = ~/.config/background.png
    blur_passes = 3
    blur_sizes = 1
    vibrancy = 0.1696s
    noise = 0.01
    contrast = 0.8916
}

input-field {
    monitor =
    size = 200, 50
    outline_thickness = 3
    dots_size = 0.33 # Scale of input-field height, 0.2 - 0.8
    dots_spacing = 0.15 # Scale of dots' absolute size, 0.0 - 1.0
    dots_center = true
    dots_rounding = -1 # -1 default circle, -2 follow input-field rounding
    outer_color = $source_color
    inner_color = $background
    font_color = $source_color
    fade_on_empty = false
    fade_timeout = 1000 # Milliseconds before fade_on_empty is triggered.
    placeholder_text = <i><span> Password</span></i># Text rendered in the input box when it's empty. # foreground="$source_color" ##ffffff99
    hide_input = false
    rounding = 40 # -1 means complete rounding (circle/oval)
    check_color = $primary
    fail_color = $error # if authentication failed, changes outer_color and fail message color
    fail_text = <i>$FAIL <b>($ATTEMPTS)</b></i> # can be set to empty
    fail_transition = 300 # transition time in ms between normal outer_color and fail_color
    capslock_color = -1
    numlock_color = -1
    bothlock_color = -1 # when both locks are active. -1 means don't change outer color (same for above)
    invert_numlock = false # change color if numlock is off
    swap_font_color = false # see below
    position = 0, -80
    halign = center
    valign = center
    shadow_passes = 10
    shadow_size = 20
    shadow_color = $shadow
    shadow_boost = 1.6
}

label {
    monitor =
    #clock
    text = cmd[update:1000] echo "$TIME"
    color = $secondary
    font_size = 55
    font_family = Fira Semibold
    position = 0, 70
    halign = center
    valign = bottom
    shadow_passes = 5
    shadow_size = 10
}

label {
    monitor =
    text = ✝    👑    ✝ #  $USER
    color = $secondary
    font_size = 20
    font_family = Fira Semibold
    position = 0, 360
    halign = center
    valign = bottom
    shadow_passes = 5
    shadow_size = 10
}

image {
    monitor =
    path = .face.icon
    size = 160 # lesser side if not 1:1 ratio
    rounding = 75 # negative values mean circle
    border_size = 4
    border_color = $source_color
    rotate = 0 # degrees, counter-clockwise
    reload_time = -1 # seconds between reloading, 0 to reload with SIGUSR2
#    reload_cmd =  # command to get new path. if empty, old path will be used. don't run "follow" commands like tail -F
    position = 0, -100
    halign = center
    valign = top
    shadow_passes = 10
    shadow_size = 20
    shadow_color = $shadow
    shadow_boost = 1.6
}
EOF

            # Add default content to the custom_keybinds.conf file
            cat > "$HOME/.config/hyprcustom/custom_keybinds.conf" << 'EOF'
# ██╗  ██╗███████╗██╗   ██╗██████╗ ██╗███╗   ██╗██████╗ ███████╗
# ██║ ██╔╝██╔════╝╚██╗ ██╔╝██╔══██╗██║████╗  ██║██╔══██╗██╔════╝
# █████╔╝ █████╗   ╚████╔╝ ██████╔╝██║██╔██╗ ██║██║  ██║███████╗
# ██╔═██╗ ██╔══╝    ╚██╔╝  ██╔══██╗██║██║╚██╗██║██║  ██║╚════██║
# ██║  ██╗███████╗   ██║   ██████╔╝██║██║ ╚████║██████╔╝███████║
# ╚═╝  ╚═╝╚══════╝   ╚═╝   ╚═════╝ ╚═╝╚═╝  ╚═══╝╚═════╝ ╚══════╝

#### $ ####
$mainMod = SUPER
$HYPRSCRIPTS = ~/.config/hypr/scripts
$SCRIPTS = ~/.config/hyprcandy/scripts
$EDITOR = gedit # Change from the default editor to your prefered editor
#$DISCORD = equibop
#### $ ####

#### Kill active window ####

bind = $mainMod, Escape, killactive #Kill single active window
bind = $mainMod SHIFT, Escape, exec, hyprctl activewindow | grep pid | tr -d 'pid:' | xargs kill #Quit active window and all similar open instances

#### Gaps OUT controls (outer gaps - screen edges) ####
bind = $mainMod ALT, equal, exec, ~/.config/hyprcandy/hooks/hyprland_gaps_out_increase.sh  # $mainMod+Alt+= (Gap increase)
bind = $mainMod ALT, minus, exec, ~/.config/hyprcandy/hooks/hyprland_gaps_out_decrease.sh  # $mainMod+Alt+- (Gap decrease)

#### Gaps IN controls (inner gaps - between windows) ####
bind = ALT, equal, exec, ~/.config/hyprcandy/hooks/hyprland_gaps_in_increase.sh            # Alt+= (Gap increase)
bind = ALT, minus, exec, ~/.config/hyprcandy/hooks/hyprland_gaps_in_decrease.sh            # Alt+- (Gap decrease)

#### Border controls #### 

bind = $mainMod SHIFT, equal, exec, ~/.config/hyprcandy/hooks/hyprland_border_increase.sh  # $mainMod+Shift+= (Border increase)
bind = $mainMod SHIFT, minus, exec, ~/.config/hyprcandy/hooks/hyprland_border_decrease.sh  # $mainMod+Shift+- (Border decrease)

#### Rounding controls ####

bind = $mainMod CTRL, equal, exec, ~/.config/hyprcandy/hooks/hyprland_rounding_increase.sh # $mainMod+Ctrl+= (Rounding increase)
bind = $mainMod CTRL, minus, exec, ~/.config/hyprcandy/hooks/hyprland_rounding_decrease.sh # $mainMod+Ctrl+- (Rounding decrease)

#### Rofi Menus ####

bind = $mainMod, A, exec, rofi -show drun || pkill rofi      #Launch or kill rofi application finder
bind = $mainMod CTRL, K, exec, $HYPRSCRIPTS/keybindings.sh     #Show keybindings
bind = $mainMod CTRL, V, exec, $SCRIPTS/cliphist.sh     #Open clipboard manager
bind = $mainMod CTRL, E, exec, ~/.config/hyprcandy/settings/emojipicker.sh 		  #Open rofi emoji-picker
bind = $mainMod CTRL, G, exec, ~/.config/hyprcandy/settings/glyphpicker.sh 		  #Open rofi glyph-picker

#### Applications ####

#bind = $mainMod CTRL, S, exec, spotify
#bind = $mainMod, D, exec, $DISCORD
#bind = $mainMod, W, exec, warp-terminal
bind = $mainMod, C, exec, DRI_PRIME=1 $EDITOR #Editor
bind = $mainMod, B, exec, DRI_PRIME=1 xdg-open "http:// &" #Launch your default browser
bind = $mainMod, Q, exec, DRI_PRIME=1 pypr toggle term #Launch kitty in a pyprland scratchpad
bind = $mainMod, Return, exec, kitty #Launch normal kitty instances
bind = $mainMod, O, exec, DRI_PRIME=1 /usr/bin/octopi #Launch octopi application finder
bind = $mainMod, E, exec, DRI_PRIME=1 nautilus #pypr toggle filemanager #Launch the filemanager 
bind = $mainMod CTRL, C, exec, DRI_PRIME=1 gnome-calculator #Launch the calculator

#### Dock keybinds ####

bind = CTRL SHIFT, Z, exec, pkill -f nwg-dock-hyprland #kill dock
bind = CTRL SHIFT, J, exec, nwg-dock-hyprland -p left -lp start -i 28 -w 10 -ml 6 -mt 10 -mb 10 -x -r -s "style.css" -c "rofi -show drun" #Left dock
bind = CTRL SHIFT, I, exec, nwg-dock-hyprland -p top -lp start -i 28 -w 10 -mt 6 -ml 10 -mr 10 -x -r -s "style.css" -c "rofi -show drun" #Top dock
bind = CTRL SHIFT, K, exec, ~/.config/nwg-dock-hyprland/launch.sh #Bottom dock and quick-reload dock
bind = CTRL SHIFT, L, exec, nwg-dock-hyprland -p right -lp start -i 28 -w 10 -mr 6 -mt 10 -mb 10 -x -r -s "style.css" -c "rofi -show drun" #Right dock

#### Hyprpanel ####

bind = $mainMod, H, exec, DRI_PRIME=1 ~/.config/hyprcandy/hooks/restart_hyprpanel.sh #Restart or reload hyprpanel and stop automatic idle-inhibitor
bind = $mainMod Alt, H, exec, ~/.config/hyprcandy/hooks/kill_hyprpanel_safe.sh #Close panel and start automatic idle-inhibitor

#### Recorder ####

# Wf--recorder (simple recorder) + slurp (allows to select a specific region of the monitor)
# {to list audio devices run "pactl list sources | grep Name"}   
bind = $mainMod, R, exec, wf-recorder -g -a --audio=bluez_output.78_15_2D_0D_BD_B7.1.monitor $(slurp) # Start recording
bind = Alt, R, exec, pkill -x wf-recorder #Stop recording

#### Hyprsunset ####

bind = Shift, H, exec, hyprctl hyprsunset gamma +10 #Increase gamma by 10%
bind = Alt, H, exec, hyprctl hyprsunset gamma -10 #Reduce gamma by 10%


#### Actions ####

bind = $mainMod CTRL, R, exec, $HYPRSCRIPTS/loadconfig.sh                                 #Reload Hyprland configuration
bind = $mainMod SHIFT, A, exec, $HYPRSCRIPTS/toggle-animations.sh                         #Toggle animations
bind = $mainMod, PRINT, exec, $HYPRSCRIPTS/screenshot.sh                                  #Take a screenshot
bind = $mainMod CTRL, Q, exec, $SCRIPTS/wlogout.sh            				  #Start wlogout ~/.config/hyprcandy/scripts
bind = $mainMod, V, exec, cliphist wipe 						  #Clear cliphist database
bind = $mainMod CTRL, D, exec, $ cliphist list | dmenu | cliphist delete 		  #Delete an old item
bind = $mainMod ALT, D, exec, $ cliphist delete-query "secret item"  			  #Delete an old item quering manually
bind = $mainMod ALT, S, exec, $ cliphist list | dmenu | cliphist decode | wl-copy    	  #Select an old item
bind = $mainMod ALT, O, exec, $HYPRSCRIPTS/window-opacity.sh                              #Change opacity
bind = $mainMod, L, exec, ~/.config/hypr/scripts/power.sh lock 				  #Lock


#### Workspaces ####

bind = $mainMod, 1, workspace, 1  #Open workspace 1
bind = $mainMod, 2, workspace, 2  #Open workspace 2
bind = $mainMod, 3, workspace, 3  #Open workspace 3
bind = $mainMod, 4, workspace, 4  #Open workspace 4
bind = $mainMod, 5, workspace, 5  #Open workspace 5
bind = $mainMod, 6, workspace, 6  #Open workspace 6
bind = $mainMod, 7, workspace, 7  #Open workspace 7
bind = $mainMod, 8, workspace, 8  #Open workspace 8
bind = $mainMod, 9, workspace, 9  #Open workspace 9
bind = $mainMod, 0, workspace, 10 #Open workspace 10

bind = $mainMod SHIFT, 1, movetoworkspace, 1  #Move active window to workspace 1
bind = $mainMod SHIFT, 2, movetoworkspace, 2  #Move active window to workspace 2
bind = $mainMod SHIFT, 3, movetoworkspace, 3  #Move active window to workspace 3
bind = $mainMod SHIFT, 4, movetoworkspace, 4  #Move active window to workspace 4
bind = $mainMod SHIFT, 5, movetoworkspace, 5  #Move active window to workspace 5
bind = $mainMod SHIFT, 6, movetoworkspace, 6  #Move active window to workspace 6
bind = $mainMod SHIFT, 7, movetoworkspace, 7  #Move active window to workspace 7
bind = $mainMod SHIFT, 8, movetoworkspace, 8  #Move active window to workspace 8
bind = $mainMod SHIFT, 9, movetoworkspace, 9  #Move active window to workspace 9
bind = $mainMod SHIFT, 0, movetoworkspace, 10 #Move active window to workspace 10

bind = $mainMod, Tab, workspace, m+1       #Open next workspace
bind = $mainMod SHIFT, Tab, workspace, m-1 #Open previous workspace

bind = $mainMod CTRL, 1, exec, $HYPRSCRIPTS/moveTo.sh 1  #Move all windows to workspace 1
bind = $mainMod CTRL, 2, exec, $HYPRSCRIPTS/moveTo.sh 2  #Move all windows to workspace 2
bind = $mainMod CTRL, 3, exec, $HYPRSCRIPTS/moveTo.sh 3  #Move all windows to workspace 3
bind = $mainMod CTRL, 4, exec, $HYPRSCRIPTS/moveTo.sh 4  #Move all windows to workspace 4
bind = $mainMod CTRL, 5, exec, $HYPRSCRIPTS/moveTo.sh 5  #Move all windows to workspace 5
bind = $mainMod CTRL, 6, exec, $HYPRSCRIPTS/moveTo.sh 6  #Move all windows to workspace 6
bind = $mainMod CTRL, 7, exec, $HYPRSCRIPTS/moveTo.sh 7  #Move all windows to workspace 7
bind = $mainMod CTRL, 8, exec, $HYPRSCRIPTS/moveTo.sh 8  #Move all windows to workspace 8
bind = $mainMod CTRL, 9, exec, $HYPRSCRIPTS/moveTo.sh 9  #Move all windows to workspace 9
bind = $mainMod CTRL, 0, exec, $HYPRSCRIPTS/moveTo.sh 10  #Move all windows to workspace 10

bind = $mainMod, mouse_down, workspace, e+1  #Open next workspace
bind = $mainMod, mouse_up, workspace, e-1    #Open previous workspace
bind = $mainMod CTRL, down, workspace, empty #Open the next empty workspace

#### Minimize windows using special workspaces ####

bind = CTRL SHIFT, 1, togglespecialworkspace, magic #Togle window to and from special workspace
bind = CTRL SHIFT, 2, movetoworkspace, +0 #Move window to special workspace 2 (Can be toggled with "$mainMod,1")
bind = CTRL SHIFT, 3, togglespecialworkspace, magic #Togle window to and from special workspace
bind = CTRL SHIFT, 4, movetoworkspace, special:magic #Move window to special workspace 4 (Can be toggled with "$mainMod,1")
bind = CTRL SHIFT, 5, togglespecialworkspace, magic #Togle window to and from special workspace


#### Windows ####

bind = $mainMod ALT, 1, movetoworkspacesilent, 1  #Move active window to workspace 1 silently
bind = $mainMod ALT, 2, movetoworkspacesilent, 2  #Move active window to workspace 2 silently
bind = $mainMod ALT, 3, movetoworkspacesilent, 3  #Move active window to workspace 3 silently
bind = $mainMod ALT, 4, movetoworkspacesilent, 4  #Move active window to workspace 4 silently
bind = $mainMod ALT, 5, movetoworkspacesilent, 5  #Move active window to workspace 5 silently
bind = $mainMod ALT, 6, movetoworkspacesilent, 6  #Move active window to workspace 6 silently
bind = $mainMod ALT, 7, movetoworkspacesilent, 7  #Move active window to workspace 7 silently
bind = $mainMod ALT, 8, movetoworkspacesilent, 8  #Move active window to workspace 8 silently
bind = $mainMod ALT, 9, movetoworkspacesilent, 9  #Move active window to workspace 9 silently
bind = $mainMod ALT, 0, movetoworkspacesilent, 10  #Move active window to workspace 10 silently 

bindm = $mainMod, Z, movewindow #Hold to move selected window
bindm = $mainMod, X, resizewindow #Hold to resize selected window

bind = $mainMod, F, fullscreen, 0                                                           #Set active window to fullscreen
bind = $mainMod, M, fullscreen, 1                                                           #Maximize Window
bind = $mainMod CTRL, F, togglefloating                                                     #Toggle active windows into floating mode
bind = $mainMod CTRL, T, exec, $HYPRSCRIPTS/toggleallfloat.sh                               #Toggle all windows into floating mode
bind = $mainMod, J, togglesplit                                                             #Toggle split
bind = $mainMod, left, movefocus, l                                                         #Move focus left
bind = $mainMod, right, movefocus, r                                                        #Move focus right
bind = $mainMod, up, movefocus, u                                                           #Move focus up
bind = $mainMod, down, movefocus, d                                                         #Move focus down
bindm = $mainMod, mouse:272, movewindow                                                     #Move window with the mouse
bindm = $mainMod, mouse:273, resizewindow                                                   #Resize window with the mouse
bind = $mainMod SHIFT, right, resizeactive, 100 0                                           #Increase window width with keyboard
bind = $mainMod SHIFT, left, resizeactive, -100 0                                           #Reduce window width with keyboard
bind = $mainMod SHIFT, down, resizeactive, 0 100                                            #Increase window height with keyboard
bind = $mainMod SHIFT, up, resizeactive, 0 -100                                             #Reduce window height with keyboard
bind = $mainMod, G, togglegroup                                                             #Toggle window group
bind = $mainMod CTRL, left, changegroupactive, prev				  	    #Switch to the previous window in the group
bind = $mainMod CTRL, right, changegroupactive, next					    #Switch to the next window in the group
bind = $mainMod, K, swapsplit                                                               #Swapsplit
bind = $mainMod ALT, left, swapwindow, l                                                    #Swap tiled window left
bind = $mainMod ALT, right, swapwindow, r                                                   #Swap tiled window right
bind = $mainMod ALT, up, swapwindow, u                                                      #Swap tiled window up
bind = $mainMod ALT, down, swapwindow, d                                                    #Swap tiled window down
binde = ALT,Tab,cyclenext                                                                   #Cycle between windows
binde = ALT,Tab,bringactivetotop                                                            #Bring active window to the top
bind = ALT, S, layoutmsg, swapwithmaster master 					    #Switch current focused window to master
bind = $mainMod SHIFT, L, exec, hyprctl keyword general:layout "$(hyprctl getoption general:layout | grep -q 'dwindle' && echo 'master' || echo 'dwindle')" #Toggle between dwindle and master layout


#### Fn keys ####

bind = , XF86MonBrightnessUp, exec, brightnessctl -q s +10% #Increase brightness by 10%
bind = , XF86MonBrightnessDown, exec, brightnessctl -q s 10%- #Reduce brightness by 10%
bind = , XF86AudioRaiseVolume, exec, pactl set-sink-mute @DEFAULT_SINK@ 0 && pactl set-sink-volume @DEFAULT_SINK@ +5%   #Increase volume by 5%
bind = , XF86AudioLowerVolume, exec, pactl set-sink-mute @DEFAULT_SINK@ 0 && pactl set-sink-volume @DEFAULT_SINK@ -5%  #Reduce volume by 5%
bind = , XF86AudioMute, exec, pactl set-sink-mute @DEFAULT_SINK@ toggle #Toggle mute
bind = , XF86AudioPlay, exec, playerctl play-pause #Audio play pause
bind = , XF86AudioPause, exec, playerctl pause #Audio pause
bind = , XF86AudioNext, exec, playerctl next #Audio next
bind = , XF86AudioPrev, exec, playerctl previous #Audio previous
bind = , XF86AudioMicMute, exec, pactl set-source-mute @DEFAULT_SOURCE@ toggle #Toggle microphone
bind = , XF86Calculator, exec, ~/.config/hyprcandy/settings/calculator.sh  #Open calculator
bind = , XF86Lock, exec, hyprlock #Open screenlock

bind = , code:236, exec, brightnessctl -d smc::kbd_backlight s +10 #Increase kbd-brightness by 10%
bind = , code:237, exec, brightnessctl -d smc::kbd_backlight s 10- #Reduce kbd-brightness by 10%

bind = , F2, exec, brightnessctl -q s +10% #Increase brightness by 10%
bind = , F1, exec, brightnessctl -q s 10%- #Reduce brightness by 10%
bind = Shift, F9, exec, amixer sset Master toggle | sed -En '/\[on\]/ s/.*\[([0-9]+)%\].*/\1/ p; /\[off\]/ s/.*/0/p' | head -1 > /tmp/$HYPRLAND_INSTANCE_SIGNATURE.wob\	#Mutes player audio
bind = , F8, exec, pactl set-sink-mute @DEFAULT_SINK@ 0 && pactl set-sink-volume @DEFAULT_SINK@ +5% #Increase volume by 5%
bind = , F7, exec, pactl set-sink-mute @DEFAULT_SINK@ 0 && pactl set-sink-volume @DEFAULT_SINK@ -5% #Reduce volume by 5%
bind = , F4, exec, playerctl play-pause #Toggle play/pause
bind = , F6, exec, playerctl next #Play next video/song
bind = , F5, exec, playerctl previous #Play previous video/song
EOF
        fi
}

# Function to setup keyboard layout
setup_keyboard_layout() {
    # Keyboard layout selection
    echo
    print_status "Keyboard Layout Configuration"
    echo "Select your keyboard layout (this will be applied to Hyprland):"
    echo "1) us - United States (default)"
    echo "2) gb - United Kingdom"
    echo "3) de - Germany"
    echo "4) fr - France"
    echo "5) es - Spain"
    echo "6) it - Italy"
    echo "7) cn - China"
    echo "8) ru - Russia"
    echo "9) jp - Japan"
    echo "10) kr - South Korea"
    echo "11) ar - Arabic"
    echo "12) il - Israel"
    echo "13) in - India"
    echo "14) tr - Turkey"
    echo "15) uz - Uzbekistan"
    echo "16) br - Brazil"
    echo "17) no - Norway"
    echo "18) pl - Poland"
    echo "19) nl - Netherlands"
    echo "20) se - Sweden"
    echo "21) fi - Finland"
    echo "22) custom - Enter your own layout code"
    echo
    echo -e "${CYAN}Note: For other countries not listed above, use option 22 (custom)${NC}"
    echo -e "${CYAN}Common examples: 'dvorak', 'colemak', 'ca' (Canada), 'au' (Australia), etc.${NC}"
    echo
    
    KEYBOARD_LAYOUT="us"  # Default layout
    
    while true; do
        echo -e "${YELLOW}Enter your choice (1-22, or press Enter for default 'us'):${NC}"
        read -r layout_choice
        
        # If empty input, use default
        if [ -z "$layout_choice" ]; then
            layout_choice=1
        fi
        
        case $layout_choice in
            1)
                KEYBOARD_LAYOUT="us"
                print_status "Selected: United States (us)"
                break
                ;;
            2)
                KEYBOARD_LAYOUT="gb"
                print_status "Selected: United Kingdom (gb)"
                break
                ;;
            3)
                KEYBOARD_LAYOUT="de"
                print_status "Selected: Germany (de)"
                break
                ;;
            4)
                KEYBOARD_LAYOUT="fr"
                print_status "Selected: France (fr)"
                break
                ;;
            5)
                KEYBOARD_LAYOUT="es"
                print_status "Selected: Spain (es)"
                break
                ;;
            6)
                KEYBOARD_LAYOUT="it"
                print_status "Selected: Italy (it)"
                break
                ;;
            7)
                KEYBOARD_LAYOUT="cn"
                print_status "Selected: China (cn)"
                break
                ;;
            8)
                KEYBOARD_LAYOUT="ru"
                print_status "Selected: Russia (ru)"
                break
                ;;
            9)
                KEYBOARD_LAYOUT="jp"
                print_status "Selected: Japan (jp)"
                break
                ;;
            10)
                KEYBOARD_LAYOUT="kr"
                print_status "Selected: South Korea (kr)"
                break
                ;;
            11)
                KEYBOARD_LAYOUT="ar"
                print_status "Selected: Arabic (ar)"
                break
                ;;
            12)
                KEYBOARD_LAYOUT="il"
                print_status "Selected: Israel (il)"
                break
                ;;
            13)
                KEYBOARD_LAYOUT="in"
                print_status "Selected: India (in)"
                break
                ;;
            14)
                KEYBOARD_LAYOUT="tr"
                print_status "Selected: Turkey (tr)"
                break
                ;;
            15)
                KEYBOARD_LAYOUT="uz"
                print_status "Selected: Uzbekistan (uz)"
                break
                ;;
            16)
                KEYBOARD_LAYOUT="br"
                print_status "Selected: Brazil (br)"
                break
                ;;
            17)
                KEYBOARD_LAYOUT="no"
                print_status "Selected: Norway (no)"
                break
                ;;
            18)
                KEYBOARD_LAYOUT="pl"
                print_status "Selected: Poland (pl)"
                break
                ;;
            19)
                KEYBOARD_LAYOUT="nl"
                print_status "Selected: Netherlands (nl)"
                break
                ;;
            20)
                KEYBOARD_LAYOUT="se"
                print_status "Selected: Sweden (se)"
                break
                ;;
            21)
                KEYBOARD_LAYOUT="fi"
                print_status "Selected: Finland (fi)"
                break
                ;;
            22)
                echo -e "${YELLOW}Enter your custom keyboard layout code (e.g., 'dvorak', 'colemak', 'ca', 'au'):${NC}"
                read -r custom_layout
                if [ -n "$custom_layout" ]; then
                    KEYBOARD_LAYOUT="$custom_layout"
                    print_status "Selected: Custom layout ($custom_layout)"
                    break
                else
                    print_error "Custom layout cannot be empty. Please try again."
                fi
                ;;
            *)
                print_error "Invalid choice. Please enter a number between 1-22."
                ;;
        esac
    done
    
        # Apply the keyboard layout to the custom.conf file
    CUSTOM_CONFIG_FILE="$HOME/.config/hyprcustom/custom.conf"
    
    if [ -f "$CUSTOM_CONFIG_FILE" ]; then
        sed -i "s/\$LAYOUT/$KEYBOARD_LAYOUT/g" "$CUSTOM_CONFIG_FILE"
        print_status "Keyboard layout '$KEYBOARD_LAYOUT' has been applied to custom.conf"
    else
        print_error "Custom config file not found at $CUSTOM_CONFIG_FILE"
        print_error "Please run setup_custom_config() first"
    fi

    # 🔄 Reload Hyprland
    echo
    echo "🔄 Reloading Hyprland with 'hyprctl reload'..."
    if command -v hyprctl > /dev/null 2>&1; then
        if pgrep -x "Hyprland" > /dev/null; then
            hyprctl reload && echo "✅ Hyprland reloaded successfully." || echo "❌ Failed to reload Hyprland."
        else
            echo "ℹ️  Hyprland is not currently running. Configuration will be applied on next start and Hyprland login."
        fi
    else
        echo "⚠️  'hyprctl' not found. Skipping Hyprland reload. Run 'hyprctl reload' on next start and Hyprland login."
    fi

    print_success "HyprCandy configuration setup completed!"  
}

# Function to prompt for reboot
prompt_reboot() {
    echo
    print_success "Installation and configuration completed!"
    print_status "All packages have been installed and Hyprcandy configurations have been deployed."
    print_status "The $DISPLAY_MANAGER display manager has been enabled."
    echo
    print_warning "A reboot is recommended to ensure all changes take effect properly."
    echo
    echo -e "${YELLOW}Would you like to reboot now? (y/N)${NC}"
    read -r reboot_choice
    case "$reboot_choice" in
        [yY][eE][sS]|[yY])
            print_status "Rebooting system..."
            sudo reboot
            ;;
        *)
            print_status "Reboot skipped. Please reboot manually when convenient."
            print_status "Run: sudo reboot"
            ;;
    esac
}

# Main execution
main() {
    # Show multicolored ASCII art
    show_ascii_art
    
    print_status "This installer will set up a complete Hyprland environment with:"
    echo "  • Hyprland window manager and ecosystem"
    echo "  • Essential applications and utilities"
    echo "  • Pre-configured Hyprcandy dotfiles"
    echo "  • Dynamically colored Hyprland environment"
    echo "  • Your choice of display manager (SDDM or GDM)"
    echo "  • Your choice of shell (Fish or Zsh) with comprehensive configuration"
    echo
    
    # Choose display manager first
    choose_display_manager
    echo
    
    # Choose shell
    choose_shell
    echo
    
    # Check for AUR helper or install one
    check_or_install_aur_helper
    
    echo
    print_status "Using $AUR_HELPER as AUR helper"
    
    # Build package list based on display manager and shell choice
    build_package_list
    
    # Ask for confirmation
    echo -e "${YELLOW}This will install ${#packages[@]} packages and setup Hyprcandy configuration. Continue? (y/N)${NC}"
    read -r response
    case "$response" in
        [yY][eE][sS]|[yY])
            install_packages
            ;;
        *)
            print_status "Installation cancelled."
            exit 0
            ;;
    esac
    
    echo
    print_status "Package installation completed!"

     # Setup shell configuration
    echo
    print_status "Setting up shell configuration..."
    if [ "$SHELL_CHOICE" = "fish" ]; then
        setup_fish
    elif [ "$SHELL_CHOICE" = "zsh" ]; then
        setup_zsh
    fi
    
    # Automatically setup Hyprcandy configuration
    print_status "Proceeding with Hyprcandy configuration setup..."
    setup_hyprcandy
    
    # Enable display manager
    enable_display_manager

    # Setup default "custom.conf" file
    setup_custom_config

    # Setup keyboard layout
    setup_keyboard_layout
    
    # Configuration management tips
    echo
    print_status "Configuration management tips:"
    print_status "• Your Hyprcandy configs are in: ~/.hyprcandy/"
    print_status "• Minor updates: cd ~/.hyprcandy && git pull && stow */"
    print_status "• Major updates: rerun the install script for updated apps and configs"
    print_status "• To remove a config: cd ~/.hyprcandy && stow -D <config_name> -t $HOME"
    print_status "• To reinstall a config: cd ~/.hyprcandy && stow -R <config_name> -t $HOME"
    
    # Display and wallpaper configuration notes
    echo
    echo -e "${CYAN}════════════════════════════════════════════════════════════════════════════════════════════════════════════${NC}"
    echo -e "${WHITE}                              🖥️  Post-Installation Configuration  🖼️${NC}"
    echo -e "${CYAN}════════════════════════════════════════════════════════════════════════════════════════════════════════════${NC}"
    echo
    print_status "After rebooting, you may want to configure the following:"
    echo
    echo -e "${PURPLE}📱 Display Configuration:${NC}"
    print_status "• Use ${YELLOW}nwg-displays${NC} to configure monitor scaling, resolution, and positioning"
    print_status "• Launch it from the application menu or run: ${CYAN}nwg-displays${NC}"
    print_status "• Adjust scaling for HiDPI displays if needed"
    echo
    echo -e "${PURPLE}🐚 Zsh Configuration:${NC}"
    print_status "• IMPORTANT: If you chose Zsh-shell then use ${CYAN}SUPER + Q${NC} to toggle Kitty and go through the Zsh setup"
    print_status "• IMPORTANT: (Remember to type ${YELLOW}n${NC}o at the end when asked to Apply changes to .zshrc since HyprCandy already has them applied)"
    print_status "• To configure Zsh, in the ${CYAN}Home${NC} directory edit ${CYAN}.hyprcandy-zsh.zsh${NC} or ${CYAN}.zshrc${NC}"
    print_status "• You can also rerun the script to switch from either one or regenerate HyprCandy's default Zsh shell setup"
    print_status "• You can also rerun the script to install Fish shell"
    print_status "• When both are installed switch at anytime by running ${CYAN}chsh -s /usr/bin/<name of shell>${NC} then reboot"
    echo
    echo -e "${PURPLE}🖼️ Wallpaper Setup (Hyprpanel):${NC}"
    print_status "• Through Hyprpanel's configuration interface in the ${CYAN}Theming${NC} section do the following:"
    print_status "• Under ${YELLOW}General Settings${NC} choose a wallaper to apply where it says None"
    print_status "• Find default wallpapers check the ${CYAN}~/Pictures/HyprCandy${NC} or ${CYAN}HyprCandy${NC} folder"
    print_status "• Under ${YELLOW}Matugen Settings${NC} toggle the button to enable matugen color application"
    print_status "• If the wallpaper doesn't apply through the configuration interface, then toggle the button to apply wallpapers"
    print_status "• Ths will quickly reset swww and apply the background"
    print_status "• Remember to reload the dock with ${CYAN}SHIFT + K${NC} to update its colors"
    echo
    echo -e "${PURPLE}🎨 Font, Icon And Cursor Theming:${NC}"
    print_status "• Open the application-finder with SUPER + A and search for ${YELLOW}GTK Settings${NC} application"
    print_status "• Prefered font to set through nwg-look is ${CYAN}JetBrainsMono Nerd Font Propo Regular${NC} at size ${CYAN}10${NC}"
    print_status "• Use ${YELLOW}nwg-look${NC} to configure the system-font, tela-icons and cursor themes"
    print_status "• Cursor themes take effect after loging out and back in"
    echo
    echo -e "${PURPLE}🐟 Fish Configuration:${NC}"
    print_status "• To configure Fish edit, in the ${YELLOW}~/.config/fish${NC} directory edit the ${YELLOW}config.fish${NC} file"
    print_status "• You can also rerun the script to switch from either one or regenerate HyprCandy's default Fish shell setup"
    print_status "• You can also rerun the script to install Zsh shell"
    print_status "• When both are installed switch by running ${CYAN}chsh -s /usr/bin/<name of shell>${NC} then reboot"
    echo
    echo -e "${PURPLE}🔎 Firefox:${NC}"
    print_status "• Required packages are already installed. Just open firefox, install the ${YELLOW}pywalfox${NC} extension and run ${YELLOW}pywalfox update${NC} in kitty"
    echo
    echo -e "${PURPLE}🏠 Clean Home Directory:${NC}"
    print_status "• You can delete any stowed symlinks made in the 'Home' directory"
    echo
    echo -e "${CYAN}════════════════════════════════════════════════════════════════════════════════════════════════════════════${NC}"
    
    # Prompt for reboot
    prompt_reboot
}

# Run main function
main "$@"
