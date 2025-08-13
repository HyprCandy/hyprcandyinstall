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
PANEL_CHOICE=""
BROWSER_CHOICE=""

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
    print_status "For old users remove rofi-wayland through 'sudo pacman -Rnsd rofi-wayland' then clear cache through 'sudo pacman -Scc'"
    echo -e "${CYAN}Choose your display manager:${NC}"
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

choose_panel() {
    echo -e "${CYAN}Choose your panel: you can also rerun the script to switch from either or regenerate HyprCandy's default panel setup:${NC}"
    echo -e "${GREEN}1) Waybar${NC}"
    echo "   • Light with fast startup/reload for a 'taskbar' like experience"
    echo "   • Highly customizable manually"
    echo "   • Waypaper integration: loads colors through waypaper backgrounds"
    echo "   • Fast live wallpaper application through caching and easier background setup"
    echo ""
    echo -e "${GREEN}2) Hyprpanel${NC}"
    echo "   • Easy to theme through its interface"
    echo "   • Has an autohide feature when only one window is open"
    echo "   • Much slower to relaunch after manually killing (when multiple windows are open)"
    echo "   • Recommended for users who don't mind an always-on panel"
    echo "   • Longer process to set backgrounds and slower for live backgrounds"
    echo ""
    
    read -rp "Enter 1 or 2: " panel_choice
    case $panel_choice in
        1) PANEL_CHOICE="waybar" ;;
        2) PANEL_CHOICE="hyprpanel" ;;
        *) 
            print_error "Invalid choice. Please enter 1 or 2."
            echo ""
            choose_panel  # Recursively ask again
            ;;
    esac
    echo -e "${GREEN}Panel selected: $PANEL_CHOICE${NC}"
}

choose_browser() {
    echo -e "${CYAN}Choose your browser:${NC}"
    echo "1) Brave (Seemless integration with HyprCandy GTK and Qt theme through its Appearance settings, fast, secure and privacy-focused browser)"
    echo "2) Firefox (Themed through python-pywalfox by running pywalfox update in the terminal, open-source browser with a focus on privacy)"
    echo "3) Zen Browser (Themed through zen mods and slightly through python-pywalfox by running pywalfox update in the terminal, open-source browser with a focus on privacy)"
    echo "4) Librewolf (Open-source browser with a focus on privacy, highly customizable manually)"
    echo "5) Other (Please install your own browser post-installation)"
    read -rp "Enter 1, 2, 3, 4 or 5: " browser_choice
    case $browser_choice in
        1) BROWSER_CHOICE="brave" ;;
        2) BROWSER_CHOICE="firefox" ;;
        3) BROWSER_CHOICE="zen-browser-bin" ;;
        4) BROWSER_CHOICE="librewolf" ;;
        5) BROWSER_CHOICE="Other" ;;
        *) print_error "Invalid choice. Please enter 1, 2, 3, 4 or 5." ;;
    esac
    echo -e "${GREEN}Browser selected: $BROWSER_CHOICE${NC}"
}

# Function to choose shell
choose_shell() {
    echo -e "${CYAN}Choose your shell: you can also rerun the script to switch from either or regenerate HyprCandy's default shell setup:${NC}"
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

        # Flatpak base repo for Gnome Software app
        "flatpak"
        
        # Terminals and file manager
        "kitty"
        "nautilus"
        
        # Qt and GTK theming
        "qt5ct"
        "qt6ct"
        "nwg-look"
        
        # System utilities
        "bluez"
        "bluez-utils"
        "blueman"
        "nwg-displays"
        "nwg-dock-hyprland"
        "wlogout"
        "uwsm-git"
        "pacman-contrib"
        
        # Application launchers and menus
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
        "matugen-bin"
        "wallust"
        
        # Editors
        "gedit"
        "neovim"
        "micro"
        
        # Utilities
        "zip"
        "p7zip"
        "wtype"
        "cava"
        "downgrade"
        "ntfs-3g"
        "fuse"
        "video-trimmer"
        "eog"
        "inotify-tools"
        "bc"
        "libnotify"
        "jq"

        # Waybar setup notification daemon and fallback notification daemon when hyprpanel isn't running
        "mako"
        
        # Fonts and emojis
        "ttf-dejavu-sans-code"
        "ttf-cascadia-mono-nerd"
        "ttf-fantasque-nerd"
        "ttf-firacode-nerd"
        "ttf-jetbrains-mono-nerd"
        "ttf-nerd-fonts-symbols"
        "ttf-nerd-fonts-symbols-common"
        "ttf-nerd-fonts-symbols-mono"
        "ttf-meslo-nerd"
        "powerline-fonts"
        "noto-fonts-emoji"
        "noto-color-emoji-fontconfig"
        "awesome-terminal-fonts"
        
        # Clipboard
        "cliphist"
        
        # Browser and theming
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
        "asciiquarium"
        
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
    
    
    # Add panel based on user choice
    if [ "$PANEL_CHOICE" = "waybar" ]; then
        packages+=(
        "waybar"
        "waypaper"
        )
        print_status "Added Waybar to package list"
    else
        packages+=(
        "ags-hyprpanel-git"
        )
        print_status "Added Hyprpanel to package list"
    fi

    # Add browser based on user choice
    if [ "$BROWSER_CHOICE" = "brave" ]; then
        packages+=(
            "brave-bin"
        )
        print_status "Added Brave to package list"
    elif [ "$BROWSER_CHOICE" = "firefox" ]; then
        packages+=(
            "firefox"
            "python-pywalfox"
        )
        print_status "Added Firefox to package list"
    elif [ "$BROWSER_CHOICE" = "zen-browser-bin" ]; then
        packages+=(
            "zen-browser-bin"
            "python-pywalfox"
        )
        print_status "Added Zen Browser to package list"
    elif [ "$BROWSER_CHOICE" = "librewolf" ]; then
        packages+=(
            "librewolf"
            "python-pywalfox"
        )
        print_status "Added Librewolf to package list"
    elif [ "$BROWSER_CHOICE" = "Other" ]; then
        print_status "Please install your own browser post-installation"
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

    # Installed seperately without "--noconfirm" incase of conflicting "rofi" package
    $AUR_HELPER -S rofi-lbonn-wayland-git
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

[fill]
symbol = " "

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
alias hyprcandy="cd .hyprcandy && git pull && stow --ignore='HyprCandy' --ignore='Candy-Images' --ignore='Dock-SVGs' --ignore='Gifs' --ignore='Logo' --ignore='GJS' --ignore='resources' --ignore='src' --ignore='meson.build' --ignore='README.md' --ignore='run.log' --ignore='test_layout.js' --ignore='test_media_menu.js' --ignore='toggle.js' --ignore='toggle-main.js' --ignore='~' --ignore='candy-main.js' --ignore='gjs-media-player.desktop' --ignore='gjs-toggle-controls.desktop' --ignore='main.js' --ignore='media-main.js' --ignore='SEEK_FEATURE.md' --ignore='setup-custom-icon.sh' --ignore='weather-main.js' */"
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
alias matrix="cmatrix -a -b -r"
alias pipes="pipes.sh"
alias sea="asciiquarium"

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

[fill]
symbol = " "

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
alias hyprcandy="cd .hyprcandy && git pull && stow --ignore='HyprCandy' --ignore='Candy-Images' --ignore='Dock-SVGs' --ignore='Gifs' --ignore='Logo' --ignore='GJS' --ignore='resources' --ignore='src' --ignore='meson.build' --ignore='README.md' --ignore='run.log' --ignore='test_layout.js' --ignore='test_media_menu.js' --ignore='toggle.js' --ignore='toggle-main.js' --ignore='~' --ignore='candy-main.js' --ignore='gjs-media-player.desktop' --ignore='gjs-toggle-controls.desktop' --ignore='main.js' --ignore='media-main.js' --ignore='SEEK_FEATURE.md' --ignore='setup-custom-icon.sh' --ignore='weather-main.js' */"
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
alias matrix="cmatrix -a -b -r"
alias pipes="pipes.sh"
alias sea="asciiquarium"

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

    if [ "$PANEL_CHOICE" = "waybar" ]; then
        if [ -d "$HOME/mechabar" ]; then
            echo "🔄 Installing Waybar..."
            rm -rf "$HOME/mechabar"
            sleep 0.5
            git clone https://github.com/sejjy/mechabar.git
            cd mechabar
            ./install.sh
            cd ..
            rm -rf mechabar
            echo "✅ Waybar installed successfully!"
        else
            echo "🔄 Installing Waybar..."
            git clone https://github.com/sejjy/mechabar.git
            cd mechabar
            ./install.sh
            cd ..
            rm -rf mechabar
            echo "✅ Waybar installed successfully!"
        fi
    fi

    print_status "Setting up Hyprcandy configuration..."
    
    # Check if stow is available
    if ! command -v stow &> /dev/null; then
        print_error "stow is not installed. Cannot proceed with configuration setup."
        return 1
    fi
    
    # Backup previous default config folder if it exists
    PREVIOUS_CONFIG_FOLDER="$HOME/.config/hypr"
    
    if [ ! -d "$PREVIOUS_CONFIG_FOLDER" ]; then
        print_error "Default config folder not found: $PREVIOUS_CONFIG_FOLDER"
        echo -e "${RED}Skipping default config backup${NC}"
    else
        cp -r "$PREVIOUS_CONFIG_FOLDER" "${PREVIOUS_CONFIG_FOLDER}.backup.$(date +%Y%m%d_%H%M%S)"
        echo -e "${GREEN}Previous default config folder backup created${NC}"
    fi
    sleep 1
    
    # Backup previous custom config folder if it exists
    PREVIOUS_CUSTOM_CONFIG_FOLDER="$HOME/.config/hyprcustom"
    
    if [ ! -d "$PREVIOUS_CUSTOM_CONFIG_FOLDER" ]; then
        print_error "Custom config folder not found: $PREVIOUS_CUSTOM_CONFIG_FOLDER"
        echo -e "${RED}Skipping custom config backup${NC}"
    else
        cp -r "$PREVIOUS_CUSTOM_CONFIG_FOLDER" "${PREVIOUS_CUSTOM_CONFIG_FOLDER}.backup.$(date +%Y%m%d_%H%M%S)"
        echo -e "${GREEN}Previous custom config folder backup created${NC}"
    fi
    sleep 1

    # In case of updates, remove existing .hyprcandy folder before cloning
    if [ -d "$HOME/.hyprcandy" ]; then
        echo "🗑️  Removing existing .hyprcandy folder to clone updated dotfiles..."
        rm -rf "$HOME/.hyprcandy"
        rm -rf "$HOME/.ultracandy"
        sleep 2
    else
        echo "✅ .hyprcandy dotfiles folder doesn't exist — seems to be a fresh install."
        rm -rf "$HOME/.ultracandy"
        sleep 2
    fi

    # Clone Hyprcandy repository
    hyprcandy_dir="$HOME/.hyprcandy"
    echo "🌐 Cloning Hyprcandy repository into $hyprcandy_dir..."
    git clone https://github.com/HyprCandy/Hyprcandy.git "$hyprcandy_dir"

    # Go to the home directory
    cd "$HOME"

    # Remove present .zshrc file
    rm -rf .face.icon .hyprcandy-zsh.zsh .icons Candy GJS
    rm -rf "$HOME/Pictures/HyprCandy"

    # Ensure ~/.config exists, then remove specified subdirectories
    [ -d "$HOME/.config" ] || mkdir -p "$HOME/.config"
    cd "$HOME/.config" || exit 1
    rm -rf background background.png btop cava fastfetch gtk-3.0 gtk-4.0 htop hypr hyprcandy hyprpanel kitty matugen micro nvtop nwg-dock-hyprland nwg-look qt5ct qt6ct rofi uwsm wallust waybar waypaper wlogout xsettingsd

    # Go to the home directory
    cd "$HOME"

    # Safely remove existing .zshrc, .hyprcandy-zsh.zsh and .icons files (only if they exist)
    # [ -f "$HOME/.zshrc" ] && rm -f "$HOME/.zshrc"
    [ -f "$HOME/.face.icon" ] && rm -f "$HOME/.face.icon"
    [ -f "$HOME/.hyprcandy-zsh.zsh" ] && rm -f "$HOME/.hyprcandy-zsh.zsh"
    [ -f "$HOME/.icons" ] && rm -f "$HOME/.icons"
    [ -f "$HOME/Candy" ] && rm -f "$HOME/Candy"
    [ -f "$HOME/GJS" ] && rm -f "$HOME/GJS"

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
    preserve_items=("GJS" "Candy" ".git")

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

# Stow all configurations at once, ignoring Candy folder
if stow -v -t "$HOME" --ignore='Candy' --ignore='GJS' . 2>/dev/null; then
    echo "✅ Successfully stowed all configurations"
else
    echo "⚠️  Stow operation failed — attempting restow..."
    if stow -R -v -t "$HOME" --ignore='Candy' --ignore='GJS' . 2>/dev/null; then
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

### ✅ Setup mako config, hook scripts and needed services
echo "📁 Creating background hook scripts..."
mkdir -p "$HOME/.config/hyprcandy/hooks" "$HOME/.config/systemd/user" "$HOME/.config/mako"

### 🪧 Setup mako config
cat > "$HOME/.config/mako/config" << 'EOF'
# Mako Configuration with Material You Colors
# Colors directly embedded (since include might not work)

# Default notification appearance
background-color=#432a00
text-color=#ffffff
border-color=#edbf80
progress-color=#000000

# Notification positioning and layout
anchor=top-right
margin=15,15,0,0
padding=15,20
border-size=2
border-radius=16

# Typography
font=FantasqueSansM Nerd Font Propo Italic 10
markup=1
format=<b>%s</b>\n%b

# Notification dimensions
width=240
height=120
max-visible=1

# Behavior
default-timeout=3000
ignore-timeout=0
group-by=app-name
sort=-time

# Icon settings
icon-path=/usr/share/icons/Papirus-Dark
max-icon-size=20

# Urgency levels with Material You colors
[urgency=low]
background-color=#432a00
text-color=#ffffff
border-color=#edbf80
default-timeout=3000

[urgency=normal]
background-color=#432a00
text-color=#ffffff
border-color=#edbf80
default-timeout=5000

[urgency=critical]
background-color=#432a00
text-color=#ffffff
border-color=#edbf80
default-timeout=0

# App-specific styling
[app-name=Spotify]
background-color=#432a00
text-color=#ffffff
border-color=#edbf80

[app-name=Discord]
background-color=#432a00
text-color=#ffffff
border-color=#edbf80

[app-name="Volume Control"]
background-color=#432a00
text-color=#ffffff
border-color=#edbf80
progress-color=#000000

[app-name="Brightness Control"]
background-color=#432a00
text-color=#ffffff
border-color=#edbf80
progress-color=#000000

# Network notifications
[app-name="NetworkManager"]
background-color=#432a00
text-color=#ffffff
border-color=#edbf80

# Battery notifications
[app-name="Power Management"]
background-color=#432a00
text-color=#ffffff
border-color=#edbf80

[app-name="Power Management" urgency=critical]
background-color=#432a00
text-color=#ffffff
border-color=#edbf80

# System notifications
[app-name="System"]
background-color=#432a00
text-color=#ffffff
border-color=#edbf80

# Screenshot notifications
[app-name="Screenshot"]
background-color=#432a00
text-color=#ffffff
border-color=#edbf80

# Media player notifications
[category=media]
background-color=#432a00
text-color=#ffffff
border-color=#edbf80
default-timeout=3000

# Animation and effects
on-button-left=dismiss
on-button-middle=none
on-button-right=dismiss-all
on-touch=dismiss

# Layer shell settings (for Wayland compositors)
layer=overlay
anchor=top-right
EOF

# ═══════════════════════════════════════════════════════════════
#                    Icon Size Increase Script
# ═══════════════════════════════════════════════════════════════

cat > "$HOME/.config/hyprcandy/hooks/nwg_dock_icon_size_increase.sh" << 'EOF'
#!/bin/bash

LAUNCH_SCRIPT="$HOME/.config/nwg-dock-hyprland/launch.sh"
KEYBINDS_FILE="$HOME/.config/hyprcustom/custom_keybinds.conf"
SETTINGS_FILE="$HOME/.config/hyprcandy/nwg_dock_settings.conf"

# Create settings file if it doesn't exist
if [ ! -f "$SETTINGS_FILE" ]; then
    echo "ICON_SIZE=28" > "$SETTINGS_FILE"
    echo "BORDER_RADIUS=16" >> "$SETTINGS_FILE"
    echo "BORDER_WIDTH=2" >> "$SETTINGS_FILE"
fi

# Source current settings
source "$SETTINGS_FILE"

# Increment icon size
NEW_SIZE=$((ICON_SIZE + 2))

# Update settings and configs
sed -i "s/ICON_SIZE=.*/ICON_SIZE=$NEW_SIZE/" "$SETTINGS_FILE"
sed -i "s/-i [0-9]\\+/-i $NEW_SIZE/g" "$LAUNCH_SCRIPT"
sed -i "s/-i [0-9]\\+/-i $NEW_SIZE/g" "$KEYBINDS_FILE"

# Relaunch dock in correct position
if pgrep -f "nwg-dock-hyprland.*-p left" > /dev/null; then
    pkill -f nwg-dock-hyprland
    sleep 0.3
    nwg-dock-hyprland -p left -lp start -i $NEW_SIZE -w 10 -ml 6 -mt 10 -mb 10 -x -r -s "style.css" -c "rofi -show drun" &
elif pgrep -f "nwg-dock-hyprland.*-p top" > /dev/null; then
    pkill -f nwg-dock-hyprland
    sleep 0.3
    nwg-dock-hyprland -p top -lp start -i $NEW_SIZE -w 10 -mt 6 -ml 10 -mr 10 -x -r -s "style.css" -c "rofi -show drun" &
elif pgrep -f "nwg-dock-hyprland.*-p right" > /dev/null; then
    pkill -f nwg-dock-hyprland
    sleep 0.3
    nwg-dock-hyprland -p right -lp start -i $NEW_SIZE -w 10 -mr 6 -mt 10 -mb 10 -x -r -s "style.css" -c "rofi -show drun" &
else
    "$LAUNCH_SCRIPT" &
fi

echo "🔼 Icon size increased: $NEW_SIZE px"
notify-send "Dock Icon Size Increased" "Size: ${NEW_SIZE}px" -t 2000
EOF

# ═══════════════════════════════════════════════════════════════
#                    Icon Size Decrease Script
# ═══════════════════════════════════════════════════════════════

cat > "$HOME/.config/hyprcandy/hooks/nwg_dock_icon_size_decrease.sh" << 'EOF'
#!/bin/bash

LAUNCH_SCRIPT="$HOME/.config/nwg-dock-hyprland/launch.sh"
KEYBINDS_FILE="$HOME/.config/hyprcustom/custom_keybinds.conf"
SETTINGS_FILE="$HOME/.config/hyprcandy/nwg_dock_settings.conf"

# Create settings file if it doesn't exist
if [ ! -f "$SETTINGS_FILE" ]; then
    echo "ICON_SIZE=28" > "$SETTINGS_FILE"
    echo "BORDER_RADIUS=16" >> "$SETTINGS_FILE"
    echo "BORDER_WIDTH=2" >> "$SETTINGS_FILE"
fi

# Source current settings
source "$SETTINGS_FILE"

# Decrease icon size with lower bound of 16px
NEW_SIZE=$((ICON_SIZE > 16 ? ICON_SIZE - 2 : 16))

# Update configs
sed -i "s/ICON_SIZE=.*/ICON_SIZE=$NEW_SIZE/" "$SETTINGS_FILE"
sed -i "s/-i [0-9]\\+/-i $NEW_SIZE/g" "$LAUNCH_SCRIPT"
sed -i "s/-i [0-9]\\+/-i $NEW_SIZE/g" "$KEYBINDS_FILE"

# Relaunch
if pgrep -f "nwg-dock-hyprland.*-p left" > /dev/null; then
    pkill -f nwg-dock-hyprland
    sleep 0.3
    nwg-dock-hyprland -p left -lp start -i $NEW_SIZE -w 10 -ml 6 -mt 10 -mb 10 -x -r -s "style.css" -c "rofi -show drun" &
elif pgrep -f "nwg-dock-hyprland.*-p top" > /dev/null; then
    pkill -f nwg-dock-hyprland
    sleep 0.3
    nwg-dock-hyprland -p top -lp start -i $NEW_SIZE -w 10 -mt 6 -ml 10 -mr 10 -x -r -s "style.css" -c "rofi -show drun" &
elif pgrep -f "nwg-dock-hyprland.*-p right" > /dev/null; then
    pkill -f nwg-dock-hyprland
    sleep 0.3
    nwg-dock-hyprland -p right -lp start -i $NEW_SIZE -w 10 -mr 6 -mt 10 -mb 10 -x -r -s "style.css" -c "rofi -show drun" &
else
    "$LAUNCH_SCRIPT" &
fi

echo "🔽 Icon size decreased: $NEW_SIZE px"
notify-send "Dock Icon Size Decreased" "Size: ${NEW_SIZE}px" -t 2000
EOF

# ═══════════════════════════════════════════════════════════════
#                    Border Radius Increase Script
# ═══════════════════════════════════════════════════════════════

cat > "$HOME/.config/hyprcandy/hooks/nwg_dock_border_radius_increase.sh" << 'EOF'
#!/bin/bash

STYLE_FILE="$HOME/.config/nwg-dock-hyprland/style.css"
SETTINGS_FILE="$HOME/.config/hyprcandy/nwg_dock_settings.conf"

# Create settings file if it doesn't exist
if [ ! -f "$SETTINGS_FILE" ]; then
    echo "ICON_SIZE=28" > "$SETTINGS_FILE"
    echo "BORDER_RADIUS=16" >> "$SETTINGS_FILE"
    echo "BORDER_WIDTH=2" >> "$SETTINGS_FILE"
fi

# Source current settings
source "$SETTINGS_FILE"

# Increment border radius
NEW_RADIUS=$((BORDER_RADIUS + 2))

# Update settings file
sed -i "s/BORDER_RADIUS=.*/BORDER_RADIUS=$NEW_RADIUS/" "$SETTINGS_FILE"

# Update style.css file
sed -i "s/border-radius: [0-9]\+px/border-radius: ${NEW_RADIUS}px/" "$STYLE_FILE"

# Reload dock to apply CSS changes
if pgrep -f "nwg-dock-hyprland.*-p left" > /dev/null; then
    pkill -f nwg-dock-hyprland
    sleep 0.3
    nwg-dock-hyprland -p left -lp start -i $ICON_SIZE -w 10 -ml 6 -mt 10 -mb 10 -x -r -s "style.css" -c "rofi -show drun" > /dev/null 2>&1 &
elif pgrep -f "nwg-dock-hyprland.*-p top" > /dev/null; then
    pkill -f nwg-dock-hyprland
    sleep 0.3
    nwg-dock-hyprland -p top -lp start -i $ICON_SIZE -w 10 -mt 6 -ml 10 -mr 10 -x -r -s "style.css" -c "rofi -show drun" > /dev/null 2>&1 &
elif pgrep -f "nwg-dock-hyprland.*-p right" > /dev/null; then
    pkill -f nwg-dock-hyprland
    sleep 0.3
    nwg-dock-hyprland -p right -lp start -i $ICON_SIZE -w 10 -mr 6 -mt 10 -mb 10 -x -r -s "style.css" -c "rofi -show drun" > /dev/null 2>&1 &
elif pgrep -f "nwg-dock-hyprland" > /dev/null; then
    # Default to bottom
    LAUNCH_SCRIPT="$HOME/.config/nwg-dock-hyprland/launch.sh"
    pkill -f nwg-dock-hyprland
    sleep 0.3
    "$LAUNCH_SCRIPT" > /dev/null 2>&1 &
fi

echo "🔼 Border radius increased: $NEW_RADIUS px"
notify-send "Dock Border Radius Increased" "Radius: ${NEW_RADIUS}px" -t 2000
EOF

# ═══════════════════════════════════════════════════════════════
#                    Border Radius Decrease Script
# ═══════════════════════════════════════════════════════════════

cat > "$HOME/.config/hyprcandy/hooks/nwg_dock_border_radius_decrease.sh" << 'EOF'
#!/bin/bash

STYLE_FILE="$HOME/.config/nwg-dock-hyprland/style.css"
SETTINGS_FILE="$HOME/.config/hyprcandy/nwg_dock_settings.conf"

# Create settings file if it doesn't exist
if [ ! -f "$SETTINGS_FILE" ]; then
    echo "ICON_SIZE=28" > "$SETTINGS_FILE"
    echo "BORDER_RADIUS=16" >> "$SETTINGS_FILE"
    echo "BORDER_WIDTH=2" >> "$SETTINGS_FILE"
fi

# Source current settings
source "$SETTINGS_FILE"

# Decrement border radius with floor
NEW_RADIUS=$((BORDER_RADIUS > 0 ? BORDER_RADIUS - 2 : 0))

# Update settings file
sed -i "s/BORDER_RADIUS=.*/BORDER_RADIUS=$NEW_RADIUS/" "$SETTINGS_FILE"

# Update style.css file
sed -i "s/border-radius: [0-9]\+px/border-radius: ${NEW_RADIUS}px/" "$STYLE_FILE"

# Reload dock to apply CSS changes
if pgrep -f "nwg-dock-hyprland.*-p left" > /dev/null; then
    pkill -f nwg-dock-hyprland
    sleep 0.3
    nwg-dock-hyprland -p left -lp start -i $ICON_SIZE -w 10 -ml 6 -mt 10 -mb 10 -x -r -s "style.css" -c "rofi -show drun" > /dev/null 2>&1 &
elif pgrep -f "nwg-dock-hyprland.*-p top" > /dev/null; then
    pkill -f nwg-dock-hyprland
    sleep 0.3
    nwg-dock-hyprland -p top -lp start -i $ICON_SIZE -w 10 -mt 6 -ml 10 -mr 10 -x -r -s "style.css" -c "rofi -show drun" > /dev/null 2>&1 &
elif pgrep -f "nwg-dock-hyprland.*-p right" > /dev/null; then
    pkill -f nwg-dock-hyprland
    sleep 0.3
    nwg-dock-hyprland -p right -lp start -i $ICON_SIZE -w 10 -mr 6 -mt 10 -mb 10 -x -r -s "style.css" -c "rofi -show drun" > /dev/null 2>&1 &
elif pgrep -f "nwg-dock-hyprland" > /dev/null; then
    LAUNCH_SCRIPT="$HOME/.config/nwg-dock-hyprland/launch.sh"
    pkill -f nwg-dock-hyprland
    sleep 0.3
    "$LAUNCH_SCRIPT" > /dev/null 2>&1 &
fi

echo "🔽 Border radius decreased: $NEW_RADIUS px"
notify-send "Dock Border Radius Decreased" "Radius: ${NEW_RADIUS}px" -t 2000
EOF

# ═══════════════════════════════════════════════════════════════
#                    Border Width Increase Script (WITH RELOAD)
# ═══════════════════════════════════════════════════════════════

cat > "$HOME/.config/hyprcandy/hooks/nwg_dock_border_width_increase.sh" << 'EOF'
#!/bin/bash

STYLE_FILE="$HOME/.config/nwg-dock-hyprland/style.css"
SETTINGS_FILE="$HOME/.config/hyprcandy/nwg_dock_settings.conf"

# Create settings file if it doesn't exist
if [ ! -f "$SETTINGS_FILE" ]; then
    echo "ICON_SIZE=28" > "$SETTINGS_FILE"
    echo "BORDER_RADIUS=16" >> "$SETTINGS_FILE"
    echo "BORDER_WIDTH=2" >> "$SETTINGS_FILE"
fi

# Source current settings
source "$SETTINGS_FILE"

# Increment border width
NEW_WIDTH=$((BORDER_WIDTH + 1))

# Update settings file
sed -i "s/BORDER_WIDTH=.*/BORDER_WIDTH=$NEW_WIDTH/" "$SETTINGS_FILE"

# Update style.css file
sed -i "s/border-width: [0-9]\+px/border-width: ${NEW_WIDTH}px/" "$STYLE_FILE"

# Reload dock to apply CSS changes
if pgrep -f "nwg-dock-hyprland.*-p left" > /dev/null; then
    pkill -f nwg-dock-hyprland
    sleep 0.3
    nwg-dock-hyprland -p left -lp start -i $ICON_SIZE -w 10 -ml 6 -mt 10 -mb 10 -x -r -s "style.css" -c "rofi -show drun" > /dev/null 2>&1 &
elif pgrep -f "nwg-dock-hyprland.*-p top" > /dev/null; then
    pkill -f nwg-dock-hyprland
    sleep 0.3
    nwg-dock-hyprland -p top -lp start -i $ICON_SIZE -w 10 -mt 6 -ml 10 -mr 10 -x -r -s "style.css" -c "rofi -show drun" > /dev/null 2>&1 &
elif pgrep -f "nwg-dock-hyprland.*-p right" > /dev/null; then
    pkill -f nwg-dock-hyprland
    sleep 0.3
    nwg-dock-hyprland -p right -lp start -i $ICON_SIZE -w 10 -mr 6 -mt 10 -mb 10 -x -r -s "style.css" -c "rofi -show drun" > /dev/null 2>&1 &
elif pgrep -f "nwg-dock-hyprland" > /dev/null; then
    # Default to bottom
    LAUNCH_SCRIPT="$HOME/.config/nwg-dock-hyprland/launch.sh"
    pkill -f nwg-dock-hyprland
    sleep 0.3
    "$LAUNCH_SCRIPT" > /dev/null 2>&1 &
fi

# ... (same dock reload logic as before, for brevity)
notify-send "Dock Border Width Increased" "Width: ${NEW_WIDTH}px" -t 2000
EOF

# ═══════════════════════════════════════════════════════════════
#                    Border Width Decrease Script (WITH RELOAD)
# ═══════════════════════════════════════════════════════════════

cat > "$HOME/.config/hyprcandy/hooks/nwg_dock_border_width_decrease.sh" << 'EOF'
#!/bin/bash

STYLE_FILE="$HOME/.config/nwg-dock-hyprland/style.css"
SETTINGS_FILE="$HOME/.config/hyprcandy/nwg_dock_settings.conf"

# Create settings file if it doesn't exist
if [ ! -f "$SETTINGS_FILE" ]; then
    echo "ICON_SIZE=28" > "$SETTINGS_FILE"
    echo "BORDER_RADIUS=16" >> "$SETTINGS_FILE"
    echo "BORDER_WIDTH=2" >> "$SETTINGS_FILE"
fi

# Source current settings
source "$SETTINGS_FILE"

# Decrement border width (minimum 0)
NEW_WIDTH=$((BORDER_WIDTH > 0 ? BORDER_WIDTH - 1 : 0))

# Update settings file
sed -i "s/BORDER_WIDTH=.*/BORDER_WIDTH=$NEW_WIDTH/" "$SETTINGS_FILE"

# Update style.css file
sed -i "s/border-width: [0-9]\+px/border-width: ${NEW_WIDTH}px/" "$STYLE_FILE"

# Reload dock to apply CSS changes
if pgrep -f "nwg-dock-hyprland.*-p left" > /dev/null; then
    pkill -f nwg-dock-hyprland
    sleep 0.3
    nwg-dock-hyprland -p left -lp start -i $ICON_SIZE -w 10 -ml 6 -mt 10 -mb 10 -x -r -s "style.css" -c "rofi -show drun" > /dev/null 2>&1 &
elif pgrep -f "nwg-dock-hyprland.*-p top" > /dev/null; then
    pkill -f nwg-dock-hyprland
    sleep 0.3
    nwg-dock-hyprland -p top -lp start -i $ICON_SIZE -w 10 -mt 6 -ml 10 -mr 10 -x -r -s "style.css" -c "rofi -show drun" > /dev/null 2>&1 &
elif pgrep -f "nwg-dock-hyprland.*-p right" > /dev/null; then
    pkill -f nwg-dock-hyprland
    sleep 0.3
    nwg-dock-hyprland -p right -lp start -i $ICON_SIZE -w 10 -mr 6 -mt 10 -mb 10 -x -r -s "style.css" -c "rofi -show drun" > /dev/null 2>&1 &
elif pgrep -f "nwg-dock-hyprland" > /dev/null; then
    # Default to bottom
    LAUNCH_SCRIPT="$HOME/.config/nwg-dock-hyprland/launch.sh"
    pkill -f nwg-dock-hyprland
    sleep 0.3
    "$LAUNCH_SCRIPT" > /dev/null 2>&1 &
fi

# ... (same dock reload logic as before, for brevity)
notify-send "Dock Border Width Decreased" "Width: ${NEW_WIDTH}px" -t 2000
EOF

# ═══════════════════════════════════════════════════════════════
#                    Dock Presets Script
# ═══════════════════════════════════════════════════════════════

cat > "$HOME/.config/hyprcandy/hooks/nwg_dock_presets.sh" << 'EOF'
#!/bin/bash

LAUNCH_SCRIPT="$HOME/.config/nwg-dock-hyprland/launch.sh"
KEYBINDS_FILE="$HOME/.config/hyprcustom/custom_keybinds.conf"
STYLE_FILE="$HOME/.config/nwg-dock-hyprland/style.css"
SETTINGS_FILE="$HOME/.config/hyprcandy/nwg_dock_settings.conf"

case "$1" in
    "minimal")
        ICON_SIZE=20
        BORDER_RADIUS=8
        BORDER_WIDTH=1
        ;;
    "balanced")
        ICON_SIZE=28
        BORDER_RADIUS=16
        BORDER_WIDTH=2
        ;;
    "prominent")
        ICON_SIZE=36
        BORDER_RADIUS=20
        BORDER_WIDTH=3
        ;;
    "hidden")
        pkill -f nwg-dock-hyprland
        echo "🫥 Dock hidden"
        notify-send "Dock Hidden" "nwg-dock-hyprland stopped" -t 2000
        exit 0
        ;;
    *)
        echo "Usage: $0 {minimal|balanced|prominent|hidden}"
        exit 1
        ;;
esac

# Update settings file
cat > "$SETTINGS_FILE" << SETTINGS_EOF
ICON_SIZE=$ICON_SIZE
BORDER_RADIUS=$BORDER_RADIUS
BORDER_WIDTH=$BORDER_WIDTH
SETTINGS_EOF

# Update launch script
sed -i "s/-i [0-9]\+/-i $ICON_SIZE/g" "$LAUNCH_SCRIPT"

# Update keybinds file
sed -i "s/-i [0-9]\+/-i $ICON_SIZE/g" "$KEYBINDS_FILE"

# Update style.css file
sed -i "s/border-radius: [0-9]\+px/border-radius: ${BORDER_RADIUS}px/" "$STYLE_FILE"
sed -i "s/border-width: [0-9]\+px/border-width: ${BORDER_WIDTH}px/" "$STYLE_FILE"

# Restart dock with current position detection
if pgrep -f "nwg-dock-hyprland.*-p left" > /dev/null; then
    pkill -f nwg-dock-hyprland
    sleep 0.3
    nwg-dock-hyprland -p left -lp start -i $ICON_SIZE -w 10 -ml 6 -mt 10 -mb 10 -x -r -s "style.css" -c "rofi -show drun" > /dev/null 2>&1 &
elif pgrep -f "nwg-dock-hyprland.*-p top" > /dev/null; then
    pkill -f nwg-dock-hyprland
    sleep 0.3
    nwg-dock-hyprland -p top -lp start -i $ICON_SIZE -w 10 -mt 6 -ml 10 -mr 10 -x -r -s "style.css" -c "rofi -show drun" > /dev/null 2>&1 &
elif pgrep -f "nwg-dock-hyprland.*-p right" > /dev/null; then
    pkill -f nwg-dock-hyprland
    sleep 0.3
    nwg-dock-hyprland -p right -lp start -i $ICON_SIZE -w 10 -mr 6 -mt 10 -mb 10 -x -r -s "style.css" -c "rofi -show drun" > /dev/null 2>&1 &
else
    # Default to bottom (launch script)
    "$LAUNCH_SCRIPT" > /dev/null 2>&1 &
fi

echo "🎨 Applied $1 preset: icon_size=$ICON_SIZE, border_radius=$BORDER_RADIUS, border_width=$BORDER_WIDTH"
notify-send "Dock Preset Applied" "$1: SIZE=$ICON_SIZE RADIUS=$BORDER_RADIUS WIDTH=$BORDER_WIDTH" -t 3000
EOF

# ═══════════════════════════════════════════════════════════════
#                    Dock Status Display Script
# ═══════════════════════════════════════════════════════════════

cat > "$HOME/.config/hyprcandy/hooks/nwg_dock_status_display.sh" << 'EOF'
#!/bin/bash

SETTINGS_FILE="$HOME/.config/hyprcandy/nwg_dock_settings.conf"

# Default fallback settings
if [ ! -f "$SETTINGS_FILE" ]; then
    echo "ICON_SIZE=28" > "$SETTINGS_FILE"
    echo "BORDER_RADIUS=16" >> "$SETTINGS_FILE"
    echo "BORDER_WIDTH=2" >> "$SETTINGS_FILE"
fi

source "$SETTINGS_FILE"

# Detect current dock position
if pgrep -f "nwg-dock-hyprland.*-p left" > /dev/null; then
    DOCK_POSITION="left"
elif pgrep -f "nwg-dock-hyprland.*-p top" > /dev/null; then
    DOCK_POSITION="top"
elif pgrep -f "nwg-dock-hyprland.*-p right" > /dev/null; then
    DOCK_POSITION="right"
elif pgrep -f "nwg-dock-hyprland" > /dev/null; then
    DOCK_POSITION="bottom"
else
    DOCK_POSITION="stopped"
fi

# Dock running?
if pgrep -f "nwg-dock-hyprland" > /dev/null; then
    DOCK_STATUS="Running"
else
    DOCK_STATUS="Stopped"
fi

STATUS="🚢 NWG-Dock Status
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
📐 Icon Size: ${ICON_SIZE}px
🔘 Border Radius: ${BORDER_RADIUS}px
🔸 Border Width: ${BORDER_WIDTH}px
📍 Position: $DOCK_POSITION
🔄 Status: $DOCK_STATUS
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

echo "$STATUS"
notify-send "NWG-Dock Status" "SIZE:${ICON_SIZE} RADIUS:${BORDER_RADIUS} WIDTH:${BORDER_WIDTH} POS:$DOCK_POSITION" -t 5000
EOF

# ═══════════════════════════════════════════════════════════════
#                  Make Dock Hook Scripts Executable
# ═══════════════════════════════════════════════════════════════

chmod +x "$HOME/.config/hyprcandy/hooks/nwg_dock_icon_size_increase.sh"
chmod +x "$HOME/.config/hyprcandy/hooks/nwg_dock_icon_size_decrease.sh"
chmod +x "$HOME/.config/hyprcandy/hooks/nwg_dock_border_radius_increase.sh"
chmod +x "$HOME/.config/hyprcandy/hooks/nwg_dock_border_radius_decrease.sh"
chmod +x "$HOME/.config/hyprcandy/hooks/nwg_dock_border_width_increase.sh"
chmod +x "$HOME/.config/hyprcandy/hooks/nwg_dock_border_width_decrease.sh"
chmod +x "$HOME/.config/hyprcandy/hooks/nwg_dock_presets.sh"
chmod +x "$HOME/.config/hyprcandy/hooks/nwg_dock_status_display.sh"

# ═══════════════════════════════════════════════════════════════
#                    Gaps OUT Increase Script
# ═══════════════════════════════════════════════════════════════

cat > "$HOME/.config/hyprcandy/hooks/hyprland_gaps_out_increase.sh" << 'EOF'
#!/bin/bash

CONFIG_FILE="$HOME/.config/hyprcustom/custom.conf"

CURRENT_GAPS_OUT=$(grep -E "^\s*gaps_out\s*=" "$CONFIG_FILE" | sed 's/.*gaps_out\s*=\s*\([0-9]*\).*/\1/')
NEW_GAPS_OUT=$((CURRENT_GAPS_OUT + 1))
sed -i "s/^\(\s*gaps_out\s*=\s*\)[0-9]*/\1$NEW_GAPS_OUT/" "$CONFIG_FILE"

hyprctl keyword general:gaps_out $NEW_GAPS_OUT
hyprctl reload

echo "🔼 Gaps OUT increased: gaps_out=$NEW_GAPS_OUT"
notify-send "Gaps OUT Increased" "gaps_out: $NEW_GAPS_OUT" -t 2000
EOF

chmod +x "$HOME/.config/hyprcandy/hooks/hyprland_gaps_out_increase.sh"

# ═══════════════════════════════════════════════════════════════
#                    Gaps OUT Decrease Script
# ═══════════════════════════════════════════════════════════════

cat > "$HOME/.config/hyprcandy/hooks/hyprland_gaps_out_decrease.sh" << 'EOF'
#!/bin/bash

CONFIG_FILE="$HOME/.config/hyprcustom/custom.conf"

CURRENT_GAPS_OUT=$(grep -E "^\s*gaps_out\s*=" "$CONFIG_FILE" | sed 's/.*gaps_out\s*=\s*\([0-9]*\).*/\1/')
NEW_GAPS_OUT=$((CURRENT_GAPS_OUT > 0 ? CURRENT_GAPS_OUT - 1 : 0))
sed -i "s/^\(\s*gaps_out\s*=\s*\)[0-9]*/\1$NEW_GAPS_OUT/" "$CONFIG_FILE"
hyprctl keyword general:gaps_out $NEW_GAPS_OUT
hyprctl reload

echo "🔽 Gaps OUT decreased: gaps_out=$NEW_GAPS_OUT"
notify-send "Gaps OUT Decreased" "gaps_out: $NEW_GAPS_OUT" -t 2000
EOF

# ═══════════════════════════════════════════════════════════════
#                    Gaps IN Increase Script
# ═══════════════════════════════════════════════════════════════

cat > "$HOME/.config/hyprcandy/hooks/hyprland_gaps_in_increase.sh" << 'EOF'
#!/bin/bash

CONFIG_FILE="$HOME/.config/hyprcustom/custom.conf"
CURRENT_GAPS_IN=$(grep -E "^\s*gaps_in\s*=" "$CONFIG_FILE" | sed 's/.*gaps_in\s*=\s*\([0-9]*\).*/\1/')
NEW_GAPS_IN=$((CURRENT_GAPS_IN + 1))
sed -i "s/^\(\s*gaps_in\s*=\s*\)[0-9]*/\1$NEW_GAPS_IN/" "$CONFIG_FILE"
hyprctl keyword general:gaps_in $NEW_GAPS_IN
hyprctl reload

echo "🔼 Gaps IN increased: gaps_in=$NEW_GAPS_IN"
notify-send "Gaps IN Increased" "gaps_in: $NEW_GAPS_IN" -t 2000
EOF

# ═══════════════════════════════════════════════════════════════
#                    Gaps IN Decrease Script
# ═══════════════════════════════════════════════════════════════

cat > "$HOME/.config/hyprcandy/hooks/hyprland_gaps_in_decrease.sh" << 'EOF'
#!/bin/bash

CONFIG_FILE="$HOME/.config/hyprcustom/custom.conf"
CURRENT_GAPS_IN=$(grep -E "^\s*gaps_in\s*=" "$CONFIG_FILE" | sed 's/.*gaps_in\s*=\s*\([0-9]*\).*/\1/')
NEW_GAPS_IN=$((CURRENT_GAPS_IN > 0 ? CURRENT_GAPS_IN - 1 : 0))
sed -i "s/^\(\s*gaps_in\s*=\s*\)[0-9]*/\1$NEW_GAPS_IN/" "$CONFIG_FILE"
hyprctl keyword general:gaps_in $NEW_GAPS_IN
hyprctl reload

echo "🔽 Gaps IN decreased: gaps_in=$NEW_GAPS_IN"
notify-send "Gaps IN Decreased" "gaps_in: $NEW_GAPS_IN" -t 2000
EOF

# ═══════════════════════════════════════════════════════════════
#                Border Increase Script with Force Options
# ═══════════════════════════════════════════════════════════════

cat > "$HOME/.config/hyprcandy/hooks/hyprland_border_increase.sh" << 'EOF'
#!/bin/bash

CONFIG_FILE="$HOME/.config/hyprcustom/custom.conf"
CURRENT_BORDER=$(grep -E "^\s*border_size\s*=" "$CONFIG_FILE" | sed 's/.*border_size\s*=\s*\([0-9]*\).*/\1/')
NEW_BORDER=$((CURRENT_BORDER + 1))
sed -i "s/^\(\s*border_size\s*=\s*\)[0-9]*/\1$NEW_BORDER/" "$CONFIG_FILE"
hyprctl keyword general:border_size $NEW_BORDER
hyprctl reload

echo "🔼 Border increased: border_size=$NEW_BORDER"
notify-send "Border Increased" "border_size: $NEW_BORDER" -t 2000
EOF

# ═══════════════════════════════════════════════════════════════
#                Border Decrease Script with Force Options
# ═══════════════════════════════════════════════════════════════

cat > "$HOME/.config/hyprcandy/hooks/hyprland_border_decrease.sh" << 'EOF'
#!/bin/bash

CONFIG_FILE="$HOME/.config/hyprcustom/custom.conf"

CURRENT_BORDER=$(grep -E "^\s*border_size\s*=" "$CONFIG_FILE" | sed 's/.*border_size\s*=\s*\([0-9]*\).*/\1/')
NEW_BORDER=$((CURRENT_BORDER > 0 ? CURRENT_BORDER - 1 : 0))
sed -i "s/^\(\s*border_size\s*=\s*\)[0-9]*/\1$NEW_BORDER/" "$CONFIG_FILE"

hyprctl keyword general:border_size $NEW_BORDER
hyprctl reload

echo "🔽 Border decreased: border_size=$NEW_BORDER"
notify-send "Border Decreased" "border_size: $NEW_BORDER" -t 2000
EOF

# ═══════════════════════════════════════════════════════════════
#                Rounding Increase Script with Force Options
# ═══════════════════════════════════════════════════════════════

cat > "$HOME/.config/hyprcandy/hooks/hyprland_rounding_increase.sh" << 'EOF'
#!/bin/bash

CONFIG_FILE="$HOME/.config/hyprcustom/custom.conf"
CURRENT_ROUNDING=$(grep -E "^\s*rounding\s*=" "$CONFIG_FILE" | sed 's/.*rounding\s*=\s*\([0-9]*\).*/\1/')
NEW_ROUNDING=$((CURRENT_ROUNDING + 1))
sed -i "s/^\(\s*rounding\s*=\s*\)[0-9]*/\1$NEW_ROUNDING/" "$CONFIG_FILE"

hyprctl keyword decoration:rounding $NEW_ROUNDING
hyprctl reload

echo "🔼 Rounding increased: rounding=$NEW_ROUNDING"
notify-send "Rounding Increased" "rounding: $NEW_ROUNDING" -t 2000
EOF

# ═══════════════════════════════════════════════════════════════
#                Rounding Decrease Script with Force Options
# ═══════════════════════════════════════════════════════════════

cat > "$HOME/.config/hyprcandy/hooks/hyprland_rounding_decrease.sh" << 'EOF'
#!/bin/bash

CONFIG_FILE="$HOME/.config/hyprcustom/custom.conf"
CURRENT_ROUNDING=$(grep -E "^\s*rounding\s*=" "$CONFIG_FILE" | sed 's/.*rounding\s*=\s*\([0-9]*\).*/\1/')
NEW_ROUNDING=$((CURRENT_ROUNDING > 0 ? CURRENT_ROUNDING - 1 : 0))
sed -i "s/^\(\s*rounding\s*=\s*\)[0-9]*/\1$NEW_ROUNDING/" "$CONFIG_FILE"

hyprctl keyword decoration:rounding $NEW_ROUNDING
hyprctl reload

echo "🔽 Rounding decreased: rounding=$NEW_ROUNDING"
notify-send "Rounding Decreased" "rounding: $NEW_ROUNDING" -t 2000
EOF

# ═══════════════════════════════════════════════════════════════
#                    Gaps + Border Presets Script
# ═══════════════════════════════════════════════════════════════

cat > "$HOME/.config/hyprcandy/hooks/hyprland_gap_presets.sh" << 'EOF'
#!/bin/bash

CONFIG_FILE="$HOME/.config/hyprcustom/custom.conf"

case "$1" in
    "minimal")
        GAPS_OUT=2
        GAPS_IN=1
        BORDER=2
        ROUNDING=3
        ;;
    "balanced")
        GAPS_OUT=6
        GAPS_IN=4
        BORDER=3
        ROUNDING=10
        ;;
    "spacious")
        GAPS_OUT=10
        GAPS_IN=6
        BORDER=3
        ROUNDING=10
        ;;
    "zero")
        GAPS_OUT=0
        GAPS_IN=0
        BORDER=0
        ROUNDING=0
        ;;
    *)
        echo "Usage: $0 {minimal|balanced|spacious|zero}"
        exit 1
        ;;
esac

# Apply all settings
sed -i "s/^\(\s*gaps_out\s*=\s*\)[0-9]*/\1$GAPS_OUT/" "$CONFIG_FILE"
sed -i "s/^\(\s*gaps_in\s*=\s*\)[0-9]*/\1$GAPS_IN/" "$CONFIG_FILE"
sed -i "s/^\(\s*border_size\s*=\s*\)[0-9]*/\1$BORDER/" "$CONFIG_FILE"
sed -i "s/^\(\s*rounding\s*=\s*\)[0-9]*/\1$ROUNDING/" "$CONFIG_FILE"

# Apply immediately
hyprctl keyword general:gaps_out $GAPS_OUT
hyprctl keyword general:gaps_in $GAPS_IN
hyprctl keyword general:border_size $BORDER
hyprctl keyword decoration:rounding $ROUNDING

echo "🎨 Applied $1 preset: gaps_out=$GAPS_OUT, gaps_in=$GAPS_IN, border=$BORDER, rounding=$ROUNDING"
notify-send "Visual Preset Applied" "$1: OUT=$GAPS_OUT IN=$GAPS_IN BORDER=$BORDER ROUND=$ROUNDING" -t 3000
EOF

# ═══════════════════════════════════════════════════════════════
#                    Visual Status Display Script
# ═══════════════════════════════════════════════════════════════

cat > "$HOME/.config/hyprcandy/hooks/hyprland_status_display.sh" << 'EOF'
#!/bin/bash

CONFIG_FILE="$HOME/.config/hyprcustom/custom.conf"

GAPS_OUT=$(grep -E "^\s*gaps_out\s*=" "$CONFIG_FILE" | sed 's/.*gaps_out\s*=\s*\([0-9]*\).*/\1/')
GAPS_IN=$(grep -E "^\s*gaps_in\s*=" "$CONFIG_FILE" | sed 's/.*gaps_in\s*=\s*\([0-9]*\).*/\1/')
BORDER=$(grep -E "^\s*border_size\s*=" "$CONFIG_FILE" | sed 's/.*border_size\s*=\s*\([0-9]*\).*/\1/')
ROUNDING=$(grep -E "^\s*rounding\s*=" "$CONFIG_FILE" | sed 's/.*rounding\s*=\s*\([0-9]*\).*/\1/')

STATUS="🎨 Hyprland Visual Settings
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🔲 Gaps OUT (screen edges): $GAPS_OUT
🔳 Gaps IN (between windows): $GAPS_IN
🔸 Border size: $BORDER
🔘 Corner rounding: $ROUNDING
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

echo "$STATUS"
notify-send "Visual Settings Status" "OUT:$GAPS_OUT IN:$GAPS_IN BORDER:$BORDER ROUND:$ROUNDING" -t 5000
EOF

# ═══════════════════════════════════════════════════════════════
#                  Make Hyprland Scripts Executable
# ═══════════════════════════════════════════════════════════════

chmod +x "$HOME/.config/hyprcandy/hooks/hyprland_gaps_out_increase.sh"
chmod +x "$HOME/.config/hyprcandy/hooks/hyprland_gaps_out_decrease.sh"
chmod +x "$HOME/.config/hyprcandy/hooks/hyprland_gaps_in_increase.sh"
chmod +x "$HOME/.config/hyprcandy/hooks/hyprland_gaps_in_decrease.sh"
chmod +x "$HOME/.config/hyprcandy/hooks/hyprland_border_increase.sh"
chmod +x "$HOME/.config/hyprcandy/hooks/hyprland_border_decrease.sh"
chmod +x "$HOME/.config/hyprcandy/hooks/hyprland_rounding_increase.sh"
chmod +x "$HOME/.config/hyprcandy/hooks/hyprland_rounding_decrease.sh"
chmod +x "$HOME/.config/hyprcandy/hooks/hyprland_gap_presets.sh"
chmod +x "$HOME/.config/hyprcandy/hooks/hyprland_status_display.sh"

echo "✅ Hyprland adjustment scripts created and made executable!"

# ═══════════════════════════════════════════════════════════════
#                 SERVICES BASED ON CHOSEN BAR
# ═══════════════════════════════════════════════════════════════
if [ "$PANEL_CHOICE" = "waybar" ]; then

# ═══════════════════════════════════════════════════════════════
#                      Startup with Waybar
# ═══════════════════════════════════════════════════════════════

cat > "$HOME/.config/hyprcandy/hooks/startup_services.sh" << 'EOF'
#!/bin/bash

# Define colors file path
COLORS_FILE="$HOME/.config/hyprcandy/nwg_dock_colors.conf"

# Function to initialize colors file
initialize_colors_file() {
    echo "🎨 Initializing colors file..."
    
    mkdir -p "$(dirname "$COLORS_FILE")"
    local css_file="$HOME/.config/nwg-dock-hyprland/colors.css"
    
    if [ -f "$css_file" ]; then
        grep -E "@define-color (blur_background8|primary)" "$css_file" > "$COLORS_FILE"
        echo "✅ Colors file initialized with current values"
    else
        touch "$COLORS_FILE"
        echo "⚠️ CSS file not found, created empty colors file"
    fi
}

# MAIN EXECUTION
initialize_colors_file
echo "🎯 All services started successfully"
EOF

else

# ═══════════════════════════════════════════════════════════════
#                      Startup with Hyprpanel
# ═══════════════════════════════════════════════════════════════

cat > "$HOME/.config/hyprcandy/hooks/startup_services.sh" << 'EOF'
#!/bin/bash

# Define colors file path
COLORS_FILE="$HOME/.config/hyprcandy/nwg_dock_colors.conf"

# Function to initialize colors file
initialize_colors_file() {
    echo "🎨 Initializing colors file..."
    
    mkdir -p "$(dirname "$COLORS_FILE")"
    local css_file="$HOME/.config/nwg-dock-hyprland/colors.css"
    
    if [ -f "$css_file" ]; then
        grep -E "@define-color (blur_background8|primary)" "$css_file" > "$COLORS_FILE"
        echo "✅ Colors file initialized with current values"
    else
        touch "$COLORS_FILE"
        echo "⚠️ CSS file not found, created empty colors file"
    fi
}

wait_for_hyprpanel() {
    echo "⏳ Waiting for hyprpanel to initialize..."
    local max_wait=30
    local count=0

    while [ $count -lt $max_wait ]; do
        if pgrep -f "gjs" > /dev/null 2>&1; then
            echo "✅ hyprpanel is running"
            sleep 0.5
            return 0
        fi
        sleep 0.5
        ((count++))
    done

    echo "⚠️ hyprpanel may not have started properly"
    return 1
}

restart_swww() {
    echo "🔄 Restarting swww-daemon..."
    pkill swww-daemon 2>/dev/null
    sleep 0.5
    swww-daemon &
    sleep 1
    echo "✅ swww-daemon restarted"
}

# MAIN EXECUTION
initialize_colors_file
    
if wait_for_hyprpanel; then
    sleep 0.5
    restart_swww
else
    echo "⚠️ Proceeding with swww restart anyway..."
    restart_swww
fi

echo "🎯 All services started successfully"
EOF

chmod +x "$HOME/.config/hyprcandy/hooks/startup_services.sh"
fi

# ═══════════════════════════════════════════════════════════════
#                      Cursor Update Script
# ═══════════════════════════════════════════════════════════════

cat > "$HOME/.config/hyprcandy/hooks/watch_cursor_theme.sh" << 'EOF'
#!/bin/bash

GTK3_FILE="$HOME/.config/gtk-3.0/settings.ini"
GTK4_FILE="$HOME/.config/gtk-4.0/settings.ini"
HYPRCONF="$HOME/.config/hyprcustom/custom.conf"

get_value() {
    grep -E "^$1=" "$1" 2>/dev/null | cut -d'=' -f2 | tr -d ' '
}

extract_cursor_theme() {
    grep -E "^gtk-cursor-theme-name=" "$1" | cut -d'=' -f2 | tr -d ' '
}

extract_cursor_size() {
    grep -E "^gtk-cursor-theme-size=" "$1" | cut -d'=' -f2 | tr -d ' '
}

update_hypr_cursor_env() {
    local theme="$1"
    local size="$2"

    [ -z "$theme" ] && return
    [ -z "$size" ] && return

    # Replace each env line using sed
    sed -i "s|^env = XCURSOR_THEME,.*|env = XCURSOR_THEME,$theme|" "$HYPRCONF"
    sed -i "s|^env = XCURSOR_SIZE,.*|env = XCURSOR_SIZE,$size|" "$HYPRCONF"
    sed -i "s|^env = HYPRCURSOR_THEME,.*|env = HYPRCURSOR_THEME,$theme|" "$HYPRCONF"
    sed -i "s|^env = HYPRCURSOR_SIZE,.*|env = HYPRCURSOR_SIZE,$size|" "$HYPRCONF"

    echo "✅ Updated cursor theme and size: $theme / $size"
}

watch_gtk_file() {
    local file="$1"
    echo "🔍 Watching $file for cursor changes..."
    inotifywait -m -e modify "$file" | while read -r; do
        theme=$(extract_cursor_theme "$file")
        size=$(extract_cursor_size "$file")
        update_hypr_cursor_env "$theme" "$size"
    done
}

# Initial sync if file exists
for gtk_file in "$GTK3_FILE" "$GTK4_FILE"; do
    if [ -f "$gtk_file" ]; then
        theme=$(extract_cursor_theme "$gtk_file")
        size=$(extract_cursor_size "$gtk_file")
        update_hypr_cursor_env "$theme" "$size"
    fi
done

# Start watchers in background
watch_gtk_file "$GTK3_FILE" &
watch_gtk_file "$GTK4_FILE" &
wait
EOF

chmod +x "$HOME/.config/hyprcandy/hooks/watch_cursor_theme.sh"

# ═══════════════════════════════════════════════════════════════
#                    Cursor Update Service
# ═══════════════════════════════════════════════════════════════

cat > "$HOME/.config/systemd/user/cursor-theme-watcher.service" << 'EOF'
[Unit]
Description=Watch GTK cursor theme and size changes
After=graphical-session.target

[Service]
Type=simple
ExecStart=%h/.config/hyprcandy/hooks/watch_cursor_theme.sh
Restart=on-failure

[Install]
WantedBy=default.target
EOF

if [ "$PANEL_CHOICE" = "waybar" ]; then

echo

else

# ═══════════════════════════════════════════════════════════════
#                  Clear Swww Cache Script
# ═══════════════════════════════════════════════════════════════

cat > "$HOME/.config/hyprcandy/hooks/clear_swww.sh" << 'EOF'
#!/bin/bash
CACHE_DIR="$HOME/.cache/swww"
[ -d "$CACHE_DIR" ] && rm -rf "$CACHE_DIR"
EOF
chmod +x "$HOME/.config/hyprcandy/hooks/clear_swww.sh"
fi

if [ "$PANEL_CHOICE" = "waybar" ]; then
# ═══════════════════════════════════════════════════════════════
#                  Background Update Script
# ═══════════════════════════════════════════════════════════════

cat > "$HOME/.config/hyprcandy/hooks/update_background.sh" << 'EOF'
#!/bin/bash
set +e
# Define colors file path
COLORS_FILE="$HOME/.config/hyprcandy/nwg_dock_colors.conf"

# Update local background.png
if command -v magick >/dev/null && [ -f "$HOME/.config/background" ]; then
    magick "$HOME/.config/background[0]" "$HOME/.config/background.png"
    
    # Check if colors have changed and launch dock if different
    colors_file="$HOME/.config/nwg-dock-hyprland/colors.css"
    
    # Get current colors from CSS file
    get_current_colors() {
        if [ -f "$colors_file" ]; then
            grep -E "@define-color (blur_background8|primary)" "$colors_file"
        fi
    }
    
    # Get stored colors from our tracking file
    get_stored_colors() {
        if [ -f "$COLORS_FILE" ]; then
            cat "$COLORS_FILE"
        fi
    }
    
    # Compare colors and launch dock if different
    if [ -f "$colors_file" ]; then
        current_colors=$(get_current_colors)
        stored_colors=$(get_stored_colors)
        
        if [ "$current_colors" != "$stored_colors" ]; then
            # Colors have changed, reload dock
            pkill -f mwg-dock-hyprland
            sleep 0.3
            "$HOME/.config/nwg-dock-hyprland/launch.sh" >/dev/null 2>&1 &
            # Update stored colors file with new colors
            mkdir -p "$(dirname "$COLORS_FILE")"
            echo "$current_colors" > "$COLORS_FILE"
            echo "🎨 Updated dock colors and launched dock"
        else
            echo "🎨 Colors unchanged, skipping dock launch"
        fi
    else
        # Fallback if colors.css doesn't exist
        "$HOME/.config/nwg-dock-hyprland/launch.sh" >/dev/null 2>&1 &
        echo "🎨 Colors file not found, launched dock anyway"
    fi
fi

sleep 1

# Update SDDM background with sudo and reload the dock
if command -v magick >/dev/null && [ -f "$HOME/.config/background" ]; then
    sudo magick "$HOME/.config/background[0]" "/usr/share/sddm/themes/sugar-candy/Backgrounds/Mountain.jpg"
    sleep 1
fi

# Update mako config colors from nwg-dock-hyprland/colors.css
MAKO_CONFIG="$HOME/.config/mako/config"
COLORS_CSS="$HOME/.config/nwg-dock-hyprland/colors.css"

if [ -f "$COLORS_CSS" ] && [ -f "$MAKO_CONFIG" ]; then
    # Extract hex values from colors.css, removing trailing semicolons and newlines
    ON_PRIMARY_FIXED_VARIANT=$(grep -E "@define-color[[:space:]]+on_primary_fixed_variant" "$COLORS_CSS" | awk '{print $3}' | tr -d ';' | tr -d '\n')
    PRIMARY_FIXED_DIM=$(grep -E "@define-color[[:space:]]+primary_fixed_dim" "$COLORS_CSS" | awk '{print $3}' | tr -d ';' | tr -d '\n')
    SCIM=$(grep -E "@define-color[[:space:]]+scrim" "$COLORS_CSS" | awk '{print $3}' | tr -d ';' | tr -d '\n')

    # Only proceed if both colors are found
    if [[ $ON_PRIMARY_FIXED_VARIANT =~ ^#([A-Fa-f0-9]{6})$ ]] && [[ $PRIMARY_FIXED_DIM =~ ^#([A-Fa-f0-9]{6})$ ]]; then
        # Update all background-color, progress-color, and border-color lines in mako config
        sed -i "s|^background-color=#.*|background-color=$ON_PRIMARY_FIXED_VARIANT|g" "$MAKO_CONFIG"
        sed -i "s|^progress-color=#.*|progress-color=$SCIM|g" "$MAKO_CONFIG"
        sed -i "s|^border-color=#.*|border-color=$PRIMARY_FIXED_DIM|g" "$MAKO_CONFIG"
        pkill -f mako
        sleep 1
        mako &
        echo "🎨 Updated ALL mako config colors: background-color=$ON_PRIMARY_FIXED_VARIANT, progress-color=$SCIM, border-color=$PRIMARY_FIXED_DIM"
    else
        echo "⚠️  Could not extract required color values from $COLORS_CSS"
    fi
else
    echo "⚠️  $COLORS_CSS or $MAKO_CONFIG not found, skipping mako color update"
fi
EOF

else

cat > "$HOME/.config/hyprcandy/hooks/update_background.sh" << 'EOF'
#!/bin/bash
set +e
# Define colors file path
COLORS_FILE="$HOME/.config/hyprcandy/nwg_dock_colors.conf"

# Update local background.png
if command -v magick >/dev/null && [ -f "$HOME/.config/background" ]; then
    wallust run ~/.config/background &
    magick "$HOME/.config/background[0]" "$HOME/.config/background.png"
   
    # Check if colors have changed and launch dock if different
    colors_file="$HOME/.config/nwg-dock-hyprland/colors.css"
    
    # Get current colors from CSS file
    get_current_colors() {
        if [ -f "$colors_file" ]; then
            grep -E "@define-color (blur_background8|primary)" "$colors_file"
        fi
    }
    
    # Get stored colors from our tracking file
    get_stored_colors() {
        if [ -f "$COLORS_FILE" ]; then
            cat "$COLORS_FILE"
        fi
    }
    
    # Compare colors and launch dock if different
    if [ -f "$colors_file" ]; then
        current_colors=$(get_current_colors)
        stored_colors=$(get_stored_colors)
        
        if [ "$current_colors" != "$stored_colors" ]; then
            # Colors have changed, reload dock
            pkill -f mwg-dock-hyprland
            sleep 0.3
            "$HOME/.config/nwg-dock-hyprland/launch.sh" >/dev/null 2>&1 &
            # Update stored colors file with new colors
            mkdir -p "$(dirname "$COLORS_FILE")"
            echo "$current_colors" > "$COLORS_FILE"
            echo "🎨 Updated dock colors and launched dock"
        else
            echo "🎨 Colors unchanged, skipping dock launch"
        fi
    else
        # Fallback if colors.css doesn't exist
        "$HOME/.config/nwg-dock-hyprland/launch.sh" >/dev/null 2>&1 &
        echo "🎨 Colors file not found, launched dock anyway"
    fi
fi

sleep 1

# Update SDDM background with sudo and reload the dock
if command -v magick >/dev/null && [ -f "$HOME/.config/background" ]; then
    sudo magick "$HOME/.config/background[0]" "/usr/share/sddm/themes/sugar-candy/Backgrounds/Mountain.jpg"
    sleep 1
fi

# Update mako config colors from nwg-dock-hyprland/colors.css
MAKO_CONFIG="$HOME/.config/mako/config"
COLORS_CSS="$HOME/.config/nwg-dock-hyprland/colors.css"

if [ -f "$COLORS_CSS" ] && [ -f "$MAKO_CONFIG" ]; then
    # Extract hex values from colors.css, removing trailing semicolons and newlines
    ON_PRIMARY_FIXED_VARIANT=$(grep -E "@define-color[[:space:]]+on_primary_fixed_variant" "$COLORS_CSS" | awk '{print $3}' | tr -d ';' | tr -d '\n')
    PRIMARY_FIXED_DIM=$(grep -E "@define-color[[:space:]]+primary_fixed_dim" "$COLORS_CSS" | awk '{print $3}' | tr -d ';' | tr -d '\n')
    SCIM=$(grep -E "@define-color[[:space:]]+scrim" "$COLORS_CSS" | awk '{print $3}' | tr -d ';' | tr -d '\n')

    # Only proceed if both colors are found
    if [[ $ON_PRIMARY_FIXED_VARIANT =~ ^#([A-Fa-f0-9]{6})$ ]] && [[ $PRIMARY_FIXED_DIM =~ ^#([A-Fa-f0-9]{6})$ ]]; then
        # Update all background-color, progress-color, and border-color lines in mako config
        sed -i "s|^background-color=#.*|background-color=$ON_PRIMARY_FIXED_VARIANT|g" "$MAKO_CONFIG"
        sed -i "s|^progress-color=#.*|progress-color=$SCIM|g" "$MAKO_CONFIG"
        sed -i "s|^border-color=#.*|border-color=$PRIMARY_FIXED_DIM|g" "$MAKO_CONFIG"
        pkill -f mako
        sleep 1
        mako &
        echo "🎨 Updated ALL mako config colors: background-color=$ON_PRIMARY_FIXED_VARIANT, progress-color=$SCIM, border-color=$PRIMARY_FIXED_DIM"
    else
        echo "⚠️  Could not extract required color values from $COLORS_CSS"
    fi
else
    echo "⚠️  $COLORS_CSS or $MAKO_CONFIG not found, skipping mako color update"
fi
EOF
fi

chmod +x "$HOME/.config/hyprcandy/hooks/update_background.sh"

# ═══════════════════════════════════════════════════════════════
#              Background File & Matugen Watcher
# ═══════════════════════════════════════════════════════════════

cat > "$HOME/.config/hyprcandy/hooks/watch_background.sh" << 'EOF'
#!/bin/bash
CONFIG_BG="$HOME/.config/background"
HOOKS_DIR="$HOME/.config/hyprcandy/hooks"
COLORS_CSS="$HOME/.config/nwg-dock-hyprland/colors.css"

while [ -z "$HYPRLAND_INSTANCE_SIGNATURE" ]; do
    echo "Waiting for Hyprland to start..."
    sleep 1
done
echo "Hyprland started"

# Function to execute hooks
execute_hooks() {
    echo "🎯 Executing hooks..."
    "$HOOKS_DIR/clear_swww.sh"
    "$HOOKS_DIR/update_background.sh"
}

# Function to monitor matugen process
monitor_matugen() {
    echo "🎨 Matugen detected, waiting for completion..."
    
    # Wait for matugen to finish
    while pgrep -x "matugen" > /dev/null 2>&1; do
        sleep 0.1
    done
    
    # Additional 3-second wait for file writes to complete
    sleep 3
    
    echo "✅ Matugen finished, executing hooks"
    execute_hooks
}

# ⏳ Wait for background file to exist
while [ ! -f "$CONFIG_BG" ]; do
    echo "⏳ Waiting for background file to appear..."
    sleep 0.5
done

echo "🚀 Starting background and matugen monitoring..."

# Start background monitoring in background
{
    inotifywait -m -e close_write "$CONFIG_BG" | while read -r file; do
        echo "🎯 Detected background update: $file"
        
        # Check if matugen is running
        if pgrep -x "matugen" > /dev/null 2>&1; then
            echo "🎨 Matugen is running, will wait for completion..."
            monitor_matugen
        else
            execute_hooks
        fi
    done
} &

# Start matugen process monitoring
{
    while true; do
        # Wait for matugen to start
        while ! pgrep -x "matugen" > /dev/null 2>&1; do
            sleep 0.5
        done
        
        echo "🎨 Matugen process detected!"
        monitor_matugen
    done
} &

# Wait for any child process to exit
wait
EOF

chmod +x "$HOME/.config/hyprcandy/hooks/watch_background.sh"

# ═══════════════════════════════════════════════════════════════
#            Systemd Service: Background Watcher
# ═══════════════════════════════════════════════════════════════

cat > "$HOME/.config/systemd/user/background-watcher.service" << 'EOF'
[Unit]
Description=Watch ~/.config/background, clear swww cache and update background images
After=graphical-session.target hyprland-session.target

[Service]
ExecStart=%h/.config/hyprcandy/hooks/watch_background.sh
Restart=on-failure

[Install]
WantedBy=graphical-session.target
EOF

if [ "$PANEL_CHOICE" = "waybar" ]; then

# ═══════════════════════════════════════════════════════════════
#         waybar_idle_monitor.sh — Auto Toggle Inhibitor
# ═══════════════════════════════════════════════════════════════

cat > "$HOME/.config/hyprcandy/hooks/waybar_idle_monitor.sh" << 'EOF'
#!/usr/bin/env bash
#
# waybar_idle_monitor.sh
#   - when waybar is NOT running: start our idle inhibitor
#   - when waybar IS running : stop our idle inhibitor
#   - ignores any other inhibitors

# ----------------------------------------------------------------------
# Configuration
# ----------------------------------------------------------------------
INHIBITOR_WHO="Waybar-Idle-Monitor"
CHECK_INTERVAL=5      # seconds between polls

# holds the PID of our systemd-inhibit process
IDLE_INHIBITOR_PID=""

# Wait for Hyprland to start
while [ -z "$HYPRLAND_INSTANCE_SIGNATURE" ]; do
  echo "Waiting for Hyprland to start..."
  sleep 1
done
echo "Hyprland started"
echo "🔍 Waiting for Waybar to start..."

# ----------------------------------------------------------------------
# Helpers
# ----------------------------------------------------------------------

# Returns 0 if our inhibitor is already active
has_our_inhibitor() {
  systemd-inhibit --list 2>/dev/null \
    | grep -F "$INHIBITOR_WHO" \
    >/dev/null 2>&1
}

# Returns 0 if waybar is running
is_waybar_running() {
  pgrep -x waybar >/dev/null 2>&1
}

# ----------------------------------------------------------------------
# Start / stop our inhibitor
# ----------------------------------------------------------------------

start_idle_inhibitor() {
  if has_our_inhibitor; then
    echo "$(date): [INFO] Idle inhibitor already active."
    return
  fi

  echo "$(date): [INFO] Starting idle inhibitor (waybar down)…"
  systemd-inhibit \
    --what=idle \
    --who="$INHIBITOR_WHO" \
    --why="waybar not running — keep screen awake" \
    sleep infinity &
  IDLE_INHIBITOR_PID=$!
}

stop_idle_inhibitor() {
  if [ -n "$IDLE_INHIBITOR_PID" ] && kill -0 "$IDLE_INHIBITOR_PID" 2>/dev/null; then
    echo "$(date): [INFO] Stopping idle inhibitor (waybar back)…"
    kill "$IDLE_INHIBITOR_PID"
    IDLE_INHIBITOR_PID=""
  elif has_our_inhibitor; then
    # fallback if we lost track of the PID
    echo "$(date): [INFO] Killing stray idle inhibitor by tag…"
    pkill -f "systemd-inhibit.*$INHIBITOR_WHO"
  fi
}

# ----------------------------------------------------------------------
# Cleanup on exit
# ----------------------------------------------------------------------

cleanup() {
  echo "$(date): [INFO] Exiting — cleaning up."
  stop_idle_inhibitor
  exit 0
}

trap cleanup SIGINT SIGTERM

# ----------------------------------------------------------------------
# Main
# ----------------------------------------------------------------------

echo "$(date): [INFO] Starting Waybar idle monitor…"
echo "       CHECK_INTERVAL=${CHECK_INTERVAL}s, INHIBITOR_WHO=$INHIBITOR_WHO"

# Initial state
if is_waybar_running; then
  stop_idle_inhibitor
else
  start_idle_inhibitor
fi

# Poll loop
while true; do
  if is_waybar_running; then
    stop_idle_inhibitor
  else
    start_idle_inhibitor
  fi
  sleep "$CHECK_INTERVAL"
done
EOF

chmod +x "$HOME/.config/hyprcandy/hooks/waybar_idle_monitor.sh"

# ═══════════════════════════════════════════════════════════════
#        Systemd Service: waybar Idle Inhibitor Monitor
# ═══════════════════════════════════════════════════════════════

cat > "$HOME/.config/systemd/user/waybar-idle-monitor.service" << 'EOF'
[Unit]
Description=Waybar Idle Inhibitor Monitor
After=graphical-session.target
Wants=graphical-session.target

[Service]
Type=simple
# Make sure this path matches where you put your script:
ExecStart=%h/.config/hyprcandy/hooks/waybar_idle_monitor.sh
Restart=always
RestartSec=10

[Install]
WantedBy=default.target
EOF

# ═══════════════════════════════════════════════════════════════
#             Waybar Restart and Kill Scripts
# ═══════════════════════════════════════════════════════════════

cat > "$HOME/.config/hyprcandy/hooks/restart_waybar.sh" << 'EOF'
#!/bin/bash
systemctl --user restart waybar.service
EOF

cat > "$HOME/.config/hyprcandy/hooks/kill_waybar_safe.sh" << 'EOF'
#!/bin/bash
systemctl --user stop waybar.service
pkill -x waybar
EOF

chmod +x "$HOME/.config/hyprcandy/hooks/restart_waybar.sh"
chmod +x "$HOME/.config/hyprcandy/hooks/kill_waybar_safe.sh"

# ═══════════════════════════════════════════════════════════════
#               Waypaper Integration Scripts
# ═══════════════════════════════════════════════════════════════
    cat > "$HOME/.config/hyprcandy/hooks/waypaper_integration.sh" << 'EOF'
#!/bin/bash
CONFIG_BG="$HOME/.config/background"
WAYPAPER_CONFIG="$HOME/.config/waypaper/config.ini"
MATUGEN_CONFIG="$HOME/.config/matugen/config.toml"
get_waypaper_background() {
    if [ -f "$WAYPAPER_CONFIG" ]; then
        # Parse INI format: look for "wallpaper = " line in the config file
        current_bg=$(grep "^wallpaper = " "$WAYPAPER_CONFIG" | cut -d'=' -f2- | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')
        if [ -n "$current_bg" ]; then
            # Expand tilde to actual home directory path
            current_bg=$(echo "$current_bg" | sed "s|^~|$HOME|")
            echo "$current_bg"
            return 0
        fi
    fi
    return 1
}
update_config_background() {
    local bg_path="$1"
    if [ -f "$bg_path" ]; then
        magick "$bg_path" "$HOME/.config/background" 
        echo "✅ Updated ~/.config/background to point to: $bg_path"
        return 0
    else
        echo "❌ Background file not found: $bg_path"
        return 1
    fi
}
trigger_matugen() {
    if [ -f "$MATUGEN_CONFIG" ]; then
        echo "🎨 Triggering matugen color generation..."
        matugen image "$CONFIG_BG" --type scheme-content --contrast 0.6 &
        echo "✅ Matugen color generation started"
    else
        echo "⚠️  Matugen config not found at: $MATUGEN_CONFIG"
    fi
}
trigger_wallust() {
    if command -v wallust >/dev/null 2>&1; then
        echo "🎨 Triggering wallust color generation..."
        wallust run ~/.config/background &
        echo "✅ Wallust color generation started"
    else
        echo "⚠️  Wallust not found"
    fi
}
execute_color_generation() {
    echo "🚀 Starting color generation for new background..."
    trigger_matugen
    trigger_wallust
    sleep 1
    echo "✅ Color generation processes initiated"
}
main() {
    echo "🎯 Waypaper integration triggered"
    current_bg=$(get_waypaper_background)
    if [ $? -eq 0 ]; then
        echo "📸 Current Waypaper background: $current_bg"
        if update_config_background "$current_bg"; then
            execute_color_generation
        fi
    else
        echo "⚠️  Could not determine current Waypaper background"
    fi
}
main
EOF
    chmod +x "$HOME/.config/hyprcandy/hooks/waypaper_integration.sh"

    cat > "$HOME/.config/hyprcandy/hooks/waypaper_watcher.sh" << 'EOF'
#!/bin/bash
WAYPAPER_CONFIG="$HOME/.config/waypaper/config.ini"
INTEGRATION_SCRIPT="$HOME/.config/hyprcandy/hooks/waypaper_integration.sh"
wait_for_config() {
    while [ -z "$HYPRLAND_INSTANCE_SIGNATURE" ]; do
        echo "Waiting for Hyprland to start..."
        sleep 1
    done
    echo "Hyprland started"
    echo "🔍 Waiting for Waypaper config to appear..."
    while [ ! -f "$WAYPAPER_CONFIG" ]; do
        echo "⏳ Waiting for Waypaper config to appear..."
        sleep 1
    done
    echo "✅ Waypaper config found"
}
monitor_waypaper() {
    echo "🔍 Starting Waypaper config monitoring..."
    wait_for_config
    inotifywait -m -e modify "$WAYPAPER_CONFIG" | while read -r path action file; do
        echo "🎯 Waypaper config changed, triggering integration..."
        sleep 0.5
        "$INTEGRATION_SCRIPT"
    done
}
initial_setup() {
    echo "🚀 Initial Waypaper integration setup..."
    wait_for_config
    "$INTEGRATION_SCRIPT"
    monitor_waypaper
}
echo "🎨 Starting Waypaper integration watcher..."
initial_setup
EOF
    chmod +x "$HOME/.config/hyprcandy/hooks/waypaper_watcher.sh"

# ═══════════════════════════════════════════════════════════════
#               Systemd Service: Waypaper Watcher
# ═══════════════════════════════════════════════════════════════
    cat > "$HOME/.config/systemd/user/waypaper-watcher.service" << 'EOF'
[Unit]
Description=Monitor Waypaper config changes and trigger color generation
After=graphical-session.target

[Service]
Type=simple
ExecStart=%h/.config/hyprcandy/hooks/waypaper_watcher.sh
Restart=always
RestartSec=10
KillMode=mixed
KillSignal=SIGTERM
TimeoutStopSec=15

[Install]
WantedBy=default.target
EOF

else

# ═══════════════════════════════════════════════════════════════
#         hyprpanel_idle_monitor.sh — Auto Toggle Inhibitor
# ═══════════════════════════════════════════════════════════════

cat > "$HOME/.config/hyprcandy/hooks/hyprpanel_idle_monitor.sh" << 'EOF'
#!/bin/bash

IDLE_INHIBITOR_PID=""
MAKO_PID=""
CHECK_INTERVAL=5
INHIBITOR_WHO="HyprCandy-Monitor"

# Wait for Hyprland to start
while [ -z "$HYPRLAND_INSTANCE_SIGNATURE" ]; do
  echo "Waiting for Hyprland to start..."
  sleep 1
done
echo "Hyprland started"
echo "🔍 Waiting for hyprpanel to start..."

has_hyprpanel_inhibitor() {
    systemd-inhibit --list 2>/dev/null | grep -i "hyprpanel\|panel" >/dev/null 2>&1
}

has_our_inhibitor() {
    systemd-inhibit --list 2>/dev/null | grep "$INHIBITOR_WHO" >/dev/null 2>&1
}

is_mako_running() {
    pgrep -x "mako" > /dev/null 2>&1
}

start_mako() {
    if is_mako_running; then return; fi
    mako &
    MAKO_PID=$!
    sleep 1
}

stop_mako() {
    if [ -n "$MAKO_PID" ] && kill -0 "$MAKO_PID" 2>/dev/null; then
        kill "$MAKO_PID"
        MAKO_PID=""
    elif is_mako_running; then
        pkill -x "mako"
    fi
}

# Function to start idle inhibitor (only if hyprpanel doesn't have one)
start_idle_inhibitor() {
    if has_hyprpanel_inhibitor; then
        echo "$(date): Hyprpanel already has inhibitor"
        return
    fi
    if has_our_inhibitor; then
        echo "$(date): Our idle inhibitor is already active"
        return
    fi
    if [ -z "$IDLE_INHIBITOR_PID" ] || ! kill -0 "$IDLE_INHIBITOR_PID" 2>/dev/null; then
        systemd-inhibit --what=idle --who="$INHIBITOR_WHO" --why="Hyprpanel not running" sleep infinity &
        IDLE_INHIBITOR_PID=$!
    fi
}

stop_idle_inhibitor() {
    if [ -n "$IDLE_INHIBITOR_PID" ] && kill -0 "$IDLE_INHIBITOR_PID" 2>/dev/null; then
        kill "$IDLE_INHIBITOR_PID"
        IDLE_INHIBITOR_PID=""
    fi
}

is_hyprpanel_running() {
    pgrep -f "gjs" > /dev/null 2>&1
}

start_fallback_services() {
    start_idle_inhibitor
    start_mako
}

stop_fallback_services() {
    stop_idle_inhibitor
    stop_mako
}

cleanup() {
    stop_idle_inhibitor
    stop_mako
    exit 0
}

trap cleanup SIGTERM SIGINT

echo "$(date): Starting enhanced hyprpanel monitor..."
echo "$(date): WHO=$INHIBITOR_WHO, CHECK_INTERVAL=${CHECK_INTERVAL}s"

if is_hyprpanel_running; then
    stop_fallback_services
else
    start_fallback_services
fi

while true; do
    if is_hyprpanel_running; then
        if [ -n "$IDLE_INHIBITOR_PID" ] && kill -0 "$IDLE_INHIBITOR_PID" 2>/dev/null; then
            stop_fallback_services
        fi
    else
        needs_inhibitor=false
        needs_mako=false
        if [ -z "$IDLE_INHIBITOR_PID" ] || ! kill -0 "$IDLE_INHIBITOR_PID" 2>/dev/null; then
            if ! has_hyprpanel_inhibitor; then
                needs_inhibitor=true
            fi
        fi
        if ! is_mako_running; then
            needs_mako=true
        fi
        if $needs_inhibitor || $needs_mako; then
            if $needs_inhibitor; then start_idle_inhibitor; fi
            if $needs_mako; then start_mako; fi
        fi
    fi
    sleep "$CHECK_INTERVAL"
done
EOF

chmod +x "$HOME/.config/hyprcandy/hooks/hyprpanel_idle_monitor.sh"

# ═══════════════════════════════════════════════════════════════
#        Systemd Service: hyprpanel Idle Inhibitor Monitor
# ═══════════════════════════════════════════════════════════════

cat > "$HOME/.config/systemd/user/hyprpanel-idle-monitor.service" << 'EOF'
[Unit]
Description=Monitor hyprpanel and manage idle inhibitor
After=graphical-session.target
Wants=graphical-session.target

[Service]
Type=simple
ExecStart=%h/.config/hyprcandy/hooks/hyprpanel_idle_monitor.sh
Restart=always
RestartSec=10
KillMode=mixed
KillSignal=SIGTERM
TimeoutStopSec=15

[Install]
WantedBy=default.target
EOF

# ═══════════════════════════════════════════════════════════════
#             Safe hyprpanel Killer Script (Preserve swww)
# ═══════════════════════════════════════════════════════════════

cat > "$HOME/.config/hyprcandy/hooks/kill_hyprpanel_safe.sh" << 'EOF'
#!/bin/bash

echo "🔄 Safely closing hyprpanel while preserving swww-daemon..."

# Try graceful shutdown
if pgrep -f "hyprpanel" > /dev/null; then
    echo "📱 Attempting graceful shutdown..."
    hyprpanel -q
    sleep 1

    if pgrep -f "hyprpanel" > /dev/null; then
        echo "⚠️  Graceful shutdown failed, trying systemd stop..."
        systemctl --user stop hyprpanel.service
        sleep 1

        if pgrep -f "hyprpanel" > /dev/null; then
            echo "🔨 Force killing hyprpanel processes..."
            pkill -f "gjs.*hyprpanel"
        fi
    fi
fi

# Ensure swww-daemon continues running
if ! pgrep -f "swww-daemon" > /dev/null; then
    echo "🔄 swww-daemon not found, restarting it..."
    swww-daemon &
    sleep 1
    if [ -f "$HOME/.config/background" ]; then
        echo "🖼️  Restoring wallpaper..."
        swww img "$HOME/.config/background" --transition-type fade --transition-duration 1
    fi
fi

echo "✅ hyprpanel safely closed, swww-daemon preserved"
EOF

chmod +x "$HOME/.config/hyprcandy/hooks/kill_hyprpanel_safe.sh"

# ═══════════════════════════════════════════════════════════════
#             Hyprpanel Restart Script (via systemd)
# ═══════════════════════════════════════════════════════════════

cat > "$HOME/.config/hyprcandy/hooks/restart_hyprpanel.sh" << 'EOF'
#!/bin/bash

echo "🔄 Restarting hyprpanel via systemd..."

systemctl --user stop hyprpanel.service
sleep 0.5
systemctl --user start hyprpanel.service

echo "✅ Hyprpanel restarted"
EOF

chmod +x "$HOME/.config/hyprcandy/hooks/restart_hyprpanel.sh"

# ═══════════════════════════════════════════════════════════════
#             Systemd Service: Hyprpanel Launcher
# ═══════════════════════════════════════════════════════════════

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
RestartSec=6
KillMode=mixed
KillSignal=SIGTERM
TimeoutStopSec=10

# Don't restart if manually stopped (allows keybind control)
RestartPreventExitStatus=143

[Install]
WantedBy=graphical-session.target
EOF
fi

# ═══════════════════════════════════════════════════════════════
#      Script: Update Rofi Font from GTK Settings Font Name
# ═══════════════════════════════════════════════════════════════

cat > "$HOME/.config/hyprcandy/hooks/update_rofi_font.sh" << 'EOF'
#!/bin/bash

GTK_FILE="$HOME/.config/gtk-3.0/settings.ini"
ROFI_RASI="$HOME/.config/hyprcandy/settings/rofi-font.rasi"

# Get font name from GTK settings
GTK_FONT=$(grep "^gtk-font-name=" "$GTK_FILE" | cut -d'=' -f2-)

# Escape double quotes
GTK_FONT_ESCAPED=$(echo "$GTK_FONT" | sed 's/"/\\"/g')

# Update font line in rofi rasi config
if [ -f "$ROFI_RASI" ]; then
    sed -i "s|^.*font:.*|configuration { font: \"$GTK_FONT_ESCAPED\"; }|" "$ROFI_RASI"
    echo "✅ Updated Rofi font to: $GTK_FONT_ESCAPED"
else
    echo "⚠️  Rofi font config not found at: $ROFI_RASI"
fi
EOF

chmod +x "$HOME/.config/hyprcandy/hooks/update_rofi_font.sh"

# ═══════════════════════════════════════════════════════════════
#      Watcher: React to GTK Font Changes via nwg-look
# ═══════════════════════════════════════════════════════════════

cat > "$HOME/.config/hyprcandy/hooks/watch_gtk_font.sh" << 'EOF'
#!/bin/bash

GTK_FILE="$HOME/.config/gtk-3.0/settings.ini"
HOOK_SCRIPT="$HOME/.config/hyprcandy/hooks/update_rofi_font.sh"

# Wait until the GTK file exists
while [ ! -f "$GTK_FILE" ]; do
    sleep 1
done

# Initial update
"$HOOK_SCRIPT"

# Watch for font name changes
inotifywait -m -e modify "$GTK_FILE" | while read -r path event file; do
    if grep -q "^gtk-font-name=" "$GTK_FILE"; then
        "$HOOK_SCRIPT"
    fi
done
EOF

chmod +x "$HOME/.config/hyprcandy/hooks/watch_gtk_font.sh"

# ═══════════════════════════════════════════════════════════════
#      Systemd Service: GTK Font → Rofi Font Syncer
# ═══════════════════════════════════════════════════════════════

cat > "$HOME/.config/systemd/user/rofi-font-watcher.service" << 'EOF'
[Unit]
Description=Auto-update Rofi font when GTK font changes via nwg-look
After=graphical-session.target

[Service]
ExecStart=%h/.config/hyprcandy/hooks/watch_gtk_font.sh
Restart=on-failure

[Install]
WantedBy=default.target
EOF

# ═══════════════════════════════════════════════════════════════
#               Change Nwg-Dock Start Button Icon
# ═══════════════════════════════════════════════════════════════

cat > "$HOME/.config/hyprcandy/hooks/change_start_button_icon.sh" << 'EOF'
#!/bin/bash

# Change Start Button Icon
 # ⚙️ Step 1: Remove old grid.svg from nwg-dock-hyprland
 echo "🔄 Replacing 'grid.svg' in /usr/share/nwg-dock-hyprland/images..."

print_status "Removing old start button icon"

if cd /usr/share/nwg-dock-hyprland/images 2>/dev/null; then
    pkexec rm -f grid.svg && echo "🗑️  Removed old grid.svg"
else
    echo "❌ Failed to access /usr/share/nwg-dock-hyprland/images"
    exit 1
fi

# 🏠 Step 2: Return to home
cd "$HOME" || exit 1

# 📂 Step 3: Copy new grid.svg from custom SVG folder
SVG_SOURCE="$HOME/Pictures/Candy/Dock-SVGs/grid.svg"
SVG_DEST="/usr/share/nwg-dock-hyprland/images"

print_status "Changing start button icon"

if [ -f "$SVG_SOURCE" ]; then
    pkexec cp "$SVG_SOURCE" "$SVG_DEST" && echo "✅ grid.svg copied successfully."
    sleep 1
    #"$HOME/.config/nwg-dock-hyprland/launch.sh" >/dev/null 2>&1 &
    notify-send "Start Icon Changed" -t 2000
else
    echo "❌ grid.svg not found at $SVG_SOURCE"
    exit 1
fi
EOF
chmod +x "$HOME/.config/hyprcandy/hooks/change_start_button_icon.sh"

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
    
    # 📁 Copy Candy folder to ~/Pictures
    echo
    echo "📁 Attempting to copy 'Candy' images folder to ~/Pictures..."
    if [ -d "$hyprcandy_dir/Candy" ]; then
        if [ -d "$HOME/Pictures" ]; then
            cp -r "$hyprcandy_dir/Candy" "$HOME/Pictures/"
            echo "✅ 'Candy' copied successfully to ~/Pictures"
        else
            echo "⚠️  Skipped copy: '$HOME/Pictures' directory does not exist."
        fi
    else
        echo "⚠️  'Candy' folder not found in $hyprcandy_dir"
    fi

    # Change Start Button Icon
    # ⚙️ Step 1: Remove old grid.svg from nwg-dock-hyprland
    echo "🔄 Replacing 'grid.svg' in /usr/share/nwg-dock-hyprland/images..."

    print_status "Removing old start button icon"

    if cd /usr/share/nwg-dock-hyprland/images 2>/dev/null; then
        sudo rm -f grid.svg && echo "🗑️  Removed old grid.svg"
    else
        echo "❌ Failed to access /usr/share/nwg-dock-hyprland/images"
        exit 1
    fi

    # 🏠 Step 2: Return to home
    cd "$HOME" || exit 1

    # 📂 Step 3: Copy new grid.svg from custom SVG folder
    SVG_SOURCE="$HOME/Pictures/Candy/Dock-SVGs/grid.svg"
    SVG_DEST="/usr/share/nwg-dock-hyprland/images"

    print_status "Changing start button icon"

    if [ -f "$SVG_SOURCE" ]; then
        sudo cp "$SVG_SOURCE" "$SVG_DEST" && echo "✅ grid.svg copied successfully."
    else
        echo "❌ grid.svg not found at $SVG_SOURCE"
        exit 1
    fi

    # 🔐 Add sudoers entry for background script
    echo
    echo "🔄 Adding sddm background auto-update settings..."
    
    # Get the current username
    USERNAME=$(whoami)
    
    # Create the sudoers entries for background script and required commands
    SUDOERS_ENTRIES=(
        "$USERNAME ALL=(ALL) NOPASSWD: $HOME/.config/hyprcandy/hooks/update_background.sh"
        "$USERNAME ALL=(ALL) NOPASSWD: /usr/bin/magick * /usr/share/sddm/themes/sugar-candy/Backgrounds/Mountain.jpg"
    )
    
    # Add all entries to sudoers safely using visudo
    printf '%s\n' "${SUDOERS_ENTRIES[@]}" | sudo EDITOR='tee -a' visudo -f /etc/sudoers.d/hyprcandy-background
    
    # Set proper permissions on the sudoers file
    sudo chmod 440 /etc/sudoers.d/hyprcandy-background
    
    echo "✅ Added sddm background auto-update settings successfully"
    
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
          if [ "$PANEL_CHOICE" = "waybar" ]; then
 # Add default content to the custom.conf file
            cat > "$HOME/.config/hyprcustom/custom.conf" << 'EOF'
# ██╗  ██╗██╗   ██╗██████╗ ██████╗  ██████╗ █████╗ ███╗   ██╗██████╗ ██╗   ██╗
# ██║  ██║╚██╗ ██╔╝██╔══██╗██╔══██╗██╔════╝██╔══██╗████╗  ██║██╔══██╗╚██╗ ██╔╝
# ███████║ ╚████╔╝ ██████╔╝██████╔╝██║     ███████║██╔██╗ ██║██║  ██║ ╚████╔╝ 
# ██╔══██║  ╚██╔╝  ██╔═══╝ ██╔══██╗██║     ██╔══██║██║╚██╗██║██║  ██║  ╚██╔╝  
# ██║  ██║   ██║   ██║     ██║  ██║╚██████╗██║  ██║██║ ╚████║██████╔╝   ██║   
# ╚═╝  ╚═╝   ╚═╝   ╚═╝     ╚═╝  ╚═╝ ╚═════╝╚═╝  ╚═╝╚═╝  ╚═══╝╚═════╝    ╚═╝   

#[IMPORTANT]#
# Your custom settings made in this file are safe from resets after rerunning the script.
# To reset, delete the 'hyprcustom' folder (not just the 'custom.conf' file) before rerunning the script to regenerate the default setup.
#[IMPORTANT]#

# ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
# ┃                           Autostart                         ┃
# ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

#Launch bar/panel
exec-once = waybar &

exec-once = systemctl --user import-environment HYPRLAND_INSTANCE_SIGNATURE
exec-once = systemctl --user start background-watcher #Watches for system background changes to update background.png
exec-once = systemctl --user start waybar-idle-monitor #Watches bar/panel running status to enable/disable idle-inhibitor
exec-once = systemctl --user start waypaper-watcher #Watches for system waypaper changes to trigger color generation
exec-once = systemctl --user start rofi-font-watcher #Watches for system font changes to update rofi-font.rasi
exec-once = systemctl --user start cursor-theme-watcher #Watches for system cursor theme & size changes to update cursor theme & size on re-login
exec-once = bash -c "mkfifo /tmp/$HYPRLAND_INSTANCE_SIGNATURE.wob && tail -f /tmp/$HYPRLAND_INSTANCE_SIGNATURE.wob | wob & disown" &
exec-once = dbus-update-activation-environment --systemd DBUS_SESSION_BUS_ADDRESS DISPLAY XAUTHORITY &
exec-once = hash dbus-update-activation-environment 2>/dev/null &
exec-once = systemctl --user import-environment &
# Start swww
exec-once = swww-daemon &
# Start mako
exec-once = mako &
# Startup
exec-once = ~/.config/hyprcandy/hooks/startup_services.sh &
# Start Polkit
exec-once = systemctl --user start hyprpolkitagent &
# Dock
exec-once = ~/.config/nwg-dock-hyprland/launch.sh &
# Using hypridle to start hyprlock
exec-once = hypridle &
# Load cliphist history
exec-once = wl-paste --watch cliphist store
# Restart xdg
exec-once = ~/.config/hpr/scripts/xdg.sh
# Restore wallaper
exec-once = bash ~/.config/hypr/scripts/wallpaper-restore.sh
# Launch newtwork tray applet
#exec-once = nm-applet &
# Pyprland
#exec-once = /usr/bin/pypr &

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

# Packages to have full env path access
env = PATH,$PATH:/usr/local/bin:/usr/bin:/bin:/home/$USERNAME/.cargo/bin

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
env = QT_QPA_PLATFORM,wayland
env = QT_QPA_PLATFORMTHEME,gtk3
env = QT_WAYLAND_DISABLE_WINDOWDECORATION,0
env = QT_AUTO_SCREEN_SCALE_FACTOR,1
# GDK
env = GDK_DEBUG,portals
env = GDK_SCALE,1
# Toolkit Backend
env = GDK_BACKEND,wayland
env = CLUTTER_BACKEND,wayland
# Mozilla
env = MOZ_ENABLE_WAYLAND,1
# Ozone
env = OZONE_PLATFORM,wayland
env = ELECTRON_OZONE_PLATFORM_HINT,wayland
# Extra
env = WINIT_UNIX_BACKEND,wayland
env = GTK_THEME,adw-gtk3-dark
env = WLR_DRM_NO_ATOMIC,1
# Virtual machine display scaling
env = QT_SCALE_FACTOR_ROUNDING_POLICY=PassThrough
# For better VM performance
env = QEMU_AUDIO_DRV=pa

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
    border_size = 3
    col.active_border = $primary_fixed_dim $on_primary_fixed_variant $on_primary_fixed_variant $on_primary_fixed_variant $primary_fixed_dim 90deg
    col.inactive_border = $on_primary_fixed_variant
    layout = dwindle
    resize_on_border = true
    allow_tearing = true
}

group:groupbar:col.active =  $primary_fixed_dim
group:groupbar:col.inactive = $on_primary_fixed_variant

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
    size = 4
    passes = 2
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
        color = $scrim
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
windowrule = bordercolor $primary_fixed_dim $on_primary_fixed_variant 90deg, floating:1, onworkspace:w[fv1-10]
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
windowrulev2 = float,class:^(eww-main-window)$
windowrulev2 = float,class:^(eww-notifications)$
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
windowrulev2 = rounding 0, fullscreen:1
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
layerrule = blur,nwg-dock
layerrule = ignorezero,nwg-dock
layerrule = blur,logout_dialog
layerrule = ignorezero,logout_dialog
layerrule = blur,gtk-layer-shell
layerrule = ignorezero,gtk-layer-shell
layerrule = blur,waybar
layerrule = ignorezero,waybar
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

else  

            # Add default content to the custom.conf file
            cat > "$HOME/.config/hyprcustom/custom.conf" << 'EOF'
# ██╗  ██╗██╗   ██╗██████╗ ██████╗  ██████╗ █████╗ ███╗   ██╗██████╗ ██╗   ██╗
# ██║  ██║╚██╗ ██╔╝██╔══██╗██╔══██╗██╔════╝██╔══██╗████╗  ██║██╔══██╗╚██╗ ██╔╝
# ███████║ ╚████╔╝ ██████╔╝██████╔╝██║     ███████║██╔██╗ ██║██║  ██║ ╚████╔╝ 
# ██╔══██║  ╚██╔╝  ██╔═══╝ ██╔══██╗██║     ██╔══██║██║╚██╗██║██║  ██║  ╚██╔╝  
# ██║  ██║   ██║   ██║     ██║  ██║╚██████╗██║  ██║██║ ╚████║██████╔╝   ██║   
# ╚═╝  ╚═╝   ╚═╝   ╚═╝     ╚═╝  ╚═╝ ╚═════╝╚═╝  ╚═╝╚═╝  ╚═══╝╚═════╝    ╚═╝   

#[IMPORTANT]#
# Your custom settings made in this file are safe from resets after rerunning the script.
# To reset, delete the 'hyprcustom' folder (not just the 'custom.conf' file) before rerunning the script to regenerate the default setup.
#[IMPORTANT]#

# ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
# ┃                           Autostart                         ┃
# ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

#Launch bar/panel
exec-once = systemctl --user start hyprpanel

exec-once = systemctl --user import-environment HYPRLAND_INSTANCE_SIGNATURE
exec-once = systemctl --user start background-watcher #Watches for system background changes to update background.png
exec-once = systemctl --user start hyprpanel-idle-monitor #Watches bar/panel running status to enable/disable idle-inhibitor
#exec-once = systemctl --user start waypaper-watcher #Watches for system waypaper changes to trigger color generation
exec-once = systemctl --user start rofi-font-watcher #Watches for system font changes to update rofi-font.rasi
exec-once = systemctl --user start cursor-theme-watcher #Watches for system cursor theme & size changes to update cursor theme & size on re-login
exec-once = bash -c "mkfifo /tmp/$HYPRLAND_INSTANCE_SIGNATURE.wob && tail -f /tmp/$HYPRLAND_INSTANCE_SIGNATURE.wob | wob & disown" &
exec-once = dbus-update-activation-environment --systemd DBUS_SESSION_BUS_ADDRESS DISPLAY XAUTHORITY &
exec-once = hash dbus-update-activation-environment 2>/dev/null &
exec-once = systemctl --user import-environment &
# Start swww
#exec-once = swww-daemon &
# Start mako
#exec-once = mako &
# Startup
exec-once = ~/.config/hyprcandy/hooks/startup_services.sh &
# Start polkit agent
exec-once = systemctl --user start hyprpolkitagent &
# Dock
exec-once = ~/.config/nwg-dock-hyprland/launch.sh &
# Using hypridle to start hyprlock
exec-once = hypridle &
# Load cliphist history
exec-once = wl-paste --watch cliphist store
# Restart xdg
exec-once = ~/.config/hpr/scripts/xdg.sh
# Restore wallaper
exec-once = bash ~/.config/hypr/scripts/wallpaper-restore.sh
# Launch newtwork tray applet
#exec-once = nm-applet &
# Pyprland
#exec-once = /usr/bin/pypr &

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

# Packages to have full env path access
env = PATH,$PATH:/usr/local/bin:/usr/bin:/bin:/home/$USERNAME/.cargo/bin

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
env = QT_QPA_PLATFORM,wayland
env = QT_QPA_PLATFORMTHEME,gtk3
env = QT_WAYLAND_DISABLE_WINDOWDECORATION,0
env = QT_AUTO_SCREEN_SCALE_FACTOR,1
# GDK
env = GDK_DEBUG,portals
env = GDK_SCALE,1
# Toolkit Backend
env = GDK_BACKEND,wayland
env = CLUTTER_BACKEND,wayland
# Mozilla
env = MOZ_ENABLE_WAYLAND,1
# Ozone
env = OZONE_PLATFORM,wayland
env = ELECTRON_OZONE_PLATFORM_HINT,wayland
# Extra
env = WINIT_UNIX_BACKEND,wayland
env = GTK_THEME,adw-gtk3-dark
env = WLR_DRM_NO_ATOMIC,1
# Virtual machine display scaling
env = QT_SCALE_FACTOR_ROUNDING_POLICY=PassThrough
# For better VM performance
env = QEMU_AUDIO_DRV=pa

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
    border_size = 3
    col.active_border = $primary_fixed_dim $on_primary_fixed_variant $on_primary_fixed_variant $on_primary_fixed_variant $primary_fixed_dim 90deg
    col.inactive_border = $on_primary_fixed_variant
    layout = dwindle
    resize_on_border = true
    allow_tearing = true
}

group:groupbar:col.active =  $primary_fixed_dim
group:groupbar:col.inactive = $on_primary_fixed_variant

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
    size = 4
    passes = 2
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
        color = $scrim
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
windowrule = bordercolor $primary_fixed_dim $on_primary_fixed_variant 90deg, floating:1, onworkspace:w[fv1-10]
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
windowrulev2 = float,class:^(eww-main-window)$
windowrulev2 = float,class:^(eww-notifications)$
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
windowrulev2 = rounding 0, fullscreen:1
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
layerrule = blur,nwg-dock
layerrule = ignorezero,nwg-dock
layerrule = blur,logout_dialog
layerrule = ignorezero,logout_dialog
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
fi

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
    blur_sizes = 0
    vibrancy = 0.1696
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
    path = ~/.config/background.png #.face.icon
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

if [ "$PANEL_CHOICE" = "waybar" ]; then

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

#### Rofi Menus ####

bind = $mainMod, A, exec, rofi -show drun || pkill rofi      #Launch or kill/hide rofi application finder
bind = $mainMod, K, exec, $HYPRSCRIPTS/keybindings.sh     #Show keybindings
bind = $mainMod CTRL, V, exec, $SCRIPTS/cliphist.sh     #Open clipboard manager
bind = $mainMod CTRL, E, exec, ~/.config/hyprcandy/settings/emojipicker.sh 		  #Open rofi emoji-picker
bind = $mainMod CTRL, G, exec, ~/.config/hyprcandy/settings/glyphpicker.sh 		  #Open rofi glyph-picker

#### Applications ####

bind = $mainMod, S, exec, spotify
bind = $mainMod, D, exec, $DISCORD
bind = $mainMod, W, exec, warp-terminal
bind = $mainMod, C, exec, DRI_PRIME=1 $EDITOR #Editor
bind = $mainMod, B, exec, DRI_PRIME=1 xdg-open "http://" #Launch your default browser
bind = $mainMod, Q, exec, kitty #Launch normal kitty instances
#bind = $mainMod, Return, exec, DRI_PRIME=1 pypr toggle term #Launch a kitty scratchpad through pyprland
bind = $mainMod, O, exec, DRI_PRIME=1 /usr/bin/octopi #Launch octopi application finder
bind = $mainMod, E, exec, DRI_PRIME=1 nautilus #pypr toggle filemanager #Launch the filemanager 
bind = $mainMod CTRL, C, exec, DRI_PRIME=1 gnome-calculator #Launch the calculator

#### Bar/Panel ####

bind = ALT, 1, exec, ~/.config/hyprcandy/hooks/kill_waybar_safe.sh #Hide/kill waybar and start automatic idle-inhibitor
bind = ALT, 2, exec, ~/.config/hyprcandy/hooks/restart_waybar.sh #Restart or reload waybar and stop automatic idle-inhibitor

#### Dock keybinds ####

bind = ALT, 3, exec, ~/.config/hyprcandy/hooks/nwg_dock_presets.sh hidden #Hide/kill dock
bind = ALT, 4, exec, ~/.config/nwg-dock-hyprland/launch.sh #Bottom dock and quick-reload dock
bind = ALT, 5, exec, nwg-dock-hyprland -p top -lp start -i 22 -w 10 -mt 6 -ml 10 -mr 10 -x -r -s "style.css" -c "rofi -show drun" #Top dock
bind = ALT, 6, exec, nwg-dock-hyprland -p left -lp start -i 22 -w 10 -ml 6 -mt 10 -mb 10 -x -r -s "style.css" -c "rofi -show drun" #Left dock
bind = ALT, 7, exec, nwg-dock-hyprland -p right -lp start -i 22 -w 10 -mr 6 -mt 10 -mb 10 -x -r -s "style.css" -c "rofi -show drun" #Right dock
bind = ALT, 8, exec, ~/.config/hyprcandy/hooks/nwg_dock_status_display.sh #Dock status display

#### Status display ####

bind = ALT, 9, exec, ~/.config/hyprcandy/hooks/hyprland_status_display.sh #Hyprland status display

#### Recorder ####

# Wf--recorder (simple recorder) + slurp (allows to select a specific region of the monitor)
# {to list audio devices run "pactl list sources | grep Name"}   
bind = $mainMod, R, exec, bash -c 'wf-recorder -g -a --audio=bluez_output.78_15_2D_0D_BD_B7.1.monitor -f "$HOME/Videos/Recordings/recording-$(date +%Y%m%d-%H%M%S).mp4" $(slurp)' # Start recording
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
bind = $mainMod CTRL, K, swapsplit                                                               #Swapsplit
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

# Keyboard backlight controls with notifications
bind = , code:236, exec, brightnessctl -d smc::kbd_backlight s +10 && notify-send "Keyboard Backlight" "$(brightnessctl -d smc::kbd_backlight | grep -o '[0-9]*%' | head -1)" -t 1000
bind = , code:237, exec, brightnessctl -d smc::kbd_backlight s 10- && notify-send "Keyboard Backlight" "$(brightnessctl -d smc::kbd_backlight | grep -o '[0-9]*%' | head -1)" -t 1000

# Screen brightness controls with notifications
bind = , F2, exec, brightnessctl -q s +10% && notify-send "Screen Brightness" "$(brightnessctl | grep -o '[0-9]*%' | head -1)" -t 1000
bind = , F1, exec, brightnessctl -q s 10%- && notify-send "Screen Brightness" "$(brightnessctl | grep -o '[0-9]*%' | head -1)" -t 1000

# Volume mute toggle with notification
bind = Shift, F9, exec, amixer sset Master toggle | sed -En '/\[on\]/ s/.*\[([0-9]+)%\].*/\1/ p; /\[off\]/ s/.*/0/p' | head -1 > /tmp/$HYPRLAND_INSTANCE_SIGNATURE.wob && if amixer sget Master | grep -q '\[off\]'; then notify-send "Volume" "Muted" -t 1000; else notify-send "Volume" "$(amixer sget Master | grep -o '[0-9]*%' | head -1)" -t 1000; fi

# Volume controls with notifications
bind = , F8, exec, pactl set-sink-mute @DEFAULT_SINK@ 0 && pactl set-sink-volume @DEFAULT_SINK@ +5% && notify-send "Volume" "$(pactl get-sink-volume @DEFAULT_SINK@ | grep -o '[0-9]*%' | head -1)" -t 1000
bind = , F7, exec, pactl set-sink-mute @DEFAULT_SINK@ 0 && pactl set-sink-volume @DEFAULT_SINK@ -5% && notify-send "Volume" "$(pactl get-sink-volume @DEFAULT_SINK@ | grep -o '[0-9]*%' | head -1)" -t 1000

bind = , F4, exec, playerctl play-pause #Toggle play/pause
bind = , F6, exec, playerctl next #Play next video/song
bind = , F5, exec, playerctl previous #Play previous video/song
EOF

else

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

#### Rofi Menus ####

bind = $mainMod, A, exec, rofi -show drun || pkill rofi      #Launch or kill/hide rofi application finder
bind = $mainMod, K, exec, $HYPRSCRIPTS/keybindings.sh     #Show keybindings
bind = $mainMod CTRL, V, exec, $SCRIPTS/cliphist.sh     #Open clipboard manager
bind = $mainMod CTRL, E, exec, ~/.config/hyprcandy/settings/emojipicker.sh 		  #Open rofi emoji-picker
bind = $mainMod CTRL, G, exec, ~/.config/hyprcandy/settings/glyphpicker.sh 		  #Open rofi glyph-picker

#### Applications ####

bind = $mainMod, S, exec, spotify
bind = $mainMod, D, exec, $DISCORD
bind = $mainMod, W, exec, warp-terminal
bind = $mainMod, C, exec, DRI_PRIME=1 $EDITOR #Editor
bind = $mainMod, B, exec, DRI_PRIME=1 xdg-open "http://" #Launch your default browser
bind = $mainMod, Q, exec, kitty #Launch normal kitty instances
#bind = $mainMod, Return, exec, DRI_PRIME=1 pypr toggle term #Launch a kitty scratchpad through pyprland
bind = $mainMod, O, exec, DRI_PRIME=1 /usr/bin/octopi #Launch octopi application finder
bind = $mainMod, E, exec, DRI_PRIME=1 nautilus #pypr toggle filemanager #Launch the filemanager 
bind = $mainMod CTRL, C, exec, DRI_PRIME=1 gnome-calculator #Launch the calculator

#### Bar/Panel ####

bind = ALT, 1, exec, ~/.config/hyprcandy/hooks/kill_hyprpanel_safe.sh #Hide/kill hyprpanel and start automatic idle-inhibitor
bind = ALT, 2, exec, ~/.config/hyprcandy/hooks/restart_hyprpanel.sh #Restart or reload hyprpanel and stop automatic idle-inhibitor

#### Dock keybinds ####

bind = ALT, 3, exec, ~/.config/hyprcandy/hooks/nwg_dock_presets.sh hidden #Hide/kill dock
bind = ALT, 4, exec, ~/.config/nwg-dock-hyprland/launch.sh #Bottom dock and quick-reload dock
bind = ALT, 5, exec, nwg-dock-hyprland -p top -lp start -i 22 -w 10 -mt 6 -ml 10 -mr 10 -x -r -s "style.css" -c "rofi -show drun" #Top dock
bind = ALT, 6, exec, nwg-dock-hyprland -p left -lp start -i 22 -w 10 -ml 6 -mt 10 -mb 10 -x -r -s "style.css" -c "rofi -show drun" #Left dock
bind = ALT, 7, exec, nwg-dock-hyprland -p right -lp start -i 22 -w 10 -mr 6 -mt 10 -mb 10 -x -r -s "style.css" -c "rofi -show drun" #Right dock
bind = ALT, 8, exec, ~/.config/hyprcandy/hooks/nwg_dock_status_display.sh #Dock status display

#### Status display ####

bind = ALT, 9, exec, ~/.config/hyprcandy/hooks/hyprland_status_display.sh #Hyprland status display

#### Recorder ####

# Wf--recorder (simple recorder) + slurp (allows to select a specific region of the monitor)
# {to list audio devices run "pactl list sources | grep Name"}   
bind = $mainMod, R, exec, bash -c 'wf-recorder -g -a --audio=bluez_output.78_15_2D_0D_BD_B7.1.monitor -f "$HOME/Videos/Recordings/recording-$(date +%Y%m%d-%H%M%S).mp4" $(slurp)' # Start recording
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
bind = $mainMod CTRL, K, swapsplit                                                               #Swapsplit
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

# Keyboard backlight controls with notifications
bind = , code:236, exec, brightnessctl -d smc::kbd_backlight s +10 && notify-send "Keyboard Backlight" "$(brightnessctl -d smc::kbd_backlight | grep -o '[0-9]*%' | head -1)" -t 1000
bind = , code:237, exec, brightnessctl -d smc::kbd_backlight s 10- && notify-send "Keyboard Backlight" "$(brightnessctl -d smc::kbd_backlight | grep -o '[0-9]*%' | head -1)" -t 1000

# Screen brightness controls with notifications
bind = , F2, exec, brightnessctl -q s +10% && notify-send "Screen Brightness" "$(brightnessctl | grep -o '[0-9]*%' | head -1)" -t 1000
bind = , F1, exec, brightnessctl -q s 10%- && notify-send "Screen Brightness" "$(brightnessctl | grep -o '[0-9]*%' | head -1)" -t 1000

# Volume mute toggle with notification
bind = Shift, F9, exec, amixer sset Master toggle | sed -En '/\[on\]/ s/.*\[([0-9]+)%\].*/\1/ p; /\[off\]/ s/.*/0/p' | head -1 > /tmp/$HYPRLAND_INSTANCE_SIGNATURE.wob && if amixer sget Master | grep -q '\[off\]'; then notify-send "Volume" "Muted" -t 1000; else notify-send "Volume" "$(amixer sget Master | grep -o '[0-9]*%' | head -1)" -t 1000; fi

# Volume controls with notifications
bind = , F8, exec, pactl set-sink-mute @DEFAULT_SINK@ 0 && pactl set-sink-volume @DEFAULT_SINK@ +5% && notify-send "Volume" "$(pactl get-sink-volume @DEFAULT_SINK@ | grep -o '[0-9]*%' | head -1)" -t 1000
bind = , F7, exec, pactl set-sink-mute @DEFAULT_SINK@ 0 && pactl set-sink-volume @DEFAULT_SINK@ -5% && notify-send "Volume" "$(pactl get-sink-volume @DEFAULT_SINK@ | grep -o '[0-9]*%' | head -1)" -t 1000

bind = , F4, exec, playerctl play-pause #Toggle play/pause
bind = , F6, exec, playerctl next #Play next video/song
bind = , F5, exec, playerctl previous #Play previous video/song
EOF
fi

    # 🎨 Update Hyprland custom.conf with current username  
    USERNAME=$(whoami)      
    HYPRLAND_CUSTOM="$HOME/.config/hyprcustom/custom.conf"
    echo "🎨 Updating Hyprland custom.conf with current username..."		
    
    if [ -f "$HYPRLAND_CUSTOM" ]; then
        sed -i "s|\$USERNAME|$USERNAME|g" "$HYPRLAND_CUSTOM"
        echo "✅ Updated custom.conf PATH with username: $USERNAME"
    else
        echo "⚠️  File not found: $HYPRLAND_CUSTOM"
    fi
        fi
}

update_keybinds() {
    local CONFIG_FILE="$HOME/.config/hyprcustom/custom_keybinds.conf"
    
    # Check if config file exists
    if [ ! -f "$CONFIG_FILE" ]; then
        print_error "Config file not found: $CONFIG_FILE"
        return 1
    fi
    
    # Optional: Create backup (uncomment if needed)
    # cp "$CONFIG_FILE" "${CONFIG_FILE}.backup.$(date +%Y%m%d_%H%M%S)"
    # echo -e "${GREEN}Backup created${NC}"
    
    # Check current panel configuration to avoid unnecessary changes
    if grep -q "waybar" "$CONFIG_FILE" && [ "$PANEL_CHOICE" = "waybar" ]; then
        print_warning "Keybinds already set for waybar"
        return 0
    elif grep -q "hyprpanel" "$CONFIG_FILE" && [ "$PANEL_CHOICE" = "hyprpanel" ]; then
        print_warning "Keybinds already set for hyprpanel"
        return 0
    fi
    
    if [ "$PANEL_CHOICE" = "waybar" ]; then
        # Replace hyprpanel with waybar
        sed -i 's/hyprpanel/waybar/g' "$CONFIG_FILE"
        # Also update specific script paths that might reference hyprpanel
        sed -i 's/kill_hyprpanel_safe\.sh/kill_waybar_safe.sh/g' "$CONFIG_FILE"
        sed -i 's/restart_hyprpanel\.sh/restart_waybar.sh/g' "$CONFIG_FILE"
        echo -e "${GREEN}Updated keybinds for waybar${NC}"
    else
        # Replace waybar with hyprpanel
        sed -i 's/waybar/hyprpanel/g' "$CONFIG_FILE"
        # Also update specific script paths that might reference waybar
        sed -i 's/kill_waybar_safe\.sh/kill_hyprpanel_safe.sh/g' "$CONFIG_FILE"
        sed -i 's/restart_waybar\.sh/restart_hyprpanel.sh/g' "$CONFIG_FILE"
        echo -e "${GREEN}Updated keybinds for hyprpanel${NC}"
    fi
}

update_custom() {
    local CUSTOM_CONFIG_FILE="$HOME/.config/hyprcustom/custom.conf"
    
    # Check if custom config file exists
    if [ ! -f "$CUSTOM_CONFIG_FILE" ]; then
        print_error "Custom config file not found: $CUSTOM_CONFIG_FILE"
        return 1
    fi
    
    # Optional: Create backup (uncomment if needed)
    # cp "$CUSTOM_CONFIG_FILE" "${CUSTOM_CONFIG_FILE}.backup.$(date +%Y%m%d_%H%M%S)"
    # echo -e "${GREEN}Custom config backup created${NC}"
    
    if [ "$PANEL_CHOICE" = "waybar" ]; then
        # Replace bar-0 with waybar in layer rules
        sed -i '18s/exec-once = systemctl --user start hyprpanel/exec-once = waybar \&/g' "$CUSTOM_CONFIG_FILE"
        sed -i '22s/exec-once = systemctl --user start hyprpanel-idle-monitor/exec-once = systemctl --user start waybar-idle-monitor/g' "$CUSTOM_CONFIG_FILE"
        sed -i 's/#exec-once = swww-daemon &/exec-once = swww-daemon \&/g' "$CUSTOM_CONFIG_FILE"
        sed -i 's/#exec-once = mako &/exec-once = mako \&/g' "$CUSTOM_CONFIG_FILE"
        sed -i 's/#exec-once = systemctl --user start waypaper-watcher/exec-once = systemctl --user start waypaper-watcher/g' "$CUSTOM_CONFIG_FILE"
        sed -i 's/layerrule = blur,bar-0/layerrule = blur,waybar/g' "$CUSTOM_CONFIG_FILE"
        sed -i 's/layerrule = ignorezero,bar-0/layerrule = ignorezero,waybar/g' "$CUSTOM_CONFIG_FILE"
        echo -e "${GREEN}Updated custom config layer rules for waybar${NC}"
    else
        # Replace bar-0 with hyprpanel in layer rules
        sed -i '18s/exec-once = waybar \&/exec-once = systemctl --user start hyprpanel/g' "$CUSTOM_CONFIG_FILE"
        sed -i '22s/exec-once = systemctl --user start waybar-idle-monitor/exec-once = systemctl --user start hyprpanel-idle-monitor/g' "$CUSTOM_CONFIG_FILE"
        sed -i 's/exec-once = swww-daemon &/#exec-once = swww-daemon \&/g' "$CUSTOM_CONFIG_FILE"
        sed -i 's/exec-once = mako &/#exec-once = mako \&/g' "$CUSTOM_CONFIG_FILE"
        sed -i 's/exec-once = systemctl --user start waypaper-watcher/#exec-once = systemctl --user start waypaper-watcher/g' "$CUSTOM_CONFIG_FILE"
        sed -i 's/layerrule = blur,waybar/layerrule = blur,bar-0/g' "$CUSTOM_CONFIG_FILE"
        sed -i 's/layerrule = ignorezero,waybar/layerrule = ignorezero,bar-0/g' "$CUSTOM_CONFIG_FILE"
        echo -e "${GREEN}Updated custom config layer rules for hyprpanel${NC}"
    fi
}

setup_gjs() {
# Create the GJS directory and files if they don't already exist
if [ ! -d "$HOME/.hyprcandy/GJS/src" ]; then
    mkdir -p "$HOME/.hyprcandy/GJS/src"
    echo "📁 Created the GJS directory"
fi

# Add GJS files
cat > "$HOME/.hyprcandy/GJS/toggle-main.js" << 'EOF'
#!/usr/bin/env gjs

imports.gi.versions.Gtk = '4.0';
imports.gi.versions.Gdk = '4.0';
imports.gi.versions.GLib = '2.0';
const { Gtk, Gdk, GLib } = imports.gi;

const scriptDir = GLib.path_get_dirname(imports.system.programInvocationName);
imports.searchPath.unshift(scriptDir);
imports.searchPath.unshift(GLib.build_filenamev([scriptDir, 'src']));

let Adw;
try {
    imports.gi.versions.Adw = '1';
    Adw = imports.gi.Adw;
} catch (e) {
    Adw = null;
}

const Toggle = imports['toggle'];

const APP_ID = 'org.gnome.gjstoggles';

function onActivate(app) {
    const winToggles = new (Adw ? Adw.ApplicationWindow : Gtk.ApplicationWindow)({
        application: app,
        title: 'Toggles',
        default_width: 400,
        default_height: 220,
        resizable: false,
        decorated: false,
    });
    if (winToggles.set_icon_from_file) {
        try { winToggles.set_icon_from_file(GLib.build_filenamev([GLib.get_home_dir(), '.local/share/icons/HyprCandy.png'])); } catch (e) {}
    }
    const togglesBox = Toggle.createTogglesBox();
    if (Adw && winToggles.set_content) {
        winToggles.set_content(togglesBox);
    } else {
        winToggles.set_child(togglesBox);
    }
    // Add Escape key handling
    const keyController = new Gtk.EventControllerKey();
    keyController.connect('key-pressed', (controller, keyval, keycode, state) => {
        if (keyval === Gdk.KEY_Escape) {
            winToggles.close();
        }
        return false;
    });
    winToggles.add_controller(keyController);
    winToggles.set_visible(true);
    if (winToggles.set_keep_above) winToggles.set_keep_above(true);
    winToggles.present();
}

function main() {
    const ApplicationType = Adw ? Adw.Application : Gtk.Application;
    const app = new ApplicationType({ application_id: APP_ID });
    app.connect('activate', onActivate);
    app.run([]);
}

main();  
EOF

cat > "$HOME/.hyprcandy/GJS/weather-main.js" << 'EOF'
#!/usr/bin/env gjs

imports.gi.versions.Gtk = '4.0';
imports.gi.versions.Gdk = '4.0';
imports.gi.versions.GLib = '2.0';
const { Gtk, Gdk, GLib } = imports.gi;

const scriptDir = GLib.path_get_dirname(imports.system.programInvocationName);
imports.searchPath.unshift(scriptDir);
imports.searchPath.unshift(GLib.build_filenamev([scriptDir, 'src']));

let Adw;
try {
    imports.gi.versions.Adw = '1';
    Adw = imports.gi.Adw;
} catch (e) {
    Adw = null;
}

const Weather = imports['weather'];

const APP_ID = 'Candy.Weather';

function onActivate(app) {
    const winWeather = new (Adw ? Adw.ApplicationWindow : Gtk.ApplicationWindow)({
        application: app,
        title: 'Weather',
        // default_width: 300,
        // default_height: 160,
        resizable: false,
        decorated: false,
    });
    if (winWeather.set_icon_from_file) {
        try { winWeather.set_icon_from_file(GLib.build_filenamev([GLib.get_home_dir(), '.local/share/icons/HyprCandy.png'])); } catch (e) {}
    }
    const weatherBox = Weather.createWeatherBox();
    if (Adw && winWeather.set_content) {
        winWeather.set_content(weatherBox);
    } else {
        winWeather.set_child(weatherBox);
    }
    // Add Escape key handling
    const keyController = new Gtk.EventControllerKey();
    keyController.connect('key-pressed', (controller, keyval, keycode, state) => {
        if (keyval === Gdk.KEY_Escape) {
            winWeather.close();
        }
        return false;
    });
    winWeather.add_controller(keyController);
    winWeather.set_visible(true);
    if (winWeather.set_keep_above) winWeather.set_keep_above(true);
    winWeather.present();
}

function main() {
    const ApplicationType = Adw ? Adw.Application : Gtk.Application;
    const app = new ApplicationType({ application_id: APP_ID });
    app.connect('activate', onActivate);
    app.run([]);
}

main(); 
EOF

cat > "$HOME/.hyprcandy/GJS/src/mediaMenu.js" << 'EOF'
imports.gi.versions.Gtk = '4.0';
imports.gi.versions.Gio = '2.0';
imports.gi.versions.GLib = '2.0';
imports.gi.versions.Gdk = '4.0';
imports.gi.versions.Soup = '3.0';
imports.gi.versions.GdkPixbuf = '2.0';
const { Gtk, Gio, GLib, Gdk, Soup, GdkPixbuf } = imports.gi;

function createTogglesBox() {
// --- Hyprsunset state persistence setup ---
const hyprsunsetStateDir = GLib.build_filenamev([GLib.get_home_dir(), '.config', 'hyprcandy']);
const hyprsunsetStateFile = GLib.build_filenamev([hyprsunsetStateDir, 'hyprsunset.state']);
// Ensure directory exists
try { GLib.mkdir_with_parents(hyprsunsetStateDir, 0o755); } catch (e) {}
function loadHyprsunsetState() {
    try {
        let [ok, contents] = GLib.file_get_contents(hyprsunsetStateFile);
        if (ok && contents) {
            let state = imports.byteArray.toString(contents).trim();
            return state === 'enabled';
        }
    } catch (e) {}
    return false;
}
function saveHyprsunsetState(enabled) {
    try {
        GLib.file_set_contents(hyprsunsetStateFile, enabled ? 'enabled' : 'disabled');
    } catch (e) {}
}

// Main horizontal layout: left (hyprsunset, hyprpicker, toggles), right (presets, weather)
const mainRow = new Gtk.Box({
    orientation: Gtk.Orientation.HORIZONTAL,
    spacing: 32,
    halign: Gtk.Align.CENTER,
    valign: Gtk.Align.CENTER,
    margin_top: 16,
    margin_bottom: 16,
    margin_start: 16,
    margin_end: 16
});
mainRow.add_css_class('candy-utils-frame');

// Left: Hyprsunset, Hyprpicker, Toggles
const leftBox = new Gtk.Box({
    orientation: Gtk.Orientation.VERTICAL,
    spacing: 16,
    halign: Gtk.Align.CENTER,
    valign: Gtk.Align.CENTER
});
// Hyprsunset controls
const hyprsunsetBox = new Gtk.Box({ orientation: Gtk.Orientation.HORIZONTAL, spacing: 8, halign: Gtk.Align.CENTER });
let hyprsunsetEnabled = loadHyprsunsetState();
const hyprsunsetBtn = new Gtk.Button({ label: hyprsunsetEnabled ? 'Hyprsunset 󰌵' : 'Hyprsunset 󰹏' });
if (hyprsunsetEnabled) hyprsunsetBtn.add_css_class('neon-highlight');
hyprsunsetBtn.connect('clicked', () => {
    if (!hyprsunsetEnabled) {
        GLib.spawn_command_line_async("bash -c 'hyprsunset &'");
        hyprsunsetBtn.set_label('Hyprsunset 󰌵');
        hyprsunsetBtn.add_css_class('neon-highlight');
        hyprsunsetEnabled = true;
    } else {
        GLib.spawn_command_line_async('pkill hyprsunset');
        hyprsunsetBtn.set_label('Hyprsunset 󰹏');
        hyprsunsetBtn.remove_css_class('neon-highlight');
        hyprsunsetEnabled = false;
    }
    saveHyprsunsetState(hyprsunsetEnabled);
});
const gammaDecBtn = new Gtk.Button({ label: 'Gamma -10%' });
gammaDecBtn.connect('clicked', () => {
    GLib.spawn_command_line_async('hyprctl hyprsunset gamma -10');
});
const gammaIncBtn = new Gtk.Button({ label: 'Gamma +10%' });
gammaIncBtn.connect('clicked', () => {
    GLib.spawn_command_line_async('hyprctl hyprsunset gamma +10');
});
hyprsunsetBox.append(hyprsunsetBtn);
hyprsunsetBox.append(gammaDecBtn);
hyprsunsetBox.append(gammaIncBtn);
//leftBox.append(hyprsunsetBox);

// Hyprpicker button
const hyprpickerBtn = new Gtk.Button({ label: 'Launch Hyprpicker' });
hyprpickerBtn.connect('clicked', () => {
    GLib.spawn_command_line_async('hyprpicker');
});
//leftBox.append(hyprpickerBtn);

// --- Xray Toggle Button ---
const xrayStateFile = GLib.build_filenamev([hyprsunsetStateDir, 'xray.state']);
function loadXrayState() {
    try {
        let [ok, contents] = GLib.file_get_contents(xrayStateFile);
        if (ok && contents) {
            let state = imports.byteArray.toString(contents).trim();
            return state === 'enabled';
        }
    } catch (e) {}
    return false;
}
function saveXrayState(enabled) {
    try {
        GLib.file_set_contents(xrayStateFile, enabled ? 'enabled' : 'disabled');
    } catch (e) {}
}
function toggleXray(enabled) {
    const configFile = GLib.build_filenamev([GLib.get_home_dir(), '.config', 'hyprcustom', 'custom.conf']);
    const newValue = enabled ? 'true' : 'false';
    GLib.spawn_command_line_async(`sed -i 's/xray = .*/xray = ${newValue}/' "${configFile}"`);
    GLib.spawn_command_line_async('hyprctl reload');
}

let xrayEnabled = loadXrayState();
const xrayBtn = new Gtk.Button({ label: xrayEnabled ? 'Xray Enabled ' : 'Xray Disabled ' });
if (xrayEnabled) xrayBtn.add_css_class('neon-highlight');
xrayBtn.connect('clicked', () => {
    xrayEnabled = !xrayEnabled;
    toggleXray(xrayEnabled);
    if (xrayEnabled) {
        xrayBtn.set_label('Xray Enabled ');
        xrayBtn.add_css_class('neon-highlight');
    } else {
        xrayBtn.set_label('Xray Disabled ');
        xrayBtn.remove_css_class('neon-highlight');
    }
    saveXrayState(xrayEnabled);
});
//leftBox.append(xrayBtn);

// --- Opacity Toggle Button ---
const opacityStateFile = GLib.build_filenamev([hyprsunsetStateDir, 'opacity.state']);
function loadOpacityState() {
    try {
        let [ok, contents] = GLib.file_get_contents(opacityStateFile);
        if (ok && contents) {
            let state = imports.byteArray.toString(contents).trim();
            return state === 'enabled';
        }
    } catch (e) {}
    return false;
}
function saveOpacityState(enabled) {
    try {
        GLib.file_set_contents(opacityStateFile, enabled ? 'enabled' : 'disabled');
    } catch (e) {}
}

let opacityEnabled = loadOpacityState();
const opacityBtn = new Gtk.Button({ label: opacityEnabled ? 'Opacity ' : 'Opacity ' });
if (opacityEnabled) opacityBtn.add_css_class('neon-highlight');
opacityBtn.connect('clicked', () => {
    opacityEnabled = !opacityEnabled;
    if (opacityEnabled) {
        opacityBtn.set_label('Opacity ');
        opacityBtn.add_css_class('neon-highlight');
        GLib.spawn_command_line_async('bash -c "$HOME/.config/hypr/scripts/window-opacity.sh"');
    } else {
        opacityBtn.set_label('Opacity ');
        opacityBtn.remove_css_class('neon-highlight');
        GLib.spawn_command_line_async('bash -c "$HOME/.config/hypr/scripts/window-opacity.sh"');
    }
    saveOpacityState(opacityEnabled);
});

// --- Active Opacity Controls ---
function activeOpacityRow(label, configKey) {
    const row = new Gtk.Box({ orientation: Gtk.Orientation.HORIZONTAL, spacing: 8, halign: Gtk.Align.CENTER, valign: Gtk.Align.CENTER });
    const lbl = new Gtk.Label({ label, halign: Gtk.Align.END, xalign: 1 });
    lbl.set_size_request(110, -1);
    const decBtn = new Gtk.Button({ label: '-' });
    decBtn.set_size_request(32, 32);
    const incBtn = new Gtk.Button({ label: '+' });
    incBtn.set_size_request(32, 32);
    
    function updateActiveOpacity(increment) {
        const configFile = GLib.build_filenamev([GLib.get_home_dir(), '.config', 'hyprcustom', 'custom.conf']);
        // Read current value
        try {
            let [ok, contents] = GLib.file_get_contents(configFile);
            if (ok && contents) {
                let content = imports.byteArray.toString(contents);
                let regex = new RegExp(`active_opacity = ([0-9.]+)`);
                let match = content.match(regex);
                if (match) {
                    let currentValue = parseFloat(match[1]);
                    let newValue = Math.max(0.0, Math.min(1.0, currentValue + increment));
                    let newValueStr = newValue.toFixed(2);
                    GLib.spawn_command_line_async(`sed -i 's/active_opacity = .*/active_opacity = ${newValueStr}/' "${configFile}"`);
                    GLib.spawn_command_line_async('hyprctl reload');
                    GLib.spawn_command_line_async(`notify-send "Opacity" "Scale: ${newValueStr}" -t 2000`);
                }
            }
        } catch (e) {}
    }
    
    decBtn.connect('clicked', () => {
        updateActiveOpacity(-0.05);
    });
    incBtn.connect('clicked', () => {
        updateActiveOpacity(0.05);
    });
    
    row.append(lbl);
    row.append(decBtn);
    row.append(incBtn);
    leftBox.append(row);
}

// --- Blur Controls ---
function addBlurSizeRow(label, configKey, increment = 1) {
    const row = new Gtk.Box({ orientation: Gtk.Orientation.HORIZONTAL, spacing: 8, halign: Gtk.Align.CENTER, valign: Gtk.Align.CENTER });
    const lbl = new Gtk.Label({ label, halign: Gtk.Align.END, xalign: 1 });
    lbl.set_size_request(110, -1);
    const decBtn = new Gtk.Button({ label: '-' });
    decBtn.set_size_request(32, 32);
    const incBtn = new Gtk.Button({ label: '+' });
    incBtn.set_size_request(32, 32);
    
    function updateBlurSize(increment) {
        const configFile = GLib.build_filenamev([GLib.get_home_dir(), '.config', 'hyprcustom', 'custom.conf']);
        // Read current value
        try {
            let [ok, contents] = GLib.file_get_contents(configFile);
            if (ok && contents) {
                let content = imports.byteArray.toString(contents);
                // Look for size = X inside the blur block
                let blurSection = content.match(/blur \{[\s\S]*?\}/);
                if (blurSection) {
                    let sizeMatch = blurSection[0].match(/size = ([0-9]+)/);
                    if (sizeMatch) {
                        let currentValue = parseInt(sizeMatch[1]);
                        let newValue = Math.max(0, currentValue + increment);
                        // Use a simpler sed command that targets the specific line
                        GLib.spawn_command_line_async(`sed -i '/blur {/,/}/{s/size = ${currentValue}/size = ${newValue}/}' '${configFile}'`);
                        GLib.spawn_command_line_async('hyprctl reload');
                        GLib.spawn_command_line_async(`notify-send "Blur Size" "Size: ${newValue}" -t 2000`);
                    }
                }
            }
        } catch (e) {
            print('Error updating blur size: ' + e.message);
        }
    }
    
    decBtn.connect('clicked', () => {
        updateBlurSize(-increment);
    });
    incBtn.connect('clicked', () => {
        updateBlurSize(increment);
    });
    
    row.append(lbl);
    row.append(decBtn);
    row.append(incBtn);
    leftBox.append(row);
}

function addBlurPassRow(label, configKey, increment = 1) {
    const row = new Gtk.Box({ orientation: Gtk.Orientation.HORIZONTAL, spacing: 8, halign: Gtk.Align.CENTER, valign: Gtk.Align.CENTER });
    const lbl = new Gtk.Label({ label, halign: Gtk.Align.END, xalign: 1 });
    lbl.set_size_request(110, -1);
    const decBtn = new Gtk.Button({ label: '-' });
    decBtn.set_size_request(32, 32);
    const incBtn = new Gtk.Button({ label: '+' });
    incBtn.set_size_request(32, 32);
    
    function updateBlurPass(increment) {
        const configFile = GLib.build_filenamev([GLib.get_home_dir(), '.config', 'hyprcustom', 'custom.conf']);
        // Read current value
        try {
            let [ok, contents] = GLib.file_get_contents(configFile);
            if (ok && contents) {
                let content = imports.byteArray.toString(contents);
                // Look for passes = X inside the blur block
                let blurSection = content.match(/blur \{[\s\S]*?\}/);
                if (blurSection) {
                    let passesMatch = blurSection[0].match(/passes = ([0-9]+)/);
                    if (passesMatch) {
                        let currentValue = parseInt(passesMatch[1]);
                        let newValue = Math.max(0, currentValue + increment);
                        // Use a simpler sed command that targets the specific line
                        GLib.spawn_command_line_async(`sed -i 's/passes = ${currentValue}/passes = ${newValue}/' '${configFile}'`);
                        GLib.spawn_command_line_async('hyprctl reload');
                        GLib.spawn_command_line_async(`notify-send "Blur Pass" "Passes: ${newValue}" -t 2000`);
                    }
                }
            }
        } catch (e) {
            print('Error updating blur passes: ' + e.message);
        }
    }
    
    decBtn.connect('clicked', () => {
        updateBlurPass(-increment);
    });
    incBtn.connect('clicked', () => {
        updateBlurPass(increment);
    });
    
    row.append(lbl);
    row.append(decBtn);
    row.append(incBtn);
    leftBox.append(row);
}

// --- Rofi Controls ---
function addRofiBorderRow(label, increment = 1) {
    const row = new Gtk.Box({ orientation: Gtk.Orientation.HORIZONTAL, spacing: 8, halign: Gtk.Align.CENTER, valign: Gtk.Align.CENTER });
    const lbl = new Gtk.Label({ label, halign: Gtk.Align.END, xalign: 1 });
    lbl.set_size_request(110, -1);
    const decBtn = new Gtk.Button({ label: '-' });
    decBtn.set_size_request(32, 32);
    const incBtn = new Gtk.Button({ label: '+' });
    incBtn.set_size_request(32, 32);
    
    function updateRofiBorder(increment) {
        const rofiBorderFile = GLib.build_filenamev([GLib.get_home_dir(), '.config', 'hyprcandy', 'settings', 'rofi-border.rasi']);
        try {
            let [ok, contents] = GLib.file_get_contents(rofiBorderFile);
            if (ok && contents) {
                let content = imports.byteArray.toString(contents);
                let borderMatch = content.match(/border-width: ([0-9]+)px/);
                if (borderMatch) {
                    let currentValue = parseInt(borderMatch[1]);
                    let newValue = Math.max(0, currentValue + increment);
                    GLib.spawn_command_line_async(`sed -i 's/border-width: ${currentValue}px/border-width: ${newValue}px/' '${rofiBorderFile}'`);
                    GLib.spawn_command_line_async(`notify-send "Rofi Border" "Border: ${newValue}px" -t 2000`);
                }
            }
        } catch (e) {
            print('Error updating rofi border: ' + e.message);
        }
    }
    
    decBtn.connect('clicked', () => {
        updateRofiBorder(-increment);
    });
    incBtn.connect('clicked', () => {
        updateRofiBorder(increment);
    });
    
    row.append(lbl);
    row.append(decBtn);
    row.append(incBtn);
    leftBox.append(row);
}

function addRofiRadiusRow(label, increment = 0.1) {
    const row = new Gtk.Box({ orientation: Gtk.Orientation.HORIZONTAL, spacing: 8, halign: Gtk.Align.CENTER, valign: Gtk.Align.CENTER });
    const lbl = new Gtk.Label({ label, halign: Gtk.Align.END, xalign: 1 });
    lbl.set_size_request(110, -1);
    const decBtn = new Gtk.Button({ label: '-' });
    decBtn.set_size_request(32, 32);
    const incBtn = new Gtk.Button({ label: '+' });
    incBtn.set_size_request(32, 32);
    
    function updateRofiRadius(increment) {
        const rofiRadiusFile = GLib.build_filenamev([GLib.get_home_dir(), '.config', 'hyprcandy', 'settings', 'rofi-border-radius.rasi']);
        try {
            let [ok, contents] = GLib.file_get_contents(rofiRadiusFile);
            if (ok && contents) {
                let content = imports.byteArray.toString(contents);
                let radiusMatch = content.match(/border-radius: ([0-9.]+)em/);
                if (radiusMatch) {
                    let currentValue = parseFloat(radiusMatch[1]);
                    let newValue = Math.max(0, Math.min(5, currentValue + increment));
                    let newValueStr = newValue.toFixed(1);
                    GLib.spawn_command_line_async(`sed -i 's/border-radius: ${radiusMatch[1]}em/border-radius: ${newValueStr}em/' '${rofiRadiusFile}'`);
                    GLib.spawn_command_line_async(`notify-send "Rofi Radius" "Radius: ${newValueStr}em" -t 2000`);
                }
            }
        } catch (e) {
            print('Error updating rofi radius: ' + e.message);
        }
    }
    
    decBtn.connect('clicked', () => {
        updateRofiRadius(-increment);
    });
    incBtn.connect('clicked', () => {
        updateRofiRadius(increment);
    });
    
    row.append(lbl);
    row.append(decBtn);
    row.append(incBtn);
    leftBox.append(row);
}

// Move presets and weather to left box after opacity button
//leftBox.append(opacityBtn);

// Preset buttons
const presetBox = new Gtk.Box({ orientation: Gtk.Orientation.VERTICAL, spacing: 4, halign: Gtk.Align.CENTER });
// Add 'New Start Icon' button before Dock presets
const newStartIconBtn = new Gtk.Button({ label: 'New Start Icon' });
newStartIconBtn.connect('clicked', () => {
    GLib.spawn_command_line_async(`${GLib.get_home_dir()}/.config/hyprcandy/hooks/change_start_button_icon.sh`);
});
presetBox.append(newStartIconBtn);
const dockPresets = ['minimal', 'balanced', 'prominent', 'hidden'];
dockPresets.forEach(preset => {
    let btn = new Gtk.Button({ label: `Dock: ${preset.charAt(0).toUpperCase() + preset.slice(1)}` });
    btn.connect('clicked', () => {
        GLib.spawn_command_line_async(`bash -c '$HOME/.config/hyprcandy/hooks/nwg_dock_presets.sh ${preset}'`);
    });
    presetBox.append(btn);
});
const hyprPresets = ['minimal', 'balanced', 'spacious', 'zero'];
hyprPresets.forEach(preset => {
    let btn = new Gtk.Button({ label: `Hypr: ${preset.charAt(0).toUpperCase() + preset.slice(1)}` });
    btn.connect('clicked', () => {
        GLib.spawn_command_line_async(`bash -c '$HOME/.config/hyprcandy/hooks/hyprland_gap_presets.sh ${preset}'`);
    });
    presetBox.append(btn);
});
leftBox.append(presetBox);

mainRow.append(leftBox);

// --- Theme Box (Matugen Schemes) ---
const themeBox = new Gtk.Box({
    orientation: Gtk.Orientation.VERTICAL,
    spacing: 4,
    halign: Gtk.Align.CENTER,
    valign: Gtk.Align.CENTER
});

// Matugen state persistence setup
const matugenStateFile = GLib.build_filenamev([hyprsunsetStateDir, 'matugen-state']);
function loadMatugenState() {
    try {
        let [ok, contents] = GLib.file_get_contents(matugenStateFile);
        if (ok && contents) {
            let state = imports.byteArray.toString(contents).trim();
            return state || 'scheme-content'; // Default to content if empty
        }
    } catch (e) {}
    return 'scheme-content'; // Default fallback
}
function saveMatugenState(scheme) {
    try {
        GLib.file_set_contents(matugenStateFile, scheme);
    } catch (e) {}
}

let currentMatugenScheme = loadMatugenState();

// Matugen scheme buttons
const matugenSchemes = [
    'Content',
    'Expressive', 
    'Fidelity',
    'Fruit-salad',
    'Monochrome',
    'Neutral',
    'Rainbow',
    'Tonal-spot'
];

function updateMatugenScheme(schemeName) {
    const waypaperIntegrationFile = GLib.build_filenamev([GLib.get_home_dir(), '.config', 'hyprcandy', 'hooks', 'waypaper_integration.sh']);
    const gtk3File = GLib.build_filenamev([GLib.get_home_dir(), '.config', 'gtk-3.0', 'gtk.css']);
    const gtk4File = GLib.build_filenamev([GLib.get_home_dir(), '.config', 'gtk-4.0', 'gtk.css']);
    
    // Convert scheme name to matugen format
    const schemeMap = {
        'Content': 'scheme-content',
        'Expressive': 'scheme-expressive',
        'Fidelity': 'scheme-fidelity',
        'Fruit-salad': 'scheme-fruit-salad',
        'Monochrome': 'scheme-monochrome',
        'Neutral': 'scheme-neutral',
        'Rainbow': 'scheme-rainbow',
        'Tonal-spot': 'scheme-tonal-spot'
    };
    
    const matugenScheme = schemeMap[schemeName];
    if (!matugenScheme) return;
    
    // Update the waypaper_integration.sh file
    GLib.spawn_command_line_async(`sed -i 's/--type scheme-[^ ]*/--type ${matugenScheme}/' '${waypaperIntegrationFile}'`);
    
    // Handle monochrome vs other schemes for GTK CSS
    if (schemeName === 'Monochrome') {
        // Replace @on_secondary with @on_primary_fixed_variant for monochrome
        GLib.spawn_command_line_async(`sed -i 's/@on_secondary/@on_primary_fixed_variant/g' '${gtk3File}'`);
        GLib.spawn_command_line_async(`sed -i 's/@on_secondary/@on_primary_fixed_variant/g' '${gtk4File}'`);
    } else {
        // Replace @on_primary_fixed_variant with @on_secondary for other schemes
        GLib.spawn_command_line_async(`sed -i 's/@on_primary_fixed_variant/@on_secondary/g' '${gtk3File}'`);
        GLib.spawn_command_line_async(`sed -i 's/@on_primary_fixed_variant/@on_secondary/g' '${gtk4File}'`);
    }
    
    // Save the new state
    saveMatugenState(matugenScheme);
    currentMatugenScheme = matugenScheme;
    
    // Update button states
    updateMatugenButtonStates();
}

function updateMatugenButtonStates() {
    // Update all button states based on current scheme
    for (let i = 0; i < matugenButtons.length; i++) {
        const btn = matugenButtons[i];
        const schemeName = matugenSchemes[i];
        const schemeMap = {
            'Content': 'scheme-content',
            'Expressive': 'scheme-expressive',
            'Fidelity': 'scheme-fidelity',
            'Fruit-salad': 'scheme-fruit-salad',
            'Monochrome': 'scheme-monochrome',
            'Neutral': 'scheme-neutral',
            'Rainbow': 'scheme-rainbow',
            'Tonal-spot': 'scheme-tonal-spot'
        };
        
        if (currentMatugenScheme === schemeMap[schemeName]) {
            btn.add_css_class('neon-highlight');
        } else {
            btn.remove_css_class('neon-highlight');
        }
    }
}

const matugenButtons = [];
matugenSchemes.forEach(schemeName => {
    const btn = new Gtk.Button({ label: schemeName });
    btn.connect('clicked', () => {
        updateMatugenScheme(schemeName);
    });
    matugenButtons.push(btn);
    themeBox.append(btn);
});

// Set initial button states
updateMatugenButtonStates();

//mainRow.append(themeBox);

// Right: All toggles
const rightBox = new Gtk.Box({
    orientation: Gtk.Orientation.VERTICAL,
    spacing: 16,
    halign: Gtk.Align.CENTER,
    valign: Gtk.Align.CENTER
});

// Create new toggles box for right side
const rightTogglesBox = new Gtk.Box({
    orientation: Gtk.Orientation.VERTICAL,
    spacing: 10,
    halign: Gtk.Align.CENTER,
    valign: Gtk.Align.CENTER
});

// Move all toggle functions to append to rightTogglesBox instead of togglesBox
function addToggleRowRight(label, incScript, decScript) {
    const row = new Gtk.Box({ orientation: Gtk.Orientation.HORIZONTAL, spacing: 8, halign: Gtk.Align.CENTER, valign: Gtk.Align.CENTER });
    const lbl = new Gtk.Label({ label, halign: Gtk.Align.END, xalign: 1 });
    lbl.set_size_request(110, -1);
    const decBtn = new Gtk.Button({ label: '-' });
    decBtn.set_size_request(32, 32);
    const incBtn = new Gtk.Button({ label: '+' });
    incBtn.set_size_request(32, 32);
    decBtn.connect('clicked', () => {
        GLib.spawn_command_line_async(`bash -c '$HOME/.config/hyprcandy/hooks/${decScript}'`);
    });
    incBtn.connect('clicked', () => {
        GLib.spawn_command_line_async(`bash -c '$HOME/.config/hyprcandy/hooks/${incScript}'`);
    });
    row.append(lbl);
    row.append(decBtn);
    row.append(incBtn);
    rightTogglesBox.append(row);
}

function activeOpacityRowRight(label, configKey) {
    const row = new Gtk.Box({ orientation: Gtk.Orientation.HORIZONTAL, spacing: 8, halign: Gtk.Align.CENTER, valign: Gtk.Align.CENTER });
    const lbl = new Gtk.Label({ label, halign: Gtk.Align.END, xalign: 1 });
    lbl.set_size_request(110, -1);
    const decBtn = new Gtk.Button({ label: '-' });
    decBtn.set_size_request(32, 32);
    const incBtn = new Gtk.Button({ label: '+' });
    incBtn.set_size_request(32, 32);
    
    function updateActiveOpacity(increment) {
        const configFile = GLib.build_filenamev([GLib.get_home_dir(), '.config', 'hyprcustom', 'custom.conf']);
        // Read current value
        try {
            let [ok, contents] = GLib.file_get_contents(configFile);
            if (ok && contents) {
                let content = imports.byteArray.toString(contents);
                let regex = new RegExp(`active_opacity = ([0-9.]+)`);
                let match = content.match(regex);
                if (match) {
                    let currentValue = parseFloat(match[1]);
                    let newValue = Math.max(0.0, Math.min(1.0, currentValue + increment));
                    let newValueStr = newValue.toFixed(2);
                    GLib.spawn_command_line_async(`sed -i 's/active_opacity = .*/active_opacity = ${newValueStr}/' "${configFile}"`);
                    GLib.spawn_command_line_async('hyprctl reload');
                    GLib.spawn_command_line_async(`notify-send "Opacity" "Scale: ${newValueStr}" -t 2000`);
                }
            }
        } catch (e) {}
    }
    
    decBtn.connect('clicked', () => {
        updateActiveOpacity(-0.05);
    });
    incBtn.connect('clicked', () => {
        updateActiveOpacity(0.05);
    });
    
    row.append(lbl);
    row.append(decBtn);
    row.append(incBtn);
    rightTogglesBox.append(row);
}

function addBlurSizeRowRight(label, configKey, increment = 1) {
    const row = new Gtk.Box({ orientation: Gtk.Orientation.HORIZONTAL, spacing: 8, halign: Gtk.Align.CENTER, valign: Gtk.Align.CENTER });
    const lbl = new Gtk.Label({ label, halign: Gtk.Align.END, xalign: 1 });
    lbl.set_size_request(110, -1);
    const decBtn = new Gtk.Button({ label: '-' });
    decBtn.set_size_request(32, 32);
    const incBtn = new Gtk.Button({ label: '+' });
    incBtn.set_size_request(32, 32);
    
    function updateBlurSize(increment) {
        const configFile = GLib.build_filenamev([GLib.get_home_dir(), '.config', 'hyprcustom', 'custom.conf']);
        // Read current value
        try {
            let [ok, contents] = GLib.file_get_contents(configFile);
            if (ok && contents) {
                let content = imports.byteArray.toString(contents);
                // Look for size = X inside the blur block
                let blurSection = content.match(/blur \{[\s\S]*?\}/);
                if (blurSection) {
                    let sizeMatch = blurSection[0].match(/size = ([0-9]+)/);
                    if (sizeMatch) {
                        let currentValue = parseInt(sizeMatch[1]);
                        let newValue = Math.max(0, currentValue + increment);
                        // Use a simpler sed command that targets the specific line
                        GLib.spawn_command_line_async(`sed -i '/blur {/,/}/{s/size = ${currentValue}/size = ${newValue}/}' '${configFile}'`);
                        GLib.spawn_command_line_async('hyprctl reload');
                        GLib.spawn_command_line_async(`notify-send "Blur Size" "Size: ${newValue}" -t 2000`);
                    }
                }
            }
        } catch (e) {
            print('Error updating blur size: ' + e.message);
        }
    }
    
    decBtn.connect('clicked', () => {
        updateBlurSize(-increment);
    });
    incBtn.connect('clicked', () => {
        updateBlurSize(increment);
    });
    
    row.append(lbl);
    row.append(decBtn);
    row.append(incBtn);
    rightTogglesBox.append(row);
}

function addBlurPassRowRight(label, configKey, increment = 1) {
    const row = new Gtk.Box({ orientation: Gtk.Orientation.HORIZONTAL, spacing: 8, halign: Gtk.Align.CENTER, valign: Gtk.Align.CENTER });
    const lbl = new Gtk.Label({ label, halign: Gtk.Align.END, xalign: 1 });
    lbl.set_size_request(110, -1);
    const decBtn = new Gtk.Button({ label: '-' });
    decBtn.set_size_request(32, 32);
    const incBtn = new Gtk.Button({ label: '+' });
    incBtn.set_size_request(32, 32);
    
    function updateBlurPass(increment) {
        const configFile = GLib.build_filenamev([GLib.get_home_dir(), '.config', 'hyprcustom', 'custom.conf']);
        // Read current value
        try {
            let [ok, contents] = GLib.file_get_contents(configFile);
            if (ok && contents) {
                let content = imports.byteArray.toString(contents);
                // Look for passes = X inside the blur block
                let blurSection = content.match(/blur \{[\s\S]*?\}/);
                if (blurSection) {
                    let passesMatch = blurSection[0].match(/passes = ([0-9]+)/);
                    if (passesMatch) {
                        let currentValue = parseInt(passesMatch[1]);
                        let newValue = Math.max(0, currentValue + increment);
                        // Use a simpler sed command that targets the specific line
                        GLib.spawn_command_line_async(`sed -i 's/passes = ${currentValue}/passes = ${newValue}/' '${configFile}'`);
                        GLib.spawn_command_line_async('hyprctl reload');
                        GLib.spawn_command_line_async(`notify-send "Blur Pass" "Passes: ${newValue}" -t 2000`);
                    }
                }
            }
        } catch (e) {
            print('Error updating blur passes: ' + e.message);
        }
    }
    
    decBtn.connect('clicked', () => {
        updateBlurPass(-increment);
    });
    incBtn.connect('clicked', () => {
        updateBlurPass(increment);
    });
    
    row.append(lbl);
    row.append(decBtn);
    row.append(incBtn);
    rightTogglesBox.append(row);
}

function addRofiBorderRowRight(label, increment = 1) {
    const row = new Gtk.Box({ orientation: Gtk.Orientation.HORIZONTAL, spacing: 8, halign: Gtk.Align.CENTER, valign: Gtk.Align.CENTER });
    const lbl = new Gtk.Label({ label, halign: Gtk.Align.END, xalign: 1 });
    lbl.set_size_request(110, -1);
    const decBtn = new Gtk.Button({ label: '-' });
    decBtn.set_size_request(32, 32);
    const incBtn = new Gtk.Button({ label: '+' });
    incBtn.set_size_request(32, 32);
    
    function updateRofiBorder(increment) {
        const rofiBorderFile = GLib.build_filenamev([GLib.get_home_dir(), '.config', 'hyprcandy', 'settings', 'rofi-border.rasi']);
        try {
            let [ok, contents] = GLib.file_get_contents(rofiBorderFile);
            if (ok && contents) {
                let content = imports.byteArray.toString(contents);
                let borderMatch = content.match(/border-width: ([0-9]+)px/);
                if (borderMatch) {
                    let currentValue = parseInt(borderMatch[1]);
                    let newValue = Math.max(0, currentValue + increment);
                    GLib.spawn_command_line_async(`sed -i 's/border-width: ${currentValue}px/border-width: ${newValue}px/' '${rofiBorderFile}'`);
                    GLib.spawn_command_line_async(`notify-send "Rofi Border" "Border: ${newValue}px" -t 2000`);
                }
            }
        } catch (e) {
            print('Error updating rofi border: ' + e.message);
        }
    }
    
    decBtn.connect('clicked', () => {
        updateRofiBorder(-increment);
    });
    incBtn.connect('clicked', () => {
        updateRofiBorder(increment);
    });
    
    row.append(lbl);
    row.append(decBtn);
    row.append(incBtn);
    rightTogglesBox.append(row);
}

function addRofiRadiusRowRight(label, increment = 0.1) {
    const row = new Gtk.Box({ orientation: Gtk.Orientation.HORIZONTAL, spacing: 8, halign: Gtk.Align.CENTER, valign: Gtk.Align.CENTER });
    const lbl = new Gtk.Label({ label, halign: Gtk.Align.END, xalign: 1 });
    lbl.set_size_request(110, -1);
    const decBtn = new Gtk.Button({ label: '-' });
    decBtn.set_size_request(32, 32);
    const incBtn = new Gtk.Button({ label: '+' });
    incBtn.set_size_request(32, 32);
    
    function updateRofiRadius(increment) {
        const rofiRadiusFile = GLib.build_filenamev([GLib.get_home_dir(), '.config', 'hyprcandy', 'settings', 'rofi-border-radius.rasi']);
        try {
            let [ok, contents] = GLib.file_get_contents(rofiRadiusFile);
            if (ok && contents) {
                let content = imports.byteArray.toString(contents);
                let radiusMatch = content.match(/border-radius: ([0-9.]+)em/);
                if (radiusMatch) {
                    let currentValue = parseFloat(radiusMatch[1]);
                    let newValue = Math.max(0, Math.min(5, currentValue + increment));
                    let newValueStr = newValue.toFixed(1);
                    GLib.spawn_command_line_async(`sed -i 's/border-radius: ${radiusMatch[1]}em/border-radius: ${newValueStr}em/' '${rofiRadiusFile}'`);
                    GLib.spawn_command_line_async(`notify-send "Rofi Radius" "Radius: ${newValueStr}em" -t 2000`);
                }
            }
        } catch (e) {
            print('Error updating rofi radius: ' + e.message);
        }
    }
    
    decBtn.connect('clicked', () => {
        updateRofiRadius(-increment);
    });
    incBtn.connect('clicked', () => {
        updateRofiRadius(increment);
    });
    
    row.append(lbl);
    row.append(decBtn);
    row.append(incBtn);
    rightTogglesBox.append(row);
}

// Add all toggles to the right box
addToggleRowRight('Dock Icon Size', 'nwg_dock_icon_size_increase.sh', 'nwg_dock_icon_size_decrease.sh');
addToggleRowRight('Dock Radius', 'nwg_dock_border_radius_increase.sh', 'nwg_dock_border_radius_decrease.sh');
addToggleRowRight('Dock Width', 'nwg_dock_border_width_increase.sh', 'nwg_dock_border_width_decrease.sh');
addToggleRowRight('Rounding', 'hyprland_rounding_increase.sh', 'hyprland_rounding_decrease.sh');
addToggleRowRight('Gaps OUT', 'hyprland_gaps_out_increase.sh', 'hyprland_gaps_out_decrease.sh');
addToggleRowRight('Gaps IN', 'hyprland_gaps_in_increase.sh', 'hyprland_gaps_in_decrease.sh');
addToggleRowRight('Border', 'hyprland_border_increase.sh', 'hyprland_border_decrease.sh');
addBlurSizeRowRight('Blur Size', 'size', 1);
addBlurPassRowRight('Blur Pass', 'passes', 1);
addRofiBorderRowRight('Rofi Border', 1);
addRofiRadiusRowRight('Rofi Radius', 0.1);
activeOpacityRowRight('Opacity Scale', 'active_opacity');

rightBox.append(rightTogglesBox);
mainRow.append(rightBox);
return mainRow;
}

// Export both functions
var exports = {
    createTogglesBox
}; 
EOF

cat > "$HOME/.hyprcandy/GJS/src/weather.js" << 'EOF'
imports.gi.versions.Gtk = '4.0';
imports.gi.versions.Gio = '2.0';
imports.gi.versions.GLib = '2.0';
imports.gi.versions.Gdk = '4.0';
imports.gi.versions.Soup = '3.0';
const { Gtk, Gio, GLib, Gdk, Soup } = imports.gi;

const scriptDir = GLib.path_get_dirname(imports.system.programInvocationName);
imports.searchPath.unshift(scriptDir);

function createWeatherBox() {
    // Load user's GTK color theme
    const userColorsProvider = new Gtk.CssProvider();
    userColorsProvider.load_from_path(GLib.build_filenamev([GLib.get_home_dir(), '.config', 'gtk-3.0', 'colors.css']));
    Gtk.StyleContext.add_provider_for_display(
        Gdk.Display.get_default(),
        userColorsProvider,
        Gtk.STYLE_PROVIDER_PRIORITY_USER
    );

    // Load our custom gradient CSS after user theme
    const cssProvider = new Gtk.CssProvider();
    let css = `
        .media-player-frame, .weather-frame, .tray-frame {
            border-radius: 22px;
            min-width: 244px;
            min-height: 118px;
            padding: 0px 0px;
            box-shadow: 0 4px 32px 0 rgba(0,0,0,0.22);
            background: linear-gradient(45deg, @source_color 0%, @background 100%, #9558e1 0%, #16121a 100%);
            background-size: cover;
        }
        .weather-bg-overlay {
            background-size: cover;
            background-position: center;
            background-repeat: no-repeat;
            background-color: rgba(0, 0, 0, 0.12);
            opacity: 0.95;
            border-radius: 22px;
        }
        .weather-blurred-bg {
            background-size: cover;
            background-position: center;
            background-repeat: no-repeat;
            background-color: rgba(0,0,0,0.4);
            opacity: 0.8;
            border-radius: 22px;
        }
        .weather-content {
            margin: 0px;
            padding: 0px;
        }
        .weather-temp {
            font-size: 1.8em;
            font-weight: 700;
            color: @primary_fixed_dim;
            text-shadow: 0 0 12px @background;
            opacity: 1;
        }
        .weather-desc {
            font-size: 0.9em;
            font-weight: 600;
            color: #f0f0f0;
            text-shadow: 0 0 8px rgba(224, 224, 224, 0.6);
            opacity: 1;
        }
        .weather-location {
            font-size: 0.8em;
            font-weight: 500;
            color: #ffffff;
            text-shadow: 0 0 6px rgba(255, 255, 255, 0.7);
            opacity: 1;
        }
    `;
    cssProvider.load_from_data(css, css.length);
    Gtk.StyleContext.add_provider_for_display(
        Gdk.Display.get_default(),
        cssProvider,
        Gtk.STYLE_PROVIDER_PRIORITY_APPLICATION
    );

    // --- Weather Frame and Box ---
    const weatherFrame = new Gtk.Overlay({
        halign: Gtk.Align.CENTER,
        valign: Gtk.Align.CENTER,
        hexpand: true,
        vexpand: true,
        margin_top: 2,
        margin_bottom: 2,
        margin_start: 2,
        margin_end: 2
    });
    weatherFrame.add_css_class('weather-frame');

    // Weather content
    const weatherBox = new Gtk.Box({
        orientation: Gtk.Orientation.VERTICAL,
        spacing: 4,
        hexpand: true,
        vexpand: true,
        halign: Gtk.Align.CENTER,
        valign: Gtk.Align.CENTER,
        margin_top: 0, // Reduced from 8
        margin_bottom: 0 // Reduced from 8
    });
    weatherBox.add_css_class('weather-content');

    // Weather labels
    const weatherTemp = new Gtk.Label({
        label: '--°C',
        halign: Gtk.Align.CENTER,
        valign: Gtk.Align.CENTER,
    });
    weatherTemp.add_css_class('weather-temp');
    
    const weatherDesc = new Gtk.Label({
        label: 'Weather',
        halign: Gtk.Align.CENTER,
        valign: Gtk.Align.CENTER,
        ellipsize: 3,
        max_width_chars: 15,
    });
    weatherDesc.add_css_class('weather-desc');
    
    const weatherLocation = new Gtk.Label({
        label: 'Location',
        halign: Gtk.Align.CENTER,
        valign: Gtk.Align.CENTER,
        ellipsize: 3,
        max_width_chars: 15,
    });
    weatherLocation.add_css_class('weather-location');

    weatherBox.append(weatherTemp);
    weatherBox.append(weatherDesc);
    weatherBox.append(weatherLocation);
    weatherFrame.set_child(weatherBox);

    // --- Weather async/cached update function using wttr.in ---
    let weatherCache = null;
    let weatherCacheTime = 0;
    const WEATHER_CACHE_DURATION = 10 * 60 * 1000; // 10 minutes in ms
    const WEATHER_URL = 'https://wttr.in/?format=j1';
    const session = new Soup.Session();

    function setWeatherLabels(weatherData) {
        weatherTemp.set_label(`${weatherData.temp}°C`);
        weatherDesc.set_label(weatherData.desc);
        weatherLocation.set_label(weatherData.loc);
    }

    function updateWeather() {
        const now = Date.now();
        if (weatherCache && (now - weatherCacheTime < WEATHER_CACHE_DURATION)) {
            setWeatherLabels(weatherCache);
            return;
        }
        let message = Soup.Message.new('GET', WEATHER_URL);
        session.send_and_read_async(message, GLib.PRIORITY_DEFAULT, null, (session, res) => {
            try {
                let bytes = session.send_and_read_finish(res);
                let text = imports.byteArray.toString(bytes.get_data());
                let data = JSON.parse(text);
                let current = data.current_condition && data.current_condition[0];
                let temp = current ? current.temp_C : '--';
                let desc = current && current.weatherDesc && current.weatherDesc[0] ? current.weatherDesc[0].value : 'Weather';
                let loc = data.nearest_area && data.nearest_area[0] && data.nearest_area[0].areaName && data.nearest_area[0].areaName[0] ? data.nearest_area[0].areaName[0].value : 'Location';
                let weatherData = { temp, desc, loc };
                weatherCache = weatherData;
                weatherCacheTime = Date.now();
                setWeatherLabels(weatherData);
            } catch (e) {
                setWeatherLabels({ temp: '--', desc: 'Weather', loc: 'Location' });
            }
        });
    }

    updateWeather();
    const weatherInterval = GLib.timeout_add(GLib.PRIORITY_DEFAULT, 30000, () => {
        updateWeather();
        return true;
    });

    return weatherFrame;
}

function createWeatherBoxForEmbed() {
    // Only the weather content box, no overlay or extra margins
    const weatherBox = new Gtk.Box({
        orientation: Gtk.Orientation.VERTICAL,
        spacing: 4,
        hexpand: true,
        vexpand: true,
        halign: Gtk.Align.CENTER,
        valign: Gtk.Align.CENTER,
        margin_top: 0,
        margin_bottom: 0
    });
    weatherBox.add_css_class('weather-content');

    const weatherTemp = new Gtk.Label({
        label: '--°C',
        halign: Gtk.Align.CENTER,
        valign: Gtk.Align.CENTER,
    });
    weatherTemp.add_css_class('weather-temp');
    const weatherDesc = new Gtk.Label({
        label: 'Weather',
        halign: Gtk.Align.CENTER,
        valign: Gtk.Align.CENTER,
        ellipsize: 3,
        max_width_chars: 15,
    });
    weatherDesc.add_css_class('weather-desc');
    const weatherLocation = new Gtk.Label({
        label: 'Location',
        halign: Gtk.Align.CENTER,
        valign: Gtk.Align.CENTER,
        ellipsize: 3,
        max_width_chars: 15,
    });
    weatherLocation.add_css_class('weather-location');
    weatherBox.append(weatherTemp);
    weatherBox.append(weatherDesc);
    weatherBox.append(weatherLocation);

    // --- Weather async/cached update function using wttr.in ---
    let weatherCache = null;
    let weatherCacheTime = 0;
    const WEATHER_CACHE_DURATION = 10 * 60 * 1000;
    const WEATHER_URL = 'https://wttr.in/?format=j1';
    const session = new Soup.Session();

    function setWeatherLabels(weatherData) {
        weatherTemp.set_label(`${weatherData.temp}°C`);
        weatherDesc.set_label(weatherData.desc);
        weatherLocation.set_label(weatherData.loc);
    }

    function updateWeather() {
        const now = Date.now();
        if (weatherCache && (now - weatherCacheTime < WEATHER_CACHE_DURATION)) {
            setWeatherLabels(weatherCache);
            return;
        }
        let message = Soup.Message.new('GET', WEATHER_URL);
        session.send_and_read_async(message, GLib.PRIORITY_DEFAULT, null, (session, res) => {
            try {
                let bytes = session.send_and_read_finish(res);
                let text = imports.byteArray.toString(bytes.get_data());
                let data = JSON.parse(text);
                let current = data.current_condition && data.current_condition[0];
                let temp = current ? current.temp_C : '--';
                let desc = current && current.weatherDesc && current.weatherDesc[0] ? current.weatherDesc[0].value : 'Weather';
                let loc = data.nearest_area && data.nearest_area[0] && data.nearest_area[0].areaName && data.nearest_area[0].areaName[0] ? data.nearest_area[0].areaName[0].value : 'Location';
                let weatherData = { temp, desc, loc };
                weatherCache = weatherData;
                weatherCacheTime = Date.now();
                setWeatherLabels(weatherData);
            } catch (e) {
                setWeatherLabels({ temp: '--', desc: 'Weather', loc: 'Location' });
            }
        });
    }

    updateWeather();
    const weatherInterval = GLib.timeout_add(GLib.PRIORITY_DEFAULT, 30000, () => {
        updateWeather();
        return true;
    });

    return weatherBox;
}

var exports = {
    createWeatherBox,
    createWeatherBoxForEmbed
}; 
EOF

echo "✅ Files and Apps setup complete"
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

pgrep -x swww-daemon > /dev/null 2>&1 || swww-daemon &
sleep 1
swww img "$HOME/.config/background"

# Update SDDM background with sudo
if command -v magick >/dev/null && [ -f "$HOME/.config/background" ]; then
    sudo magick "$HOME/.config/background[0]" "/usr/share/sddm/themes/sugar-candy/Backgrounds/Mountain.jpg"
    sleep 1
fi

systemctl --user daemon-reload
systemctl --user disable --now hyprpanel.service hyprpanel-idle-monitor.service waybar.service waybar-idle-monitor.service waypaper-watcher.service background-watcher.service swww.service rofi-font-watcher.service cursor-theme-watcher.service &>/dev/null
sleep 1
systemctl --user stop hyprpanel.service hyprpanel-idle-monitor.service waybar-idle-monitor.service waypaper-watcher.service background-watcher.service rofi-font-watcher.service cursor-theme-watcher.service &>/dev/null

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
        hyprctl reload
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
    echo -e "${YELLOW}Would you like to reboot now? (n/Y)${NC}"
    read -r reboot_choice
    case "$reboot_choice" in
        [nN][oO]|[nN])
            print_status "Reboot skipped. Please reboot manually when convenient."
            print_status "Run: sudo reboot"
            ;;
        *)
            print_status "Rebooting system..."
            sudo reboot
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
    
    # Choose a panel
    choose_panel
    echo
    
    # Choose a browser
    choose_browser
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
    echo -e "${YELLOW}This will install ${#packages[@]} packages and setup HyprCandy configuration. Continue? (n/Y)${NC}"
    read -r response
    case "$response" in
        [nN][oO]|[nN])
            print_status "Installation cancelled."
            exit 0
            ;;
        *)
            install_packages
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

    # Update keybinds based on choice
    update_keybinds
    
    # Update custom config based on choice
    update_custom

    # Setup GJS
    setup_gjs

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
    echo -e "${PURPLE}🔎 Browser Color Theming:${NC}"
    print_status "• If you chose Brave, go to ${YELLOW}Appearance${NC} in Settings and set the 'Theme' to ${CYAN}GTK${NC} and Brave colors to Same as Linux"
    print_status "• If you chose Firefox, install the ${YELLOW}pywalfox${NC} extension and run ${YELLOW}pywalfox update${NC} in kitty"
    print_status "• If you chose Zen Browser, for slight additional theming install the ${YELLOW}pywalfox${NC} extension and run ${YELLOW}pywalfox update${NC}"
    print_status "• If you chose Librewolf, you know what you're doing"
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
