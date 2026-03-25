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
        "hyprlang"
        "hyprlock"
        "hyprpaper"
        "hyprpicker"
        "hyprpolkitagent"
        "hyprsunset"
        "hyprsysteminfo"
        "hyprutils"
        "hyprwayland-scanner"
        
        # Packages
        "pacman-contrib"
        "octopi"
        "rebuild-detector"
        
        # Dependacies
        "meson" 
        "cpio" 
        "cmake"
        
        # GNOME components (always include gnome-control-center and gnome-tweaks)
        "gnome-control-center"
        "gnome-tweaks"
        "gnome-software"
        "mutter"
        
        # Terminals and file manager
        "kitty"
        "nautilus"
        
        # Qt and GTK theming
        "qt5ct"
        "qt6ct"
        "nwg-look"
        
        # System utilities
        "blueman"
        "r-quick-share"
        "nwg-displays"
        "wlogout"
        "uwsm"
        "quickshell"
        
        # Application launchers and menus
        "rofi"
        "rofi-emoji"
        "rofi-nerdy"
        
        # Wallpaper and screenshot tools
        "awww"
        "grimblast-git"
        "wob"
        "wf-recorder"
        "slurp"
        "swappy"
        
        # System tools
        "gnome-disk-utility"
        "brightnessctl"
        "playerctl"
        "power-profiles-daemon"
        
        # Audio system
        "pipewire"
        "pipewire-jack"
        "pipewire-pulse"
        "pipewire-alsa"
        "alsa-utils"
        
        # System monitoring
        "btop"
        "nvtop"
        "htop"
        
        # Customization and theming
        "matugen-bin"
        
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
        
        # Browser and themes
        #"adw-gtk-theme"
        #"adwaita-qt6"   Keeping the libadwaita default which is themed by my matugen setup
        #"adwaita-qt-git"
        "tela-circle-icon-theme-all"
        
        # Cursor themes
        "bibata-cursor-theme-bin"
        
        # Entertainment
        "spotify"
        
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
    
    
    # Add panel based on user choice
    if [ "$PANEL_CHOICE" = "waybar" ]; then
        packages+=(
        "waybar"
        "waypaper-git"
        "swaync"
        )
        print_status "Added Waybar to package list"
    else
        packages+=(
        "ags-hyprpanel-git"
        "mako"
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
        
        if $AUR_HELPER -S --needed "${batch[@]}"; then
            installed=$((installed + ${#batch[@]}))
            print_success "Batch $((i/batch_size + 1)) installed successfully"
        else
            print_warning "Some packages in batch $((i/batch_size + 1)) failed to install"
            # Try installing packages individually to identify failures
            for pkg in "${batch[@]}"; do
                if ! $AUR_HELPER -S --needed "$pkg"; then
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

    print_status "Setting up HyprCandy configuration..."
    # Prevent notification daemon conflicts
    if [ "$PANEL_CHOICE" = "waybar" ]; then
        print_status "Attempting to remove mako since you chose waybar to avoid conflicts with swaync incase mako was installed before..."
        $AUR_HELPER -R mako
    else
        print_status "Attempting to remove swaync since you chose hyprpanel to avoid conflicts with mako incase swaync was installed before..."
        $AUR_HELPER -R swaync
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
    
    # Ensure Fisher function exists
mkdir -p ~/.config/fish/functions
curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish -o ~/.config/fish/functions/fisher.fish

# Now install plugins using fisher (must be in a proper Fish shell)
fish -c '
    fisher install jorgebucaran/fisher
    fisher install \
        jorgebucaran/autopair.fish \
        jethrokuan/z \
        patrickf1/fzf.fish \
        franciscolourenco/done
'
    
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

[username]
style_user = "bold blue"
style_root = "bold red"
format = "[󱞬](grey) [](green) [$user](grey) [](green) ($style)"
show_always = true

[directory]
style = "blue"
read_only = " 🔒"
truncation_length = 4
truncate_to_repo = false

[character]
success_symbol = "[󱞪](grey) [](green)"
error_symbol = "[󱞪](grey) [x](red)"
vimcmd_symbol = "[󱞪](grey) [❮](green)"

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
symbol = "💠 󰁍"
style = "bold green"

[python]
symbol = "🐍 󰁍"
style = "bold yellow"

[rust]
symbol = "⚙️ 󰁍"
style = "bold red"

[time]
format = '[](green) [\[ $time \]](grey) [](green)($style) '#🕙
time_format = "%T"
disabled = false
style = "bright-white"

[cmd_duration]
format = "⏱️ [$duration]($style) 󰁍"
style = "yellow"

[jobs]
symbol = "⚡ 󰁍"
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
set -gx HYPRLAND_LOG_WS 1
set -x EDITOR micro
set -x BROWSER firefox
set -x TERMINAL kitty

# Add local bin to PATH
if test -d ~/.local/bin
    set -x PATH ~/.local/bin $PATH
end

# Aliases
alias hyprcandy="cd .hyprcandy && git pull && stow --ignore='Candy' --ignore='Candy-Images' --ignore='Dock-SVGs' --ignore='Gifs' --ignore='Logo' --ignore='transparent.png' --ignore='GJS' --ignore='toggle-control-center.sh' --ignore='toggle-media-player.sh' --ignore='toggle-system-monitor.sh' --ignore='toggle-weather-widget.sh' --ignore='toggle-hyprland-settings.sh' --ignore='candy-system-monitor.js' --ignore='resources' --ignore='src' --ignore='meson.build' --ignore='README.md' --ignore='run.log' --ignore='test_layout.js' --ignore='test_media_menu.js' --ignore='toggle.js' --ignore='toggle-main.js' --ignore='~' --ignore='candy-main.js' --ignore='gjs-media-player.desktop' --ignore='gjs-toggle-controls.desktop' --ignore='main.js' --ignore='media-main.js' --ignore='SEEK_FEATURE.md' --ignore='setup-custom-icon.sh' --ignore='weather-main.js' */"
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
alias clock="tty-clock -s -c"
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

[username]
style_user = "bold blue"
style_root = "bold red"
format = "[󱞬](grey) [](green) [$user](grey) [](green) ($style)"
show_always = true

[directory]
style = "blue"
read_only = " 🔒"
truncation_length = 4
truncate_to_repo = false

[character]
success_symbol = "[󱞪](grey) [](green)"
error_symbol = "[󱞪](grey) [x](red)"
vimcmd_symbol = "[󱞪](grey) [❮](green)"

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
symbol = "💠 󰁍"
style = "bold green"

[python]
symbol = "🐍 󰁍"
style = "bold yellow"

[rust]
symbol = "⚙️ 󰁍"
style = "bold red"

[time]
format = '[](green) [\[ $time \]](grey) [](green)($style) '#🕙
time_format = "%T"
disabled = false
style = "bright-white"

[cmd_duration]
format = "⏱️ [$duration]($style) 󰁍"
style = "yellow"

[jobs]
symbol = "⚡ 󰁍"
style = "bold blue"
EOF
        
        # Create .zshrc with Starship configuration
        cat > "$HOME/.zshrc" << 'EOF'
# HyprCandy Zsh Configuration with Oh My Zsh and Starship

# Oh My Zsh configuration
export ZSH="$HOME/.oh-my-zsh"

# Set environment variables
export HYPRLAND_LOG_WS=1
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

alias hyprcandy="cd .hyprcandy && git pull && stow --ignore='Candy' --ignore='Candy-Images' --ignore='Dock-SVGs' --ignore='Gifs' --ignore='Logo' --ignore='transparent.png' --ignore='GJS' --ignore='toggle-control-center.sh' --ignore='toggle-media-player.sh' --ignore='toggle-system-monitor.sh' --ignore='toggle-weather-widget.sh' --ignore='toggle-hyprland-settings.sh' --ignore='candy-system-monitor.js' --ignore='resources' --ignore='src' --ignore='meson.build' --ignore='README.md' --ignore='run.log' --ignore='test_layout.js' --ignore='test_media_menu.js' --ignore='toggle.js' --ignore='toggle-main.js' --ignore='~' --ignore='candy-main.js' --ignore='gjs-media-player.desktop' --ignore='gjs-toggle-controls.desktop' --ignore='main.js' --ignore='media-main.js' --ignore='SEEK_FEATURE.md' --ignore='setup-custom-icon.sh' --ignore='weather-main.js' */"
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
alias clock="tty-clock -s -c"
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
    
    print_status "Setting up HyprCandy configuration..."
    
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

    # Remove existing .hyprcandy folder
    if [ -d "$HOME/.ultracandy" ]; then
        echo "🗑️  Removing existing .hyprcandy folder..."
        rm -rf "$HOME/.ultracandy"
        rm -rf "$HOME/.hyprcandy"
        sleep 2
    else
        echo "✅ Seems to be a fresh install."
        rm -rf "$HOME/.hyprcandy"
        sleep 2
    fi

    # Clone HyprCandy repository
    hyprcandy_dir="$HOME/.hyprcaandy"
    echo "🌐 Cloning HyprCandy repository ..." #into $hyprcandy_dir
    git clone https://github.com/HyprCandy/Hyprcandy.git "$hyprcandy_dir"
    echo "✅ Cloninig complete"
    
    # Clone overview repository
    #overview_dir="$HOME/.config/quickshell/overview"
    #if [ ! -d "$overview_dir" ]; then
        #echo "🌐 Cloning overview repository ..."
        #git clone https://github.com/Shanu-Kumawat/quickshell-overview "$overview_dir"
        #echo "✅ Cloning complete"
    #fi
    
    # Go to the home directory
    cd "$HOME"

    # Remove present .zshrc file 
    rm -rf .face.icon .hyprcandy-zsh.zsh .icons Candy GJS
    rm -rf "$HOME/Pictures/HyprCandy"

    # Ensure ~/.config exists, then remove specified subdirectories
    [ -d "$HOME/.config" ] || mkdir -p "$HOME/.config"
    cd "$HOME/.config" || exit 1
    rm -rf background background.png btop cava fastfetch gtk-3.0 gtk-4.0 htop hypr hyprcustom hyprcandy hyprpanel kitty matugen micro nvtop nwg-dock-hyprland nwg-look qt5ct qt6ct quickshell rofi swaync wallust waybar waypaper wlogout xsettingsd

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
    
    # Change to the HyprCandy dotfiles directory
    cd "$hyprcandy_dir" || { echo "❌ Error: Could not find HyprCandy directory"; exit 1; }

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
if stow -v -t "$HOME" --ignore='Candy' --ignore='GJS' --ignore='candy-system-monitor.js' . 2>/dev/null; then
    echo "✅ Successfully stowed all configurations"
else
    echo "⚠️  Stow operation failed — attempting restow..."
    if stow -R -v -t "$HOME" --ignore='Candy' --ignore='GJS' --ignore='candy-system-monitor.js' . 2>/dev/null; then
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
mkdir -p "$HOME/.config/hyprcandy/hooks" "$HOME/.config/systemd/user" "$HOME/.config/mako" "$HOME/.config/pypr" 

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
sed -i "5s/border-radius: [0-9]\+px/border-radius: ${NEW_RADIUS}px/" "$STYLE_FILE"

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
sed -i "5s/border-radius: [0-9]\+px/border-radius: ${NEW_RADIUS}px/" "$STYLE_FILE"

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
        ICON_SIZE=30
        BORDER_RADIUS=20
        BORDER_WIDTH=2
        ;;
    "prominent")
        ICON_SIZE=40
        BORDER_RADIUS=20
        BORDER_WIDTH=3
        ;;
    "hidden")
        pkill -f nwg-dock-hyprland
        #echo "🫥 Dock hidden"
        #notify-send "Dock Hidden" "nwg-dock-hyprland stopped" -t 2000
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
sed -i "5s/border-radius: [0-9]\+px/border-radius: ${BORDER_RADIUS}px/" "$STYLE_FILE"
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

CONFIG_FILE="$HOME/.config/hypr/hyprviz.conf"

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

CONFIG_FILE="$HOME/.config/hypr/hyprviz.conf"

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

CONFIG_FILE="$HOME/.config/hypr/hyprviz.conf"
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

CONFIG_FILE="$HOME/.config/hypr/hyprviz.conf"
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

CONFIG_FILE="$HOME/.config/hypr/hyprviz.conf"
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

CONFIG_FILE="$HOME/.config/hypr/hyprviz.conf"

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

CONFIG_FILE="$HOME/.config/hypr/hyprviz.conf"
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

CONFIG_FILE="$HOME/.config/hypr/hyprviz.conf"
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

CONFIG_FILE="$HOME/.config/hypr/hyprviz.conf"

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

CONFIG_FILE="$HOME/.config/hypr/hyprviz.conf"

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
#                    SWAYNC RECORDER SCRIPT
# ═══════════════════════════════════════════════════════════════

cat > "$HOME/.config/swaync/recorder.sh" << 'EOF'
#!/bin/env bash

if pgrep -x "wf-recorder" > /dev/null; then
  pkill -x wf-recorder 
  sleep 0.1
  notify-send "Recorder" "Stopped " -t 2000
else
  bash -c 'wf-recorder -g -a --audio=bluez_output.78_15_2D_0D_BD_B7.1.monitor -f "$HOME/Videos/Recordings/recording-$(date +%Y%m%d-%H%M%S).mp4" $(slurp)'
fi
EOF

chmod +x "$HOME/.config/swaync/recorder.sh"

# ═══════════════════════════════════════════════════════════════
#                           GJS SCRIPTS
# ═══════════════════════════════════════════════════════════════

cat > "$HOME/.hyprcandy/GJS/toggle-control-center.sh" << 'EOF'
#!/bin/bash

# Check if the process is running
if pgrep -f "candy-main.js" > /dev/null; then
    # If running, kill it
    killall gjs ~/.hyprcandy/GJS/candy-main.js
else
    # If not running, start it
    gjs ~/.hyprcandy/GJS/candy-main.js &
fi
EOF

cat > "$HOME/.hyprcandy/GJS/toggle-media-player.sh" << 'EOF'
#!/bin/bash

# Check if the process is running
if pgrep -f "media-main.js" > /dev/null; then
    # If running, kill it
    killall gjs ~/.hyprcandy/GJS/media-main.js
else
    # If not running, start it
    gjs ~/.hyprcandy/GJS/media-main.js &
fi
EOF

cat > "$HOME/.hyprcandy/GJS/toggle-system-monitor.sh" << 'EOF'
#!/bin/bash

# Check if the process is running
if pgrep -f "candy-system-monitor.js" > /dev/null; then
    # If running, kill it
    killall gjs ~/.hyprcandy/GJS/candy-system-monitor.js
else
    # If not running, start it
    gjs ~/.hyprcandy/GJS/candy-system-monitor.js &
fi
EOF

cat > "$HOME/.hyprcandy/GJS/toggle-weather-widget.sh" << 'EOF'
#!/bin/bash

# Check if the process is running
if pgrep -f "weather-main.js" > /dev/null; then
    # If running, kill it
    killall gjs ~/.hyprcandy/GJS/weather-main.js
else
    # If not running, start it
    gjs ~/.hyprcandy/GJS/weather-main.js &
fi
EOF

chmod +x "$HOME/.hyprcandy/GJS/toggle-control-center.sh"
chmod +x "$HOME/.hyprcandy/GJS/toggle-media-player.sh"
chmod +x "$HOME/.hyprcandy/GJS/toggle-system-monitor.sh"
chmod +x "$HOME/.hyprcandy/GJS/toggle-weather-widget.sh"

echo "✅ Widget toggle scripts made executable!"

# ═══════════════════════════════════════════════════════════════
#                 SERVICES BASED ON CHOSEN BAR
# ═══════════════════════════════════════════════════════════════

if [ "$PANEL_CHOICE" = "waybar" ]; then

# ═══════════════════════════════════════════════════════════════
#                          Hyprlock Script
# ═══════════════════════════════════════════════════════════════

cat > "$HOME/.config/hypr/scripts/hyprlock-watcher.sh" << 'EOF'
#!/bin/bash
# hyprlock-watcher.sh - Watches for hyprlock unlock and refreshes waybar

WEATHER_CACHE_FILE="/tmp/waybar-weather-cache.json"

# Wait for Hyprland to start
while [ -z "$HYPRLAND_INSTANCE_SIGNATURE" ]; do
    sleep 1
done

echo "Hyprlock watcher started"

# Continuously monitor for hyprlock
while true; do
    # Wait for hyprlock to start
    while ! pgrep -x hyprlock >/dev/null 2>&1; do
        sleep 1
    done
    
    echo "Hyprlock detected - waiting for unlock..."
    
    # Wait for hyprlock to end (unlock)
    while pgrep -x hyprlock >/dev/null 2>&1; do
        sleep 0.5
    done
    
    echo "Unlocked! Checking waybar status..."
    
    # Only refresh waybar if it was running before lock
    if pgrep -x waybar >/dev/null 2>&1; then
        echo "Waybar is running - refreshing..."
        
        # Remove cached weather file
        rm -f "$WEATHER_CACHE_FILE"
        #rm -f "${WEATHER_CACHE_FILE}.tmp"
        
        # Wait a moment for system to fully resume
        sleep 3
        
        # Full waybar restart
        systemctl --user restart waybar.service
    else
        echo "Waybar was hidden before session lock - skipping refresh"
    fi
    
    # Wait a bit before checking for next lock
    sleep 3
done
EOF

chmod +x "$HOME/.config/hypr/scripts/hyprlock-watcher.sh"

# ═══════════════════════════════════════════════════════════════
#                         Hyprlock Service
# ═══════════════════════════════════════════════════════════════

cat > "$HOME/.config/systemd/user/hyprlock-watcher.service" << 'EOF'
[Unit]
Description=Hyprlock Unlock Watcher - Refreshes Waybar on Resume
Documentation=https://wiki.hyprland.org/Hypr-Ecosystem/hyprlock/
PartOf=graphical-session.target
After=graphical-session.target
Requisite=graphical-session.target

[Service]
Type=simple
ExecStart=%h/.config/hypr/scripts/hyprlock-watcher.sh
Restart=on-failure
RestartSec=3

[Install]
WantedBy=graphical-session.target
EOF

echo "✅ Hyprlock service to re-initialize waybar set"
fi

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

restart_awww() {
    echo "🔄 Restarting awww-daemon..."
    pkill awww-daemon 2>/dev/null
    sleep 0.5
    awww-daemon &
    sleep 1
    echo "✅ awww-daemon restarted"
}

# MAIN EXECUTION
initialize_colors_file
    
if wait_for_hyprpanel; then
    sleep 0.5
    restart_awww
else
    echo "⚠️ Proceeding with awww restart anyway..."
    restart_awww
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
HYPRCONF="$HOME/.config/hypr/hyprviz.conf"

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

    # Apply changes immediately
    apply_cursor_changes "$theme" "$size"

    echo "✅ Updated and applied cursor theme: $theme / $size"
}

apply_cursor_changes() {
    local theme="$1"
    local size="$2"
    
    # Method 1: Reload Hyprland config
    hyprctl reload 2>/dev/null
    # Apply cursor changes immediately using hyprctl
    hyprctl setcursor "$theme" "$size" 2>/dev/null || {
        echo "⚠️  hyprctl setcursor failed, falling back to reload"
        hyprctl reload 2>/dev/null
    }
    
    # Method 2: Set cursor for current session (fallback)
    if command -v gsettings >/dev/null 2>&1; then
        gsettings set org.gnome.desktop.interface cursor-theme "$theme" 2>/dev/null || true
        gsettings set org.gnome.desktop.interface cursor-size "$size" 2>/dev/null || true
    fi
    
    # Method 3: Update X11 cursor (if running under Xwayland apps)
    if [ -n "$DISPLAY" ]; then
        echo "Xcursor.theme: $theme" | xrdb -merge 2>/dev/null || true
        echo "Xcursor.size: $size" | xrdb -merge 2>/dev/null || true
    fi
}

watch_gtk_file() {
    local file="$1"
    echo "👁 Watching $file for cursor changes..."
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
After=hyprland-session.target
PartOf=hyprland-session.target

[Service]
Type=simple
ExecStart=%h/.config/hyprcandy/hooks/watch_cursor_theme.sh
Restart=on-failure
RestartSec=5

# Import environment variables from the user session
Environment="PATH=/usr/local/bin:/usr/bin:/bin"
# These will be set by the ExecStartPre command
ExecStartPre=/bin/bash -c 'systemctl --user import-environment HYPRLAND_INSTANCE_SIGNATURE XDG_CURRENT_DESKTOP WAYLAND_DISPLAY DISPLAY'

[Install]
WantedBy=hyprland-session.target
EOF

# ═══════════════════════════════════════════════════════════════
#                        Pyprland Config
# ═══════════════════════════════════════════════════════════════

cat > "$HOME/.config/pypr/config.toml" << 'EOF'
[pyprland]
plugins = [
    "scratchpads"
]
[scratchpads.term]
animation = "fromTop"
command = "kitty --class=kitty-scratchpad"
class = "kitty-scratchpad"
EOF

if [ "$PANEL_CHOICE" = "waybar" ]; then

# ═══════════════════════════════════════════════════════════════
#                         Waybar Service
# ═══════════════════════════════════════════════════════════════

cat > "$HOME/.config/systemd/user/waybar.service" << 'EOF'
Unit]
Description=Waybar - Highly customizable Wayland bar
Documentation=https://github.com/Alexays/Waybar/wiki
After=graphical-session.target hyprland-session.target
Wants=graphical-session.target
PartOf=graphical-session.target
Requisite=graphical-session.target

[Service]
Type=simple
ExecStart=/usr/bin/waybar
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
# Just waybar service. No awww cache clearing needed

else

# ═══════════════════════════════════════════════════════════════
#                  Clear awww Cache Script
# ═══════════════════════════════════════════════════════════════

cat > "$HOME/.config/hyprcandy/hooks/clear_awww.sh" << 'EOF'
#!/bin/bash
CACHE_DIR="$HOME/.cache/awww"
[ -d "$CACHE_DIR" ] && rm -rf "$CACHE_DIR"
EOF
chmod +x "$HOME/.config/hyprcandy/hooks/clear_awww.sh"
fi

if [ "$PANEL_CHOICE" = "waybar" ]; then
# ═══════════════════════════════════════════════════════════════
#                  Background Update Script
# ═══════════════════════════════════════════════════════════════

cat > "$HOME/.config/hyprcandy/hooks/update_background.sh" << 'EOF'
#!/bin/bash
set +e

restart_swaync() {
    swaync &
    sleep 1
    swaync-client -rs
}
restart_swaync

# Update ROFI background 
ROFI_RASI="$HOME/.config/rofi/colors.rasi"

if command -v sed >/dev/null; then
    sed -i "2s/, 1)/, 0.7)/" "$ROFI_RASI"
    echo "Rofi color updated"
fi

# Update local background.png
if command -v magick >/dev/null && [ -f "$HOME/.config/background" ]; then
    magick "$HOME/.config/background[0]" "$HOME/.config/background.png"
fi

sleep 1

# Enhanced Function to reload GTK apps with better color hotreload
# Enhanced Function to reload GTK apps
reload_gtk_apps() {
    echo "Reloading GTK applications..."
    
    # Method 1: Force GTK theme refresh by switching themes
    current_theme=$(gsettings get org.gnome.desktop.interface gtk-theme)
    gsettings set org.gnome.desktop.interface gtk-theme "''"
    sleep 0.2
    gsettings set org.gnome.desktop.interface gtk-theme "$current_theme"
    
    # 2. Send SIGUSR1 to all GTK processes (forces theme reload in some apps)
    pkill -SIGUSR1 -f "gtk" 2>/dev/null || true
    
    # Method 3: Force reload GTK settings files
    if [ -f "$HOME/.config/gtk-3.0/settings.ini" ]; then
        touch "$HOME/.config/gtk-3.0/settings.ini"
    fi
    if [ -f "$HOME/.config/gtk-4.0/settings.ini" ]; then
        touch "$HOME/.config/gtk-4.0/settings.ini"
    fi
    
    # Method 4: Send multiple signals to GTK processes
    pkill -SIGHUP -f "gtk" 2>/dev/null || true
    pkill -SIGUSR1 -f "gtk" 2>/dev/null || true
    pkill -SIGTERM -f "gsd-color" 2>/dev/null || true
    
    # Method 5: Restart XSettings daemon (more aggressive)
    if pgrep -x "xsettingsd" > /dev/null; then
        pkill -SIGTERM xsettingsd
        sleep 0.2
        xsettingsd &
    fi
    
    # Method 6: Force dconf/gsettings sync
    if command -v dconf >/dev/null; then
        dconf update
        sync
    fi
    
    # Method 7: Restart gnome-settings-daemon more aggressively
    if pgrep -f "gnome-settings-daemon" > /dev/null; then
        pkill -SIGTERM -f "gnome-settings-daemon"
        sleep 0.3
        gnome-settings-daemon --replace &
    fi
    
    # Method 8: Trigger GTK CSS reload by modifying GTK CSS files
    for gtk_dir in "$HOME/.config/gtk-3.0" "$HOME/.config/gtk-4.0"; do
        if [ -d "$gtk_dir" ]; then
            # Touch all CSS files to trigger inotify events
            find "$gtk_dir" -name "*.css" -exec touch {} \; 2>/dev/null || true
        fi
    done
    
    # Method 9: Qt applications (if you have any)
    if command -v qt5ct >/dev/null || command -v qt6ct >/dev/null; then
        export QT_QPA_PLATFORMTHEME=gtk3
        pkill -SIGHUP -f "qt" 2>/dev/null || true
    fi
    
    # 10. Send custom signals to known responsive GTK apps
    # Some apps listen for SIGHUP or SIGUSR2 for theme changes
    for signal in SIGHUP SIGUSR2; do
        pkill -$signal -f "nautilus\|gnome-\|evince\|gedit" 2>/dev/null || true
    done

    sleep 5 && systemctl --user start cursor-theme-watcher #Watches for system cursor theme & size changes to update cursor theme & size on re-login
}

# Alternative: Add this function to force specific app reloads if needed
force_app_color_reload() {
    echo "Force reloading specific applications..."
    
    # Store current window positions if using a tiling WM
    if command -v hyprctl >/dev/null; then
        # Get current workspace
        current_workspace=$(hyprctl activeworkspace -j | jq -r '.id')
    fi
    
    # List of common GTK apps that might need restarting for colors
    apps_to_reload=("nautilus" "gnome-control-center" "gnome-settings" "gnome-calculator" "evince" "gedit" "gnome-weather")
    
    for app in "${apps_to_reload[@]}"; do
        if pgrep -x "$app" > /dev/null; then
            echo "Restarting $app for color update..."
            pkill -SIGTERM "$app"
            sleep 0.5
            # Restart in background
            "$app" >/dev/null 2>&1 &
        fi
    done
}

reload_gtk_apps
# Uncomment the line below if you want to force restart specific apps
#force_app_color_reload

# Update SDDM background with sudo and reload the dock
if command -v magick >/dev/null && [ -f "$HOME/.config/background" ]; then
    sudo magick "$HOME/.config/background[0]" "/usr/share/sddm/themes/sugar-candy/Backgrounds/Mountain.jpg"
    sleep 1
fi

# Create lock.png at 661x661 pixels
if command -v magick >/dev/null && [ -f "$HOME/.config/background" ]; then
    magick "$HOME/.config/background[0]" -resize 661x661^ -gravity center -extent 661x661 "$HOME/.config/lock.png"
    echo "🔒 Created lock.png at 661x661 pixels"
fi
EOF

else

cat > "$HOME/.config/hyprcandy/hooks/update_background.sh" << 'EOF'
#!/bin/bash
set +e

# Update ROFI background 
ROFI_RASI="$HOME/.config/rofi/colors.rasi"

if command -v sed >/dev/null; then
    sed -i "2s/, 1)/, 0.7)/" "$ROFI_RASI"
    echo "Rofi color updated"
fi

# Update local background.png
if command -v magick >/dev/null && [ -f "$HOME/.config/background" ]; then
    magick "$HOME/.config/background[0]" "$HOME/.config/background.png"
fi

sleep 1

# Enhanced Function to reload GTK apps with better color hotreload
# Enhanced Function to reload GTK apps
reload_gtk_apps() {
    echo "Reloading GTK applications..."
    
    # Method 1: Force GTK theme refresh by switching themes
    current_theme=$(gsettings get org.gnome.desktop.interface gtk-theme)
    gsettings set org.gnome.desktop.interface gtk-theme "''"
    sleep 0.2
    gsettings set org.gnome.desktop.interface gtk-theme "$current_theme"
    
    # 2. Send SIGUSR1 to all GTK processes (forces theme reload in some apps)
    pkill -SIGUSR1 -f "gtk" 2>/dev/null || true
    
    # Method 3: Force reload GTK settings files
    if [ -f "$HOME/.config/gtk-3.0/settings.ini" ]; then
        touch "$HOME/.config/gtk-3.0/settings.ini"
    fi
    if [ -f "$HOME/.config/gtk-4.0/settings.ini" ]; then
        touch "$HOME/.config/gtk-4.0/settings.ini"
    fi
    
    # Method 4: Send multiple signals to GTK processes
    pkill -SIGHUP -f "gtk" 2>/dev/null || true
    pkill -SIGUSR1 -f "gtk" 2>/dev/null || true
    pkill -SIGTERM -f "gsd-color" 2>/dev/null || true
    
    # Method 5: Restart XSettings daemon (more aggressive)
    if pgrep -x "xsettingsd" > /dev/null; then
        pkill -SIGTERM xsettingsd
        sleep 0.2
        xsettingsd &
    fi
    
    # Method 6: Force dconf/gsettings sync
    if command -v dconf >/dev/null; then
        dconf update
        sync
    fi
    
    # Method 7: Restart gnome-settings-daemon more aggressively
    if pgrep -f "gnome-settings-daemon" > /dev/null; then
        pkill -SIGTERM -f "gnome-settings-daemon"
        sleep 0.3
        gnome-settings-daemon --replace &
    fi
    
    # Method 8: Trigger GTK CSS reload by modifying GTK CSS files
    for gtk_dir in "$HOME/.config/gtk-3.0" "$HOME/.config/gtk-4.0"; do
        if [ -d "$gtk_dir" ]; then
            # Touch all CSS files to trigger inotify events
            find "$gtk_dir" -name "*.css" -exec touch {} \; 2>/dev/null || true
        fi
    done
    
    # Method 9: Qt applications (if you have any)
    if command -v qt5ct >/dev/null || command -v qt6ct >/dev/null; then
        export QT_QPA_PLATFORMTHEME=gtk3
        pkill -SIGHUP -f "qt" 2>/dev/null || true
    fi
    
    # 10. Send custom signals to known responsive GTK apps
    # Some apps listen for SIGHUP or SIGUSR2 for theme changes
    for signal in SIGHUP SIGUSR2; do
        pkill -$signal -f "nautilus\|gnome-\|evince\|gedit" 2>/dev/null || true
    done

    sleep 5 && systemctl --user start cursor-theme-watcher #Watches for system cursor theme & size changes to update cursor theme & size on re-login
}

# Alternative: Add this function to force specific app reloads if needed
force_app_color_reload() {
    echo "Force reloading specific applications..."
    
    # Store current window positions if using a tiling WM
    if command -v hyprctl >/dev/null; then
        # Get current workspace
        current_workspace=$(hyprctl activeworkspace -j | jq -r '.id')
    fi
    
    # List of common GTK apps that might need restarting for colors
    apps_to_reload=("nautilus" "gnome-control-center" "gnome-settings" "gnome-calculator" "evince" "gedit" "gnome-weather")
    
    for app in "${apps_to_reload[@]}"; do
        if pgrep -x "$app" > /dev/null; then
            echo "Restarting $app for color update..."
            pkill -SIGTERM "$app"
            sleep 0.5
            # Restart in background
            "$app" >/dev/null 2>&1 &
        fi
    done
}

reload_gtk_apps
# Uncomment the line below if you want to force restart specific apps
#force_app_color_reload

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
COLORS_FILE="$HOME/.config/hyprcandy/nwg_dock_colors.conf"
AUTO_RELAUNCH_PREF="$HOME/.config/hyprcandy/scripts/.dock-auto-relaunch"

while [ -z "$HYPRLAND_INSTANCE_SIGNATURE" ]; do
    echo "Waiting for Hyprland to start..."
    sleep 1
done
echo "Hyprland started"

# Function to execute hooks
execute_hooks() {
    echo "🎯 Executing hooks & checking dock relaunch..."
    
    # Check auto-relaunch preference
    AUTO_RELAUNCH_STATE="enabled"
    if [ -f "$AUTO_RELAUNCH_PREF" ]; then
        AUTO_RELAUNCH_STATE=$(<"$AUTO_RELAUNCH_PREF")
    fi
    
    # Only proceed with dock relaunch if auto-relaunch is enabled
    if [[ "$AUTO_RELAUNCH_STATE" == "enabled" ]]; then
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
                pkill -f nwg-dock-hyprland
                sleep 0.5
                nohup bash -c "$HOME/.config/hyprcandy/scripts/toggle-dock.sh --relaunch" >/dev/null 2>&1 &
                mkdir -p "$(dirname "$COLORS_FILE")"
                echo "$current_colors" > "$COLORS_FILE"
                echo "🎨 Updated dock colors and launched dock"
            else
                echo "🎨 Colors unchanged, skipping dock launch"
            fi
        else
            # Fallback if colors.css doesn't exist
            echo "🎨 Colors file not found"
        fi
    else
        echo "🚫 Auto-relaunch disabled by user, skipping dock relaunch"
    fi
    
    "$HOOKS_DIR/clear_awww.sh"
    "$HOOKS_DIR/update_background.sh"
}

# Function to monitor matugen process
monitor_matugen() {
    echo "🎨 Matugen detected, waiting for completion..."
    
    # Wait for matugen to finish
    while pgrep -x "matugen" > /dev/null 2>&1; do
        sleep 1
    done
    
    echo "✅ Matugen finished, reloading dock & executing hooks"
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
Description=Watch ~/.config/background, clear awww cache and update background images
After=hyprland-session.target
PartOf=hyprland-session.target

[Service]
Type=simple
ExecStart=%h/.config/hyprcandy/hooks/watch_background.sh
Restart=on-failure
RestartSec=5

# Import environment variables from the user session
Environment="PATH=/usr/local/bin:/usr/bin:/bin"
# These will be set by the ExecStartPre command
ExecStartPre=/bin/bash -c 'systemctl --user import-environment HYPRLAND_INSTANCE_SIGNATURE XDG_CURRENT_DESKTOP WAYLAND_DISPLAY DISPLAY'

[Install]
WantedBy=hyprland-session.target
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
        matugen image "$CONFIG_BG" --type scheme-content --contrast 0.65 -m dark -r nearest &
        echo "✅ Matugen color generation started"
    else
        echo "⚠️  Matugen config not found at: $MATUGEN_CONFIG"
    fi
}
execute_color_generation() {
    echo "🚀 Starting color generation for new background..."
    trigger_matugen
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
#             Safe hyprpanel Killer Script (Preserve awww)
# ═══════════════════════════════════════════════════════════════

cat > "$HOME/.config/hyprcandy/hooks/kill_hyprpanel_safe.sh" << 'EOF'
#!/bin/bash

echo "🔄 Safely closing hyprpanel while preserving awww-daemon..."

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

# Ensure awww-daemon continues running
if ! pgrep -f "awww-daemon" > /dev/null; then
    echo "🔄 awww-daemon not found, restarting it..."
    awww-daemon &
    sleep 1
    if [ -f "$HOME/.config/background" ]; then
        echo "🖼️  Restoring wallpaper..."
        awww img "$HOME/.config/background" --transition-type fade --transition-duration 1
    fi
fi

echo "✅ hyprpanel safely closed, awww-daemon preserved"
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
chmod +x "$HOME/.config/waybar/scripts/waybar-weather.sh"
chmod +x "$HOME/.config/waybar/scripts/toggle-weather-format.sh"

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
    fi

    # 🏠 Step 2: Return to home
    cd "$HOME"

    # 📂 Step 3: Copy new grid.svg from custom SVG folder
    SVG_SOURCE="$HOME/Pictures/Candy/Dock-SVGs/grid.svg"
    SVG_DEST="/usr/share/nwg-dock-hyprland/images"

    print_status "Changing start button icon"

    if [ -f "$SVG_SOURCE" ]; then
        sudo cp "$SVG_SOURCE" "$SVG_DEST" && echo "✅ grid.svg copied successfully."
    else
        echo "❌ grid.svg not found at $SVG_SOURCE"
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
    # Symlink GTK3 and GTK4 settings files
    ln -sf ~/.config/gtk-3.0/settings.ini ~/.config/gtk-4.0/settings.ini
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
            mkdir -p "$HOME/.config/hyprcustom" && touch "$HOME/.config/hypr/hyprviz.conf" && touch "$HOME/.config/hyprcustom/custom_lock.conf"
            echo "📁 Created the custom settings directory with 'custom.conf' and 'custom_lock.conf' files to keep your personal Hyprland and Hyprlock changes safe ..."
          if [ "$PANEL_CHOICE" = "waybar" ]; then
 # Add default content to the custom.conf file
            cat > "$HOME/.config/hypr/hyprviz.conf" << 'EOF'
# ██████╗ █████╗ ███╗   ██╗██████╗ ██╗   ██╗
#██╔════╝██╔══██╗████╗  ██║██╔══██╗╚██╗ ██╔╝
#██║     ███████║██╔██╗ ██║██║  ██║ ╚████╔╝ 
#██║     ██╔══██║██║╚██╗██║██║  ██║  ╚██╔╝  
#╚██████╗██║  ██║██║ ╚████║██████╔╝   ██║   
# ╚═════╝╚═╝  ╚═╝╚═╝  ╚═══╝╚═════╝    ╚═╝   

#[IMPORTANT]#
# Add custom settings at the very end of the file.
# To reset, delete the 'hyprcustom' folder (not just the 'custom.conf' file) before rerunning the script to regenerate the default setup.
#[IMPORTANT]#

# ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
# ┃                           Autostart                         ┃
# ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

exec-once = systemctl --user import-environment HYPRLAND_INSTANCE_SIGNATURE
exec-once = hyprpm reload && hyprctl dismissnotify #Reload plugin
exec-once = systemctl --user start background-watcher #Watches for system background changes to update background.png
exec-once = ~/.config/hyprcandy/hooks/restart_waybar.sh #Launch bar/panel
exec-once = systemctl --user start waybar-idle-monitor #Watches bar/panel running status to enable/disable idle-inhibitor
exec-once = systemctl --user start hyprlock-watcher.service #Hyprlock watcher to re-initialize waybar on session resume
exec-once = systemctl --user start waypaper-watcher #Watches for system waypaper changes to trigger color generation
exec-once = systemctl --user start rofi-font-watcher #Watches for system font changes to update rofi-font.rasi
exec-once = systemctl --user start cursor-theme-watcher #Watches for cursor theme changes
exec-once = bash -c "mkfifo /tmp/$HYPRLAND_INSTANCE_SIGNATURE.wob && tail -f /tmp/$HYPRLAND_INSTANCE_SIGNATURE.wob | wob & disown" &
exec-once = dbus-update-activation-environment --systemd DBUS_SESSION_BUS_ADDRESS DISPLAY XAUTHORITY &
exec-once = hash dbus-update-activation-environment 2>/dev/null &
exec-once = systemctl --user import-environment &
# Start awww
exec-once = awww-daemon &
# Start swaync
exec-once = swaync &
# Startup
exec-once = ~/.config/hyprcandy/hooks/startup_services.sh &
# Start Polkit
exec-once = systemctl --user start hyprpolkitagent &
# Dock
exec-once = ~/.config/hyprcandy/scripts/toggle-dock.sh --login &
# Using hypridle to start hyprlock
exec-once = hypridle &
# Load cliphist history
exec-once = wl-paste --watch cliphist store
# Restart xdg
exec-once = ~/.config/hpr/scripts/xdg.sh
# Restore wallaper
exec-once = bash ~/.config/hypr/scripts/wallpaper-restore.sh
# Restart wallaper service
exec-once = systemctl --user restart background-watcher
# Pyprland
exec-once = /usr/bin/pypr &
# Overview env rule and startup
env = QS_NO_RELOAD_POPUP,1
exec-once = qs -c overview &

# ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
# ┃                           Animations                        ┃
# ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

source = ~/.config/hypr/conf/animations/vertical.conf

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
env = WLR_NO_HARDWARE_CURSORS,1
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
    gaps_in = 6
    gaps_out = 8	
    gaps_workspaces = 50    # Gaps between workspaces
    border_size = 3
    col.active_border = $source_color
    col.inactive_border = $background
    layout = dwindle
    resize_on_border = true
    allow_tearing = true
}

group {
    col.border_active =  $source_color
    col.border_inactive = $background
    col.border_locked_active =  $primary_fixed_dim
    col.border_locked_inactive = $background
    
    groupbar {
        font_size = 14
        font_weight_active = heavy
        font_weight_inactive = heavy
        text_color = $surface_variant
        col.active =  $primary_fixed_dim
        col.inactive = $background
        col.locked_active =  $primary_fixed_dim
        col.locked_inactive = $background
        indicator_height = 4
        indicator_gap = 6
    
        # Additional styling options
        height = 10          # Height of the groupbar
        render_titles = true           # Show window titles
        scrolling = true              # Enable scrolling through titles
        
        # Gradients work too (like hyprbars)
        # col.active = $source_color $primary_fixed_dim 45deg
    }
}

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

gesture = 3, horizontal, workspace
gesture = 4, swipe, move,
gesture = 2, pinch, float
gestures {
    workspace_swipe_distance = 700
    workspace_swipe_cancel_ratio = 0.2
    workspace_swipe_min_speed_to_force = 5
    workspace_swipe_direction_lock = true
    workspace_swipe_direction_lock_threshold = 10
    workspace_swipe_create_new = true
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
    rounding = 15
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
        vibrancy = 0.24999999999999933
        noise = 0
    popups = true
    popups_ignorealpha = 0.8
        brightness = 1.0000000000000002
        contrast = 0.9999999999999997
        special = false
        vibrancy_darkness = 0.5000000000000002
    }

    shadow {
        enabled = true
        range = 12
        render_power = 4
        color = $scrim
    }
    dim_strength = 0.19999999999999973
    dim_inactive = false
}

# ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
# ┃                          Decorations                        ┃
# ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

decoration {
    rounding = 15
    rounding_power = 2
    active_opacity = 0.8499999999999999
    inactive_opacity = 0.8499999999999999
    fullscreen_opacity = 1.0

    blur {
    enabled = true
    size = 2
    passes = 4
    new_optimizations = on
    ignore_opacity = true
        xray = true
        vibrancy = 0.24999999999999933
        noise = 0
    popups = true
    popups_ignorealpha = 0.8
        brightness = 1.0000000000000002
        contrast = 0.9999999999999997
        special = false
        vibrancy_darkness = 0.5000000000000002
    }

    shadow {
        enabled = true
        range = 12
        render_power = 4
        color = $scrim
    }
    dim_strength = 0.19999999999999973
    dim_inactive = false
}

# ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
# ┃                      Window & layer rules                   ┃
# ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

windowrule = move 73% 75,match:class (Candy.SystemMonitor)
windowrule = move 32% 75,match:class (Candy.Media)
windowrule = move 1% 75,match:class (Candy.Weather)
windowrule = opacity 0.85 0.85,match:class ^(kitty|kitty-scratchpad|Alacritty|floating-installer|clock)$
windowrule = float on, center on,size 800 500,match:class (kitty-scratchpad)
windowrule = suppress_event maximize, match:class .* #nofocus,match:class ^$,match:title ^$,xwayland:1,floating:1,fullscreen:0,pinned:0
# Pavucontrol floating
windowrule = float on,match:class (.*org.pulseaudio.pavucontrol.*)
windowrule = size 700 600,match:class (.*org.pulseaudio.pavucontrol.*)
windowrule = center on,match:class (.*org.pulseaudio.pavucontrol.*)
#windowrule = pin on,match:class (.*org.pulseaudio.pavucontrol.*)
# Browser Picture in Picture
windowrule = float on, match:title ^(Picture-in-Picture)$
windowrule = pin on, match:title ^(Picture-in-Picture)$
windowrule = move 69.5% 4%, match:title ^(Picture-in-Picture)$
# Waypaper
windowrule = float on,match:class (.*waypaper.*)
windowrule = size 800 600,match:class (.*waypaper.*)
windowrule = center on,match:class (.*waypaper.*)
#windowrule = pin on,match:class (.*waypaper.*)
# Blueman Manager
windowrule = float on,match:class (blueman-manager)
windowrule = size 800 600,match:class (blueman-manager)
windowrule = center on,match:class (blueman-manager)
# Weather
windowrule = float on,match:class (org.gnome.Weather)
windowrule = size 700 600,match:class (org.gnome.Weather)
windowrule = center on,match:class (org.gnome.Weather)
#windowrule = pin on,match:class (org.gnome.Weather)
# Calendar
windowrule = float on,match:class (org.gnome.Calendar)
windowrule = size 820 600,match:class (org.gnome.Calendar)
windowrule = center on,match:class (org.gnome.Calendar)
#windowrule = pin on,match:class (org.gnome.Calendar)
# System Monitor
windowrule = float on,match:class (org.gnome.SystemMonitor)
windowrule = size 820 625,match:class (org.gnome.SystemMonitor)
windowrule = center on,match:class (org.gnome.SystemMonitor)
#windowrule = pin on,match:class (org.gnome.SystemMonitor)
# Files
windowrule = float on,match:title (Open Files)
windowrule = size 700 600,match:title (Open Files)
windowrule = center on,match:title (Open Files)
#windowrule = pin on,match:title (Open Files)

windowrule = float on,match:title (Select Copy Destination)
windowrule = size 700 600,match:title (Select Copy Destination)
windowrule = center on,match:title (Select Copy Destination)
#windowrule = pin on,match:title (Select Copy Destination)

windowrule = float on,match:title (Select Move Destination)
windowrule = size 700 600,match:title (Select Move Destination)
windowrule = center on,match:title (Select Move Destination)
#windowrule = pin on,match:title (Select Move Destination)

windowrule = float on,match:title (Save As)
windowrule = size 700 600,match:title (Save As)
windowrule = center on,match:title (Save As)
#windowrule = pin on,match:title (Save As)

windowrule = float on,match:title (Select files to send)
windowrule = size 700 600,match:title (Select files to send)
windowrule = center on,match:title (Select files to send)
#windowrule = pin on,match:title (Select files to send)

windowrule = float on,match:title (Bluetooth File Transfer)
#windowrule = pin on,match:title (Bluetooth File Transfer)
# nwg-look
windowrule = float on,match:class (nwg-look)
windowrule = size 700 600,match:class (nwg-look)
windowrule = center on,match:class (nwg-look)
#windowrule = pin on,match:class (nwg-look)
# CachyOS Hello
windowrule = float on,match:class (CachyOSHello)
windowrule = size 700 600,match:class (CachyOSHello)
windowrule = center on,match:class (CachyOSHello)
#windowrule = pin on,match:class (CachyOSHello)
# nwg-displays
windowrule = float on,match:class (nwg-displays)
windowrule = size 990 600,match:class (nwg-displays)
windowrule = center on,match:class (nwg-displays)
#windowrule = pin on,match:class (nwg-displays)
# System Mission Center
windowrule = float on, match:class (io.missioncenter.MissionCenter)
#windowrule = pin on, match:class (io.missioncenter.MissionCenter)
windowrule = center on, match:class (io.missioncenter.MissionCenter)
windowrule = size 900 600, match:class (io.missioncenter.MissionCenter)
# System Mission Center Preference Window
windowrule = float on, match:class (missioncenter), match:title ^(Preferences)$
#windowrule = pin on, match:class (missioncenter), match:title ^(Preferences)$
windowrule = center on, match:class (missioncenter), match:title ^(Preferences)$
# Gnome Calculator
windowrule = float on,match:class (org.gnome.Calculator)
windowrule = size 700 600,match:class (org.gnome.Calculator)
windowrule = center on,match:class (org.gnome.Calculator)
# Emoji Picker Smile
windowrule = float on,match:class (it.mijorus.smile)
#windowrule = pin on, match:class (it.mijorus.smile)
windowrule = move 100%-w-40 90,match:class (it.mijorus.smile)
# Hyprland Share Picker
windowrule = float on, match:class (hyprland-share-picker)
#windowrule = pin on, match:class (hyprland-share-picker)
windowrule = center on, match:title match:class (hyprland-share-picker)
windowrule = size 600 400,match:class (hyprland-share-picker)
# Hyprland Settings App
windowrule = float on,match:title (hyprviz)
windowrule = size 1000 625,match:title (hyprviz)
windowrule = center on,match:title (hyprviz)
# General floating
windowrule = float on,match:class (dotfiles-floating)
windowrule = size 1000 700,match:class (dotfiles-floating)
windowrule = center on,match:class (dotfiles-floating)
# Float Necessary Windows
windowrule = float on, match:class ^(org.pulseaudio.pavucontrol)
windowrule = float on, match:class ^()$,match:title ^(Picture in picture)$
windowrule = float on, match:class ^()$,match:title ^(Save File)$
windowrule = float on, match:class ^()$,match:title ^(Open File)$
windowrule = float on, match:class ^(LibreWolf)$,match:title ^(Picture-in-Picture)$
##windowrule = float on, match:class ^(blueman-manager)$
windowrule = float on, match:class ^(xdg-desktop-portal-hyprland|xdg-desktop-portal-gtk|xdg-desktop-portal-kde)(.*)$
windowrule = float on, match:class ^(hyprpolkitagent|polkit-gnome-authentication-agent-1|org.org.kde.polkit-kde-authentication-agent-1)(.*)$
windowrule = float on, match:class ^(CachyOSHello)$
windowrule = float on, match:class ^(zenity)$
windowrule = float on, match:class ^()$,match:title ^(Steam - Self Updater)$
# Increase the opacity
windowrule = opacity 1.0, match:class ^(zen)$
# # windowrule = opacity 1.0, match:class ^(discord|armcord|webcord)$
# # windowrule = opacity 1.0, match:title ^(QQ|Telegram)$
# # windowrule = opacity 1.0, match:title ^(NetEase Cloud Music Gtk4)$
# General window rules
windowrule = float on, match:title ^(Picture-in-Picture)$
windowrule = size 460 260, match:title ^(Picture-in-Picture)$
windowrule = move 65%- 10%-, match:title ^(Picture-in-Picture)$
windowrule = float on, match:title ^(imv|mpv|danmufloat|termfloat|nemo|ncmpcpp)$
windowrule = move 25%-, match:title ^(imv|mpv|danmufloat|termfloat|nemo|ncmpcpp)$
windowrule = size 960 540, match:title ^(imv|mpv|danmufloat|termfloat|nemo|ncmpcpp)$
#windowrule = pin on, match:title ^(danmufloat)$
windowrule = rounding 5, match:title ^(danmufloat|termfloat)$
windowrule = animation slide right, match:class ^(kitty|Alacritty)$
#windowrule = no_blur on, match:class ^(org.mozilla.firefox)$
# Decorations related to floating windows on workspaces 1 to 10
##windowrule = bordersize 2, floating:1, onworkspace:w[fv1-10]
workspace = w[fv1-10], border_color c $source_color, float on #$on_primary_fixed_variant 90deg
##windowrule = rounding 8, floating:1, onworkspace:w[fv1-10]
# Decorations related to tiling windows on workspaces 1 to 10
##windowrule = bordersize 3, floating:0, onworkspace:f[1-10]
##windowrule = rounding 4, floating:0, onworkspace:f[1-10]
#windowrule = tile, match:title ^(Microsoft-edge)$
vwindowrule = tile, match:title ^(Brave-browser)$
#windowrule = tile, match:title ^(Chromium)$
windowrule = float on, match:title ^(pavucontrol)$
windowrule = float on, match:title ^(blueman-manager)$
windowrule = float on, match:title ^(nm-connection-editor)$
windowrule = float on, match:title ^(qalculate-gtk)$
# idleinhibit
windowrule = idle_inhibit fullscreen,match:class ([window]) # Available modes: none, always, focus, fullscreen
### no blur for specific classes
##windowrule = noblur,match:class ^(?!(nautilus|nwg-look|nwg-displays|zen))
## Windows Rules End #

windowrule = opacity 1.0 $& 1.0 $& 1,match:class ^(nautilus)$
windowrule = opacity 1.0 $& 1.0 $& 1,match:class ^(zen)$
# # windowrule = opacity 1.0 $& 1.0 $& 1,match:class ^(Brave-browser)$
windowrule = opacity 1.0 $& 1.0 $& 1,match:class ^(code-oss)$
windowrule = opacity 1.0 $& 1.0 $& 1,match:class ^([Cc]ode)$
# # windowrule = opacity 1.0 $& 1.0 $& 1,match:class ^(code-url-handler)$
# # windowrule = opacity 1.0 $& 1.0 $& 1,match:class ^(code-insiders-url-handler)$
# # windowrule = opacity 1.0 $& 1.0 $& 1,match:class ^(org.kde.dolphin)$
# # windowrule = opacity 1.0 $& 1.0 $& 1,match:class ^(org.kde.ark)$
windowrule = opacity 1.0 $& 1.0 $& 1,match:class ^(nwg-look)$
windowrule = opacity 1.0 $& 1.0 $& 1,match:class ^(qt5ct)$
windowrule = opacity 1.0 $& 1.0 $& 1,match:class ^(qt6ct)$
windowrule = opacity 1.0 $& 1.0 $& 1,match:class ^(kvantummanager)$
# # windowrule = opacity 1.0 $& 1.0 $& 1,match:class ^(org.pulseaudio.pavucontrol)$
# # windowrule = opacity 1.0 $& 1.0 $& 1,match:class ^(blueman-manager)$
# # windowrule = opacity 1.0 $& 1.0 $& 1,match:class ^(nm-applet)$
# # windowrule = opacity 1.0 $& 1.0 $& 1,match:class ^(nm-connection-editor)$
# # windowrule = opacity 1.0 $& 1.0 $& 1,match:class ^(org.kde.polkit-kde-authentication-agent-1)$
# # windowrule = opacity 1.0 $& 1.0 $& 1,match:class ^(polkit-gnome-authentication-agent-1)$
# # windowrule = opacity 1.0 $& 1.0 $& 1,match:class ^(org.freedesktop.impl.portal.desktop.gtk)$
# # windowrule = opacity 1.0 $& 1.0 $& 1,match:class ^(org.freedesktop.impl.portal.desktop.hyprland)$
# # windowrule = opacity 1.0 $& 1.0 $& 1,match:class ^([Ss]team)$
# # windowrule = opacity 1.0 $& 1.0 $& 1,match:class ^(steamwebhelper)$
windowrule = opacity 1.0 $& 1.0 $& 1,match:class ^([Ss]potify)$
windowrule = opacity 1.0 $& 1.0 $& 1,match:title ^(Spotify Free)$
windowrule = opacity 1.0 $& 1.0 $& 1,match:title ^(Spotify Premium)$
# # 
# # windowrule = opacity 1.0 1.0,match:class ^(com.github.rafostar.Clapper)$ # Clapper-Gtk
# # windowrule = opacity 1.0 1.0,match:class ^(com.github.tchx84.Flatseal)$ # Flatseal-Gtk
# # windowrule = opacity 1.0 1.0,match:class ^(hu.kramo.Cartridges)$ # Cartridges-Gtk
# # windowrule = opacity 1.0 1.0,match:class ^(com.obsproject.Studio)$ # Obs-Qt
# # windowrule = opacity 1.0 1.0,match:class ^(gnome-boxes)$ # Boxes-Gtk
# # windowrule = opacity 1.0 1.0,match:class ^(vesktop)$ # Vesktop
# # windowrule = opacity 1.0 1.0,match:class ^(discord)$ # Discord-Electron
# # windowrule = opacity 1.0 1.0,match:class ^(WebCord)$ # WebCord-Electron
# # windowrule = opacity 1.0 1.0,match:class ^(ArmCord)$ # ArmCord-Electron
# # windowrule = opacity 1.0 1.0,match:class ^(app.drey.Warp)$ # Warp-Gtk
# # windowrule = opacity 1.0 1.0,match:class ^(net.davidotek.pupgui2)$ # ProtonUp-Qt
# # windowrule = opacity 1.0 1.0,match:class ^(yad)$ # Protontricks-Gtk
# # windowrule = opacity 1.0 1.0,match:class ^(Signal)$ # Signal-Gtk
# # windowrule = opacity 1.0 1.0,match:class ^(io.github.alainm23.planify)$ # planify-Gtk
# # windowrule = opacity 1.0 1.0,match:class ^(io.gitlab.theevilskeleton.Upscaler)$ # Upscaler-Gtk
# # windowrule = opacity 1.0 1.0,match:class ^(com.github.unrud.VideoDownloader)$ # VideoDownloader-Gtk
# # windowrule = opacity 1.0 1.0,match:class ^(io.gitlab.adhami3310.Impression)$ # Impression-Gtk
# # windowrule = opacity 1.0 1.0,match:class ^(io.missioncenter.MissionCenter)$ # MissionCenter-Gtk
# # windowrule = opacity 1.0 1.0,match:class ^(io.github.flattool.Warehouse)$ # Warehouse-Gtk
windowrule = float on,match:class ^(org.kde.dolphin)$,match:title ^(Progress Dialog — Dolphin)$
windowrule = float on,match:class ^(org.kde.dolphin)$,match:title ^(Copying — Dolphin)$
windowrule = float on,match:title ^(About Mozilla Firefox)$
windowrule = float on,match:class ^(firefox)$,match:title ^(Picture-in-Picture)$
windowrule = float on,match:class ^(firefox)$,match:title ^(Library)$
windowrule = float on,match:class ^(kitty)$,match:title ^(top)$
windowrule = float on,match:class ^(kitty)$,match:title ^(btop)$
windowrule = float on,match:class ^(kitty)$,match:title ^(htop)$
windowrule = float on,match:class ^(vlc)$
windowrule = float on,match:class ^(eww-main-window)$
windowrule = float on,match:class ^(eww-notifications)$
windowrule = float on,match:class ^(kvantummanager)$
windowrule = float on,match:class ^(qt5ct)$
windowrule = float on,match:class ^(qt6ct)$
windowrule = float on,match:class ^(nwg-look)$
windowrule = float on,match:class ^(org.kde.ark)$
windowrule = float on,match:class ^(org.pulseaudio.pavucontrol)$
windowrule = float on,match:class ^(blueman-manager)$
windowrule = float on,match:class ^(nm-applet)$
windowrule = float on,match:class ^(nm-connection-editor)$
windowrule = float on,match:class ^(org.kde.polkit-kde-authentication-agent-1)$

windowrule = float on,match:class ^(Signal)$ # Signal-Gtk
windowrule = float on,match:class ^(com.github.rafostar.Clapper)$ # Clapper-Gtk
windowrule = float on,match:class ^(app.drey.Warp)$ # Warp-Gtk
windowrule = float on,match:class ^(net.davidotek.pupgui2)$ # ProtonUp-Qt
windowrule = float on,match:class ^(yad)$ # Protontricks-Gtk
windowrule = float on,match:class ^(eog)$ # Imageviewer-Gtk
windowrule = float on,match:class ^(io.github.alainm23.planify)$ # planify-Gtk
windowrule = float on,match:class ^(io.gitlab.theevilskeleton.Upscaler)$ # Upscaler-Gtk
windowrule = float on,match:class ^(com.github.unrud.VideoDownloader)$ # VideoDownloader-Gkk
windowrule = float on,match:class ^(io.gitlab.adhami3310.Impression)$ # Impression-Gtk
windowrule = float on,match:class ^(io.missioncenter.MissionCenter)$ # MissionCenter-Gtk
windowrule = float on,match:class (clipse) # ensure you have a floating window class set if you want this behavior
windowrule = size 622 652,match:class (clipse) # set the size of the window as necessary
#windowrule = noborder, fullscreen:1

# common modals
#windowrule = float on,match:title ^(Open File)$
#windowrule = layer:top,match:class hyprpolkitagent
windowrule = float on,match:title ^(Choose Files)$
windowrule = float on,match:title ^(Save As)$
windowrule = float on,match:title ^(Confirm to replace files)$
windowrule = float on,match:title ^(File Operation Progress)$
windowrule = float on,match:class ^(xdg-desktop-portal-gtk)$

# installer
windowrule = float on, match:class (floating-installer)
windowrule = center on, match:class (floating-installer)

# clock
windowrule = float on, center on, size 400 200, match:class (clock)

# Extra workspace & window rules 
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
#windowrule = bordersize 2, floating:0, onworkspace:w[t1]
#windowrule = rounding 10, floating:0, onworkspace:w[t1]
#windowrule = bordersize 2, floating:0, onworkspace:w[tg1]
#windowrule = rounding 10, floating:0, onworkspace:w[tg1]
#windowrule = bordersize 2, floating:0, onworkspace:f[1]
#windowrule = rounding 10, floating:0, onworkspace:f[1]
windowrule = rounding 0, fullscreen true, border_size 0
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
layerrule = animation slide top, match:namespace logout_dialog
layerrule = blur on,xray on,match:namespace rofi
layerrule = ignore_alpha 0.01,match:namespace rofi
layerrule = blur on,match:namespace notifications
layerrule = ignore_alpha 0.01,match:namespace notifications
layerrule = blur on,match:namespace swaync-notification-window
layerrule = ignore_alpha 0.01,match:namespace swaync-notification-window
layerrule = blur on,xray on,no_anim on,match:namespace swaync-control-center
layerrule = ignore_alpha 0.01,match:namespace swaync-control-center
layerrule = blur on,no_anim on,match:namespace nwg-dock
layerrule = ignore_alpha 0.01,match:namespace nwg-dock
layerrule = blur on,match:namespace logout_dialog
layerrule = ignore_alpha 0.01,match:namespace logout_dialog
layerrule = blur on,match:namespace gtk-layer-shell
layerrule = ignore_alpha 0.01,match:namespace gtk-layer-shell
layerrule = blur on,no_anim on,match:namespace waybar
layerrule = ignore_alpha 0.01,match:namespace waybar
layerrule = blur on,match:namespace dashboardmenu
layerrule = ignore_alpha 0.01,match:namespace dashboardmenu
layerrule = blur on,match:namespace calendarmenu
layerrule = ignore_alpha 0.01,match:namespace calendarmenu
layerrule = blur on,match:namespace notificationsmenu
layerrule = ignore_alpha 0.01,match:namespace notificationsmenu
layerrule = blur on,match:namespace networkmenu
layerrule = ignore_alpha 0.01,match:namespace networkmenu
layerrule = blur on,match:namespace mediamenu
layerrule = ignore_alpha 0.01,match:namespace mediamenu
layerrule = blur on,match:namespace energymenu
layerrule = ignore_alpha 0.01,match:namespace energymenu
layerrule = blur on,match:namespace bluetoothmenu
layerrule = ignore_alpha 0.01,match:namespace bluetoothmenu
layerrule = blur on,match:namespace audiomenu
layerrule = ignore_alpha 0.01,match:namespace audiomenu
layerrule = blur on,match:namespace hyprmenu
layerrule = ignore_alpha 0.01,match:namespace hyprmenu
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

# ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
# ┃                            Plugins                          ┃
# ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

#plugin {
#    hyprexpo {
#        #general 
#        columns = 3
#        gaps_in = 8
#        gaps_out = 10
#        bg_col = $inverse_primary
#        workspace = first 1
#        
#        #borders
#        border_style = hyprland
#        border_grad_current = $scrim
#        border_grad_focus   = $inverse_primary
#
#        #labels
#        label_enable = 1
#        label_bg_shape = circle
#        label_position = center-center
#        label_offset_x = 10
#        label_offset_y = 10
#        label_color_default = $inverse_primary
#        label_color_hover   = $primary_fixed_dim
#        label_scale_hover = 1.0
#        label_scale_focus = 1.0
#        label_bg_enable = 1
#        label_bg_color = rgba(00000088)
#        label_bg_rounding = 15
#        # label_padding = 1
#
#        label_font_size = 25
#        label_font_family = FantasqueSansM Nerd Font Propo Regular
#        label_font_bold = 1
#        label_font_italic = 0
#        label_text_underline = 0
#        label_text_strikethrough = 0
#    }
#    
#    hyprbars {
#        bar_height = 25
#        bar_color = $source_color
#        bar_blur = true
#        
#        bar_title_enabled = false
#        bar_text_size = 10
#        bar_text_font = FantasqueSansM Nerd Font Propo Regular
#        
#        bar_text_align = center
#        bar_buttons_alignment = left
#        
#        bar_padding = 15
#        bar_button_padding = 6
#        
#        color_text = white
#        
#        hyprbars-button = $on_secondary, 15, , hyprctl dispatch killactive
#        hyprbars-button = $primary_container, 15, , bash "$HOME/.config/hypr/scripts/hyprbars-minimize.sh"
#        hyprbars-button = $surface_tint, 15, 󰺖, hyprctl dispatch fullscreen 1
#        
#        on_double_click = hyprctl dispatch fullscreen 1
#    }
#}
#
#submap = hyprexpo
#bind = CTRL ALT, down, hyprexpo:expo, close
#
#bind = , left,  hyprexpo:kb_focus, left
#bind = , right, hyprexpo:kb_focus, right
#bind = , up,    hyprexpo:kb_focus, up
#bind = , down,  hyprexpo:kb_focus, down
#bind = , return, hyprexpo:kb_confirm
#
## tokens 1..10: digits
#
#bind = , 1, hyprexpo:kb_selecti, 1
#bind = , 2, hyprexpo:kb_selecti, 2
#bind = , 3, hyprexpo:kb_selecti, 3
#bind = , 4, hyprexpo:kb_selecti, 4
#bind = , 5, hyprexpo:kb_selecti, 5
#bind = , 6, hyprexpo:kb_selecti, 6
#bind = , 7, hyprexpo:kb_selecti, 7
#bind = , 8, hyprexpo:kb_selecti, 8
#bind = , 9, hyprexpo:kb_selecti, 9
#bind = , 0, hyprexpo:kb_selecti, 0
#
## tokens 11..20: SHIFT+digits (update args to match your layout symbols)
#
#bind = SHIFT, 1, hyprexpo:kb_selecti, 11
#bind = SHIFT, 2, hyprexpo:kb_selecti, 12
#bind = SHIFT, 3, hyprexpo:kb_selecti, 13
#bind = SHIFT, 4, hyprexpo:kb_selecti, 14
#bind = SHIFT, 5, hyprexpo:kb_selecti, 15
#bind = SHIFT, 6, hyprexpo:kb_selecti, 16
#bind = SHIFT, 7, hyprexpo:kb_selecti, 17
#bind = SHIFT, 8, hyprexpo:kb_selecti, 18
#bind = SHIFT, 9, hyprexpo:kb_selecti, 19
#bind = SHIFT, 0, hyprexpo:kb_selecti, 20
#
## tokens 21..46: alpha
#
#bind = , a, hyprexpo:kb_selecti, 21
#bind = , b, hyprexpo:kb_selecti, 22
#bind = , c, hyprexpo:kb_selecti, 23
#bind = , d, hyprexpo:kb_selecti, 24
#bind = , e, hyprexpo:kb_selecti, 25
#bind = , f, hyprexpo:kb_selecti, 26
#bind = , g, hyprexpo:kb_selecti, 27
#bind = , h, hyprexpo:kb_selecti, 28
#bind = , i, hyprexpo:kb_selecti, 29
#bind = , j, hyprexpo:kb_selecti, 30
#bind = , k, hyprexpo:kb_selecti, 31
#bind = , l, hyprexpo:kb_selecti, 32
#bind = , m, hyprexpo:kb_selecti, 33
#bind = , n, hyprexpo:kb_selecti, 34
#bind = , o, hyprexpo:kb_selecti, 35
#bind = , p, hyprexpo:kb_selecti, 36
#bind = , q, hyprexpo:kb_selecti, 37
#bind = , r, hyprexpo:kb_selecti, 38
#bind = , s, hyprexpo:kb_selecti, 39
#bind = , t, hyprexpo:kb_selecti, 40
#bind = , u, hyprexpo:kb_selecti, 41
#bind = , v, hyprexpo:kb_selecti, 42
#bind = , w, hyprexpo:kb_selecti, 43
#bind = , x, hyprexpo:kb_selecti, 44
#bind = , y, hyprexpo:kb_selecti, 45
#bind = , z, hyprexpo:kb_selecti, 46
#submap = reset

# ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
# ┃                           Userprefs                         ┃
# ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛
# [NOTE!!] Add you personal settings from here and incase of an update copy them to the new file once this is changed to a backup
EOF

else  

            # Add default content to the custom.conf file
            cat > "$HOME/.config/hypr/hyprviz.conf" << 'EOF'
# ██████╗ █████╗ ███╗   ██╗██████╗ ██╗   ██╗
#██╔════╝██╔══██╗████╗  ██║██╔══██╗╚██╗ ██╔╝
#██║     ███████║██╔██╗ ██║██║  ██║ ╚████╔╝ 
#██║     ██╔══██║██║╚██╗██║██║  ██║  ╚██╔╝  
#╚██████╗██║  ██║██║ ╚████║██████╔╝   ██║   
# ╚═════╝╚═╝  ╚═╝╚═╝  ╚═══╝╚═════╝    ╚═╝   

#[IMPORTANT]#
# Add custom settings at the very end of the file.
# To reset, delete the 'hyprcustom' folder (not just the 'custom.conf' file) before rerunning the script to regenerate the default setup.
#[IMPORTANT]#

# ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
# ┃                           Autostart                         ┃
# ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

exec-once = systemctl --user import-environment HYPRLAND_INSTANCE_SIGNATURE
exec-once = hyprpm reload && hyprctl dismissnotify #Reload plugin
exec-once = systemctl --user start hyprpanel #Launch bar/panel
exec-once = systemctl --user start background-watcher #Watches for system background changes to update background.png
exec-once = systemctl --user start hyprpanel-idle-monitor #Watches bar/panel running status to enable/disable idle-inhibitor
#exec-once = systemctl --user start waypaper-watcher #Watches for system waypaper changes to trigger color generation
exec-once = systemctl --user start rofi-font-watcher #Watches for system font changes to update rofi-font.rasi
exec-once = systemctl --user start cursor-theme-watcher #Watches for cursor theme changes
exec-once = bash -c "mkfifo /tmp/$HYPRLAND_INSTANCE_SIGNATURE.wob && tail -f /tmp/$HYPRLAND_INSTANCE_SIGNATURE.wob | wob & disown" &
exec-once = dbus-update-activation-environment --systemd DBUS_SESSION_BUS_ADDRESS DISPLAY XAUTHORITY &
exec-once = hash dbus-update-activation-environment 2>/dev/null &
exec-once = systemctl --user import-environment &
# Start awww
#exec-once = awww-daemon &
# Start mako
#exec-once = mako &
# Startup
exec-once = ~/.config/hyprcandy/hooks/startup_services.sh &
# Start polkit agent
exec-once = systemctl --user start hyprpolkitagent &
# Dock
exec-once = ~/.config/hyprcandy/scripts/toggle-dock.sh --login &
# Using hypridle to start hyprlock
exec-once = hypridle &
# Load cliphist history
exec-once = wl-paste --watch cliphist store
# Restart xdg
exec-once = ~/.config/hpr/scripts/xdg.sh
# Restore wallaper
exec-once = bash ~/.config/hypr/scripts/wallpaper-restore.sh
# Restart wallaper service
exec-once = systemctl --user restart background-watcher
# Pyprland
exec-once = /usr/bin/pypr &
# Overview env rule and startup
env = QS_NO_RELOAD_POPUP,1
exec-once = qs -c overview &

# ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
# ┃                           Animations                        ┃
# ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

source = ~/.config/hypr/conf/animations/vertical.conf

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
env = WLR_NO_HARDWARE_CURSORS,1
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
    gaps_in = 6
    gaps_out = 8	
    gaps_workspaces = 50    # Gaps between workspaces
    border_size = 3
    col.active_border = $source_color
    col.inactive_border = $background
    layout = dwindle
    resize_on_border = true
    allow_tearing = true
}

group {
    col.border_active =  $source_color
    col.border_inactive = $background
    col.border_locked_active =  $primary_fixed_dim
    col.border_locked_inactive = $background
    
    groupbar {
        font_size = 14
        font_weight_active = heavy
        font_weight_inactive = heavy
        text_color = $surface_variant
        col.active =  $primary_fixed_dim
        col.inactive = $background
        col.locked_active =  $primary_fixed_dim
        col.locked_inactive = $background
        indicator_height = 4
        indicator_gap = 6
    
        # Additional styling options
        height = 10          # Height of the groupbar
        render_titles = true           # Show window titles
        scrolling = true              # Enable scrolling through titles
        
        # Gradients work too (like hyprbars)
        # col.active = $source_color $primary_fixed_dim 45deg
    }
}

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

gesture = 3, horizontal, workspace
gesture = 4, swipe, move,
gesture = 2, pinch, float
gestures {
    workspace_swipe_distance = 700
    workspace_swipe_cancel_ratio = 0.2
    workspace_swipe_min_speed_to_force = 5
    workspace_swipe_direction_lock = true
    workspace_swipe_direction_lock_threshold = 10
    workspace_swipe_create_new = true
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
    rounding = 15
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
        vibrancy = 0.24999999999999933
        noise = 0
    popups = true
    popups_ignorealpha = 0.8
        brightness = 1.0000000000000002
        contrast = 0.9999999999999997
        special = false
        vibrancy_darkness = 0.5000000000000002
    }

    shadow {
        enabled = true
        range = 12
        render_power = 4
        color = $scrim
    }
    dim_strength = 0.19999999999999973
    dim_inactive = false
}

# ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
# ┃                          Decorations                        ┃
# ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

decoration {
    rounding = 15
    rounding_power = 2
    active_opacity = 0.8499999999999999
    inactive_opacity = 0.8499999999999999
    fullscreen_opacity = 1.0

    blur {
    enabled = true
    size = 2
    passes = 4
    new_optimizations = on
    ignore_opacity = true
        xray = true
        vibrancy = 0.24999999999999933
        noise = 0
    popups = true
    popups_ignorealpha = 0.8
        brightness = 1.0000000000000002
        contrast = 0.9999999999999997
        special = false
        vibrancy_darkness = 0.5000000000000002
    }

    shadow {
        enabled = true
        range = 12
        render_power = 4
        color = $scrim
    }
    dim_strength = 0.19999999999999973
    dim_inactive = false
}

# ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
# ┃                      Window & layer rules                   ┃
# ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

windowrule = move 73% 75,match:class (Candy.SystemMonitor)
windowrule = move 32% 75,match:class (Candy.Media)
windowrule = move 1% 75,match:class (Candy.Weather)
windowrule = opacity 0.85 0.85,match:class ^(kitty|kitty-scratchpad|Alacritty|floating-installer|clock)$
windowrule = float on, center on,size 800 500,match:class (kitty-scratchpad)
windowrule = suppress_event maximize, match:class .* #nofocus,match:class ^$,match:title ^$,xwayland:1,floating:1,fullscreen:0,pinned:0
# Pavucontrol floating
windowrule = float on,match:class (.*org.pulseaudio.pavucontrol.*)
windowrule = size 700 600,match:class (.*org.pulseaudio.pavucontrol.*)
windowrule = center on,match:class (.*org.pulseaudio.pavucontrol.*)
#windowrule = pin on,match:class (.*org.pulseaudio.pavucontrol.*)
# Browser Picture in Picture
windowrule = float on, match:title ^(Picture-in-Picture)$
windowrule = pin on, match:title ^(Picture-in-Picture)$
windowrule = move 69.5% 4%, match:title ^(Picture-in-Picture)$
# Waypaper
windowrule = float on,match:class (.*waypaper.*)
windowrule = size 800 600,match:class (.*waypaper.*)
windowrule = center on,match:class (.*waypaper.*)
#windowrule = pin on,match:class (.*waypaper.*)
# Blueman Manager
windowrule = float on,match:class (blueman-manager)
windowrule = size 800 600,match:class (blueman-manager)
windowrule = center on,match:class (blueman-manager)
# Weather
windowrule = float on,match:class (org.gnome.Weather)
windowrule = size 700 600,match:class (org.gnome.Weather)
windowrule = center on,match:class (org.gnome.Weather)
#windowrule = pin on,match:class (org.gnome.Weather)
# Calendar
windowrule = float on,match:class (org.gnome.Calendar)
windowrule = size 820 600,match:class (org.gnome.Calendar)
windowrule = center on,match:class (org.gnome.Calendar)
#windowrule = pin on,match:class (org.gnome.Calendar)
# System Monitor
windowrule = float on,match:class (org.gnome.SystemMonitor)
windowrule = size 820 625,match:class (org.gnome.SystemMonitor)
windowrule = center on,match:class (org.gnome.SystemMonitor)
#windowrule = pin on,match:class (org.gnome.SystemMonitor)
# Files
windowrule = float on,match:title (Open Files)
windowrule = size 700 600,match:title (Open Files)
windowrule = center on,match:title (Open Files)
#windowrule = pin on,match:title (Open Files)

windowrule = float on,match:title (Select Copy Destination)
windowrule = size 700 600,match:title (Select Copy Destination)
windowrule = center on,match:title (Select Copy Destination)
#windowrule = pin on,match:title (Select Copy Destination)

windowrule = float on,match:title (Select Move Destination)
windowrule = size 700 600,match:title (Select Move Destination)
windowrule = center on,match:title (Select Move Destination)
#windowrule = pin on,match:title (Select Move Destination)

windowrule = float on,match:title (Save As)
windowrule = size 700 600,match:title (Save As)
windowrule = center on,match:title (Save As)
#windowrule = pin on,match:title (Save As)

windowrule = float on,match:title (Select files to send)
windowrule = size 700 600,match:title (Select files to send)
windowrule = center on,match:title (Select files to send)
#windowrule = pin on,match:title (Select files to send)

windowrule = float on,match:title (Bluetooth File Transfer)
#windowrule = pin on,match:title (Bluetooth File Transfer)
# nwg-look
windowrule = float on,match:class (nwg-look)
windowrule = size 700 600,match:class (nwg-look)
windowrule = center on,match:class (nwg-look)
#windowrule = pin on,match:class (nwg-look)
# CachyOS Hello
windowrule = float on,match:class (CachyOSHello)
windowrule = size 700 600,match:class (CachyOSHello)
windowrule = center on,match:class (CachyOSHello)
#windowrule = pin on,match:class (CachyOSHello)
# nwg-displays
windowrule = float on,match:class (nwg-displays)
windowrule = size 990 600,match:class (nwg-displays)
windowrule = center on,match:class (nwg-displays)
#windowrule = pin on,match:class (nwg-displays)
# System Mission Center
windowrule = float on, match:class (io.missioncenter.MissionCenter)
#windowrule = pin on, match:class (io.missioncenter.MissionCenter)
windowrule = center on, match:class (io.missioncenter.MissionCenter)
windowrule = size 900 600, match:class (io.missioncenter.MissionCenter)
# System Mission Center Preference Window
windowrule = float on, match:class (missioncenter), match:title ^(Preferences)$
#windowrule = pin on, match:class (missioncenter), match:title ^(Preferences)$
windowrule = center on, match:class (missioncenter), match:title ^(Preferences)$
# Gnome Calculator
windowrule = float on,match:class (org.gnome.Calculator)
windowrule = size 700 600,match:class (org.gnome.Calculator)
windowrule = center on,match:class (org.gnome.Calculator)
# Emoji Picker Smile
windowrule = float on,match:class (it.mijorus.smile)
#windowrule = pin on, match:class (it.mijorus.smile)
windowrule = move 100%-w-40 90,match:class (it.mijorus.smile)
# Hyprland Share Picker
windowrule = float on, match:class (hyprland-share-picker)
#windowrule = pin on, match:class (hyprland-share-picker)
windowrule = center on, match:title match:class (hyprland-share-picker)
windowrule = size 600 400,match:class (hyprland-share-picker)
# Hyprland Settings App
windowrule = float on,match:title (hyprviz)
windowrule = size 1000 625,match:title (hyprviz)
windowrule = center on,match:title (hyprviz)
# General floating
windowrule = float on,match:class (dotfiles-floating)
windowrule = size 1000 700,match:class (dotfiles-floating)
windowrule = center on,match:class (dotfiles-floating)
# Float Necessary Windows
windowrule = float on, match:class ^(org.pulseaudio.pavucontrol)
windowrule = float on, match:class ^()$,match:title ^(Picture in picture)$
windowrule = float on, match:class ^()$,match:title ^(Save File)$
windowrule = float on, match:class ^()$,match:title ^(Open File)$
windowrule = float on, match:class ^(LibreWolf)$,match:title ^(Picture-in-Picture)$
##windowrule = float on, match:class ^(blueman-manager)$
windowrule = float on, match:class ^(xdg-desktop-portal-hyprland|xdg-desktop-portal-gtk|xdg-desktop-portal-kde)(.*)$
windowrule = float on, match:class ^(hyprpolkitagent|polkit-gnome-authentication-agent-1|org.org.kde.polkit-kde-authentication-agent-1)(.*)$
windowrule = float on, match:class ^(CachyOSHello)$
windowrule = float on, match:class ^(zenity)$
windowrule = float on, match:class ^()$,match:title ^(Steam - Self Updater)$
# Increase the opacity
windowrule = opacity 1.0, match:class ^(zen)$
# # windowrule = opacity 1.0, match:class ^(discord|armcord|webcord)$
# # windowrule = opacity 1.0, match:title ^(QQ|Telegram)$
# # windowrule = opacity 1.0, match:title ^(NetEase Cloud Music Gtk4)$
# General window rules
windowrule = float on, match:title ^(Picture-in-Picture)$
windowrule = size 460 260, match:title ^(Picture-in-Picture)$
windowrule = move 65%- 10%-, match:title ^(Picture-in-Picture)$
windowrule = float on, match:title ^(imv|mpv|danmufloat|termfloat|nemo|ncmpcpp)$
windowrule = move 25%-, match:title ^(imv|mpv|danmufloat|termfloat|nemo|ncmpcpp)$
windowrule = size 960 540, match:title ^(imv|mpv|danmufloat|termfloat|nemo|ncmpcpp)$
#windowrule = pin on, match:title ^(danmufloat)$
windowrule = rounding 5, match:title ^(danmufloat|termfloat)$
windowrule = animation slide right, match:class ^(kitty|Alacritty)$
#windowrule = no_blur on, match:class ^(org.mozilla.firefox)$
# Decorations related to floating windows on workspaces 1 to 10
##windowrule = bordersize 2, floating:1, onworkspace:w[fv1-10]
workspace = w[fv1-10], border_color c $source_color, float on #$on_primary_fixed_variant 90deg
##windowrule = rounding 8, floating:1, onworkspace:w[fv1-10]
# Decorations related to tiling windows on workspaces 1 to 10
##windowrule = bordersize 3, floating:0, onworkspace:f[1-10]
##windowrule = rounding 4, floating:0, onworkspace:f[1-10]
#windowrule = tile, match:title ^(Microsoft-edge)$
vwindowrule = tile, match:title ^(Brave-browser)$
#windowrule = tile, match:title ^(Chromium)$
windowrule = float on, match:title ^(pavucontrol)$
windowrule = float on, match:title ^(blueman-manager)$
windowrule = float on, match:title ^(nm-connection-editor)$
windowrule = float on, match:title ^(qalculate-gtk)$
# idleinhibit
windowrule = idle_inhibit fullscreen,match:class ([window]) # Available modes: none, always, focus, fullscreen
### no blur for specific classes
##windowrule = noblur,match:class ^(?!(nautilus|nwg-look|nwg-displays|zen))
## Windows Rules End #

windowrule = opacity 1.0 $& 1.0 $& 1,match:class ^(nautilus)$
windowrule = opacity 1.0 $& 1.0 $& 1,match:class ^(zen)$
# # windowrule = opacity 1.0 $& 1.0 $& 1,match:class ^(Brave-browser)$
windowrule = opacity 1.0 $& 1.0 $& 1,match:class ^(code-oss)$
windowrule = opacity 1.0 $& 1.0 $& 1,match:class ^([Cc]ode)$
# # windowrule = opacity 1.0 $& 1.0 $& 1,match:class ^(code-url-handler)$
# # windowrule = opacity 1.0 $& 1.0 $& 1,match:class ^(code-insiders-url-handler)$
# # windowrule = opacity 1.0 $& 1.0 $& 1,match:class ^(org.kde.dolphin)$
# # windowrule = opacity 1.0 $& 1.0 $& 1,match:class ^(org.kde.ark)$
windowrule = opacity 1.0 $& 1.0 $& 1,match:class ^(nwg-look)$
windowrule = opacity 1.0 $& 1.0 $& 1,match:class ^(qt5ct)$
windowrule = opacity 1.0 $& 1.0 $& 1,match:class ^(qt6ct)$
windowrule = opacity 1.0 $& 1.0 $& 1,match:class ^(kvantummanager)$
# # windowrule = opacity 1.0 $& 1.0 $& 1,match:class ^(org.pulseaudio.pavucontrol)$
# # windowrule = opacity 1.0 $& 1.0 $& 1,match:class ^(blueman-manager)$
# # windowrule = opacity 1.0 $& 1.0 $& 1,match:class ^(nm-applet)$
# # windowrule = opacity 1.0 $& 1.0 $& 1,match:class ^(nm-connection-editor)$
# # windowrule = opacity 1.0 $& 1.0 $& 1,match:class ^(org.kde.polkit-kde-authentication-agent-1)$
# # windowrule = opacity 1.0 $& 1.0 $& 1,match:class ^(polkit-gnome-authentication-agent-1)$
# # windowrule = opacity 1.0 $& 1.0 $& 1,match:class ^(org.freedesktop.impl.portal.desktop.gtk)$
# # windowrule = opacity 1.0 $& 1.0 $& 1,match:class ^(org.freedesktop.impl.portal.desktop.hyprland)$
# # windowrule = opacity 1.0 $& 1.0 $& 1,match:class ^([Ss]team)$
# # windowrule = opacity 1.0 $& 1.0 $& 1,match:class ^(steamwebhelper)$
windowrule = opacity 1.0 $& 1.0 $& 1,match:class ^([Ss]potify)$
windowrule = opacity 1.0 $& 1.0 $& 1,match:title ^(Spotify Free)$
windowrule = opacity 1.0 $& 1.0 $& 1,match:title ^(Spotify Premium)$
# # 
# # windowrule = opacity 1.0 1.0,match:class ^(com.github.rafostar.Clapper)$ # Clapper-Gtk
# # windowrule = opacity 1.0 1.0,match:class ^(com.github.tchx84.Flatseal)$ # Flatseal-Gtk
# # windowrule = opacity 1.0 1.0,match:class ^(hu.kramo.Cartridges)$ # Cartridges-Gtk
# # windowrule = opacity 1.0 1.0,match:class ^(com.obsproject.Studio)$ # Obs-Qt
# # windowrule = opacity 1.0 1.0,match:class ^(gnome-boxes)$ # Boxes-Gtk
# # windowrule = opacity 1.0 1.0,match:class ^(vesktop)$ # Vesktop
# # windowrule = opacity 1.0 1.0,match:class ^(discord)$ # Discord-Electron
# # windowrule = opacity 1.0 1.0,match:class ^(WebCord)$ # WebCord-Electron
# # windowrule = opacity 1.0 1.0,match:class ^(ArmCord)$ # ArmCord-Electron
# # windowrule = opacity 1.0 1.0,match:class ^(app.drey.Warp)$ # Warp-Gtk
# # windowrule = opacity 1.0 1.0,match:class ^(net.davidotek.pupgui2)$ # ProtonUp-Qt
# # windowrule = opacity 1.0 1.0,match:class ^(yad)$ # Protontricks-Gtk
# # windowrule = opacity 1.0 1.0,match:class ^(Signal)$ # Signal-Gtk
# # windowrule = opacity 1.0 1.0,match:class ^(io.github.alainm23.planify)$ # planify-Gtk
# # windowrule = opacity 1.0 1.0,match:class ^(io.gitlab.theevilskeleton.Upscaler)$ # Upscaler-Gtk
# # windowrule = opacity 1.0 1.0,match:class ^(com.github.unrud.VideoDownloader)$ # VideoDownloader-Gtk
# # windowrule = opacity 1.0 1.0,match:class ^(io.gitlab.adhami3310.Impression)$ # Impression-Gtk
# # windowrule = opacity 1.0 1.0,match:class ^(io.missioncenter.MissionCenter)$ # MissionCenter-Gtk
# # windowrule = opacity 1.0 1.0,match:class ^(io.github.flattool.Warehouse)$ # Warehouse-Gtk
windowrule = float on,match:class ^(org.kde.dolphin)$,match:title ^(Progress Dialog — Dolphin)$
windowrule = float on,match:class ^(org.kde.dolphin)$,match:title ^(Copying — Dolphin)$
windowrule = float on,match:title ^(About Mozilla Firefox)$
windowrule = float on,match:class ^(firefox)$,match:title ^(Picture-in-Picture)$
windowrule = float on,match:class ^(firefox)$,match:title ^(Library)$
windowrule = float on,match:class ^(kitty)$,match:title ^(top)$
windowrule = float on,match:class ^(kitty)$,match:title ^(btop)$
windowrule = float on,match:class ^(kitty)$,match:title ^(htop)$
windowrule = float on,match:class ^(vlc)$
windowrule = float on,match:class ^(eww-main-window)$
windowrule = float on,match:class ^(eww-notifications)$
windowrule = float on,match:class ^(kvantummanager)$
windowrule = float on,match:class ^(qt5ct)$
windowrule = float on,match:class ^(qt6ct)$
windowrule = float on,match:class ^(nwg-look)$
windowrule = float on,match:class ^(org.kde.ark)$
windowrule = float on,match:class ^(org.pulseaudio.pavucontrol)$
windowrule = float on,match:class ^(blueman-manager)$
windowrule = float on,match:class ^(nm-applet)$
windowrule = float on,match:class ^(nm-connection-editor)$
windowrule = float on,match:class ^(org.kde.polkit-kde-authentication-agent-1)$

windowrule = float on,match:class ^(Signal)$ # Signal-Gtk
windowrule = float on,match:class ^(com.github.rafostar.Clapper)$ # Clapper-Gtk
windowrule = float on,match:class ^(app.drey.Warp)$ # Warp-Gtk
windowrule = float on,match:class ^(net.davidotek.pupgui2)$ # ProtonUp-Qt
windowrule = float on,match:class ^(yad)$ # Protontricks-Gtk
windowrule = float on,match:class ^(eog)$ # Imageviewer-Gtk
windowrule = float on,match:class ^(io.github.alainm23.planify)$ # planify-Gtk
windowrule = float on,match:class ^(io.gitlab.theevilskeleton.Upscaler)$ # Upscaler-Gtk
windowrule = float on,match:class ^(com.github.unrud.VideoDownloader)$ # VideoDownloader-Gkk
windowrule = float on,match:class ^(io.gitlab.adhami3310.Impression)$ # Impression-Gtk
windowrule = float on,match:class ^(io.missioncenter.MissionCenter)$ # MissionCenter-Gtk
windowrule = float on,match:class (clipse) # ensure you have a floating window class set if you want this behavior
windowrule = size 622 652,match:class (clipse) # set the size of the window as necessary
#windowrule = noborder, fullscreen:1

# common modals
#windowrule = float on,match:title ^(Open File)$
#windowrule = layer:top,match:class hyprpolkitagent
windowrule = float on,match:title ^(Choose Files)$
windowrule = float on,match:title ^(Save As)$
windowrule = float on,match:title ^(Confirm to replace files)$
windowrule = float on,match:title ^(File Operation Progress)$
windowrule = float on,match:class ^(xdg-desktop-portal-gtk)$

# installer
windowrule = float on, match:class (floating-installer)
windowrule = center on, match:class (floating-installer)

# clock
windowrule = float on, center on, size 400 200, match:class (clock)

# Extra workspace & window rules 
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
#windowrule = bordersize 2, floating:0, onworkspace:w[t1]
#windowrule = rounding 10, floating:0, onworkspace:w[t1]
#windowrule = bordersize 2, floating:0, onworkspace:w[tg1]
#windowrule = rounding 10, floating:0, onworkspace:w[tg1]
#windowrule = bordersize 2, floating:0, onworkspace:f[1]
#windowrule = rounding 10, floating:0, onworkspace:f[1]
windowrule = rounding 0, fullscreen true, border_size 0
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
layerrule = animation slide top, match:namespace logout_dialog
layerrule = blur on,xray on,match:namespace rofi
layerrule = ignore_alpha 0.01,match:namespace rofi
layerrule = blur on,match:namespace notifications
layerrule = ignore_alpha 0.01,match:namespace notifications
layerrule = blur on,match:namespace swaync-notification-window
layerrule = ignore_alpha 0.01,match:namespace swaync-notification-window
layerrule = blur on,xray on,no_anim on,match:namespace swaync-control-center
layerrule = ignore_alpha 0.01,match:namespace swaync-control-center
layerrule = blur on,no_anim on,match:namespace nwg-dock
layerrule = ignore_alpha 0.01,match:namespace nwg-dock
layerrule = blur on,match:namespace logout_dialog
layerrule = ignore_alpha 0.01,match:namespace logout_dialog
layerrule = blur on,match:namespace gtk-layer-shell
layerrule = ignore_alpha 0.01,match:namespace gtk-layer-shell
layerrule = blur on,no_anim on,match:namespace bar-0
layerrule = ignore_alpha 0.01,match:namespace bar-0
layerrule = blur on,match:namespace dashboardmenu
layerrule = ignore_alpha 0.01,match:namespace dashboardmenu
layerrule = blur on,match:namespace calendarmenu
layerrule = ignore_alpha 0.01,match:namespace calendarmenu
layerrule = blur on,match:namespace notificationsmenu
layerrule = ignore_alpha 0.01,match:namespace notificationsmenu
layerrule = blur on,match:namespace networkmenu
layerrule = ignore_alpha 0.01,match:namespace networkmenu
layerrule = blur on,match:namespace mediamenu
layerrule = ignore_alpha 0.01,match:namespace mediamenu
layerrule = blur on,match:namespace energymenu
layerrule = ignore_alpha 0.01,match:namespace energymenu
layerrule = blur on,match:namespace bluetoothmenu
layerrule = ignore_alpha 0.01,match:namespace bluetoothmenu
layerrule = blur on,match:namespace audiomenu
layerrule = ignore_alpha 0.01,match:namespace audiomenu
layerrule = blur on,match:namespace hyprmenu
layerrule = ignore_alpha 0.01,match:namespace hyprmenu
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

# ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
# ┃                            Plugins                          ┃
# ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

#plugin {
#    hyprexpo {
#        #general 
#        columns = 3
#        gaps_in = 8
#        gaps_out = 10
#        bg_col = $inverse_primary
#        workspace = first 1
#        
#        #borders
#        border_style = hyprland
#        border_grad_current = $scrim
#        border_grad_focus   = $inverse_primary
#
#        #labels
#        label_enable = 1
#        label_bg_shape = circle
#        label_position = center-center
#        label_offset_x = 10
#        label_offset_y = 10
#        label_color_default = $inverse_primary
#        label_color_hover   = $primary_fixed_dim
#        label_scale_hover = 1.0
#        label_scale_focus = 1.0
#        label_bg_enable = 1
#        label_bg_color = rgba(00000088)
#        label_bg_rounding = 15
#        # label_padding = 1
#
#        label_font_size = 25
#        label_font_family = FantasqueSansM Nerd Font Propo Regular
#        label_font_bold = 1
#        label_font_italic = 0
#        label_text_underline = 0
#        label_text_strikethrough = 0
#    }
#    
#    hyprbars {
#        bar_height = 25
#        bar_color = $source_color
#        bar_blur = true
#        
#        bar_title_enabled = false
#        bar_text_size = 10
#        bar_text_font = FantasqueSansM Nerd Font Propo Regular
#        
#        bar_text_align = center
#        bar_buttons_alignment = left
#        
#        bar_padding = 15
#        bar_button_padding = 6
#        
#        color_text = white
#        
#        hyprbars-button = $on_secondary, 15, , hyprctl dispatch killactive
#        hyprbars-button = $primary_container, 15, , bash "$HOME/.config/hypr/scripts/hyprbars-minimize.sh"
#        hyprbars-button = $surface_tint, 15, 󰺖, hyprctl dispatch fullscreen 1
#        
#        on_double_click = hyprctl dispatch fullscreen 1
#    }
#}
#
#submap = hyprexpo
#bind = CTRL ALT, down, hyprexpo:expo, close
#
#bind = , left,  hyprexpo:kb_focus, left
#bind = , right, hyprexpo:kb_focus, right
#bind = , up,    hyprexpo:kb_focus, up
#bind = , down,  hyprexpo:kb_focus, down
#bind = , return, hyprexpo:kb_confirm
#
## tokens 1..10: digits
#
#bind = , 1, hyprexpo:kb_selecti, 1
#bind = , 2, hyprexpo:kb_selecti, 2
#bind = , 3, hyprexpo:kb_selecti, 3
#bind = , 4, hyprexpo:kb_selecti, 4
#bind = , 5, hyprexpo:kb_selecti, 5
#bind = , 6, hyprexpo:kb_selecti, 6
#bind = , 7, hyprexpo:kb_selecti, 7
#bind = , 8, hyprexpo:kb_selecti, 8
#bind = , 9, hyprexpo:kb_selecti, 9
#bind = , 0, hyprexpo:kb_selecti, 0
#
## tokens 11..20: SHIFT+digits (update args to match your layout symbols)
#
#bind = SHIFT, 1, hyprexpo:kb_selecti, 11
#bind = SHIFT, 2, hyprexpo:kb_selecti, 12
#bind = SHIFT, 3, hyprexpo:kb_selecti, 13
#bind = SHIFT, 4, hyprexpo:kb_selecti, 14
#bind = SHIFT, 5, hyprexpo:kb_selecti, 15
#bind = SHIFT, 6, hyprexpo:kb_selecti, 16
#bind = SHIFT, 7, hyprexpo:kb_selecti, 17
#bind = SHIFT, 8, hyprexpo:kb_selecti, 18
#bind = SHIFT, 9, hyprexpo:kb_selecti, 19
#bind = SHIFT, 0, hyprexpo:kb_selecti, 20
#
## tokens 21..46: alpha
#
#bind = , a, hyprexpo:kb_selecti, 21
#bind = , b, hyprexpo:kb_selecti, 22
#bind = , c, hyprexpo:kb_selecti, 23
#bind = , d, hyprexpo:kb_selecti, 24
#bind = , e, hyprexpo:kb_selecti, 25
#bind = , f, hyprexpo:kb_selecti, 26
#bind = , g, hyprexpo:kb_selecti, 27
#bind = , h, hyprexpo:kb_selecti, 28
#bind = , i, hyprexpo:kb_selecti, 29
#bind = , j, hyprexpo:kb_selecti, 30
#bind = , k, hyprexpo:kb_selecti, 31
#bind = , l, hyprexpo:kb_selecti, 32
#bind = , m, hyprexpo:kb_selecti, 33
#bind = , n, hyprexpo:kb_selecti, 34
#bind = , o, hyprexpo:kb_selecti, 35
#bind = , p, hyprexpo:kb_selecti, 36
#bind = , q, hyprexpo:kb_selecti, 37
#bind = , r, hyprexpo:kb_selecti, 38
#bind = , s, hyprexpo:kb_selecti, 39
#bind = , t, hyprexpo:kb_selecti, 40
#bind = , u, hyprexpo:kb_selecti, 41
#bind = , v, hyprexpo:kb_selecti, 42
#bind = , w, hyprexpo:kb_selecti, 43
#bind = , x, hyprexpo:kb_selecti, 44
#bind = , y, hyprexpo:kb_selecti, 45
#bind = , z, hyprexpo:kb_selecti, 46
#submap = reset

# ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
# ┃                           Userprefs                         ┃
# ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛
# [NOTE!!] Add you personal settings from here and incase of an update copy them to the new file once this is changed to a backup
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

auth {
    fingerprint {
        enabled = true
        ready_message = Scan fingerprint to unlock
        present_message = Scanning...
        retry_delay = 250 # in milliseconds
    }
}

background {
    monitor =
    path = ~/.config/background.png
    blur_passes = 4
    blur_sizes = 0
    vibrancy = 0.1696
    noise = 0.01
    contrast = 0.8916
}

input-field {
    monitor =
    size = 200, 50
    outline_thickness = 3
    dots_size = 0.25 # Scale of input-field height, 0.2 - 0.8
    dots_spacing = 0.2 # Scale of dots' absolute size, 0.0 - 1.0
    dots_center = true
    dots_rounding = -1 # -1 default circle, -2 follow input-field rounding
    outer_color = $primary_fixed_dim $source_color 90deg
    inner_color = $inverse_primary
    font_color = $primary_fixed_dim
    font_family = C059 Bold Italic
    fade_on_empty = false
    fade_timeout = 1000 # Milliseconds before fade_on_empty is triggered.
    placeholder_text = <i><span>       $USER       </span></i># Text rendered in the input box when it's empty. # foreground="$inverse_primary ##ffffff99
    hide_input = false
    rounding = 20 # -1 means complete rounding (circle/oval)
    check_color = $rimary
    fail_color = $error # if authentication failed, changes outer_color and fail message color
    fail_text = <i>$FAIL <b>($ATTEMPTS)</b></i> # can be set to empty
    fail_transition = 300 # transition time in ms between normal outer_color and fail_color
    capslock_color = $primary_fixed_dim
    numlock_color = $primary_fixed_dim $source_color 90deg
    #bothlock_color = -1 # when both locks are active. -1 means don't change outer color (same for above)
    invert_numlock = false # change color if numlock is off
    swap_font_color = false # see below
    position = 0, 150
    halign = center
    valign = bottom
    shadow_passes = 10
    shadow_size = 20
    shadow_color = $shadow
    shadow_boost = 1.6
}

label {
    monitor =
    #date
    text = cmd[update:60000] date +"%A, %d %B %Y"
    color = $primary_fixed_dim
    font_size = 20
    font_family = C059 Bold
    position = 0, -35
    halign = center
    valign = top
}

label {
    monitor =
    #clock
    text = cmd[update:1000] echo "$TIME"
    color = $inverse_primary
    font_size = 55
    font_family = C059 Bold Italic
    position = 0, -150
    halign = center
    valign = top
    shadow_passes = 5
    shadow_size = 10
}

#label {
    monitor =
    #text = ✝      $USER    ✝ #  $USER
    color = $primary_fixed_dim
    font_size = 20
    font_family = C059 Bold
    position = 0, 100
    halign = center
    valign = bottom
    shadow_passes = 5
    shadow_size = 10
}

image {
    monitor =
    path = ~/.config/lock.png #.face.icon
    size = 160  lesser side if not 1:1 ratio
    rounding = -1 # negative values mean circle
    border_size = 4
    border_color = $primary_fixed_dim $source_color 90deg
    rotate = 0 # degrees, counter-clockwise
    reload_time = -1 # seconds between reloading, 0 to reload with SIGUSR2
#    reload_cmd =  # command to get new path. if empty, old path will be used. don't run "follow" commands like tail -F
    position = 0, 0
    halign = center
    valign = center
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

#
$mainMod = SUPER
$HYPRSCRIPTS = ~/.config/hypr/scripts
$SCRIPTS = ~/.config/hyprcandy/scripts
$EDITOR = gedit # Change from the default editor to your prefered editor
$DISCORD = equibop
#

#### Kill active window ####

bind = $mainMod, Escape, killactive #Kill single active window
bind = $mainMod SHIFT, Escape, exec, hyprctl activewindow | grep pid | tr -d 'pid:' | xargs kill #Quit active window and all similar open instances

#### Rofi Menus ####

bind = $mainMod CTRL, R, exec, $HYPRSCRIPTS/rofi-menus.sh     #Launch utilities rofi-menu
bind = $mainMod, A, exec, rofi -show drun || pkill rofi      #Launch or kill/hide rofi application finder
bind = $mainMod, K, exec, $HYPRSCRIPTS/keybindings.sh     #Show keybindings
bind = $mainMod CTRL, A, exec, $HYPRSCRIPTS/animations.sh     #Select animations
bind = $mainMod CTRL, V, exec, $SCRIPTS/cliphist.sh     #Open clipboard manager
bind = $mainMod CTRL, E, exec, ~/.config/hyprcandy/settings/emojipicker.sh 		  #Open rofi emoji-picker
bind = $mainMod CTRL, G, exec, ~/.config/hyprcandy/settings/glyphpicker.sh 		  #Open rofi glyph-picker

#### Applications ####

bind = $mainMod, W, exec, waypaper #Waypaper
bind = $mainMod, S, exec, spotify #Spotify
bind = $mainMod, D, exec, $DISCORD #Discord
bind = $mainMod, C, exec, DRI_PRIME=1 $EDITOR #Editor
bind = $mainMod, B, exec, DRI_PRIME=1 xdg-open "http://" #Launch your default browser
bind = $mainMod, Q, exec, kitty #Launch normal kitty instances
bind = $mainMod, Return, exec, DRI_PRIME=1 pypr toggle term #Launch a kitty scratchpad through pyprland
bind = $mainMod, O, exec, DRI_PRIME=1 /usr/bin/octopi #Launch octopi application finder
bind = $mainMod, E, exec, DRI_PRIME=1 nautilus #Launch the filemanager 
bind = $mainMod CTRL, C, exec, DRI_PRIME=1 gnome-calculator #Launch the calculator

#### Bar/Panel ####

bind = ALT, 1, exec, ~/.config/hyprcandy/hooks/kill_waybar_safe.sh #Hide/kill waybar and start automatic idle-inhibitor
bind = ALT, 2, exec, ~/.config/hyprcandy/hooks/restart_waybar.sh #Restart or reload waybar and stop automatic idle-inhibitor

#### Dock keybinds ####

bind = ALT, 3, exec, $SCRIPTS/toggle-dock.sh --restore #Hide/kill or launch dock
bind = ALT, 4, exec, ~/.config/hyprcandy/hooks/nwg_dock_status_display.sh #Dock status display

#### Status display ####

bind = ALT, 5, exec, ~/.config/hyprcandy/hooks/hyprland_status_display.sh #Hyprland status display

#### Recorder ####

# Wf--recorder (simple recorder) + slurp (allows to select a specific region of the monitor)
# {to list audio devices run "pactl list sources | grep Name"}   
bind = $mainMod, R, exec, bash -c 'wf-recorder -g -a --audio=bluez_output.78_15_2D_0D_BD_B7.1.monitor -f "$HOME/Videos/Recordings/recording-$(date +%Y%m%d-%H%M%S).mp4" $(slurp)' # Start recording
bind = Alt, R, exec, pkill -x wf-recorder #Stop recording

#### Hyprsunset ####

bind = Shift, H, exec, hyprctl hyprsunset gamma +10 #Increase gamma by 10%
bind = Alt, H, exec, hyprctl hyprsunset gamma -10 #Reduce gamma by 10%


#### Actions ####

bind = CTRL, G, exec, $HYPRSCRIPTS/gamemode.sh						  #Toggle game-mode
bind = $mainMod, M, exec, ~/.config/hypr/scripts/power.sh exit 				  #Logout
#bind = $mainMod,SPACE, hyprexpo:expo, toggle						  #Hyprexpo-plus workspaces overview
bind = $mainMod SHIFT, R, exec, $HYPRSCRIPTS/loadconfig.sh                                 #Reload Hyprland configuration
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

bind = SHIFT, TAB, exec, qs ipc -c overview call overview toggle #Workspace overview

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

bind = CTRL SHIFT, 1, togglespecialworkspace, magic #Togle window from special workspace
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
bind = $mainMod SHIFT, M, fullscreen, 1                                                           #Maximize Window
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

bind = , XF86MonBrightnessUp, exec, brightnessctl -q s +10% && notify-send "Screen Brightness" "$(brightnessctl | grep -o '[0-9]*%' | head -1)" -t 1000  #Increase brightness by 10% 
bind = , XF86MonBrightnessDown, exec, brightnessctl -q s 10%- && notify-send "Screen Brightness" "$(brightnessctl | grep -o '[0-9]*%' | head -1)" -t 1000 #Reduce brightness by 10%
bind = , XF86AudioRaiseVolume, exec, pactl set-sink-mute @DEFAULT_SINK@ 0 && pactl set-sink-volume @DEFAULT_SINK@ +5% && notify-send "Volume" "$(pactl get-sink-volume @DEFAULT_SINK@ | grep -o '[0-9]*%' | head -1)" -t 1000
bind = , XF86AudioLowerVolume, exec, pactl set-sink-mute @DEFAULT_SINK@ 0 && pactl set-sink-volume @DEFAULT_SINK@ -5% && notify-send "Volume" "$(pactl get-sink-volume @DEFAULT_SINK@ | grep -o '[0-9]*%' | head -1)" -t 1000
bind = , XF86AudioMute, exec, amixer sset Master toggle | sed -En '/\[on\]/ s/.*\[([0-9]+)%\].*/\1/ p; /\[off\]/ s/.*/0/p' | head -1 > /tmp/$HYPRLAND_INSTANCE_SIGNATURE.wob && if amixer sget Master | grep -q '\[off\]'; then notify-send "Volume" "Muted" -t 1000; else notify-send "Volume" "$(amixer sget Master | grep -o '[0-9]*%' | head -1)" -t 1000; fi 
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

#
$mainMod = SUPER
$HYPRSCRIPTS = ~/.config/hypr/scripts
$SCRIPTS = ~/.config/hyprcandy/scripts
$EDITOR = gedit # Change from the default editor to your prefered editor
$DISCORD = equibop
#

#### Kill active window ####

bind = $mainMod, Escape, killactive #Kill single active window
bind = $mainMod SHIFT, Escape, exec, hyprctl activewindow | grep pid | tr -d 'pid:' | xargs kill #Quit active window and all similar open instances

#### Rofi Menus ####

bind = $mainMod CTRL, R, exec, $HYPRSCRIPTS/rofi-menus.sh     #Launch utilities rofi-menu
bind = $mainMod, A, exec, rofi -show drun || pkill rofi      #Launch or kill/hide rofi application finder
bind = $mainMod, K, exec, $HYPRSCRIPTS/keybindings.sh     #Show keybindings
bind = $mainMod CTRL, A, exec, $HYPRSCRIPTS/animations.sh     #Select animations
bind = $mainMod CTRL, V, exec, $SCRIPTS/cliphist.sh     #Open clipboard manager
bind = $mainMod CTRL, E, exec, ~/.config/hyprcandy/settings/emojipicker.sh 		  #Open rofi emoji-picker
bind = $mainMod CTRL, G, exec, ~/.config/hyprcandy/settings/glyphpicker.sh 		  #Open rofi glyph-picker

#### Applications ####

bind = $mainMod, W, exec, waypaper #Waypaper
bind = $mainMod, S, exec, spotify #Spotify
bind = $mainMod, D, exec, $DISCORD #Discord
bind = $mainMod, C, exec, DRI_PRIME=1 $EDITOR #Editor
bind = $mainMod, B, exec, DRI_PRIME=1 xdg-open "http://" #Launch your default browser
bind = $mainMod, Q, exec, kitty #Launch normal kitty instances
bind = $mainMod, Return, exec, DRI_PRIME=1 pypr toggle term #Launch a kitty scratchpad through pyprland
bind = $mainMod, O, exec, DRI_PRIME=1 /usr/bin/octopi #Launch octopi application finder
bind = $mainMod, E, exec, DRI_PRIME=1 nautilus #Launch the filemanager 
bind = $mainMod CTRL, C, exec, DRI_PRIME=1 gnome-calculator #Launch the calculator

#### Bar/Panel ####

bind = ALT, 1, exec, ~/.config/hyprcandy/hooks/kill_hyprpanel_safe.sh #Hide/kill hyprpanel and start automatic idle-inhibitor
bind = ALT, 2, exec, ~/.config/hyprcandy/hooks/restart_hyprpanel.sh #Restart or reload hyprpanel and stop automatic idle-inhibitor

#### Dock keybinds ####

bind = ALT, 3, exec, $SCRIPTS/toggle-dock.sh --restore #Hide/kill or launch dock
bind = ALT, 4, exec, ~/.config/hyprcandy/hooks/nwg_dock_status_display.sh #Dock status display

#### Status display ####

bind = ALT, 5, exec, ~/.config/hyprcandy/hooks/hyprland_status_display.sh #Hyprland status display

#### Recorder ####

# Wf--recorder (simple recorder) + slurp (allows to select a specific region of the monitor)
# {to list audio devices run "pactl list sources | grep Name"}   
bind = $mainMod, R, exec, bash -c 'wf-recorder -g -a --audio=bluez_output.78_15_2D_0D_BD_B7.1.monitor -f "$HOME/Videos/Recordings/recording-$(date +%Y%m%d-%H%M%S).mp4" $(slurp)' # Start recording
bind = Alt, R, exec, pkill -x wf-recorder #Stop recording

#### Hyprsunset ####

bind = Shift, H, exec, hyprctl hyprsunset gamma +10 #Increase gamma by 10%
bind = Alt, H, exec, hyprctl hyprsunset gamma -10 #Reduce gamma by 10%


#### Actions ####

bind = CTRL, G, exec, $HYPRSCRIPTS/gamemode.sh						  #Toggle game-mode
bind = $mainMod, M, exec, ~/.config/hypr/scripts/power.sh exit 				  #Logout
#bind = $mainMod,SPACE, hyprexpo:expo, toggle						  #Hyprexpo-plus workspaces overview
bind = $mainMod SHIFT, R, exec, $HYPRSCRIPTS/loadconfig.sh                                 #Reload Hyprland configuration
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

bind = SHIFT, TAB, exec, qs ipc -c overview call overview toggle #Workspace overview

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

bind = CTRL SHIFT, 1, togglespecialworkspace, magic #Togle window from special workspace
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
bind = $mainMod SHIFT, M, fullscreen, 1                                                           #Maximize Window
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

bind = , XF86MonBrightnessUp, exec, brightnessctl -q s +10% && notify-send "Screen Brightness" "$(brightnessctl | grep -o '[0-9]*%' | head -1)" -t 1000  #Increase brightness by 10% 
bind = , XF86MonBrightnessDown, exec, brightnessctl -q s 10%- && notify-send "Screen Brightness" "$(brightnessctl | grep -o '[0-9]*%' | head -1)" -t 1000 #Reduce brightness by 10%
bind = , XF86AudioRaiseVolume, exec, pactl set-sink-mute @DEFAULT_SINK@ 0 && pactl set-sink-volume @DEFAULT_SINK@ +5% && notify-send "Volume" "$(pactl get-sink-volume @DEFAULT_SINK@ | grep -o '[0-9]*%' | head -1)" -t 1000
bind = , XF86AudioLowerVolume, exec, pactl set-sink-mute @DEFAULT_SINK@ 0 && pactl set-sink-volume @DEFAULT_SINK@ -5% && notify-send "Volume" "$(pactl get-sink-volume @DEFAULT_SINK@ | grep -o '[0-9]*%' | head -1)" -t 1000
bind = , XF86AudioMute, exec, amixer sset Master toggle | sed -En '/\[on\]/ s/.*\[([0-9]+)%\].*/\1/ p; /\[off\]/ s/.*/0/p' | head -1 > /tmp/$HYPRLAND_INSTANCE_SIGNATURE.wob && if amixer sget Master | grep -q '\[off\]'; then notify-send "Volume" "Muted" -t 1000; else notify-send "Volume" "$(amixer sget Master | grep -o '[0-9]*%' | head -1)" -t 1000; fi 
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
    HYPRLAND_CUSTOM="$HOME/.config/hypr/hyprviz.conf"
    echo "🎨 Updating Hyprland custom.conf with current username..."		
    
    if [ -f "$HYPRLAND_CUSTOM" ]; then
        sed -i "s|\$USERNAME|$USERNAME|g" "$HYPRLAND_CUSTOM"
        echo "✅ Updated custom.conf PATH with username: $USERNAME"
    else
        echo "⚠️  File not found: $HYPRLAND_CUSTOM"
    fi
        fi

    print_status "Setting up hyprexpo-plus and hyprbars plugins with configs in hyprviz.conf" 
    print_status "Note the plugins' setup will request your permission a few times here..."
    
    hyprpm update
    hyprpm add https://github.com/hyprwm/hyprland-plugins
    hyprpm add https://github.com/sandwichfarm/hyprexpo-plus
    hyprpm disable hyprbars
    hyprpm disable hyprexpo-plus
    hyprpm reload
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
    local CUSTOM_CONFIG_FILE="$HOME/.config/hypr/hyprviz.conf"
    
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
        
        # Handle swaync line - uncomment if commented, or ensure it's uncommented
        if grep -q "^#.*exec-once = swaync &" "$CUSTOM_CONFIG_FILE"; then
            # Line is commented, uncomment it
            sed -i 's/^#\+\s*exec-once = swaync &/exec-once = swaync \&/g' "$CUSTOM_CONFIG_FILE"
        elif ! grep -q "^exec-once = swaync &" "$CUSTOM_CONFIG_FILE"; then
            # Line doesn't exist at all, add it (optional - you might want to handle this case)
            echo "exec-once = swaync &" >> "$CUSTOM_CONFIG_FILE"
        fi
        
        # Handle awww-daemon line - uncomment if commented
        if grep -q "^#.*exec-once = awww-daemon &" "$CUSTOM_CONFIG_FILE"; then
            # Line is commented, uncomment it
            sed -i 's/^#\+\s*exec-once = awww-daemon &/exec-once = awww-daemon \&/g' "$CUSTOM_CONFIG_FILE"
        elif ! grep -q "^exec-once = awww-daemon &" "$CUSTOM_CONFIG_FILE"; then
            # Line doesn't exist at all, add it (optional - you might want to handle this case)
            echo "exec-once = awww-daemon &" >> "$CUSTOM_CONFIG_FILE"
        fi
        sed -i 's/#exec-once = systemctl --user start waypaper-watcher/exec-once = systemctl --user start waypaper-watcher/g' "$CUSTOM_CONFIG_FILE"
        sed -i 's/layerrule = blur,bar-0/layerrule = blur,waybar/g' "$CUSTOM_CONFIG_FILE"
        sed -i 's/layerrule = ignorezero,bar-0/layerrule = ignorezero,waybar/g' "$CUSTOM_CONFIG_FILE"
        echo -e "${GREEN}Updated custom config layer rules for waybar${NC}"
    else
        # Replace bar-0 with hyprpanel in layer rules
        sed -i '18s/exec-once = waybar \&/exec-once = systemctl --user start hyprpanel/g' "$CUSTOM_CONFIG_FILE"
        sed -i '22s/exec-once = systemctl --user start waybar-idle-monitor/exec-once = systemctl --user start hyprpanel-idle-monitor/g' "$CUSTOM_CONFIG_FILE"
        
        # Handle swaync line - comment if uncommented
        if grep -q "^exec-once = swaync &" "$CUSTOM_CONFIG_FILE"; then
            # Line is uncommented, comment it
            sed -i 's/^exec-once = swaync &#exec-once = swaync \&/g' "$CUSTOM_CONFIG_FILE"
        fi
        
        # Handle awww-daemon line - comment if uncommented
        if grep -q "^exec-once = awww-daemon &" "$CUSTOM_CONFIG_FILE"; then
            # Line is uncommented, comment it
            sed -i 's/^exec-once = awww-daemon &#exec-once = awww-daemon \&/g' "$CUSTOM_CONFIG_FILE"
        fi
        
        sed -i 's/exec-once = awww-daemon &/#exec-once = awww-daemon \&/g' "$CUSTOM_CONFIG_FILE"
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

cat > "$HOME/.hyprcandy/GJS/candy-main.js" << 'EOF'
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

const CandyUtils = imports['candy-utils'];

const APP_ID = 'Candy.Utils';

function onActivate(app) {
    const winCandy = new (Adw ? Adw.ApplicationWindow : Gtk.ApplicationWindow)({
        application: app,
        title: 'Candy Utilities',
        default_width: 600,
        default_height: 260,
        resizable: false,
        decorated: false,
    });
    if (winCandy.set_icon_from_file) {
        try { winCandy.set_icon_from_file(GLib.build_filenamev([GLib.get_home_dir(), '.local/share/icons/HyprCandy.png'])); } catch (e) {}
    }
    const candyBox = CandyUtils.createCandyUtilsBox();
    if (Adw && winCandy.set_content) {
        winCandy.set_content(candyBox);
    } else {
        winCandy.set_child(candyBox);
    }
    // Add Escape key handling
    const keyController = new Gtk.EventControllerKey();
    keyController.connect('key-pressed', (controller, keyval, keycode, state) => {
        if (keyval === Gdk.KEY_Escape) {
            winCandy.close();
        }
        return false;
    });
    winCandy.add_controller(keyController);
    winCandy.set_visible(true);
    if (winCandy.set_keep_above) winCandy.set_keep_above(true);
    winCandy.present();
}

function main() {
    const ApplicationType = Adw ? Adw.Application : Gtk.Application;
    const app = new ApplicationType({ application_id: APP_ID });
    app.connect('activate', onActivate);
    app.run([]);
}

main(); 
EOF

cat > "$HOME/.hyprcandy/GJS/media-main.js" << 'EOF'
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

const Media = imports['media'];

const APP_ID = 'Candy.Media';

function onActivate(app) {
    const winMedia = new (Adw ? Adw.ApplicationWindow : Gtk.ApplicationWindow)({
        application: app,
        title: 'Media Player',
        default_width: 520,
        default_height: 140,
        resizable: false,
        decorated: false,
    });
    if (winMedia.set_icon_from_file) {
        try { winMedia.set_icon_from_file(GLib.build_filenamev([GLib.get_home_dir(), '.local/share/icons/HyprCandy.png'])); } catch (e) {}
    }
    const mediaBox = Media.createMediaBox();
    if (Adw && winMedia.set_content) {
        winMedia.set_content(mediaBox);
    } else {
        winMedia.set_child(mediaBox);
    }
    // Add Escape key handling
    const keyController = new Gtk.EventControllerKey();
    keyController.connect('key-pressed', (controller, keyval, keycode, state) => {
        if (keyval === Gdk.KEY_Escape) {
            winMedia.close();
        }
        return false;
    });
    winMedia.add_controller(keyController);
    winMedia.set_visible(true);
    if (winMedia.set_keep_above) winMedia.set_keep_above(true);
    winMedia.present();
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

if [ "$PANEL_CHOICE" = "waybar" ]; then
cat > "$HOME/.hyprcandy/GJS/src/candy-utils.js" << 'EOF'
imports.gi.versions.Gtk = '4.0';
imports.gi.versions.Gio = '2.0';
imports.gi.versions.GLib = '2.0';
imports.gi.versions.Gdk = '4.0';
const { Gtk, Gio, GLib, Gdk } = imports.gi;

const scriptDir = GLib.path_get_dirname(imports.system.programInvocationName);
imports.searchPath.unshift(scriptDir);

const Weather = imports.weather;

function createCandyUtilsBox() {
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
    // Load user GTK color theme CSS (if available)
    const userColorsProvider = new Gtk.CssProvider();
    try {
        userColorsProvider.load_from_path(GLib.build_filenamev([GLib.get_home_dir(), '.config', 'gtk-3.0', 'colors.css']));
        Gtk.StyleContext.add_provider_for_display(
            Gdk.Display.get_default(),
            userColorsProvider,
            Gtk.STYLE_PROVIDER_PRIORITY_USER
        );
    } catch (e) {
        // Ignore if not found
    }

    // Inject custom CSS for gradient background and frame (no neon border)
    const cssProvider = new Gtk.CssProvider();
    let css = `
        .candy-utils-frame {
            border-radius: 10px;
            min-width: 600px;
            min-height: 320px;
            padding: 0px 0px;
            box-shadow: 0 4px 32px 0 rgba(0,0,0,0.22);
            /*background: linear-gradient(90deg, @on_primary_fixed_variant 0%, @source_color 100%, @source_color 0%, @background 100%);*/
            background-size: cover;
        }
        .weather-temp {
            font-size: 1.8em;
            font-weight: 700;
            color: @primary_fixed_dim;
            text-shadow: 0 0 12px @source_color;
            opacity: 1;
        }
        .neon-highlight, button:hover, button:active {
            box-shadow: 0 0 8px 2px @background, 0 0 0 2px @background inset;
            border-color: @source_color;
            color: @inverse_primary;
        }
    `;
    cssProvider.load_from_data(css, css.length);
    Gtk.StyleContext.add_provider_for_display(
        Gdk.Display.get_default(),
        cssProvider,
        Gtk.STYLE_PROVIDER_PRIORITY_APPLICATION
    );

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
    const hyprsunsetBtn = new Gtk.Button({ label: hyprsunsetEnabled ? 'Hyprsunset 󰌵' : 'Hyprsunset 󰌶' });
    if (hyprsunsetEnabled) hyprsunsetBtn.add_css_class('neon-highlight');
    hyprsunsetBtn.connect('clicked', () => {
        if (!hyprsunsetEnabled) {
            GLib.spawn_command_line_async("bash -c 'hyprsunset &'");
            hyprsunsetBtn.set_label('Hyprsunset 󰌵');
            hyprsunsetBtn.add_css_class('neon-highlight');
            hyprsunsetEnabled = true;
        } else {
            GLib.spawn_command_line_async('pkill hyprsunset');
            hyprsunsetBtn.set_label('Hyprsunset 󰌶');
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
    leftBox.append(hyprsunsetBox);

    // Hyprpicker button
    const hyprpickerBtn = new Gtk.Button({ label: 'Launch Hyprpicker' });
    hyprpickerBtn.connect('clicked', () => {
        GLib.spawn_command_line_async('hyprpicker');
    });
    leftBox.append(hyprpickerBtn);

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
        const configFile = GLib.build_filenamev([GLib.get_home_dir(), '.config', 'hypr', 'hyprviz.conf']);
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
            const configFile = GLib.build_filenamev([GLib.get_home_dir(), '.config', 'hypr', 'hyprviz.conf']);
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
            const configFile = GLib.build_filenamev([GLib.get_home_dir(), '.config', 'hypr', 'hyprviz.conf']);
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
            const configFile = GLib.build_filenamev([GLib.get_home_dir(), '.config', 'hypr', 'hyprviz.conf']);
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
    leftBox.append(opacityBtn);
    
    // Preset buttons
    const presetBox = new Gtk.Box({ orientation: Gtk.Orientation.VERTICAL, spacing: 4, halign: Gtk.Align.CENTER });
    
    // --- Waybar Islands|Bar Toggle Button ---
    const waybarStateFile = GLib.build_filenamev([hyprsunsetStateDir, 'waybar-islands.state']);
    function loadWaybarState() {
        try {
            let [ok, contents] = GLib.file_get_contents(waybarStateFile);
            if (ok && contents) {
                let state = imports.byteArray.toString(contents).trim();
                return state === 'islands';
            }
        } catch (e) {}
        return false; // Default to bar mode
    }
    function saveWaybarState(isIslands) {
        try {
            GLib.file_set_contents(waybarStateFile, isIslands ? 'islands' : 'bar');
        } catch (e) {}
    }
    function toggleWaybarMode(isIslands) {
        const waybarStyleFile = GLib.build_filenamev([GLib.get_home_dir(), '.config', 'waybar', 'style.css']);
        const waybarBorderSizeStateFile = GLib.build_filenamev([hyprsunsetStateDir, 'waybar_border_size.state']);
        
        // Get current border size from state file, default to 2 if not found
        let currentBorderSize = 2;
        try {
            let [ok, contents] = GLib.file_get_contents(waybarBorderSizeStateFile);
            if (ok && contents) {
                let sizeStr = imports.byteArray.toString(contents).trim();
                let size = parseInt(sizeStr);
                if (!isNaN(size)) {
                    currentBorderSize = size;
                }
            }
        } catch (e) {
            // Use default value if state file doesn't exist or can't be read
        }
        
        if (isIslands) {
            // Change to islands mode: no background, no border
            GLib.spawn_command_line_async(`sed -i '25s/background: @blur_background;/background: none;/' '${waybarStyleFile}'`);
            GLib.spawn_command_line_async(`sed -i '32s/border: ${currentBorderSize}px solid @inverse_primary;/border: 0px solid @inverse_primary;/' '${waybarStyleFile}'`);
        } else {
            // Change to bar mode: restore background and border
            GLib.spawn_command_line_async(`sed -i '25s/background: none;/background: @blur_background;/' '${waybarStyleFile}'`);
            GLib.spawn_command_line_async(`sed -i '32s/border: 0px solid @inverse_primary;/border: ${currentBorderSize}px solid @inverse_primary;/' '${waybarStyleFile}'`);
        }
        // Reload waybar
        //GLib.spawn_command_line_async('killall waybar');
        //GLib.spawn_command_line_async('bash -c "waybar &"');
    }
    
    let waybarIslandsEnabled = loadWaybarState();
    const waybarToggleBtn = new Gtk.Button({ label: waybarIslandsEnabled ? 'Waybar ' : 'Waybar ' });
    if (waybarIslandsEnabled) waybarToggleBtn.add_css_class('neon-highlight');
    waybarToggleBtn.connect('clicked', () => {
        waybarIslandsEnabled = !waybarIslandsEnabled;
        toggleWaybarMode(waybarIslandsEnabled);
        if (waybarIslandsEnabled) {
            waybarToggleBtn.set_label('Waybar ');
            waybarToggleBtn.add_css_class('neon-highlight');
        } else {
            waybarToggleBtn.set_label('Waybar ');
            waybarToggleBtn.remove_css_class('neon-highlight');
        }
        saveWaybarState(waybarIslandsEnabled);
    });
    presetBox.append(waybarToggleBtn);
    
    // --- Waybar Bottom|Top Toggle Button ---
    const waybarConfigFile = GLib.build_filenamev([hyprsunsetStateDir, 'waybar-position.txt']);
    function loadWaybarConfig() {
        try {
            let [ok, contents] = GLib.file_get_contents(waybarConfigFile);
            if (ok && contents) {
                let config = imports.byteArray.toString(contents).trim();
                return config === 'bottom';
            }
        } catch (e) {}
        return false; // Default to top position
    }
    function saveWaybarConfig(isBottom) {
        try {
            GLib.file_set_contents(waybarConfigFile, isBottom ? 'bottom' : 'top');
        } catch (e) {}
    }
    function toggleWaybarSetting(isBottom) {
        const waybarConfigFile = GLib.build_filenamev([GLib.get_home_dir(), '.config', 'waybar', 'config.jsonc']);
        const RofiFile1 = GLib.build_filenamev([GLib.get_home_dir(), '.config', 'rofi', 'bluetooth-menu.rasi']);
        const RofiFile2 = GLib.build_filenamev([GLib.get_home_dir(), '.config', 'rofi', 'power-menu.rasi']);
        const RofiFile3 = GLib.build_filenamev([GLib.get_home_dir(), '.config', 'rofi', 'wifi-menu.rasi']);
        
        if (isBottom) {
            // Change to bottom position:
            GLib.spawn_command_line_async(`sed -i '5s/"position": "top",/"position": "bottom",/' '${waybarConfigFile}'`);
            // Update rofi menu positions
            GLib.spawn_command_line_async(`sed -i '31s/location:                 northeast;/location:                 southeast;/' '${RofiFile1}'`);
            GLib.spawn_command_line_async(`sed -i '31s/location:                 northeast;/location:                 southeast;/' '${RofiFile2}'`);
            GLib.spawn_command_line_async(`sed -i '31s/location:                 northeast;/location:                 southeast;/' '${RofiFile3}'`);
        } else {
            // Change to top position:
            GLib.spawn_command_line_async(`sed -i '5s/"position": "bottom",/"position": "top",/' '${waybarConfigFile}'`);
            // Update rofi menu positions
            GLib.spawn_command_line_async(`sed -i '31s/location:                 southeast;/location:                 northeast;/' '${RofiFile1}'`);
            GLib.spawn_command_line_async(`sed -i '31s/location:                 southeast;/location:                 northeast;/' '${RofiFile2}'`);
            GLib.spawn_command_line_async(`sed -i '31s/location:                 southeast;/location:                 northeast;/' '${RofiFile3}'`);
        }
        // Reload waybar
        //GLib.spawn_command_line_async('killall waybar && sleep 1');
        GLib.spawn_command_line_async('systemctl --user restart waybar.service');
    }
    
    let waybarBottomEnabled = loadWaybarConfig();
    const waybarPositionBtn = new Gtk.Button({ label: waybarBottomEnabled ? 'Waybar ' : 'Waybar ' });
    if (waybarBottomEnabled) waybarPositionBtn.add_css_class('neon-highlight');
    waybarPositionBtn.connect('clicked', () => {
        waybarBottomEnabled = !waybarBottomEnabled;
        toggleWaybarSetting(waybarBottomEnabled);
        if (waybarBottomEnabled) {
            waybarPositionBtn.set_label('Waybar ');
            waybarPositionBtn.add_css_class('neon-highlight');
        } else {
            waybarPositionBtn.set_label('Waybar ');
            waybarPositionBtn.remove_css_class('neon-highlight');
        }
        saveWaybarConfig(waybarBottomEnabled);
    });
    presetBox.append(waybarPositionBtn);

    // Add new button to cycle dock position
    const changePositionBtn = new Gtk.Button({ label:'Change Dock Position'});
    changePositionBtn.connect('clicked', () => {
      GLib.spawn_command_line_async(`${GLib.get_home_dir()}/.config/hyprcandy/scripts/cycle-dock-position.sh`);
    });
    presetBox.append(changePositionBtn);
    
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

    // Weather box at the bottom of left box
    const weatherBox = Weather.createWeatherBoxForEmbed();
    // Add neon to temp label if possible
    try {
        // Find the temp label by class
        let children = weatherBox.get_children ? weatherBox.get_children() : weatherBox.get_children;
        if (children && children.length > 0) {
            for (let child of children) {
                if (child.get_css_classes && child.get_css_classes().indexOf('weather-temp') !== -1) {
                    child.add_css_class('weather-temp');
                }
            }
        }
    } catch (e) {}
    //leftBox.append(weatherBox);
    
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
        'Light',
        'Dark',
        'Content',
        'Expressive',
        'Neutral',
        'Rainbow',
        'Tonal-spot',
        'Fruit-salad',
        'Vibrant'
    ];
    
    function updateMatugenScheme(schemeName) {
        const waypaperIntegrationFile = GLib.build_filenamev([GLib.get_home_dir(), '.config', 'hyprcandy', 'hooks', 'waypaper_integration.sh']);
        const gtk3File = GLib.build_filenamev([GLib.get_home_dir(), '.config', 'gtk-3.0', 'gtk.css']);
        const gtk4File = GLib.build_filenamev([GLib.get_home_dir(), '.config', 'gtk-4.0', 'gtk.css']);
        const hyprFile = GLib.build_filenamev([GLib.get_home_dir(), '.config', 'hypr', 'hyprviz.conf']);
        const utilsFile = GLib.build_filenamev([GLib.get_home_dir(), '.hyprcandy', 'GJS', 'src', 'candy-utils.js']);
        const waybarFile = GLib.build_filenamev([GLib.get_home_dir(), '.config', 'waybar', 'style.css']);
        const dockFile = GLib.build_filenamev([GLib.get_home_dir(), '.config', 'nwg-dock-hyprland', 'style.css']);
        const swayncFile = GLib.build_filenamev([GLib.get_home_dir(), '.config', 'swaync', 'style.css']);
        
        // Convert scheme name to matugen format
        const schemeMap = {
            'Light': 'scheme-fidelity',
            'Dark': 'scheme-monochrome',
            'Content': 'scheme-content',
            'Expressive': 'scheme-expressive',
            'Fruit-salad': 'scheme-fruit-salad',
            'Neutral': 'scheme-neutral',
            'Rainbow': 'scheme-rainbow',
            'Tonal-spot': 'scheme-tonal-spot',
            'Vibrant': 'scheme-vibrant'
        };
        
        const matugenScheme = schemeMap[schemeName];
        if (!matugenScheme) return;
        
        // Update the waypaper_integration.sh file
        GLib.spawn_command_line_async(`sed -i 's/--type scheme-[^ ]*/--type ${matugenScheme}/' '${waypaperIntegrationFile}'`);
        
        // Handle monochrome vs other schemes for GTK CSS
        if (schemeName === 'Dark') {
            GLib.spawn_command_line_async(`sed -i 's/light/dark/g' '${waypaperIntegrationFile}'`);
            GLib.spawn_command_line_async(`sed -i 's/@on_secondary/@on_primary_fixed_variant/g' '${gtk3File}'`);
            GLib.spawn_command_line_async(`sed -i 's/@on_secondary/@on_primary_fixed_variant/g' '${gtk4File}'`);
            GLib.spawn_command_line_async(`sed -i 's/@primary_fixed_dim/@on_primary_fixed_variant/g' '${gtk3File}'`);
            GLib.spawn_command_line_async(`sed -i 's/@primary_fixed_dim/@on_primary_fixed_variant/g' '${gtk4File}'`);
            GLib.spawn_command_line_async(`sed -i 's/window_fg_color black/window_fg_color white/g' '${gtk4File}'`);
            GLib.spawn_command_line_async(`sed -i 's/view_fg_color black/view_fg_color white/g' '${gtk4File}'`);
            GLib.spawn_command_line_async(`sed -i 's/headerbar_fg_color black/headerbar_fg_color white/g' '${gtk4File}'`);
            GLib.spawn_command_line_async(`sed -i 's/sidebar_fg_color black/sidebar_fg_color white/g' '${gtk4File}'`);
            GLib.spawn_command_line_async(`sed -i 's/card_fg_color black/card_fg_color white/g' '${gtk4File}'`);
            GLib.spawn_command_line_async(`sed -i 's/dialog_fg_color black/dialog_fg_color white/g' '${gtk4File}'`);
            GLib.spawn_command_line_async(`sed -i 's/color: black;/color: white;/g' '${gtk4File}'`);
            GLib.spawn_command_line_async(`sed -i 's/fg_color black;/fg_color white;/g' '${gtk4File}'`);
            GLib.spawn_command_line_async(`sed -i 's/window_fg_color black/window_fg_color white/g' '${gtk3File}'`);
            GLib.spawn_command_line_async(`sed -i 's/view_fg_color black/view_fg_color white/g' '${gtk3File}'`);
            GLib.spawn_command_line_async(`sed -i 's/headerbar_fg_color black/headerbar_fg_color white/g' '${gtk3File}'`);
            GLib.spawn_command_line_async(`sed -i 's/sidebar_fg_color black/sidebar_fg_color white/g' '${gtk3File}'`);
            GLib.spawn_command_line_async(`sed -i 's/card_fg_color black/card_fg_color white/g' '${gtk3File}'`);
            GLib.spawn_command_line_async(`sed -i 's/dialog_fg_color black/dialog_fg_color white/g' '${gtk3File}'`);
            GLib.spawn_command_line_async(`sed -i 's/color: black;/color: white;/g' '${gtk3File}'`);
            GLib.spawn_command_line_async(`sed -i 's/fg_color black;/fg_color white;/g' '${gtk3File}'`);
            /*GLib.spawn_command_line_async(`sed -i 's/accent_color @primary/accent_color @on_primary/g' '${gtk4File}'`);
            GLib.spawn_command_line_async(`sed -i 's/accent_bg_color @primary/accent_bg_color @on_primary/g' '${gtk4File}'`);
            GLib.spawn_command_line_async(`sed -i 's/accent_fg_color @on_primary/accent_fg_color @primary/g' '${gtk4File}'`);
            GLib.spawn_command_line_async(`sed -i 's/accent_color @primary/accent_color @on_primary/g' '${gtk3File}'`);
            GLib.spawn_command_line_async(`sed -i 's/accent_bg_color @primary/accent_bg_color @on_primary/g' '${gtk3File}'`);
            GLib.spawn_command_line_async(`sed -i 's/accent_fg_color @on_primary/accent_fg_color @primary/g' '${gtk3File}'`);*/
            GLib.spawn_command_line_async(`sed -i 's/color: @inverse_primary;/color: @main-fg;/g' '${waybarFile}'`);
            GLib.spawn_command_line_async(`sed -i 's/color: @primary;/color: @primary_fixed_dim;/g' '${waybarFile}'`);
            //GLib.spawn_command_line_async(`sed -i '483s/solid @primary_fixed_dim;/solid @inverse_primary;/g; 487s/solid @primary_fixed_dim;/solid @inverse_primary;/g; 2382s/solid @primary_fixed_dim;/solid @inverse_primary;/g' '${utilsFile}'`);
            GLib.spawn_command_line_async(`sed -i 's/@inverse_primary, @primary_fixed_dim/@inverse_primary, @scrim/g' '${waybarFile}'`);
            GLib.spawn_command_line_async(`sed -i '8s/@primary_fixed_dim;/@inverse_primary;/g' '${dockFile}'`);
            GLib.spawn_command_line_async(`sed -i '7s/@primary_fixed_dim;/@inverse_primary;/g' '${swayncFile}'`);
            //GLib.spawn_command_line_async(`bash -c '$HOME/.config/hyprcandy/scripts/toggle-dock.sh --relaunch'`);
            GLib.spawn_command_line_async(`bash -c 'swaync-client -rs'`);
        }
        
        if (schemeName === 'Light') {
            GLib.spawn_command_line_async(`sed -i 's/dark/light/g' '${waypaperIntegrationFile}'`);
            /*GLib.spawn_command_line_async(`sed -i 's/@on_secondary/@primary/g' '${gtk3File}'`);
            GLib.spawn_command_line_async(`sed -i 's/@on_secondary/@primary/g' '${gtk4File}'`);
            GLib.spawn_command_line_async(`sed -i 's/@on_primary_fixed_variant/@primary_fixed_dim/g' '${gtk3File}'`);
            GLib.spawn_command_line_async(`sed -i 's/@on_primary_fixed_variant/@primary_fixed_dim/g' '${gtk4File}'`);*/
            GLib.spawn_command_line_async(`sed -i 's/window_fg_color white/window_fg_color black/g' '${gtk4File}'`);
            GLib.spawn_command_line_async(`sed -i 's/view_fg_color white/view_fg_color black/g' '${gtk4File}'`);
            GLib.spawn_command_line_async(`sed -i 's/headerbar_fg_color white/headerbar_fg_color black/g' '${gtk4File}'`);
            GLib.spawn_command_line_async(`sed -i 's/sidebar_fg_color white/sidebar_fg_color black/g' '${gtk4File}'`);
            GLib.spawn_command_line_async(`sed -i 's/card_fg_color white/card_fg_color black/g' '${gtk4File}'`);
            GLib.spawn_command_line_async(`sed -i 's/dialog_fg_color white/dialog_fg_color black/g' '${gtk4File}'`);
            GLib.spawn_command_line_async(`sed -i 's/color: white;/color: black;/g' '${gtk4File}'`);
            GLib.spawn_command_line_async(`sed -i 's/fg_color white;/fg_color black;/g' '${gtk4File}'`);
            GLib.spawn_command_line_async(`sed -i 's/window_fg_color white/window_fg_color black/g' '${gtk3File}'`);
            GLib.spawn_command_line_async(`sed -i 's/view_fg_color white/view_fg_color black/g' '${gtk3File}'`);
            GLib.spawn_command_line_async(`sed -i 's/headerbar_fg_color white/headerbar_fg_color black/g' '${gtk3File}'`);
            GLib.spawn_command_line_async(`sed -i 's/sidebar_fg_color white/sidebar_fg_color black/g' '${gtk3File}'`);
            GLib.spawn_command_line_async(`sed -i 's/card_fg_color white/card_fg_color black/g' '${gtk3File}'`);
            GLib.spawn_command_line_async(`sed -i 's/dialog_fg_color white/dialog_fg_color black/g' '${gtk3File}'`);
            GLib.spawn_command_line_async(`sed -i 's/color: white;/color: black;/g' '${gtk3File}'`);
            GLib.spawn_command_line_async(`sed -i 's/fg_color white;/fg_color black;/g' '${gtk3File}'`);
            /*GLib.spawn_command_line_async(`sed -i 's/accent_color @primary/accent_color @on_primary/g' '${gtk4File}'`);
            GLib.spawn_command_line_async(`sed -i 's/accent_bg_color @primary/accent_bg_color @on_primary/g' '${gtk4File}'`);
            GLib.spawn_command_line_async(`sed -i 's/accent_fg_color @on_primary/accent_fg_color @primary/g' '${gtk4File}'`);
            GLib.spawn_command_line_async(`sed -i 's/accent_color @primary/accent_color @on_primary/g' '${gtk3File}'`);
            GLib.spawn_command_line_async(`sed -i 's/accent_bg_color @primary/accent_bg_color @on_primary/g' '${gtk3File}'`);
            GLib.spawn_command_line_async(`sed -i 's/accent_fg_color @on_primary/accent_fg_color @primary/g' '${gtk3File}'`);*/
            GLib.spawn_command_line_async(`sed -i 's/color: @main-fg;/color: @inverse_primary;/g' '${waybarFile}'`);
            GLib.spawn_command_line_async(`sed -i 's/color: @primary_fixed_dim;/color: @primary;/g' '${waybarFile}'`);
            //GLib.spawn_command_line_async(`sed -i '483s/solid @inverse_primary;/solid @primary_fixed_dim;/g; 487s/solid @inverse_primary;/solid @primary_fixed_dim;/g; 2382s/solid @inverse_primary;/solid @primary_fixed_dim;/g' '${utilsFile}'`);
            GLib.spawn_command_line_async(`sed -i 's/@inverse_primary, @scrim/@inverse_primary, @primary_fixed_dim/g' '${waybarFile}'`);
            GLib.spawn_command_line_async(`sed -i '8s/@primary_fixed_dim;/@inverse_primary;/g' '${dockFile}'`);
            GLib.spawn_command_line_async(`sed -i '7s/@primary_fixed_dim;/@inverse_primary;/g' '${swayncFile}'`);
            //GLib.spawn_command_line_async(`bash -c '$HOME/.config/hyprcandy/scripts/toggle-dock.sh --relaunch'`);
            GLib.spawn_command_line_async(`bash -c 'swaync-client -rs'`);
        }
        
        if (schemeName === 'Content') {
            GLib.spawn_command_line_async(`sed -i 's/light/dark/g' '${waypaperIntegrationFile}'`);
            GLib.spawn_command_line_async(`sed -i 's/@on_primary_fixed_variant/@on_secondary/g' '${gtk3File}'`);
            GLib.spawn_command_line_async(`sed -i 's/@on_primary_fixed_variant/@on_secondary/g' '${gtk4File}'`);
            GLib.spawn_command_line_async(`sed -i 's/@primary_fixed_dim/@on_secondary/g' '${gtk3File}'`);
            GLib.spawn_command_line_async(`sed -i 's/@primary_fixed_dim/@on_secondary/g' '${gtk4File}'`);
            GLib.spawn_command_line_async(`sed -i 's/window_fg_color black/window_fg_color white/g' '${gtk4File}'`);
            GLib.spawn_command_line_async(`sed -i 's/view_fg_color black/view_fg_color white/g' '${gtk4File}'`);
            GLib.spawn_command_line_async(`sed -i 's/headerbar_fg_color black/headerbar_fg_color white/g' '${gtk4File}'`);
            GLib.spawn_command_line_async(`sed -i 's/sidebar_fg_color black/sidebar_fg_color white/g' '${gtk4File}'`);
            GLib.spawn_command_line_async(`sed -i 's/card_fg_color black/card_fg_color white/g' '${gtk4File}'`);
            GLib.spawn_command_line_async(`sed -i 's/dialog_fg_color black/dialog_fg_color white/g' '${gtk4File}'`);
            GLib.spawn_command_line_async(`sed -i 's/color: black;/color: white;/g' '${gtk4File}'`);
            GLib.spawn_command_line_async(`sed -i 's/fg_color black;/fg_color white;/g' '${gtk4File}'`);
            GLib.spawn_command_line_async(`sed -i 's/window_fg_color black/window_fg_color white/g' '${gtk3File}'`);
            GLib.spawn_command_line_async(`sed -i 's/view_fg_color black/view_fg_color white/g' '${gtk3File}'`);
            GLib.spawn_command_line_async(`sed -i 's/headerbar_fg_color black/headerbar_fg_color white/g' '${gtk3File}'`);
            GLib.spawn_command_line_async(`sed -i 's/sidebar_fg_color black/sidebar_fg_color white/g' '${gtk3File}'`);
            GLib.spawn_command_line_async(`sed -i 's/card_fg_color black/card_fg_color white/g' '${gtk3File}'`);
            GLib.spawn_command_line_async(`sed -i 's/dialog_fg_color black/dialog_fg_color white/g' '${gtk3File}'`);
            GLib.spawn_command_line_async(`sed -i 's/color: black;/color: white;/g' '${gtk3File}'`);
            GLib.spawn_command_line_async(`sed -i 's/fg_color black;/fg_color white;/g' '${gtk3File}'`);
            /*GLib.spawn_command_line_async(`sed -i 's/accent_color @primary/accent_color @on_primary/g' '${gtk4File}'`);
            GLib.spawn_command_line_async(`sed -i 's/accent_bg_color @primary/accent_bg_color @on_primary/g' '${gtk4File}'`);
            GLib.spawn_command_line_async(`sed -i 's/accent_fg_color @on_primary/accent_fg_color @primary/g' '${gtk4File}'`);
            GLib.spawn_command_line_async(`sed -i 's/accent_color @primary/accent_color @on_primary/g' '${gtk3File}'`);
            GLib.spawn_command_line_async(`sed -i 's/accent_bg_color @primary/accent_bg_color @on_primary/g' '${gtk3File}'`);
            GLib.spawn_command_line_async(`sed -i 's/accent_fg_color @on_primary/accent_fg_color @primary/g' '${gtk3File}'`);*/
            GLib.spawn_command_line_async(`sed -i 's/color: @inverse_primary;/color: @main-fg;/g' '${waybarFile}'`);
            GLib.spawn_command_line_async(`sed -i 's/color: @primary;/color: @primary_fixed_dim;/g' '${waybarFile}'`);
            //GLib.spawn_command_line_async(`sed -i '483s/solid @primary_fixed_dim;/solid @inverse_primary;/g; 487s/solid @primary_fixed_dim;/solid @inverse_primary;/g; 2382s/solid @primary_fixed_dim;/solid @inverse_primary;/g' '${utilsFile}'`);
            GLib.spawn_command_line_async(`sed -i 's/@inverse_primary, @primary_fixed_dim/@inverse_primary, @scrim/g' '${waybarFile}'`);
            GLib.spawn_command_line_async(`sed -i '8s/@primary_fixed_dim;/@inverse_primary;/g' '${dockFile}'`);
            GLib.spawn_command_line_async(`sed -i '7s/@primary_fixed_dim;/@inverse_primary;/g' '${swayncFile}'`);
            //GLib.spawn_command_line_async(`bash -c '$HOME/.config/hyprcandy/scripts/toggle-dock.sh --relaunch'`);
            GLib.spawn_command_line_async(`bash -c 'swaync-client -rs'`);
        }
        
        if (schemeName === 'Expressive') {
            GLib.spawn_command_line_async(`sed -i 's/light/dark/g' '${waypaperIntegrationFile}'`);
            GLib.spawn_command_line_async(`sed -i 's/@on_primary_fixed_variant/@on_secondary/g' '${gtk3File}'`);
            GLib.spawn_command_line_async(`sed -i 's/@on_primary_fixed_variant/@on_secondary/g' '${gtk4File}'`);
            GLib.spawn_command_line_async(`sed -i 's/@primary_fixed_dim/@on_secondary/g' '${gtk3File}'`);
            GLib.spawn_command_line_async(`sed -i 's/@primary_fixed_dim/@on_secondary/g' '${gtk4File}'`);
            GLib.spawn_command_line_async(`sed -i 's/window_fg_color black/window_fg_color white/g' '${gtk4File}'`);
            GLib.spawn_command_line_async(`sed -i 's/view_fg_color black/view_fg_color white/g' '${gtk4File}'`);
            GLib.spawn_command_line_async(`sed -i 's/headerbar_fg_color black/headerbar_fg_color white/g' '${gtk4File}'`);
            GLib.spawn_command_line_async(`sed -i 's/sidebar_fg_color black/sidebar_fg_color white/g' '${gtk4File}'`);
            GLib.spawn_command_line_async(`sed -i 's/card_fg_color black/card_fg_color white/g' '${gtk4File}'`);
            GLib.spawn_command_line_async(`sed -i 's/dialog_fg_color black/dialog_fg_color white/g' '${gtk4File}'`);
            GLib.spawn_command_line_async(`sed -i 's/color: black;/color: white;/g' '${gtk4File}'`);
            GLib.spawn_command_line_async(`sed -i 's/fg_color black;/fg_color white;/g' '${gtk4File}'`);
            GLib.spawn_command_line_async(`sed -i 's/window_fg_color black/window_fg_color white/g' '${gtk3File}'`);
            GLib.spawn_command_line_async(`sed -i 's/view_fg_color black/view_fg_color white/g' '${gtk3File}'`);
            GLib.spawn_command_line_async(`sed -i 's/headerbar_fg_color black/headerbar_fg_color white/g' '${gtk3File}'`);
            GLib.spawn_command_line_async(`sed -i 's/sidebar_fg_color black/sidebar_fg_color white/g' '${gtk3File}'`);
            GLib.spawn_command_line_async(`sed -i 's/card_fg_color black/card_fg_color white/g' '${gtk3File}'`);
            GLib.spawn_command_line_async(`sed -i 's/dialog_fg_color black/dialog_fg_color white/g' '${gtk3File}'`);
            GLib.spawn_command_line_async(`sed -i 's/color: black;/color: white;/g' '${gtk3File}'`);
            GLib.spawn_command_line_async(`sed -i 's/fg_color black;/fg_color white;/g' '${gtk3File}'`);
            /*GLib.spawn_command_line_async(`sed -i 's/accent_color @primary/accent_color @on_primary/g' '${gtk4File}'`);
            GLib.spawn_command_line_async(`sed -i 's/accent_bg_color @primary/accent_bg_color @on_primary/g' '${gtk4File}'`);
            GLib.spawn_command_line_async(`sed -i 's/accent_fg_color @on_primary/accent_fg_color @primary/g' '${gtk4File}'`);
            GLib.spawn_command_line_async(`sed -i 's/accent_color @primary/accent_color @on_primary/g' '${gtk3File}'`);
            GLib.spawn_command_line_async(`sed -i 's/accent_bg_color @primary/accent_bg_color @on_primary/g' '${gtk3File}'`);
            GLib.spawn_command_line_async(`sed -i 's/accent_fg_color @on_primary/accent_fg_color @primary/g' '${gtk3File}'`);*/
            GLib.spawn_command_line_async(`sed -i 's/color: @inverse_primary;/color: @main-fg;/g' '${waybarFile}'`);
            GLib.spawn_command_line_async(`sed -i 's/color: @primary;/color: @primary_fixed_dim;/g' '${waybarFile}'`);
            //GLib.spawn_command_line_async(`sed -i '483s/solid @primary_fixed_dim;/solid @inverse_primary;/g; 487s/solid @primary_fixed_dim;/solid @inverse_primary;/g; 2382s/solid @primary_fixed_dim;/solid @inverse_primary;/g' '${utilsFile}'`);
            GLib.spawn_command_line_async(`sed -i 's/@inverse_primary, @primary_fixed_dim/@inverse_primary, @scrim/g' '${waybarFile}'`);
            GLib.spawn_command_line_async(`sed -i '8s/@primary_fixed_dim;/@inverse_primary;/g' '${dockFile}'`);
            GLib.spawn_command_line_async(`sed -i '7s/@primary_fixed_dim;/@inverse_primary;/g' '${swayncFile}'`);
            //GLib.spawn_command_line_async(`bash -c '$HOME/.config/hyprcandy/scripts/toggle-dock.sh --relaunch'`);
            GLib.spawn_command_line_async(`bash -c 'swaync-client -rs'`);
        }
        
        if (schemeName === 'Fruit-salad') {
            GLib.spawn_command_line_async(`sed -i 's/light/dark/g' '${waypaperIntegrationFile}'`);
            GLib.spawn_command_line_async(`sed -i 's/@on_primary_fixed_variant/@on_secondary/g' '${gtk3File}'`);
            GLib.spawn_command_line_async(`sed -i 's/@on_primary_fixed_variant/@on_secondary/g' '${gtk4File}'`);
            GLib.spawn_command_line_async(`sed -i 's/@primary_fixed_dim/@on_secondary/g' '${gtk3File}'`);
            GLib.spawn_command_line_async(`sed -i 's/@primary_fixed_dim/@on_secondary/g' '${gtk4File}'`);
            GLib.spawn_command_line_async(`sed -i 's/window_fg_color black/window_fg_color white/g' '${gtk4File}'`);
            GLib.spawn_command_line_async(`sed -i 's/view_fg_color black/view_fg_color white/g' '${gtk4File}'`);
            GLib.spawn_command_line_async(`sed -i 's/headerbar_fg_color black/headerbar_fg_color white/g' '${gtk4File}'`);
            GLib.spawn_command_line_async(`sed -i 's/sidebar_fg_color black/sidebar_fg_color white/g' '${gtk4File}'`);
            GLib.spawn_command_line_async(`sed -i 's/card_fg_color black/card_fg_color white/g' '${gtk4File}'`);
            GLib.spawn_command_line_async(`sed -i 's/dialog_fg_color black/dialog_fg_color white/g' '${gtk4File}'`);
            GLib.spawn_command_line_async(`sed -i 's/color: black;/color: white;/g' '${gtk4File}'`);
            GLib.spawn_command_line_async(`sed -i 's/fg_color black;/fg_color white;/g' '${gtk4File}'`);
            GLib.spawn_command_line_async(`sed -i 's/window_fg_color black/window_fg_color white/g' '${gtk3File}'`);
            GLib.spawn_command_line_async(`sed -i 's/view_fg_color black/view_fg_color white/g' '${gtk3File}'`);
            GLib.spawn_command_line_async(`sed -i 's/headerbar_fg_color black/headerbar_fg_color white/g' '${gtk3File}'`);
            GLib.spawn_command_line_async(`sed -i 's/sidebar_fg_color black/sidebar_fg_color white/g' '${gtk3File}'`);
            GLib.spawn_command_line_async(`sed -i 's/card_fg_color black/card_fg_color white/g' '${gtk3File}'`);
            GLib.spawn_command_line_async(`sed -i 's/dialog_fg_color black/dialog_fg_color white/g' '${gtk3File}'`);
            GLib.spawn_command_line_async(`sed -i 's/color: black;/color: white;/g' '${gtk3File}'`);
            GLib.spawn_command_line_async(`sed -i 's/fg_color black;/fg_color white;/g' '${gtk3File}'`);
            /*GLib.spawn_command_line_async(`sed -i 's/accent_color @primary/accent_color @on_primary/g' '${gtk4File}'`);
            GLib.spawn_command_line_async(`sed -i 's/accent_bg_color @primary/accent_bg_color @on_primary/g' '${gtk4File}'`);
            GLib.spawn_command_line_async(`sed -i 's/accent_fg_color @on_primary/accent_fg_color @primary/g' '${gtk4File}'`);
            GLib.spawn_command_line_async(`sed -i 's/accent_color @primary/accent_color @on_primary/g' '${gtk3File}'`);
            GLib.spawn_command_line_async(`sed -i 's/accent_bg_color @primary/accent_bg_color @on_primary/g' '${gtk3File}'`);
            GLib.spawn_command_line_async(`sed -i 's/accent_fg_color @on_primary/accent_fg_color @primary/g' '${gtk3File}'`);*/
            GLib.spawn_command_line_async(`sed -i 's/color: @inverse_primary;/color: @main-fg;/g' '${waybarFile}'`);
            GLib.spawn_command_line_async(`sed -i 's/color: @primary;/color: @primary_fixed_dim;/g' '${waybarFile}'`);
            //GLib.spawn_command_line_async(`sed -i '483s/solid @primary_fixed_dim;/solid @inverse_primary;/g; 487s/solid @primary_fixed_dim;/solid @inverse_primary;/g; 2382s/solid @primary_fixed_dim;/solid @inverse_primary;/g' '${utilsFile}'`);
            GLib.spawn_command_line_async(`sed -i 's/@inverse_primary, @primary_fixed_dim/@inverse_primary, @scrim/g' '${waybarFile}'`);
            GLib.spawn_command_line_async(`sed -i '8s/@primary_fixed_dim;/@inverse_primary;/g' '${dockFile}'`);
            GLib.spawn_command_line_async(`sed -i '7s/@primary_fixed_dim;/@inverse_primary;/g' '${swayncFile}'`);
            //GLib.spawn_command_line_async(`bash -c '$HOME/.config/hyprcandy/scripts/toggle-dock.sh --relaunch'`);
            GLib.spawn_command_line_async(`bash -c 'swaync-client -rs'`);
        }
        
        if (schemeName === 'Neutral') {
            GLib.spawn_command_line_async(`sed -i 's/light/dark/g' '${waypaperIntegrationFile}'`);
            GLib.spawn_command_line_async(`sed -i 's/@on_primary_fixed_variant/@on_secondary/g' '${gtk3File}'`);
            GLib.spawn_command_line_async(`sed -i 's/@on_primary_fixed_variant/@on_secondary/g' '${gtk4File}'`);
            GLib.spawn_command_line_async(`sed -i 's/@primary_fixed_dim/@on_secondary/g' '${gtk3File}'`);
            GLib.spawn_command_line_async(`sed -i 's/@primary_fixed_dim/@on_secondary/g' '${gtk4File}'`);
            GLib.spawn_command_line_async(`sed -i 's/window_fg_color black/window_fg_color white/g' '${gtk4File}'`);
            GLib.spawn_command_line_async(`sed -i 's/view_fg_color black/view_fg_color white/g' '${gtk4File}'`);
            GLib.spawn_command_line_async(`sed -i 's/headerbar_fg_color black/headerbar_fg_color white/g' '${gtk4File}'`);
            GLib.spawn_command_line_async(`sed -i 's/sidebar_fg_color black/sidebar_fg_color white/g' '${gtk4File}'`);
            GLib.spawn_command_line_async(`sed -i 's/card_fg_color black/card_fg_color white/g' '${gtk4File}'`);
            GLib.spawn_command_line_async(`sed -i 's/dialog_fg_color black/dialog_fg_color white/g' '${gtk4File}'`);
            GLib.spawn_command_line_async(`sed -i 's/color: black;/color: white;/g' '${gtk4File}'`);
            GLib.spawn_command_line_async(`sed -i 's/fg_color black;/fg_color white;/g' '${gtk4File}'`);
            GLib.spawn_command_line_async(`sed -i 's/window_fg_color black/window_fg_color white/g' '${gtk3File}'`);
            GLib.spawn_command_line_async(`sed -i 's/view_fg_color black/view_fg_color white/g' '${gtk3File}'`);
            GLib.spawn_command_line_async(`sed -i 's/headerbar_fg_color black/headerbar_fg_color white/g' '${gtk3File}'`);
            GLib.spawn_command_line_async(`sed -i 's/sidebar_fg_color black/sidebar_fg_color white/g' '${gtk3File}'`);
            GLib.spawn_command_line_async(`sed -i 's/card_fg_color black/card_fg_color white/g' '${gtk3File}'`);
            GLib.spawn_command_line_async(`sed -i 's/dialog_fg_color black/dialog_fg_color white/g' '${gtk3File}'`);
            GLib.spawn_command_line_async(`sed -i 's/color: black;/color: white;/g' '${gtk3File}'`);
            GLib.spawn_command_line_async(`sed -i 's/fg_color black;/fg_color white;/g' '${gtk3File}'`);
            /*GLib.spawn_command_line_async(`sed -i 's/accent_color @primary/accent_color @on_primary/g' '${gtk4File}'`);
            GLib.spawn_command_line_async(`sed -i 's/accent_bg_color @primary/accent_bg_color @on_primary/g' '${gtk4File}'`);
            GLib.spawn_command_line_async(`sed -i 's/accent_fg_color @on_primary/accent_fg_color @primary/g' '${gtk4File}'`);
            GLib.spawn_command_line_async(`sed -i 's/accent_color @primary/accent_color @on_primary/g' '${gtk3File}'`);
            GLib.spawn_command_line_async(`sed -i 's/accent_bg_color @primary/accent_bg_color @on_primary/g' '${gtk3File}'`);
            GLib.spawn_command_line_async(`sed -i 's/accent_fg_color @on_primary/accent_fg_color @primary/g' '${gtk3File}'`);*/
            GLib.spawn_command_line_async(`sed -i 's/color: @inverse_primary;/color: @main-fg;/g' '${waybarFile}'`);
            GLib.spawn_command_line_async(`sed -i 's/color: @primary;/color: @primary_fixed_dim;/g' '${waybarFile}'`);
            //GLib.spawn_command_line_async(`sed -i '483s/solid @primary_fixed_dim;/solid @inverse_primary;/g; 487s/solid @primary_fixed_dim;/solid @inverse_primary;/g; 2382s/solid @primary_fixed_dim;/solid @inverse_primary;/g' '${utilsFile}'`);
            GLib.spawn_command_line_async(`sed -i 's/@inverse_primary, @primary_fixed_dim/@inverse_primary, @scrim/g' '${waybarFile}'`);
            GLib.spawn_command_line_async(`sed -i '8s/@primary_fixed_dim;/@inverse_primary;/g' '${dockFile}'`);
            GLib.spawn_command_line_async(`sed -i '7s/@primary_fixed_dim;/@inverse_primary;/g' '${swayncFile}'`);
            //GLib.spawn_command_line_async(`bash -c '$HOME/.config/hyprcandy/scripts/toggle-dock.sh --relaunch'`);
            GLib.spawn_command_line_async(`bash -c 'swaync-client -rs'`);
        }
        
        if (schemeName === 'Rainbow') {
            GLib.spawn_command_line_async(`sed -i 's/light/dark/g' '${waypaperIntegrationFile}'`);
            GLib.spawn_command_line_async(`sed -i 's/@on_primary_fixed_variant/@on_secondary/g' '${gtk3File}'`);
            GLib.spawn_command_line_async(`sed -i 's/@on_primary_fixed_variant/@on_secondary/g' '${gtk4File}'`);
            GLib.spawn_command_line_async(`sed -i 's/@primary_fixed_dim/@on_secondary/g' '${gtk3File}'`);
            GLib.spawn_command_line_async(`sed -i 's/@primary_fixed_dim/@on_secondary/g' '${gtk4File}'`);
            GLib.spawn_command_line_async(`sed -i 's/window_fg_color black/window_fg_color white/g' '${gtk4File}'`);
            GLib.spawn_command_line_async(`sed -i 's/view_fg_color black/view_fg_color white/g' '${gtk4File}'`);
            GLib.spawn_command_line_async(`sed -i 's/headerbar_fg_color black/headerbar_fg_color white/g' '${gtk4File}'`);
            GLib.spawn_command_line_async(`sed -i 's/sidebar_fg_color black/sidebar_fg_color white/g' '${gtk4File}'`);
            GLib.spawn_command_line_async(`sed -i 's/card_fg_color black/card_fg_color white/g' '${gtk4File}'`);
            GLib.spawn_command_line_async(`sed -i 's/dialog_fg_color black/dialog_fg_color white/g' '${gtk4File}'`);
            GLib.spawn_command_line_async(`sed -i 's/color: black;/color: white;/g' '${gtk4File}'`);
            GLib.spawn_command_line_async(`sed -i 's/fg_color black;/fg_color white;/g' '${gtk4File}'`);
            GLib.spawn_command_line_async(`sed -i 's/window_fg_color black/window_fg_color white/g' '${gtk3File}'`);
            GLib.spawn_command_line_async(`sed -i 's/view_fg_color black/view_fg_color white/g' '${gtk3File}'`);
            GLib.spawn_command_line_async(`sed -i 's/headerbar_fg_color black/headerbar_fg_color white/g' '${gtk3File}'`);
            GLib.spawn_command_line_async(`sed -i 's/sidebar_fg_color black/sidebar_fg_color white/g' '${gtk3File}'`);
            GLib.spawn_command_line_async(`sed -i 's/card_fg_color black/card_fg_color white/g' '${gtk3File}'`);
            GLib.spawn_command_line_async(`sed -i 's/dialog_fg_color black/dialog_fg_color white/g' '${gtk3File}'`);
            GLib.spawn_command_line_async(`sed -i 's/color: black;/color: white;/g' '${gtk3File}'`);
            GLib.spawn_command_line_async(`sed -i 's/fg_color black;/fg_color white;/g' '${gtk3File}'`);
            /*GLib.spawn_command_line_async(`sed -i 's/accent_color @primary/accent_color @on_primary/g' '${gtk4File}'`);
            GLib.spawn_command_line_async(`sed -i 's/accent_bg_color @primary/accent_bg_color @on_primary/g' '${gtk4File}'`);
            GLib.spawn_command_line_async(`sed -i 's/accent_fg_color @on_primary/accent_fg_color @primary/g' '${gtk4File}'`);
            GLib.spawn_command_line_async(`sed -i 's/accent_color @primary/accent_color @on_primary/g' '${gtk3File}'`);
            GLib.spawn_command_line_async(`sed -i 's/accent_bg_color @primary/accent_bg_color @on_primary/g' '${gtk3File}'`);
            GLib.spawn_command_line_async(`sed -i 's/accent_fg_color @on_primary/accent_fg_color @primary/g' '${gtk3File}'`);*/
            GLib.spawn_command_line_async(`sed -i 's/color: @inverse_primary;/color: @main-fg;/g' '${waybarFile}'`);
            GLib.spawn_command_line_async(`sed -i 's/color: @primary;/color: @primary_fixed_dim;/g' '${waybarFile}'`);
            //GLib.spawn_command_line_async(`sed -i '483s/solid @primary_fixed_dim;/solid @inverse_primary;/g; 487s/solid @primary_fixed_dim;/solid @inverse_primary;/g; 2382s/solid @primary_fixed_dim;/solid @inverse_primary;/g' '${utilsFile}'`);
            GLib.spawn_command_line_async(`sed -i 's/@inverse_primary, @primary_fixed_dim/@inverse_primary, @scrim/g' '${waybarFile}'`);
            GLib.spawn_command_line_async(`sed -i '8s/@primary_fixed_dim;/@inverse_primary;/g' '${dockFile}'`);
            GLib.spawn_command_line_async(`sed -i '7s/@primary_fixed_dim;/@inverse_primary;/g' '${swayncFile}'`);
            //GLib.spawn_command_line_async(`bash -c '$HOME/.config/hyprcandy/scripts/toggle-dock.sh --relaunch'`);
            GLib.spawn_command_line_async(`bash -c 'swaync-client -rs'`);
        }
        
        if (schemeName === 'Tonal-spot') {
            GLib.spawn_command_line_async(`sed -i 's/light/dark/g' '${waypaperIntegrationFile}'`);
            GLib.spawn_command_line_async(`sed -i 's/@on_primary_fixed_variant/@on_secondary/g' '${gtk3File}'`);
            GLib.spawn_command_line_async(`sed -i 's/@on_primary_fixed_variant/@on_secondary/g' '${gtk4File}'`);
            GLib.spawn_command_line_async(`sed -i 's/@primary_fixed_dim/@on_secondary/g' '${gtk3File}'`);
            GLib.spawn_command_line_async(`sed -i 's/@primary_fixed_dim/@on_secondary/g' '${gtk4File}'`);
            GLib.spawn_command_line_async(`sed -i 's/window_fg_color black/window_fg_color white/g' '${gtk4File}'`);
            GLib.spawn_command_line_async(`sed -i 's/view_fg_color black/view_fg_color white/g' '${gtk4File}'`);
            GLib.spawn_command_line_async(`sed -i 's/headerbar_fg_color black/headerbar_fg_color white/g' '${gtk4File}'`);
            GLib.spawn_command_line_async(`sed -i 's/sidebar_fg_color black/sidebar_fg_color white/g' '${gtk4File}'`);
            GLib.spawn_command_line_async(`sed -i 's/card_fg_color black/card_fg_color white/g' '${gtk4File}'`);
            GLib.spawn_command_line_async(`sed -i 's/dialog_fg_color black/dialog_fg_color white/g' '${gtk4File}'`);
            GLib.spawn_command_line_async(`sed -i 's/color: black;/color: white;/g' '${gtk4File}'`);
            GLib.spawn_command_line_async(`sed -i 's/fg_color black;/fg_color white;/g' '${gtk4File}'`);
            GLib.spawn_command_line_async(`sed -i 's/window_fg_color black/window_fg_color white/g' '${gtk3File}'`);
            GLib.spawn_command_line_async(`sed -i 's/view_fg_color black/view_fg_color white/g' '${gtk3File}'`);
            GLib.spawn_command_line_async(`sed -i 's/headerbar_fg_color black/headerbar_fg_color white/g' '${gtk3File}'`);
            GLib.spawn_command_line_async(`sed -i 's/sidebar_fg_color black/sidebar_fg_color white/g' '${gtk3File}'`);
            GLib.spawn_command_line_async(`sed -i 's/card_fg_color black/card_fg_color white/g' '${gtk3File}'`);
            GLib.spawn_command_line_async(`sed -i 's/dialog_fg_color black/dialog_fg_color white/g' '${gtk3File}'`);
            GLib.spawn_command_line_async(`sed -i 's/color: black;/color: white;/g' '${gtk3File}'`);
            GLib.spawn_command_line_async(`sed -i 's/fg_color black;/fg_color white;/g' '${gtk3File}'`);
            /*GLib.spawn_command_line_async(`sed -i 's/accent_color @primary/accent_color @on_primary/g' '${gtk4File}'`);
            GLib.spawn_command_line_async(`sed -i 's/accent_bg_color @primary/accent_bg_color @on_primary/g' '${gtk4File}'`);
            GLib.spawn_command_line_async(`sed -i 's/accent_fg_color @on_primary/accent_fg_color @primary/g' '${gtk4File}'`);
            GLib.spawn_command_line_async(`sed -i 's/accent_color @primary/accent_color @on_primary/g' '${gtk3File}'`);
            GLib.spawn_command_line_async(`sed -i 's/accent_bg_color @primary/accent_bg_color @on_primary/g' '${gtk3File}'`);
            GLib.spawn_command_line_async(`sed -i 's/accent_fg_color @on_primary/accent_fg_color @primary/g' '${gtk3File}'`);*/
            GLib.spawn_command_line_async(`sed -i 's/color: @inverse_primary;/color: @main-fg;/g' '${waybarFile}'`);
            GLib.spawn_command_line_async(`sed -i 's/color: @primary;/color: @primary_fixed_dim;/g' '${waybarFile}'`);
            //GLib.spawn_command_line_async(`sed -i '483s/solid @primary_fixed_dim;/solid @inverse_primary;/g; 487s/solid @primary_fixed_dim;/solid @inverse_primary;/g; 2382s/solid @primary_fixed_dim;/solid @inverse_primary;/g' '${utilsFile}'`);
            GLib.spawn_command_line_async(`sed -i 's/@inverse_primary, @primary_fixed_dim/@inverse_primary, @scrim/g' '${waybarFile}'`);
            GLib.spawn_command_line_async(`sed -i '8s/@primary_fixed_dim;/@inverse_primary;/g' '${dockFile}'`);
            GLib.spawn_command_line_async(`sed -i '7s/@primary_fixed_dim;/@inverse_primary;/g' '${swayncFile}'`);
            //GLib.spawn_command_line_async(`bash -c '$HOME/.config/hyprcandy/scripts/toggle-dock.sh --relaunch'`);
            GLib.spawn_command_line_async(`bash -c 'swaync-client -rs'`); 
        }
        
        if (schemeName === 'Vibrant') {
            GLib.spawn_command_line_async(`sed -i 's/light/dark/g' '${waypaperIntegrationFile}'`);
            GLib.spawn_command_line_async(`sed -i 's/@on_primary_fixed_variant/@on_secondary/g' '${gtk3File}'`);
            GLib.spawn_command_line_async(`sed -i 's/@on_primary_fixed_variant/@on_secondary/g' '${gtk4File}'`);
            GLib.spawn_command_line_async(`sed -i 's/@primary_fixed_dim/@on_secondary/g' '${gtk3File}'`);
            GLib.spawn_command_line_async(`sed -i 's/@primary_fixed_dim/@on_secondary/g' '${gtk4File}'`);
            GLib.spawn_command_line_async(`sed -i 's/window_fg_color black/window_fg_color white/g' '${gtk4File}'`);
            GLib.spawn_command_line_async(`sed -i 's/view_fg_color black/view_fg_color white/g' '${gtk4File}'`);
            GLib.spawn_command_line_async(`sed -i 's/headerbar_fg_color black/headerbar_fg_color white/g' '${gtk4File}'`);
            GLib.spawn_command_line_async(`sed -i 's/sidebar_fg_color black/sidebar_fg_color white/g' '${gtk4File}'`);
            GLib.spawn_command_line_async(`sed -i 's/card_fg_color black/card_fg_color white/g' '${gtk4File}'`);
            GLib.spawn_command_line_async(`sed -i 's/dialog_fg_color black/dialog_fg_color white/g' '${gtk4File}'`);
            GLib.spawn_command_line_async(`sed -i 's/color: black;/color: white;/g' '${gtk4File}'`);
            GLib.spawn_command_line_async(`sed -i 's/fg_color black;/fg_color white;/g' '${gtk4File}'`);
            GLib.spawn_command_line_async(`sed -i 's/window_fg_color black/window_fg_color white/g' '${gtk3File}'`);
            GLib.spawn_command_line_async(`sed -i 's/view_fg_color black/view_fg_color white/g' '${gtk3File}'`);
            GLib.spawn_command_line_async(`sed -i 's/headerbar_fg_color black/headerbar_fg_color white/g' '${gtk3File}'`);
            GLib.spawn_command_line_async(`sed -i 's/sidebar_fg_color black/sidebar_fg_color white/g' '${gtk3File}'`);
            GLib.spawn_command_line_async(`sed -i 's/card_fg_color black/card_fg_color white/g' '${gtk3File}'`);
            GLib.spawn_command_line_async(`sed -i 's/dialog_fg_color black/dialog_fg_color white/g' '${gtk3File}'`);
            GLib.spawn_command_line_async(`sed -i 's/color: black;/color: white;/g' '${gtk3File}'`);
            GLib.spawn_command_line_async(`sed -i 's/fg_color black;/fg_color white;/g' '${gtk3File}'`);
            /*GLib.spawn_command_line_async(`sed -i 's/accent_color @primary/accent_color @on_primary/g' '${gtk4File}'`);
            GLib.spawn_command_line_async(`sed -i 's/accent_bg_color @primary/accent_bg_color @on_primary/g' '${gtk4File}'`);
            GLib.spawn_command_line_async(`sed -i 's/accent_fg_color @on_primary/accent_fg_color @primary/g' '${gtk4File}'`);
            GLib.spawn_command_line_async(`sed -i 's/accent_color @primary/accent_color @on_primary/g' '${gtk3File}'`);
            GLib.spawn_command_line_async(`sed -i 's/accent_bg_color @primary/accent_bg_color @on_primary/g' '${gtk3File}'`);
            GLib.spawn_command_line_async(`sed -i 's/accent_fg_color @on_primary/accent_fg_color @primary/g' '${gtk3File}'`);*/
            GLib.spawn_command_line_async(`sed -i 's/color: @inverse_primary;/color: @main-fg;/g' '${waybarFile}'`);
            GLib.spawn_command_line_async(`sed -i 's/color: @primary;/color: @primary_fixed_dim;/g' '${waybarFile}'`);
            //GLib.spawn_command_line_async(`sed -i '483s/solid @primary_fixed_dim;/solid @inverse_primary;/g; 487s/solid @primary_fixed_dim;/solid @inverse_primary;/g; 2382s/solid @primary_fixed_dim;/solid @inverse_primary;/g' '${utilsFile}'`);
            GLib.spawn_command_line_async(`sed -i 's/@inverse_primary, @primary_fixed_dim/@inverse_primary, @scrim/g' '${waybarFile}'`);
            GLib.spawn_command_line_async(`sed -i '8s/@primary_fixed_dim;/@inverse_primary;/g' '${dockFile}'`);
            GLib.spawn_command_line_async(`sed -i '7s/@primary_fixed_dim;/@inverse_primary;/g' '${swayncFile}'`);
            //GLib.spawn_command_line_async(`bash -c '$HOME/.config/hyprcandy/scripts/toggle-dock.sh --relaunch'`);
            GLib.spawn_command_line_async(`bash -c 'swaync-client -rs'`);
        }
        GLib.spawn_command_line_async(`bash -c '$HOME/.config/hyprcandy/hooks/waypaper_integration.sh'`);
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
                'Light': 'scheme-fidelity',
                'Dark': 'scheme-monochrome',
                'Content': 'scheme-content',
                'Expressive': 'scheme-expressive',
                'Fruit-salad': 'scheme-fruit-salad',
                'Neutral': 'scheme-neutral',
                'Rainbow': 'scheme-rainbow',
                'Tonal-spot': 'scheme-tonal-spot',
                'Vibrant': 'scheme-vibrant'
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
    
    mainRow.append(themeBox);
    
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
        spacing: 4,
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
            const configFile = GLib.build_filenamev([GLib.get_home_dir(), '.config', 'hypr', 'hyprviz.conf']);
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
            const configFile = GLib.build_filenamev([GLib.get_home_dir(), '.config', 'hypr', 'hyprviz.conf']);
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
            const configFile = GLib.build_filenamev([GLib.get_home_dir(), '.config', 'hypr', 'hyprviz.conf']);
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
    
    // --- Dock Icon Size Control (Translated from Hook Scripts) ---
    function addDockIconSizeRow(label) {
        const row = new Gtk.Box({ orientation: Gtk.Orientation.HORIZONTAL, spacing: 8, halign: Gtk.Align.CENTER, valign: Gtk.Align.CENTER });
        const lbl = new Gtk.Label({ label, halign: Gtk.Align.END, xalign: 1 });
        lbl.set_size_request(110, -1);
        
        const entry = new Gtk.Entry({ 
            placeholder_text: '16-64',
            width_chars: 8,
            halign: Gtk.Align.CENTER
        });
        
        const launchScript = GLib.build_filenamev([GLib.get_home_dir(), '.config', 'nwg-dock-hyprland', 'launch.sh']);
        const leftScript = GLib.build_filenamev([GLib.get_home_dir(), '.config', 'hyprcandy', 'scripts', 'left-dock.sh']);
        const rightScript = GLib.build_filenamev([GLib.get_home_dir(), '.config', 'hyprcandy', 'scripts', 'right-dock.sh']);
        const topScript = GLib.build_filenamev([GLib.get_home_dir(), '.config', 'hyprcandy', 'scripts', 'top-dock.sh']);
        const toggleScript = GLib.build_filenamev([GLib.get_home_dir(), '.config', 'hyprcandy', 'scripts', 'toggle-dock.sh']);
        const settingsFile = GLib.build_filenamev([GLib.get_home_dir(), '.config', 'hyprcandy', 'nwg_dock_settings.conf']);
        
        // Create settings file if it doesn't exist (from hook script logic)
        function ensureSettingsFile() {
            if (!GLib.file_test(settingsFile, GLib.FileTest.EXISTS)) {
                try {
                    GLib.file_set_contents(settingsFile, 'ICON_SIZE=28\nBORDER_RADIUS=16\nBORDER_WIDTH=2\n');
                } catch (e) {
                    print('Error creating settings file: ' + e.message);
                }
            }
        }
        
        // Load current icon size (source settings file logic)
        function loadCurrentIconSize() {
            ensureSettingsFile();
            try {
                let [ok, contents] = GLib.file_get_contents(settingsFile);
                if (ok && contents) {
                    let content = imports.byteArray.toString(contents);
                    let match = content.match(/ICON_SIZE=([0-9]+)/);
                    if (match) {
                        return match[1];
                    }
                }
            } catch (e) {
                print('Error reading settings file: ' + e.message);
            }
            return '28'; // Default value
        }
        
        // Set initial value
        entry.set_text(loadCurrentIconSize());
        
        function updateDockIconSize(newSize) {
            try {
                let numValue = parseInt(newSize);
                if (isNaN(numValue) || numValue < 16 || numValue > 64) {
                    GLib.spawn_command_line_async(`notify-send "Dock" "Invalid value: ${newSize}. Use 16-64" -t 2000`);
                    return;
                }
                
                // Update settings file (sed command from hook script)
                GLib.spawn_command_line_async(`sed -i 's/ICON_SIZE=.*/ICON_SIZE=${numValue}/' '${settingsFile}'`);
                
                // Update launch script and keybinds (sed commands from hook script)  
                GLib.spawn_command_line_async(`sed -i 's/-i [0-9]\\+/-i ${numValue}/g' '${launchScript}'`);
                GLib.spawn_command_line_async(`sed -i 's/-i [0-9]\\+/-i ${numValue}/g' '${leftScript}'`);
                GLib.spawn_command_line_async(`sed -i 's/-i [0-9]\\+/-i ${numValue}/g' '${rightScript}'`);
                GLib.spawn_command_line_async(`sed -i 's/-i [0-9]\\+/-i ${numValue}/g' '${topScript}'`);
                
                // Improved dock relaunch: let the launch script handle everything
                GLib.spawn_command_line_async(`bash -c '
                    chmod +x "${toggleScript}"
                    bash -c "${toggleScript} --relaunch" > /dev/null 2>&1 &
                '`);
                
                GLib.spawn_command_line_async(`notify-send "Dock" "Icon Size: ${numValue}px" -t 2000`);
            } catch (e) {
                print('Error updating dock icon size: ' + e.message);
            }
        }
        
        entry.connect('activate', () => {
            updateDockIconSize(entry.get_text());
        });
        
        row.append(lbl);
        row.append(entry);
        rightTogglesBox.append(row);
    }
    
    // Add dock icon size input
    addDockIconSizeRow('Dock Icon Size');
    
    // --- Dock Border Radius Control (Translated from Hook Scripts) ---
    function addDockRadiusRow(label) {
        const row = new Gtk.Box({ orientation: Gtk.Orientation.HORIZONTAL, spacing: 8, halign: Gtk.Align.CENTER, valign: Gtk.Align.CENTER });
        const lbl = new Gtk.Label({ label, halign: Gtk.Align.END, xalign: 1 });
        lbl.set_size_request(110, -1);
        
        const entry = new Gtk.Entry({ 
            placeholder_text: '0-50',
            width_chars: 8,
            halign: Gtk.Align.CENTER
        });
        
        // File paths (from hook script)
        const styleFile = GLib.build_filenamev([GLib.get_home_dir(), '.config', 'nwg-dock-hyprland', 'style.css']);
        const settingsFile = GLib.build_filenamev([GLib.get_home_dir(), '.config', 'hyprcandy', 'nwg_dock_settings.conf']);
        const toggleScript = GLib.build_filenamev([GLib.get_home_dir(), '.config', 'hyprcandy', 'scripts', 'toggle-dock.sh']);
        
        // Create settings file if it doesn't exist (from hook script logic)
        function ensureSettingsFile() {
            if (!GLib.file_test(settingsFile, GLib.FileTest.EXISTS)) {
                try {
                    GLib.file_set_contents(settingsFile, 'ICON_SIZE=28\nBORDER_RADIUS=16\nBORDER_WIDTH=2\n');
                } catch (e) {
                    print('Error creating settings file: ' + e.message);
                }
            }
        }
        
        // Load current border radius
        function loadCurrentRadius() {
            ensureSettingsFile();
            try {
                let [ok, contents] = GLib.file_get_contents(settingsFile);
                if (ok && contents) {
                    let content = imports.byteArray.toString(contents);
                    let match = content.match(/BORDER_RADIUS=([0-9]+)/);
                    if (match) {
                        return match[1];
                    }
                }
            } catch (e) {
                print('Error reading settings file: ' + e.message);
            }
            return '16'; // Default value
        }
        
        // Set initial value
        entry.set_text(loadCurrentRadius());
        
        function updateDockRadius(newRadius) {
            try {
                let numValue = parseInt(newRadius);
                if (isNaN(numValue) || numValue < 0 || numValue > 50) {
                    GLib.spawn_command_line_async(`notify-send "Dock" "Invalid value: ${newRadius}. Use 0-50" -t 2000`);
                    return;
                }
                
                // Update settings file (from hook script)
                GLib.spawn_command_line_async(`sed -i 's/BORDER_RADIUS=.*/BORDER_RADIUS=${numValue}/' '${settingsFile}'`);
                
                // Update style.css file (from hook script)
                GLib.spawn_command_line_async(`sed -i '5s/border-radius: [0-9]\\+px/border-radius: ${numValue}px/' '${styleFile}'`);
                
                // Get current icon size for relaunch
                function getCurrentIconSize() {
                    try {
                        let [ok, contents] = GLib.file_get_contents(settingsFile);
                        if (ok && contents) {
                            let content = imports.byteArray.toString(contents);
                            let match = content.match(/ICON_SIZE=([0-9]+)/);
                            if (match) {
                                return match[1];
                            }
                        }
                    } catch (e) {}
                    return '28'; // Default
                }
                
                // Improved dock relaunch: let the launch script handle everything
                GLib.spawn_command_line_async(`bash -c '
                    chmod +x "${toggleScript}"
                    bash -c "${toggleScript} --relaunch" > /dev/null 2>&1 &
                '`);
                
                GLib.spawn_command_line_async(`notify-send "Dock" "Border Radius: ${numValue}px" -t 2000`);
            } catch (e) {
                print('Error updating dock radius: ' + e.message);
            }
        }
        
        entry.connect('activate', () => {
            updateDockRadius(entry.get_text());
        });
        
        row.append(lbl);
        row.append(entry);
        rightTogglesBox.append(row);
    }
    
    // Add dock radius input
    addDockRadiusRow('Dock Radius');
    
    // --- Dock Border Width Control (Translated from Hook Scripts) ---
    function addDockWidthRow(label) {
        const row = new Gtk.Box({ orientation: Gtk.Orientation.HORIZONTAL, spacing: 8, halign: Gtk.Align.CENTER, valign: Gtk.Align.CENTER });
        const lbl = new Gtk.Label({ label, halign: Gtk.Align.END, xalign: 1 });
        lbl.set_size_request(110, -1);
        
        const entry = new Gtk.Entry({ 
            placeholder_text: '0-10',
            width_chars: 8,
            halign: Gtk.Align.CENTER
        });
        
        // File paths (from hook script)
        const styleFile = GLib.build_filenamev([GLib.get_home_dir(), '.config', 'nwg-dock-hyprland', 'style.css']);
        const settingsFile = GLib.build_filenamev([GLib.get_home_dir(), '.config', 'hyprcandy', 'nwg_dock_settings.conf']);
        const toggleScript = GLib.build_filenamev([GLib.get_home_dir(), '.config', 'hyprcandy', 'scripts', 'toggle-dock.sh']);
        
        // Create settings file if it doesn't exist (from hook script logic)
        function ensureSettingsFile() {
            if (!GLib.file_test(settingsFile, GLib.FileTest.EXISTS)) {
                try {
                    GLib.file_set_contents(settingsFile, 'ICON_SIZE=28\nBORDER_RADIUS=16\nBORDER_WIDTH=2\n');
                } catch (e) {
                    print('Error creating settings file: ' + e.message);
                }
            }
        }
        
        // Load current border width
        function loadCurrentWidth() {
            ensureSettingsFile();
            try {
                let [ok, contents] = GLib.file_get_contents(settingsFile);
                if (ok && contents) {
                    let content = imports.byteArray.toString(contents);
                    let match = content.match(/BORDER_WIDTH=([0-9]+)/);
                    if (match) {
                        return match[1];
                    }
                }
            } catch (e) {
                print('Error reading settings file: ' + e.message);
            }
            return '2'; // Default value
        }
        
        // Set initial value
        entry.set_text(loadCurrentWidth());
        
        function updateDockWidth(newWidth) {
            try {
                let numValue = parseInt(newWidth);
                if (isNaN(numValue) || numValue < 0 || numValue > 10) {
                    GLib.spawn_command_line_async(`notify-send "Dock" "Invalid value: ${newWidth}. Use 0-10" -t 2000`);
                    return;
                }
                
                // Update settings file (from hook script)
                GLib.spawn_command_line_async(`sed -i 's/BORDER_WIDTH=.*/BORDER_WIDTH=${numValue}/' '${settingsFile}'`);
                
                // Update style.css file (from hook script)
                GLib.spawn_command_line_async(`sed -i 's/border-width: [0-9]\\+px/border-width: ${numValue}px/' '${styleFile}'`);
                
                // Get current icon size for relaunch
                function getCurrentIconSize() {
                    try {
                        let [ok, contents] = GLib.file_get_contents(settingsFile);
                        if (ok && contents) {
                            let content = imports.byteArray.toString(contents);
                            let match = content.match(/ICON_SIZE=([0-9]+)/);
                            if (match) {
                                return match[1];
                            }
                        }
                    } catch (e) {}
                    return '28'; // Default
                }
                
                // Improved dock relaunch: let the launch script handle everything
                GLib.spawn_command_line_async(`bash -c '
                    chmod +x "${toggleScript}"
                    bash -c "${toggleScript} --relaunch" > /dev/null 2>&1 &
                '`);
                
                GLib.spawn_command_line_async(`notify-send "Dock" "Border Width: ${numValue}px" -t 2000`);
            } catch (e) {
                print('Error updating dock width: ' + e.message);
            }
        }
        
        entry.connect('activate', () => {
            updateDockWidth(entry.get_text());
        });
        
        row.append(lbl);
        row.append(entry);
        rightTogglesBox.append(row);
    }
    
    // Add dock width input
    addDockWidthRow('Dock Border');
    
    // --- Hyprland Rounding Control (Translated from Hook Scripts) ---
    function addRoundingRow(label) {
        const row = new Gtk.Box({ orientation: Gtk.Orientation.HORIZONTAL, spacing: 8, halign: Gtk.Align.CENTER, valign: Gtk.Align.CENTER });
        const lbl = new Gtk.Label({ label, halign: Gtk.Align.END, xalign: 1 });
        lbl.set_size_request(110, -1);
        
        const entry = new Gtk.Entry({ 
            placeholder_text: '0-50',
            width_chars: 8,
            halign: Gtk.Align.CENTER
        });
        
        // File path (from hook script)
        const configFile = GLib.build_filenamev([GLib.get_home_dir(), '.config', 'hypr', 'hyprviz.conf']);
        
        // Load current rounding value
        function loadCurrentRounding() {
            try {
                let [ok, contents] = GLib.file_get_contents(configFile);
                if (ok && contents) {
                    let content = imports.byteArray.toString(contents);
                    // grep -E "^\s*rounding\s*=" logic
                    let match = content.match(/^\s*rounding\s*=\s*([0-9]+)/m);
                    if (match) {
                        return match[1];
                    }
                }
            } catch (e) {
                print('Error reading config file: ' + e.message);
            }
            return '10'; // Default value
        }
        
        // Set initial value
        entry.set_text(loadCurrentRounding());
        
        function updateRounding(newRounding) {
            try {
                let numValue = parseInt(newRounding);
                if (isNaN(numValue) || numValue < 0 || numValue > 50) {
                    GLib.spawn_command_line_async(`notify-send "Hyprland" "Invalid value: ${newRounding}. Use 0-50" -t 2000`);
                    return;
                }
                
                // Update config file (sed command from hook script)
                GLib.spawn_command_line_async(`sed -i 's/^\\(\\s*rounding\\s*=\\s*\\)[0-9]*/\\1${numValue}/' '${configFile}'`);
                
                // Apply changes (hyprctl commands from hook script)
                GLib.spawn_command_line_async(`hyprctl keyword decoration:rounding ${numValue}`);
                GLib.spawn_command_line_async('hyprctl reload');
                
                GLib.spawn_command_line_async(`notify-send "Hyprland" "Rounding: ${numValue}" -t 2000`);
            } catch (e) {
                print('Error updating rounding: ' + e.message);
            }
        }
        
        entry.connect('activate', () => {
            updateRounding(entry.get_text());
        });
        
        row.append(lbl);
        row.append(entry);
        rightTogglesBox.append(row);
    }
    
    // Add rounding input
    //addRoundingRow('Rounding');
    
    // --- Hyprland Gaps OUT Control (Translated from Hook Scripts) ---
    function addGapsOutRow(label) {
        const row = new Gtk.Box({ orientation: Gtk.Orientation.HORIZONTAL, spacing: 8, halign: Gtk.Align.CENTER, valign: Gtk.Align.CENTER });
        const lbl = new Gtk.Label({ label, halign: Gtk.Align.END, xalign: 1 });
        lbl.set_size_request(110, -1);
        
        const entry = new Gtk.Entry({ 
            placeholder_text: '0-100',
            width_chars: 8,
            halign: Gtk.Align.CENTER
        });
        
        // File path (from hook script)
        const configFile = GLib.build_filenamev([GLib.get_home_dir(), '.config', 'hypr', 'hyprviz.conf']);
        
        // Load current gaps_out value
        function loadCurrentGapsOut() {
            try {
                let [ok, contents] = GLib.file_get_contents(configFile);
                if (ok && contents) {
                    let content = imports.byteArray.toString(contents);
                    // grep -E "^\s*gaps_out\s*=" logic
                    let match = content.match(/^\s*gaps_out\s*=\s*([0-9]+)/m);
                    if (match) {
                        return match[1];
                    }
                }
            } catch (e) {
                print('Error reading config file: ' + e.message);
            }
            return '20'; // Default value
        }
        
        // Set initial value
        entry.set_text(loadCurrentGapsOut());
        
        function updateGapsOut(newGapsOut) {
            try {
                let numValue = parseInt(newGapsOut);
                if (isNaN(numValue) || numValue < 0 || numValue > 100) {
                    GLib.spawn_command_line_async(`notify-send "Hyprland" "Invalid value: ${newGapsOut}. Use 0-100" -t 2000`);
                    return;
                }
                
                // Update config file (sed command from hook script)
                GLib.spawn_command_line_async(`sed -i 's/^\\(\\s*gaps_out\\s*=\\s*\\)[0-9]*/\\1${numValue}/' '${configFile}'`);
                
                // Apply changes (hyprctl commands from hook script)
                GLib.spawn_command_line_async(`hyprctl keyword general:gaps_out ${numValue}`);
                GLib.spawn_command_line_async('hyprctl reload');
                
                GLib.spawn_command_line_async(`notify-send "Hyprland" "Gaps OUT: ${numValue}" -t 2000`);
            } catch (e) {
                print('Error updating gaps out: ' + e.message);
            }
        }
        
        entry.connect('activate', () => {
            updateGapsOut(entry.get_text());
        });
        
        row.append(lbl);
        row.append(entry);
        rightTogglesBox.append(row);
    }
    
    // --- Hyprland Gaps IN Control (Translated from Hook Scripts) ---
    function addGapsInRow(label) {
        const row = new Gtk.Box({ orientation: Gtk.Orientation.HORIZONTAL, spacing: 8, halign: Gtk.Align.CENTER, valign: Gtk.Align.CENTER });
        const lbl = new Gtk.Label({ label, halign: Gtk.Align.END, xalign: 1 });
        lbl.set_size_request(110, -1);
        
        const entry = new Gtk.Entry({ 
            placeholder_text: '0-50',
            width_chars: 8,
            halign: Gtk.Align.CENTER
        });
        
        // File path (from hook script)
        const configFile = GLib.build_filenamev([GLib.get_home_dir(), '.config', 'hypr', 'hyprviz.conf']);
        
        // Load current gaps_in value
        function loadCurrentGapsIn() {
            try {
                let [ok, contents] = GLib.file_get_contents(configFile);
                if (ok && contents) {
                    let content = imports.byteArray.toString(contents);
                    // grep -E "^\s*gaps_in\s*=" logic
                    let match = content.match(/^\s*gaps_in\s*=\s*([0-9]+)/m);
                    if (match) {
                        return match[1];
                    }
                }
            } catch (e) {
                print('Error reading config file: ' + e.message);
            }
            return '10'; // Default value
        }
        
        // Set initial value
        entry.set_text(loadCurrentGapsIn());
        
        function updateGapsIn(newGapsIn) {
            try {
                let numValue = parseInt(newGapsIn);
                if (isNaN(numValue) || numValue < 0 || numValue > 50) {
                    GLib.spawn_command_line_async(`notify-send "Hyprland" "Invalid value: ${newGapsIn}. Use 0-50" -t 2000`);
                    return;
                }
                
                // Update config file (sed command from hook script)
                GLib.spawn_command_line_async(`sed -i 's/^\\(\\s*gaps_in\\s*=\\s*\\)[0-9]*/\\1${numValue}/' '${configFile}'`);
                
                // Apply changes (hyprctl commands from hook script)
                GLib.spawn_command_line_async(`hyprctl keyword general:gaps_in ${numValue}`);
                GLib.spawn_command_line_async('hyprctl reload');
                
                GLib.spawn_command_line_async(`notify-send "Hyprland" "Gaps IN: ${numValue}" -t 2000`);
            } catch (e) {
                print('Error updating gaps in: ' + e.message);
            }
        }
        
        entry.connect('activate', () => {
            updateGapsIn(entry.get_text());
        });
        
        row.append(lbl);
        row.append(entry);
        rightTogglesBox.append(row);
    }
    
    // Add gaps inputs
    //addGapsOutRow('Gaps OUT');
    //addGapsInRow('Gaps IN');
    
    // --- Hyprland Border Control (Translated from Hook Scripts) ---
    function addBorderRow(label) {
        const row = new Gtk.Box({ orientation: Gtk.Orientation.HORIZONTAL, spacing: 8, halign: Gtk.Align.CENTER, valign: Gtk.Align.CENTER });
        const lbl = new Gtk.Label({ label, halign: Gtk.Align.END, xalign: 1 });
        lbl.set_size_request(110, -1);
        
        const entry = new Gtk.Entry({ 
            placeholder_text: '0-10',
            width_chars: 8,
            halign: Gtk.Align.CENTER
        });
        
        // File path (from hook script)
        const configFile = GLib.build_filenamev([GLib.get_home_dir(), '.config', 'hypr', 'hyprviz.conf']);
        
        // Load current border_size value
        function loadCurrentBorder() {
            try {
                let [ok, contents] = GLib.file_get_contents(configFile);
                if (ok && contents) {
                    let content = imports.byteArray.toString(contents);
                    // grep -E "^\s*border_size\s*=" logic
                    let match = content.match(/^\s*border_size\s*=\s*([0-9]+)/m);
                    if (match) {
                        return match[1];
                    }
                }
            } catch (e) {
                print('Error reading config file: ' + e.message);
            }
            return '2'; // Default value
        }
        
        // Set initial value
        entry.set_text(loadCurrentBorder());
        
        function updateBorder(newBorder) {
            try {
                let numValue = parseInt(newBorder);
                if (isNaN(numValue) || numValue < 0 || numValue > 10) {
                    GLib.spawn_command_line_async(`notify-send "Hyprland" "Invalid value: ${newBorder}. Use 0-10" -t 2000`);
                    return;
                }
                
                // Update config file (sed command from hook script)
                GLib.spawn_command_line_async(`sed -i 's/^\\(\\s*border_size\\s*=\\s*\\)[0-9]*/\\1${numValue}/' '${configFile}'`);
                
                // Apply changes (hyprctl commands from hook script)
                GLib.spawn_command_line_async(`hyprctl keyword general:border_size ${numValue}`);
                GLib.spawn_command_line_async('hyprctl reload');
                
                GLib.spawn_command_line_async(`notify-send "Hyprland" "Border: ${numValue}" -t 2000`);
            } catch (e) {
                print('Error updating border: ' + e.message);
            }
        }
        
        entry.connect('activate', () => {
            updateBorder(entry.get_text());
        });
        
        row.append(lbl);
        row.append(entry);
        rightTogglesBox.append(row);
    }
    
    // Add border input
    //addBorderRow('Border');
    
    // --- Blur Size Control (Adapted from existing logic) ---
    function addBlurSizeRow(label) {
        const row = new Gtk.Box({ orientation: Gtk.Orientation.HORIZONTAL, spacing: 8, halign: Gtk.Align.CENTER, valign: Gtk.Align.CENTER });
        const lbl = new Gtk.Label({ label, halign: Gtk.Align.END, xalign: 1 });
        lbl.set_size_request(110, -1);
        
        const entry = new Gtk.Entry({ 
            placeholder_text: '0-20',
            width_chars: 8,
            halign: Gtk.Align.CENTER
        });
        
        // File path (from existing logic)
        const configFile = GLib.build_filenamev([GLib.get_home_dir(), '.config', 'hypr', 'hyprviz.conf']);
        
        // Load current blur size value
        function loadCurrentBlurSize() {
            try {
                let [ok, contents] = GLib.file_get_contents(configFile);
                if (ok && contents) {
                    let content = imports.byteArray.toString(contents);
                    // Look for size = X inside the blur block (from existing logic)
                    let blurSection = content.match(/blur \{[\s\S]*?\}/);
                    if (blurSection) {
                        let sizeMatch = blurSection[0].match(/size = ([0-9]+)/);
                        if (sizeMatch) {
                            return sizeMatch[1];
                        }
                    }
                }
            } catch (e) {
                print('Error reading config file: ' + e.message);
            }
            return '8'; // Default value
        }
        
        // Set initial value
        entry.set_text(loadCurrentBlurSize());
        
        function updateBlurSize(newSize) {
            try {
                let numValue = parseInt(newSize);
                if (isNaN(numValue) || numValue < 0 || numValue > 20) {
                    GLib.spawn_command_line_async(`notify-send "Blur" "Invalid value: ${newSize}. Use 0-20" -t 2000`);
                    return;
                }
                
                // Read current value and update (exact logic from existing function)
                let [ok, contents] = GLib.file_get_contents(configFile);
                if (ok && contents) {
                    let content = imports.byteArray.toString(contents);
                    let blurSection = content.match(/blur \{[\s\S]*?\}/);
                    if (blurSection) {
                        let sizeMatch = blurSection[0].match(/size = ([0-9]+)/);
                        if (sizeMatch) {
                            let currentValue = parseInt(sizeMatch[1]);
                            // Use the exact sed command from existing logic
                            GLib.spawn_command_line_async(`sed -i '/blur {/,/}/{s/size = ${currentValue}/size = ${numValue}/}' '${configFile}'`);
                            GLib.spawn_command_line_async('hyprctl reload');
                            GLib.spawn_command_line_async(`notify-send "Blur" "Size: ${numValue}" -t 2000`);
                        }
                    }
                }
            } catch (e) {
                print('Error updating blur size: ' + e.message);
            }
        }
        
        entry.connect('activate', () => {
            updateBlurSize(entry.get_text());
        });
        
        row.append(lbl);
        row.append(entry);
        rightTogglesBox.append(row);
    }
    
    // Add blur size input
    //addBlurSizeRow('Blur Size');
    
    // --- Blur Pass Control (Adapted from existing logic) ---
    function addBlurPassRow(label) {
        const row = new Gtk.Box({ orientation: Gtk.Orientation.HORIZONTAL, spacing: 8, halign: Gtk.Align.CENTER, valign: Gtk.Align.CENTER });
        const lbl = new Gtk.Label({ label, halign: Gtk.Align.END, xalign: 1 });
        lbl.set_size_request(110, -1);
        
        const entry = new Gtk.Entry({ 
            placeholder_text: '0-10',
            width_chars: 8,
            halign: Gtk.Align.CENTER
        });
        
        // File path (from existing logic)
        const configFile = GLib.build_filenamev([GLib.get_home_dir(), '.config', 'hypr', 'hyprviz.conf']);
        
        // Load current blur pass value
        function loadCurrentBlurPass() {
            try {
                let [ok, contents] = GLib.file_get_contents(configFile);
                if (ok && contents) {
                    let content = imports.byteArray.toString(contents);
                    // Look for passes = X inside the blur block (from existing logic)
                    let blurSection = content.match(/blur \{[\s\S]*?\}/);
                    if (blurSection) {
                        let passesMatch = blurSection[0].match(/passes = ([0-9]+)/);
                        if (passesMatch) {
                            return passesMatch[1];
                        }
                    }
                }
            } catch (e) {
                print('Error reading config file: ' + e.message);
            }
            return '1'; // Default value
        }
        
        // Set initial value
        entry.set_text(loadCurrentBlurPass());
        
        function updateBlurPass(newPass) {
            try {
                let numValue = parseInt(newPass);
                if (isNaN(numValue) || numValue < 0 || numValue > 10) {
                    GLib.spawn_command_line_async(`notify-send "Blur" "Invalid value: ${newPass}. Use 0-10" -t 2000`);
                    return;
                }
                
                // Read current value and update (exact logic from existing function)
                let [ok, contents] = GLib.file_get_contents(configFile);
                if (ok && contents) {
                    let content = imports.byteArray.toString(contents);
                    let blurSection = content.match(/blur \{[\s\S]*?\}/);
                    if (blurSection) {
                        let passesMatch = blurSection[0].match(/passes = ([0-9]+)/);
                        if (passesMatch) {
                            let currentValue = parseInt(passesMatch[1]);
                            // Use the exact sed command from existing logic
                            GLib.spawn_command_line_async(`sed -i 's/passes = ${currentValue}/passes = ${numValue}/' '${configFile}'`);
                            GLib.spawn_command_line_async('hyprctl reload');
                            GLib.spawn_command_line_async(`notify-send "Blur" "Passes: ${numValue}" -t 2000`);
                        }
                    }
                }
            } catch (e) {
                print('Error updating blur passes: ' + e.message);
            }
        }
        
        entry.connect('activate', () => {
            updateBlurPass(entry.get_text());
        });
        
        row.append(lbl);
        row.append(entry);
        rightTogglesBox.append(row);
    }
    
    // Add blur pass input
    //addBlurPassRow('Blur Pass');
    
    // --- Rofi Border Control (Adapted from existing logic) ---
    function addRofiBorderRow(label) {
        const row = new Gtk.Box({ orientation: Gtk.Orientation.HORIZONTAL, spacing: 8, halign: Gtk.Align.CENTER, valign: Gtk.Align.CENTER });
        const lbl = new Gtk.Label({ label, halign: Gtk.Align.END, xalign: 1 });
        lbl.set_size_request(110, -1);
        
        const entry = new Gtk.Entry({ 
            placeholder_text: '0-10',
            width_chars: 8,
            halign: Gtk.Align.CENTER
        });
        
        // File path (from existing logic)
        const rofiBorderFile = GLib.build_filenamev([GLib.get_home_dir(), '.config', 'hyprcandy', 'settings', 'rofi-border.rasi']);
        
        // Load current rofi border value
        function loadCurrentRofiBorder() {
            try {
                let [ok, contents] = GLib.file_get_contents(rofiBorderFile);
                if (ok && contents) {
                    let content = imports.byteArray.toString(contents);
                    let borderMatch = content.match(/border-width: ([0-9]+)px/);
                    if (borderMatch) {
                        return borderMatch[1];
                    }
                }
            } catch (e) {
                print('Error reading rofi border file: ' + e.message);
            }
            return '2'; // Default value
        }
        
        // Set initial value
        entry.set_text(loadCurrentRofiBorder());
        
        function updateRofiBorder(newBorder) {
            try {
                let numValue = parseInt(newBorder);
                if (isNaN(numValue) || numValue < 0 || numValue > 10) {
                    GLib.spawn_command_line_async(`notify-send "Rofi" "Invalid value: ${newBorder}. Use 0-10" -t 2000`);
                    return;
                }
                
                // Read current value and update (exact logic from existing function)
                let [ok, contents] = GLib.file_get_contents(rofiBorderFile);
                if (ok && contents) {
                    let content = imports.byteArray.toString(contents);
                    let borderMatch = content.match(/border-width: ([0-9]+)px/);
                    if (borderMatch) {
                        let currentValue = parseInt(borderMatch[1]);
                        // Use the exact sed command from existing logic
                        GLib.spawn_command_line_async(`sed -i 's/border-width: ${currentValue}px/border-width: ${numValue}px/' '${rofiBorderFile}'`);
                        GLib.spawn_command_line_async(`notify-send "Rofi" "Border: ${numValue}px" -t 2000`);
                    }
                }
            } catch (e) {
                print('Error updating rofi border: ' + e.message);
            }
        }
        
        entry.connect('activate', () => {
            updateRofiBorder(entry.get_text());
        });
        
        row.append(lbl);
        row.append(entry);
        rightTogglesBox.append(row);
    }
    
    // Add rofi border input
    addRofiBorderRow('Rofi Border');
    
    // --- Rofi Radius Control (Adapted from existing logic) ---
    function addRofiRadiusRow(label) {
        const row = new Gtk.Box({ orientation: Gtk.Orientation.HORIZONTAL, spacing: 8, halign: Gtk.Align.CENTER, valign: Gtk.Align.CENTER });
        const lbl = new Gtk.Label({ label, halign: Gtk.Align.END, xalign: 1 });
        lbl.set_size_request(110, -1);
        
        const entry = new Gtk.Entry({ 
            placeholder_text: '0.0-5.0',
            width_chars: 8,
            halign: Gtk.Align.CENTER
        });
        
        // File path (from existing logic)
        const rofiRadiusFile = GLib.build_filenamev([GLib.get_home_dir(), '.config', 'hyprcandy', 'settings', 'rofi-border-radius.rasi']);
        
        // Load current rofi radius value
        function loadCurrentRofiRadius() {
            try {
                let [ok, contents] = GLib.file_get_contents(rofiRadiusFile);
                if (ok && contents) {
                    let content = imports.byteArray.toString(contents);
                    let radiusMatch = content.match(/border-radius: ([0-9.]+)em/);
                    if (radiusMatch) {
                        return radiusMatch[1];
                    }
                }
            } catch (e) {
                print('Error reading rofi radius file: ' + e.message);
            }
            return '1.0'; // Default value
        }
        
        // Set initial value
        entry.set_text(loadCurrentRofiRadius());
        
        function updateRofiRadius(newRadius) {
            try {
                let numValue = parseFloat(newRadius);
                if (isNaN(numValue) || numValue < 0 || numValue > 5.0) {
                    GLib.spawn_command_line_async(`notify-send "Rofi" "Invalid value: ${newRadius}. Use 0.0-5.0" -t 2000`);
                    return;
                }
                
                // Read current value and update (exact logic from existing function)
                let [ok, contents] = GLib.file_get_contents(rofiRadiusFile);
                if (ok && contents) {
                    let content = imports.byteArray.toString(contents);
                    let radiusMatch = content.match(/border-radius: ([0-9.]+)em/);
                    if (radiusMatch) {
                        let newValueStr = numValue.toFixed(1);
                        // Use the exact sed command from existing logic
                        GLib.spawn_command_line_async(`sed -i 's/border-radius: ${radiusMatch[1]}em/border-radius: ${newValueStr}em/' '${rofiRadiusFile}'`);
                        GLib.spawn_command_line_async(`notify-send "Rofi" "Radius: ${newValueStr}em" -t 2000`);
                    }
                }
            } catch (e) {
                print('Error updating rofi radius: ' + e.message);
            }
        }
        
        entry.connect('activate', () => {
            updateRofiRadius(entry.get_text());
        });
        
        row.append(lbl);
        row.append(entry);
        rightTogglesBox.append(row);
    }
    
    // Add rofi radius input
    addRofiRadiusRow('Rofi Radius');
    
    // --- Opacity Scale Control (Adapted from existing logic) ---
    function addOpacityScaleRow(label) {
        const row = new Gtk.Box({ orientation: Gtk.Orientation.HORIZONTAL, spacing: 8, halign: Gtk.Align.CENTER, valign: Gtk.Align.CENTER });
        const lbl = new Gtk.Label({ label, halign: Gtk.Align.END, xalign: 1 });
        lbl.set_size_request(110, -1);
        
        const entry = new Gtk.Entry({ 
            placeholder_text: '0.0-1.0',
            width_chars: 8,
            halign: Gtk.Align.CENTER
        });
        
        // File path (from existing logic)
        const configFile = GLib.build_filenamev([GLib.get_home_dir(), '.config', 'hypr', 'hyprviz.conf']);
        
        // Load current active_opacity value
        function loadCurrentOpacity() {
            try {
                let [ok, contents] = GLib.file_get_contents(configFile);
                if (ok && contents) {
                    let content = imports.byteArray.toString(contents);
                    let match = content.match(/active_opacity = ([0-9.]+)/);
                    if (match) {
                        return match[1];
                    }
                }
            } catch (e) {
                print('Error reading config file: ' + e.message);
            }
            return '1.0'; // Default value
        }
        
        // Set initial value
        entry.set_text(loadCurrentOpacity());
        
        function updateOpacityScale(newOpacity) {
            try {
                let numValue = parseFloat(newOpacity);
                if (isNaN(numValue) || numValue < 0.0 || numValue > 1.0) {
                    GLib.spawn_command_line_async(`notify-send "Opacity" "Invalid value: ${newOpacity}. Use 0.0-1.0" -t 2000`);
                    return;
                }
                
                // Update using exact logic from existing function
                let newValueStr = numValue.toFixed(2);
                GLib.spawn_command_line_async(`sed -i 's/active_opacity = .*/active_opacity = ${newValueStr}/' "${configFile}"`);
                GLib.spawn_command_line_async('hyprctl reload');
                GLib.spawn_command_line_async(`notify-send "Opacity" "Scale: ${newValueStr}" -t 2000`);
            } catch (e) {
                print('Error updating opacity scale: ' + e.message);
            }
        }
        
        entry.connect('activate', () => {
            updateOpacityScale(entry.get_text());
        });
        
        row.append(lbl);
        row.append(entry);
        rightTogglesBox.append(row);
    }
    
    // Add opacity scale input
    //addOpacityScaleRow('Opacity Scale');
    
    // --- Waybar Padding Control (Converted to Input Box) ---
    function addWaybarPaddingRow(label) {
        const row = new Gtk.Box({ orientation: Gtk.Orientation.HORIZONTAL, spacing: 8, halign: Gtk.Align.CENTER, valign: Gtk.Align.CENTER });
        const lbl = new Gtk.Label({ label, halign: Gtk.Align.END, xalign: 1 });
        lbl.set_size_request(110, -1);
        
        const entry = new Gtk.Entry({ 
            placeholder_text: '0.0-10.0',
            width_chars: 8,
            halign: Gtk.Align.CENTER
        });
        
        // File paths (from existing logic)
        const waybarStyleFile = GLib.build_filenamev([GLib.get_home_dir(), '.config', 'waybar', 'style.css']);
        const waybarPaddingStateFile = GLib.build_filenamev([hyprsunsetStateDir, 'waybar_padding.state']);
        
        // Load current waybar padding value
        function loadCurrentWaybarPadding() {
            try {
                // Try to read from state file first
                let [ok, contents] = GLib.file_get_contents(waybarPaddingStateFile);
                if (ok && contents) {
                    let value = imports.byteArray.toString(contents).trim();
                    if (value && !isNaN(parseFloat(value))) {
                        return value;
                    }
                }
                
                // Fallback: read from CSS file
                let [cssOk, cssContents] = GLib.file_get_contents(waybarStyleFile);
                if (cssOk && cssContents) {
                    let content = imports.byteArray.toString(cssContents);
                    let paddingMatch = content.match(/padding: ([0-9.]+)px;/);
                    if (paddingMatch) {
                        return paddingMatch[1];
                    }
                }
            } catch (e) {
                print('Error reading waybar padding: ' + e.message);
            }
            return '3.5'; // Default value
        }
        
        // Set initial value
        entry.set_text(loadCurrentWaybarPadding());
        
        function updateWaybarPadding(newPadding) {
            try {
                let numValue = parseFloat(newPadding);
                if (isNaN(numValue) || numValue < 0.0 || numValue > 10.0) {
                    GLib.spawn_command_line_async(`notify-send "Waybar" "Invalid value: ${newPadding}. Use 0.0-10.0" -t 2000`);
                    return;
                }
                
                // Read current value and update (exact logic from existing function)
                let [ok, contents] = GLib.file_get_contents(waybarStyleFile);
                if (ok && contents) {
                    let content = imports.byteArray.toString(contents);
                    let paddingMatch = content.match(/padding: ([0-9.]+)px;/);
                    if (paddingMatch) {
                        let newValueStr = numValue.toFixed(1);
                        
                        // Update CSS file (correct line number for padding)
                        GLib.spawn_command_line_async(`sed -i '31s/padding: ${paddingMatch[1]}px;/padding: ${newValueStr}px;/' '${waybarStyleFile}'`);
                        
                        // Update state file
                        GLib.file_set_contents(waybarPaddingStateFile, newValueStr);
                        
                        // Send notification
                        GLib.spawn_command_line_async(`notify-send "Waybar" "Padding: ${newValueStr}px" -t 2000`);
                    }
                }
            } catch (e) {
                print('Error updating waybar padding: ' + e.message);
            }
        }
        
        entry.connect('activate', () => {
            updateWaybarPadding(entry.get_text());
        });
        
        row.append(lbl);
        row.append(entry);
        rightTogglesBox.append(row);
    }
    
    addWaybarPaddingRow('Waybar Padding');
    
    // --- Waybar Border Size Control (Converted to Input Box) ---
    function addWaybarBorderSizeRow(label) {
        const row = new Gtk.Box({ orientation: Gtk.Orientation.HORIZONTAL, spacing: 8, halign: Gtk.Align.CENTER, valign: Gtk.Align.CENTER });
        const lbl = new Gtk.Label({ label, halign: Gtk.Align.END, xalign: 1 });
        lbl.set_size_request(110, -1);
        
        const entry = new Gtk.Entry({ 
            placeholder_text: '0-10',
            width_chars: 8,
            halign: Gtk.Align.CENTER
        });
        
        // File paths (from existing logic)
        const waybarStyleFile = GLib.build_filenamev([GLib.get_home_dir(), '.config', 'waybar', 'style.css']);
        const waybarBorderSizeStateFile = GLib.build_filenamev([hyprsunsetStateDir, 'waybar_border_size.state']);
        
        // Load current waybar border size value
        function loadCurrentWaybarBorderSize() {
            try {
                // Try to read from state file first
                let [ok, contents] = GLib.file_get_contents(waybarBorderSizeStateFile);
                if (ok && contents) {
                    let value = imports.byteArray.toString(contents).trim();
                    if (value && !isNaN(parseInt(value))) {
                        return value;
                    }
                }
                
                // Fallback: read from CSS file
                let [cssOk, cssContents] = GLib.file_get_contents(waybarStyleFile);
                if (cssOk && cssContents) {
                    let content = imports.byteArray.toString(cssContents);
                    // Look for border with @inverse_primary (exact logic from existing function)
                    let borderMatch = content.match(/border:\s*([0-9]+)px\s*solid\s*@inverse_primary;/);
                    if (borderMatch) {
                        return borderMatch[1];
                    }
                }
            } catch (e) {
                print('Error reading waybar border size: ' + e.message);
            }
            return '2'; // Default value
        }
        
        // Set initial value
        entry.set_text(loadCurrentWaybarBorderSize());
        
        function updateWaybarBorderSize(newBorderSize) {
            try {
                let numValue = parseInt(newBorderSize);
                if (isNaN(numValue) || numValue < 0 || numValue > 10) {
                    GLib.spawn_command_line_async(`notify-send "Waybar" "Invalid value: ${newBorderSize}. Use 0-10" -t 2000`);
                    return;
                }
                
                // Read current value and update (exact logic from existing function)
                let [ok, contents] = GLib.file_get_contents(waybarStyleFile);
                if (ok && contents) {
                    let content = imports.byteArray.toString(contents);
                    
                    // Look specifically for the border in the window#waybar > box section (exact logic)
                    let borderMatch = content.match(/window#waybar > box\s*\{[\s\S]*?border:\s*([0-9]+)px\s*solid\s*@inverse_primary;[\s\S]*?\}/);
                    
                    if (!borderMatch) {
                        // Fallback: try to find any border with @inverse_primary
                        borderMatch = content.match(/border:\s*([0-9]+)px\s*solid\s*@inverse_primary;/);
                    }
                    
                    if (borderMatch) {
                        let currentValue = parseInt(borderMatch[1]);
                        
                        // Update CSS file using the exact current value (exact sed command from existing logic)
                        GLib.spawn_command_line_async(`sed -i '32s/border: ${currentValue}px solid @inverse_primary;/border: ${numValue}px solid @inverse_primary;/' '${waybarStyleFile}'`);
                        
                        // Update state file
                        GLib.file_set_contents(waybarBorderSizeStateFile, numValue.toString());
                        
                        // Send notification
                        GLib.spawn_command_line_async(`notify-send "Waybar" "Border Size: ${numValue}px" -t 2000`);
                    } else {
                        print('Could not find border pattern in CSS file');
                    }
                }
            } catch (e) {
                print('Error updating waybar border size: ' + e.message);
            }
        }
        
        entry.connect('activate', () => {
            updateWaybarBorderSize(entry.get_text());
        });
        
        row.append(lbl);
        row.append(entry);
        rightTogglesBox.append(row);
    }
    
    addWaybarBorderSizeRow('Waybar Border');
    
    // --- Waybar Side Margins Control ---
    function addWaybarSideMarginsRow(label) {
        const row = new Gtk.Box({ orientation: Gtk.Orientation.HORIZONTAL, spacing: 8, halign: Gtk.Align.CENTER, valign: Gtk.Align.CENTER });
        const lbl = new Gtk.Label({ label, halign: Gtk.Align.END, xalign: 1 });
        lbl.set_size_request(110, -1);
        
        const entry = new Gtk.Entry({ 
            placeholder_text: '0-255',
            width_chars: 8,
            halign: Gtk.Align.CENTER
        });
        
        // Load current value
        const waybarSideMarginsStateFile = GLib.build_filenamev([hyprsunsetStateDir, 'waybar_side_margins.state']);
        try {
            let [ok, contents] = GLib.file_get_contents(waybarSideMarginsStateFile);
            if (ok && contents) {
                let value = imports.byteArray.toString(contents).trim();
                entry.set_text(value);
            }
        } catch (e) {
            // Use default value from CSS if state file doesn't exist
            entry.set_text('4.5');
        }
        
        function updateWaybarSideMargins(value) {
            const waybarStyleFile = GLib.build_filenamev([GLib.get_home_dir(), '.config', 'waybar', 'style.css']);
            
            try {
                let numValue = parseFloat(value);
                if (isNaN(numValue) || numValue < 0 || numValue > 255) {
                    GLib.spawn_command_line_async(`notify-send "Waybar" "Invalid value: ${value}. Use 0-255" -t 2000`);
                    return;
                }
                
                let valueStr = numValue.toFixed(1);
                
                // Update CSS file - both margin-left and margin-right
                GLib.spawn_command_line_async(`sed -i '27s/margin-left: [0-9.]*px;/margin-left: ${valueStr}px;/' '${waybarStyleFile}'`);
                GLib.spawn_command_line_async(`sed -i '28s/margin-right: [0-9.]*px;/margin-right: ${valueStr}px;/' '${waybarStyleFile}'`);
                
                // Update state file
                GLib.file_set_contents(waybarSideMarginsStateFile, valueStr);
                
                // Send notification
                GLib.spawn_command_line_async(`notify-send "Waybar" "Side-margins: ${valueStr}px" -t 2000`);
            } catch (e) {
                print('Error updating waybar side margins: ' + e.message);
            }
        }
        
        entry.connect('activate', () => {
            updateWaybarSideMargins(entry.get_text());
        });
        
        row.append(lbl);
        row.append(entry);
        rightTogglesBox.append(row);
    }
    
    // --- Waybar Top Margin Control ---
    function addWaybarTopMarginRow(label) {
        const row = new Gtk.Box({ orientation: Gtk.Orientation.HORIZONTAL, spacing: 8, halign: Gtk.Align.CENTER, valign: Gtk.Align.CENTER });
        const lbl = new Gtk.Label({ label, halign: Gtk.Align.END, xalign: 1 });
        lbl.set_size_request(110, -1);
        
        const entry = new Gtk.Entry({ 
            placeholder_text: '0-20',
            width_chars: 8,
            halign: Gtk.Align.CENTER
        });
        
        // Load current value
        const waybarTopMarginStateFile = GLib.build_filenamev([hyprsunsetStateDir, 'waybar_top_margin.state']);
        try {
            let [ok, contents] = GLib.file_get_contents(waybarTopMarginStateFile);
            if (ok && contents) {
                let value = imports.byteArray.toString(contents).trim();
                entry.set_text(value);
            }
        } catch (e) {
            // Use default value from CSS if state file doesn't exist
            entry.set_text('4.5');
        }
        
        function updateWaybarTopMargin(value) {
            const waybarStyleFile = GLib.build_filenamev([GLib.get_home_dir(), '.config', 'waybar', 'style.css']);
            
            try {
                let numValue = parseFloat(value);
                if (isNaN(numValue) || numValue < 0 || numValue > 20) {
                    GLib.spawn_command_line_async(`notify-send "Waybar" "Invalid value: ${value}. Use 0-20" -t 2000`);
                    return;
                }
                
                let valueStr = numValue.toFixed(1);
                
                // Update CSS file - margin-top
                GLib.spawn_command_line_async(`sed -i '26s/margin-top: [0-9.]*px;/margin-top: ${valueStr}px;/' '${waybarStyleFile}'`);
                
                // Update state file
                GLib.file_set_contents(waybarTopMarginStateFile, valueStr);
                
                // Send notification
                GLib.spawn_command_line_async(`notify-send "Waybar" "Top-margin: ${valueStr}px" -t 2000`);
            } catch (e) {
                print('Error updating waybar top margin: ' + e.message);
            }
        }
        
        entry.connect('activate', () => {
            updateWaybarTopMargin(entry.get_text());
        });
        
        row.append(lbl);
        row.append(entry);
        rightTogglesBox.append(row);
    }

    // --- Waybar Outer Radius Control ---
    function addWaybarOuterRadiusRow(label) {
        const row = new Gtk.Box({ orientation: Gtk.Orientation.HORIZONTAL, spacing: 8, halign: Gtk.Align.CENTER, valign: Gtk.Align.CENTER });
        const lbl = new Gtk.Label({ label, halign: Gtk.Align.END, xalign: 1 });
        lbl.set_size_request(110, -1);
        
        const entry = new Gtk.Entry({ 
            placeholder_text: '0-20',
            width_chars: 8,
            halign: Gtk.Align.CENTER
        });
        
        // Load current value
        const waybarOuterRadiusStateFile = GLib.build_filenamev([hyprsunsetStateDir, 'waybar_outer_radius.state']);
        try {
            let [ok, contents] = GLib.file_get_contents(waybarOuterRadiusStateFile);
            if (ok && contents) {
                let value = imports.byteArray.toString(contents).trim();
                entry.set_text(value);
            }
        } catch (e) {
            // Use default value from CSS if state file doesn't exist
            entry.set_text('20.0');
        }
        
        function updateWaybarOuterRadius(value) {
            const waybarStyleFile = GLib.build_filenamev([GLib.get_home_dir(), '.config', 'waybar', 'style.css']);
            
            try {
                let numValue = parseFloat(value);
                if (isNaN(numValue) || numValue < 0 || numValue > 20) {
                    GLib.spawn_command_line_async(`notify-send "Waybar" "Invalid value: ${value}. Use 0-20" -t 2000`);
                    return;
                }
                
                let valueStr = numValue.toFixed(1);
                
                // Update CSS file - border-radius
                GLib.spawn_command_line_async(`sed -i '30s/border-radius: [0-9.]*px;/border-radius: ${valueStr}px;/' '${waybarStyleFile}'`);
                GLib.spawn_command_line_async(`sed -i '19s/border-radius: [0-9.]*px;/border-radius: ${valueStr}px;/' '${waybarStyleFile}'`);
                
                // Update state file
                GLib.file_set_contents(waybarOuterRadiusStateFile, valueStr);
                
                // Send notification
                GLib.spawn_command_line_async(`notify-send "Waybar" "Radius: ${valueStr}px" -t 2000`);
            } catch (e) {
                print('Error updating waybar outer radius: ' + e.message);
            }
        }
        
        entry.connect('activate', () => {
            updateWaybarOuterRadius(entry.get_text());
        });
        
        row.append(lbl);
        row.append(entry);
        rightTogglesBox.append(row);
    }
    
    // --- Waybar Bottom Margin Control ---
    function addWaybarBottomMarginRow(label) {
        const row = new Gtk.Box({ orientation: Gtk.Orientation.HORIZONTAL, spacing: 8, halign: Gtk.Align.CENTER, valign: Gtk.Align.CENTER });
        const lbl = new Gtk.Label({ label, halign: Gtk.Align.END, xalign: 1 });
        lbl.set_size_request(110, -1);
        
        const entry = new Gtk.Entry({ 
            placeholder_text: '0-20',
            width_chars: 8,
            halign: Gtk.Align.CENTER
        });
        
        // Load current value
        const waybarBottomMarginStateFile = GLib.build_filenamev([hyprsunsetStateDir, 'waybar_bottom_margin.state']);
        try {
            let [ok, contents] = GLib.file_get_contents(waybarBottomMarginStateFile);
            if (ok && contents) {
                let value = imports.byteArray.toString(contents).trim();
                entry.set_text(value);
            }
        } catch (e) {
            // Use default value from CSS if state file doesn't exist
            entry.set_text('0.0');
        }
        
        function updateWaybarBottomMargin(value) {
            const waybarStyleFile = GLib.build_filenamev([GLib.get_home_dir(), '.config', 'waybar', 'style.css']);
            
            try {
                let numValue = parseFloat(value);
                if (isNaN(numValue) || numValue < 0 || numValue > 20) {
                    GLib.spawn_command_line_async(`notify-send "Waybar" "Invalid value: ${value}. Use 0-20" -t 2000`);
                    return;
                }
                
                let valueStr = numValue.toFixed(1);
                
                // Update CSS file - margin-bottom
                GLib.spawn_command_line_async(`sed -i '29s/margin-bottom: [0-9.]*px;/margin-bottom: ${valueStr}px;/' '${waybarStyleFile}'`);
                
                // Update state file
                GLib.file_set_contents(waybarBottomMarginStateFile, valueStr);
                
                // Send notification
                GLib.spawn_command_line_async(`notify-send "Waybar" "Bottom-margin: ${valueStr}px" -t 2000`);
            } catch (e) {
                print('Error updating waybar bottom margin: ' + e.message);
            }
        }
        
        entry.connect('activate', () => {
            updateWaybarBottomMargin(entry.get_text());
        });
        
        row.append(lbl);
        row.append(entry);
        rightTogglesBox.append(row);
    }
    
    addWaybarOuterRadiusRow('Waybar Radius');
    addWaybarSideMarginsRow('Waybar Sides');
    addWaybarBottomMarginRow('Waybar Bottom');
    addWaybarTopMarginRow('Waybar Top');

    // --- Swaync Border Size Control (Converted to Input Box) ---
    function addSwayncBorderSizeRow(label) {
        const row = new Gtk.Box({ orientation: Gtk.Orientation.HORIZONTAL, spacing: 8, halign: Gtk.Align.CENTER, valign: Gtk.Align.CENTER });
        const lbl = new Gtk.Label({ label, halign: Gtk.Align.END, xalign: 1 });
        lbl.set_size_request(110, -1);

        const entry = new Gtk.Entry({
            placeholder_text: '0-10',
            width_chars: 8,
            halign: Gtk.Align.CENTER
        });

        // File paths (from existing logic)
        const swayncStyleFile = GLib.build_filenamev([GLib.get_home_dir(), '.config', 'swaync', 'style.css']);
        const swayncBorderSizeStateFile = GLib.build_filenamev([hyprsunsetStateDir, 'swaync_border_size.state']);

        // Load current swaync border size value
        function loadCurrentSwayncBorderSize() {
            try {
                // Try to read from state file first
                let [ok, contents] = GLib.file_get_contents(swayncBorderSizeStateFile);
                if (ok && contents) {
                    let value = imports.byteArray.toString(contents).trim();
                    if (value && !isNaN(parseInt(value))) {
                        return value;
                    }
                }

                // Fallback: read from CSS file
                let [cssOk, cssContents] = GLib.file_get_contents(swayncStyleFile);
                if (cssOk && cssContents) {
                    let content = imports.byteArray.toString(cssContents);
                    // Look for border with @bordercolor (exact logic from existing function)
                    let borderMatch = content.match(/border:\s*([0-9]+)px\s*solid\s*@bordercolor;/);
                    if (borderMatch) {
                        return borderMatch[1];
                    }
                }
            } catch (e) {
                print('Error reading swaync border size: ' + e.message);
            }
            return '2'; // Default value
        }

        // Set initial value
        entry.set_text(loadCurrentSwayncBorderSize());

        function updateSwayncBorderSize(newBorderSize) {
            try {
                let numValue = parseInt(newBorderSize);
                if (isNaN(numValue) || numValue < 0 || numValue > 10) {
                    GLib.spawn_command_line_async(`notify-send "Swaync" "Invalid value: ${newBorderSize}. Use 0-10" -t 2000`);
                    return;
                }

                // Read current value and update (exact logic from existing function)
                let [ok, contents] = GLib.file_get_contents(swayncStyleFile);
                if (ok && contents) {
                    let content = imports.byteArray.toString(contents);

                    // Look specifically for the border in the .control-center section (exact logic)
                    let borderMatch = content.match(/.control-center \s*\{[\s\S]*?border:\s*([0-9]+)px\s*solid\s*@bordercolor;[\s\S]*?\}/);

                    if (!borderMatch) {
                        // Fallback: try to find any border with @bordercolor
                        borderMatch = content.match(/border:\s*([0-9]+)px\s*solid\s*@bordercolor;/);
                    }

                    if (borderMatch) {
                        let currentValue = parseInt(borderMatch[1]);

                        // Update CSS file using the exact current value (exact sed command from existing logic)
                        GLib.spawn_command_line_async(`sed -i '18s/border: ${currentValue}px solid @bordercolor;/border: ${numValue}px solid @bordercolor;/' '${swayncStyleFile}'`);

                        // Update state file
                        GLib.file_set_contents(swayncBorderSizeStateFile, numValue.toString());

                        // Send notification and refresh
                        GLib.spawn_command_line_async(`bash -c 'swaync-client -rs'`);
                        GLib.spawn_command_line_async(`notify-send "Swaync" "Border Size: ${numValue}px" -t 2000`);
                    } else {
                        print('Could not find border pattern in CSS file');
                    }
                }
            } catch (e) {
                print('Error updating swaync border size: ' + e.message);
            }
        }

        entry.connect('activate', () => {
            updateSwayncBorderSize(entry.get_text());
        });

        row.append(lbl);
        row.append(entry);
        rightTogglesBox.append(row);
    }

    addSwayncBorderSizeRow('Swaync Border');

    // --- Swaync Outer Radius Control ---
    function addSwayncOuterRadiusRow(label) {
        const row = new Gtk.Box({ orientation: Gtk.Orientation.HORIZONTAL, spacing: 8, halign: Gtk.Align.CENTER, valign: Gtk.Align.CENTER });
        const lbl = new Gtk.Label({ label, halign: Gtk.Align.END, xalign: 1 });
        lbl.set_size_request(110, -1);

        const entry = new Gtk.Entry({
            placeholder_text: '0-20',
            width_chars: 8,
            halign: Gtk.Align.CENTER
        });

        // Load current value
        const swayncOuterRadiusStateFile = GLib.build_filenamev([hyprsunsetStateDir, 'swaync_outer_radius.state']);
        try {
            let [ok, contents] = GLib.file_get_contents(swayncOuterRadiusStateFile);
            if (ok && contents) {
                let value = imports.byteArray.toString(contents).trim();
                entry.set_text(value);
            }
        } catch (e) {
            // Use default value from CSS if state file doesn't exist
            entry.set_text('10.0');
        }

        function updateSwayncOuterRadius(value) {
            const swayncStyleFile = GLib.build_filenamev([GLib.get_home_dir(), '.config', 'swaync', 'style.css']);

            try {
                let numValue = parseFloat(value);
                if (isNaN(numValue) || numValue < 0 || numValue > 20) {
                    GLib.spawn_command_line_async(`notify-send "Swaync" "Invalid value: ${value}. Use 0-20" -t 2000`);
                    return;
                }

                let valueStr = numValue.toFixed(1);

                // Update CSS file - border-radius
                //GLib.spawn_command_line_async(`sed -i '19s/border-radius: [0-9.]*px;/border-radius: ${valueStr}px;/' '${swayncStyleFile}'`);
                GLib.spawn_command_line_async(`sed -i '19s/border-radius: [0-9.]*px;/border-radius: ${valueStr}px;/' '${swayncStyleFile}'`);

                // Update state file
                GLib.file_set_contents(swayncOuterRadiusStateFile, valueStr);

                // Send notification and refresh
                GLib.spawn_command_line_async(`bash -c 'swaync-client -rs'`);
                GLib.spawn_command_line_async(`notify-send "Swaync" "Radius: ${valueStr}px" -t 2000`);
            } catch (e) {
                print('Error updating swaync outer radius: ' + e.message);
            }
        }

        entry.connect('activate', () => {
            updateSwayncOuterRadius(entry.get_text());
        });

        row.append(lbl);
        row.append(entry);
        rightTogglesBox.append(row);
    }

    addSwayncOuterRadiusRow('Swaync Radius');
    
    rightBox.append(rightTogglesBox);
    mainRow.append(rightBox);
    return mainRow;
}

var exports = {
    createCandyUtilsBox
}; 
EOF

else

cat > "$HOME/.hyprcandy/GJS/src/candy-utils.js" << 'EOF'
imports.gi.versions.Gtk = '4.0';
imports.gi.versions.Gio = '2.0';
imports.gi.versions.GLib = '2.0';
imports.gi.versions.Gdk = '4.0';
const { Gtk, Gio, GLib, Gdk } = imports.gi;

const scriptDir = GLib.path_get_dirname(imports.system.programInvocationName);
imports.searchPath.unshift(scriptDir);

const Weather = imports.weather;

function createCandyUtilsBox() {
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
    // Load user GTK color theme CSS (if available)
    const userColorsProvider = new Gtk.CssProvider();
    try {
        userColorsProvider.load_from_path(GLib.build_filenamev([GLib.get_home_dir(), '.config', 'gtk-3.0', 'colors.css']));
        Gtk.StyleContext.add_provider_for_display(
            Gdk.Display.get_default(),
            userColorsProvider,
            Gtk.STYLE_PROVIDER_PRIORITY_USER
        );
    } catch (e) {
        // Ignore if not found
    }

    // Inject custom CSS for gradient background and frame (no neon border)
    const cssProvider = new Gtk.CssProvider();
    let css = `
        .candy-utils-frame {
            border-radius: 10px;
            min-width: 600px;
            min-height: 320px;
            padding: 0px 0px;
            box-shadow: 0 4px 32px 0 rgba(0,0,0,0.22);
            /*background: linear-gradient(90deg, @on_primary_fixed_variant 0%, @source_color 100%, @source_color 0%, @background 100%);*/
            background-size: cover;
        }
        .weather-temp {
            font-size: 1.8em;
            font-weight: 700;
            color: @primary_fixed_dim;
            text-shadow: 0 0 12px @source_color;
            opacity: 1;
        }
        .neon-highlight, button:hover, button:active {
            box-shadow: 0 0 8px 2px @background, 0 0 0 2px @background inset;
            border-color: @source_color;
            color: @inverse_primary;
        }
    `;
    cssProvider.load_from_data(css, css.length);
    Gtk.StyleContext.add_provider_for_display(
        Gdk.Display.get_default(),
        cssProvider,
        Gtk.STYLE_PROVIDER_PRIORITY_APPLICATION
    );

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
    const hyprsunsetBtn = new Gtk.Button({ label: hyprsunsetEnabled ? 'Hyprsunset 󰌵' : 'Hyprsunset 󰌶' });
    if (hyprsunsetEnabled) hyprsunsetBtn.add_css_class('neon-highlight');
    hyprsunsetBtn.connect('clicked', () => {
        if (!hyprsunsetEnabled) {
            GLib.spawn_command_line_async("bash -c 'hyprsunset &'");
            hyprsunsetBtn.set_label('Hyprsunset 󰌵');
            hyprsunsetBtn.add_css_class('neon-highlight');
            hyprsunsetEnabled = true;
        } else {
            GLib.spawn_command_line_async('pkill hyprsunset');
            hyprsunsetBtn.set_label('Hyprsunset 󰌶');
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
    leftBox.append(hyprsunsetBox);

    // Hyprpicker button
    const hyprpickerBtn = new Gtk.Button({ label: 'Launch Hyprpicker' });
    hyprpickerBtn.connect('clicked', () => {
        GLib.spawn_command_line_async('hyprpicker');
    });
    leftBox.append(hyprpickerBtn);

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
        const configFile = GLib.build_filenamev([GLib.get_home_dir(), '.config', 'hypr', 'hyprviz.conf']);
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
            const configFile = GLib.build_filenamev([GLib.get_home_dir(), '.config', 'hypr', 'hyprviz.conf']);
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
            const configFile = GLib.build_filenamev([GLib.get_home_dir(), '.config', 'hypr', 'hyprviz.conf']);
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
            const configFile = GLib.build_filenamev([GLib.get_home_dir(), '.config', 'hypr', 'hyprviz.conf']);
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
    leftBox.append(opacityBtn);
    
    // Preset buttons
    const presetBox = new Gtk.Box({ orientation: Gtk.Orientation.VERTICAL, spacing: 4, halign: Gtk.Align.CENTER });
    
    // --- Waybar Islands|Bar Toggle Button ---
    const waybarStateFile = GLib.build_filenamev([hyprsunsetStateDir, 'waybar-islands.state']);
    function loadWaybarState() {
        try {
            let [ok, contents] = GLib.file_get_contents(waybarStateFile);
            if (ok && contents) {
                let state = imports.byteArray.toString(contents).trim();
                return state === 'islands';
            }
        } catch (e) {}
        return false; // Default to bar mode
    }
    function saveWaybarState(isIslands) {
        try {
            GLib.file_set_contents(waybarStateFile, isIslands ? 'islands' : 'bar');
        } catch (e) {}
    }
    function toggleWaybarMode(isIslands) {
        const waybarStyleFile = GLib.build_filenamev([GLib.get_home_dir(), '.config', 'waybar', 'style.css']);
        const waybarBorderSizeStateFile = GLib.build_filenamev([hyprsunsetStateDir, 'waybar_border_size.state']);
        
        // Get current border size from state file, default to 2 if not found
        let currentBorderSize = 2;
        try {
            let [ok, contents] = GLib.file_get_contents(waybarBorderSizeStateFile);
            if (ok && contents) {
                let sizeStr = imports.byteArray.toString(contents).trim();
                let size = parseInt(sizeStr);
                if (!isNaN(size)) {
                    currentBorderSize = size;
                }
            }
        } catch (e) {
            // Use default value if state file doesn't exist or can't be read
        }
        
        if (isIslands) {
            // Change to islands mode: no background, no border
            GLib.spawn_command_line_async(`sed -i '25s/background: @blur_background;/background: none;/' '${waybarStyleFile}'`);
            GLib.spawn_command_line_async(`sed -i '32s/border: ${currentBorderSize}px solid @inverse_primary;/border: 0px solid @inverse_primary;/' '${waybarStyleFile}'`);
        } else {
            // Change to bar mode: restore background and border
            GLib.spawn_command_line_async(`sed -i '25s/background: none;/background: @blur_background;/' '${waybarStyleFile}'`);
            GLib.spawn_command_line_async(`sed -i '32s/border: 0px solid @inverse_primary;/border: ${currentBorderSize}px solid @inverse_primary;/' '${waybarStyleFile}'`);
        }
        // Reload waybar
        //GLib.spawn_command_line_async('killall waybar');
        //GLib.spawn_command_line_async('bash -c "waybar &"');
    }
    
    let waybarIslandsEnabled = loadWaybarState();
    const waybarToggleBtn = new Gtk.Button({ label: waybarIslandsEnabled ? 'Waybar ' : 'Waybar ' });
    if (waybarIslandsEnabled) waybarToggleBtn.add_css_class('neon-highlight');
    waybarToggleBtn.connect('clicked', () => {
        waybarIslandsEnabled = !waybarIslandsEnabled;
        toggleWaybarMode(waybarIslandsEnabled);
        if (waybarIslandsEnabled) {
            waybarToggleBtn.set_label('Waybar ');
            waybarToggleBtn.add_css_class('neon-highlight');
        } else {
            waybarToggleBtn.set_label('Waybar ');
            waybarToggleBtn.remove_css_class('neon-highlight');
        }
        saveWaybarState(waybarIslandsEnabled);
    });
    //presetBox.append(waybarToggleBtn);
    
    // --- Waybar Bottom|Top Toggle Button ---
    const waybarConfigFile = GLib.build_filenamev([hyprsunsetStateDir, 'waybar-position.txt']);
    function loadWaybarConfig() {
        try {
            let [ok, contents] = GLib.file_get_contents(waybarConfigFile);
            if (ok && contents) {
                let config = imports.byteArray.toString(contents).trim();
                return config === 'bottom';
            }
        } catch (e) {}
        return false; // Default to top position
    }
    function saveWaybarConfig(isBottom) {
        try {
            GLib.file_set_contents(waybarConfigFile, isBottom ? 'bottom' : 'top');
        } catch (e) {}
    }
    function toggleWaybarSetting(isBottom) {
        const waybarConfigFile = GLib.build_filenamev([GLib.get_home_dir(), '.config', 'waybar', 'config.jsonc']);
        const RofiFile1 = GLib.build_filenamev([GLib.get_home_dir(), '.config', 'rofi', 'bluetooth-menu.rasi']);
        const RofiFile2 = GLib.build_filenamev([GLib.get_home_dir(), '.config', 'rofi', 'power-menu.rasi']);
        const RofiFile3 = GLib.build_filenamev([GLib.get_home_dir(), '.config', 'rofi', 'wifi-menu.rasi']);
        
        if (isBottom) {
            // Change to bottom position:
            GLib.spawn_command_line_async(`sed -i '5s/"position": "top",/"position": "bottom",/' '${waybarConfigFile}'`);
            // Update rofi menu positions
            GLib.spawn_command_line_async(`sed -i '31s/location:                 northeast;/location:                 southeast;/' '${RofiFile1}'`);
            GLib.spawn_command_line_async(`sed -i '31s/location:                 northeast;/location:                 southeast;/' '${RofiFile2}'`);
            GLib.spawn_command_line_async(`sed -i '31s/location:                 northeast;/location:                 southeast;/' '${RofiFile3}'`);
        } else {
            // Change to top position:
            GLib.spawn_command_line_async(`sed -i '5s/"position": "bottom",/"position": "top",/' '${waybarConfigFile}'`);
            // Update rofi menu positions
            GLib.spawn_command_line_async(`sed -i '31s/location:                 southeast;/location:                 northeast;/' '${RofiFile1}'`);
            GLib.spawn_command_line_async(`sed -i '31s/location:                 southeast;/location:                 northeast;/' '${RofiFile2}'`);
            GLib.spawn_command_line_async(`sed -i '31s/location:                 southeast;/location:                 northeast;/' '${RofiFile3}'`);
        }
        // Reload waybar
        //GLib.spawn_command_line_async('killall waybar && sleep 1');
        GLib.spawn_command_line_async('systemctl --user restart waybar.service');
    }
    
    let waybarBottomEnabled = loadWaybarConfig();
    const waybarPositionBtn = new Gtk.Button({ label: waybarBottomEnabled ? 'Waybar ' : 'Waybar ' });
    if (waybarBottomEnabled) waybarPositionBtn.add_css_class('neon-highlight');
    waybarPositionBtn.connect('clicked', () => {
        waybarBottomEnabled = !waybarBottomEnabled;
        toggleWaybarSetting(waybarBottomEnabled);
        if (waybarBottomEnabled) {
            waybarPositionBtn.set_label('Waybar ');
            waybarPositionBtn.add_css_class('neon-highlight');
        } else {
            waybarPositionBtn.set_label('Waybar ');
            waybarPositionBtn.remove_css_class('neon-highlight');
        }
        saveWaybarConfig(waybarBottomEnabled);
    });
    //presetBox.append(waybarPositionBtn);

    // Add new button to cycle dock position
    const changePositionBtn = new Gtk.Button({ label:'Change Dock Position'});
    changePositionBtn.connect('clicked', () => {
      GLib.spawn_command_line_async(`${GLib.get_home_dir()}/.config/hyprcandy/scripts/cycle-dock-position.sh`);
    });
    presetBox.append(changePositionBtn);
    
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

    // Weather box at the bottom of left box
    const weatherBox = Weather.createWeatherBoxForEmbed();
    // Add neon to temp label if possible
    try {
        // Find the temp label by class
        let children = weatherBox.get_children ? weatherBox.get_children() : weatherBox.get_children;
        if (children && children.length > 0) {
            for (let child of children) {
                if (child.get_css_classes && child.get_css_classes().indexOf('weather-temp') !== -1) {
                    child.add_css_class('weather-temp');
                }
            }
        }
    } catch (e) {}
    //leftBox.append(weatherBox);
    
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
        'Light',
        'Dark',
        'Content',
        'Expressive',
        'Neutral',
        'Rainbow',
        'Tonal-spot',
        'Fruit-salad',
        'Vibrant'
    ];
    
    function updateMatugenScheme(schemeName) {
        const waypaperIntegrationFile = GLib.build_filenamev([GLib.get_home_dir(), '.config', 'hyprcandy', 'hooks', 'waypaper_integration.sh']);
        const gtk3File = GLib.build_filenamev([GLib.get_home_dir(), '.config', 'gtk-3.0', 'gtk.css']);
        const gtk4File = GLib.build_filenamev([GLib.get_home_dir(), '.config', 'gtk-4.0', 'gtk.css']);
        const hyprFile = GLib.build_filenamev([GLib.get_home_dir(), '.config', 'hypr', 'hyprviz.conf']);
        const utilsFile = GLib.build_filenamev([GLib.get_home_dir(), '.hyprcandy', 'GJS', 'src', 'candy-utils.js']);
        const waybarFile = GLib.build_filenamev([GLib.get_home_dir(), '.config', 'waybar', 'style.css']);
        const dockFile = GLib.build_filenamev([GLib.get_home_dir(), '.config', 'nwg-dock-hyprland', 'style.css']);
        const swayncFile = GLib.build_filenamev([GLib.get_home_dir(), '.config', 'swaync', 'style.css']);
        
        // Convert scheme name to matugen format
        const schemeMap = {
            'Light': 'scheme-fidelity',
            'Dark': 'scheme-monochrome',
            'Content': 'scheme-content',
            'Expressive': 'scheme-expressive',
            'Fruit-salad': 'scheme-fruit-salad',
            'Neutral': 'scheme-neutral',
            'Rainbow': 'scheme-rainbow',
            'Tonal-spot': 'scheme-tonal-spot',
            'Vibrant': 'scheme-vibrant'
        };
        
        const matugenScheme = schemeMap[schemeName];
        if (!matugenScheme) return;
        
        // Update the waypaper_integration.sh file
        GLib.spawn_command_line_async(`sed -i 's/--type scheme-[^ ]*/--type ${matugenScheme}/' '${waypaperIntegrationFile}'`);
        
        // Handle monochrome vs other schemes for GTK CSS
        if (schemeName === 'Dark') {
            GLib.spawn_command_line_async(`sed -i 's/light/dark/g' '${waypaperIntegrationFile}'`);
            GLib.spawn_command_line_async(`sed -i 's/@on_secondary/@on_primary_fixed_variant/g' '${gtk3File}'`);
            GLib.spawn_command_line_async(`sed -i 's/@on_secondary/@on_primary_fixed_variant/g' '${gtk4File}'`);
            GLib.spawn_command_line_async(`sed -i 's/@primary_fixed_dim/@on_primary_fixed_variant/g' '${gtk3File}'`);
            GLib.spawn_command_line_async(`sed -i 's/@primary_fixed_dim/@on_primary_fixed_variant/g' '${gtk4File}'`);
            GLib.spawn_command_line_async(`sed -i 's/window_fg_color black/window_fg_color white/g' '${gtk4File}'`);
            GLib.spawn_command_line_async(`sed -i 's/view_fg_color black/view_fg_color white/g' '${gtk4File}'`);
            GLib.spawn_command_line_async(`sed -i 's/headerbar_fg_color black/headerbar_fg_color white/g' '${gtk4File}'`);
            GLib.spawn_command_line_async(`sed -i 's/sidebar_fg_color black/sidebar_fg_color white/g' '${gtk4File}'`);
            GLib.spawn_command_line_async(`sed -i 's/card_fg_color black/card_fg_color white/g' '${gtk4File}'`);
            GLib.spawn_command_line_async(`sed -i 's/dialog_fg_color black/dialog_fg_color white/g' '${gtk4File}'`);
            GLib.spawn_command_line_async(`sed -i 's/color: black;/color: white;/g' '${gtk4File}'`);
            GLib.spawn_command_line_async(`sed -i 's/fg_color black;/fg_color white;/g' '${gtk4File}'`);
            GLib.spawn_command_line_async(`sed -i 's/window_fg_color black/window_fg_color white/g' '${gtk3File}'`);
            GLib.spawn_command_line_async(`sed -i 's/view_fg_color black/view_fg_color white/g' '${gtk3File}'`);
            GLib.spawn_command_line_async(`sed -i 's/headerbar_fg_color black/headerbar_fg_color white/g' '${gtk3File}'`);
            GLib.spawn_command_line_async(`sed -i 's/sidebar_fg_color black/sidebar_fg_color white/g' '${gtk3File}'`);
            GLib.spawn_command_line_async(`sed -i 's/card_fg_color black/card_fg_color white/g' '${gtk3File}'`);
            GLib.spawn_command_line_async(`sed -i 's/dialog_fg_color black/dialog_fg_color white/g' '${gtk3File}'`);
            GLib.spawn_command_line_async(`sed -i 's/color: black;/color: white;/g' '${gtk3File}'`);
            GLib.spawn_command_line_async(`sed -i 's/fg_color black;/fg_color white;/g' '${gtk3File}'`);
            /*GLib.spawn_command_line_async(`sed -i 's/accent_color @primary/accent_color @on_primary/g' '${gtk4File}'`);
            GLib.spawn_command_line_async(`sed -i 's/accent_bg_color @primary/accent_bg_color @on_primary/g' '${gtk4File}'`);
            GLib.spawn_command_line_async(`sed -i 's/accent_fg_color @on_primary/accent_fg_color @primary/g' '${gtk4File}'`);
            GLib.spawn_command_line_async(`sed -i 's/accent_color @primary/accent_color @on_primary/g' '${gtk3File}'`);
            GLib.spawn_command_line_async(`sed -i 's/accent_bg_color @primary/accent_bg_color @on_primary/g' '${gtk3File}'`);
            GLib.spawn_command_line_async(`sed -i 's/accent_fg_color @on_primary/accent_fg_color @primary/g' '${gtk3File}'`);*/
            GLib.spawn_command_line_async(`sed -i 's/color: @inverse_primary;/color: @main-fg;/g' '${waybarFile}'`);
            GLib.spawn_command_line_async(`sed -i 's/color: @primary;/color: @primary_fixed_dim;/g' '${waybarFile}'`);
            //GLib.spawn_command_line_async(`sed -i '483s/solid @primary_fixed_dim;/solid @inverse_primary;/g; 487s/solid @primary_fixed_dim;/solid @inverse_primary;/g; 2382s/solid @primary_fixed_dim;/solid @inverse_primary;/g' '${utilsFile}'`);
            GLib.spawn_command_line_async(`sed -i 's/@inverse_primary, @primary_fixed_dim/@inverse_primary, @scrim/g' '${waybarFile}'`);
            GLib.spawn_command_line_async(`sed -i '8s/@primary_fixed_dim;/@inverse_primary;/g' '${dockFile}'`);
            GLib.spawn_command_line_async(`sed -i '7s/@primary_fixed_dim;/@inverse_primary;/g' '${swayncFile}'`);
            //GLib.spawn_command_line_async(`bash -c '$HOME/.config/hyprcandy/scripts/toggle-dock.sh --relaunch'`);
            GLib.spawn_command_line_async(`bash -c 'swaync-client -rs'`);
        }
        
        if (schemeName === 'Light') {
            GLib.spawn_command_line_async(`sed -i 's/dark/light/g' '${waypaperIntegrationFile}'`);
            /*GLib.spawn_command_line_async(`sed -i 's/@on_secondary/@primary/g' '${gtk3File}'`);
            GLib.spawn_command_line_async(`sed -i 's/@on_secondary/@primary/g' '${gtk4File}'`);
            GLib.spawn_command_line_async(`sed -i 's/@on_primary_fixed_variant/@primary_fixed_dim/g' '${gtk3File}'`);
            GLib.spawn_command_line_async(`sed -i 's/@on_primary_fixed_variant/@primary_fixed_dim/g' '${gtk4File}'`);*/
            GLib.spawn_command_line_async(`sed -i 's/window_fg_color white/window_fg_color black/g' '${gtk4File}'`);
            GLib.spawn_command_line_async(`sed -i 's/view_fg_color white/view_fg_color black/g' '${gtk4File}'`);
            GLib.spawn_command_line_async(`sed -i 's/headerbar_fg_color white/headerbar_fg_color black/g' '${gtk4File}'`);
            GLib.spawn_command_line_async(`sed -i 's/sidebar_fg_color white/sidebar_fg_color black/g' '${gtk4File}'`);
            GLib.spawn_command_line_async(`sed -i 's/card_fg_color white/card_fg_color black/g' '${gtk4File}'`);
            GLib.spawn_command_line_async(`sed -i 's/dialog_fg_color white/dialog_fg_color black/g' '${gtk4File}'`);
            GLib.spawn_command_line_async(`sed -i 's/color: white;/color: black;/g' '${gtk4File}'`);
            GLib.spawn_command_line_async(`sed -i 's/fg_color white;/fg_color black;/g' '${gtk4File}'`);
            GLib.spawn_command_line_async(`sed -i 's/window_fg_color white/window_fg_color black/g' '${gtk3File}'`);
            GLib.spawn_command_line_async(`sed -i 's/view_fg_color white/view_fg_color black/g' '${gtk3File}'`);
            GLib.spawn_command_line_async(`sed -i 's/headerbar_fg_color white/headerbar_fg_color black/g' '${gtk3File}'`);
            GLib.spawn_command_line_async(`sed -i 's/sidebar_fg_color white/sidebar_fg_color black/g' '${gtk3File}'`);
            GLib.spawn_command_line_async(`sed -i 's/card_fg_color white/card_fg_color black/g' '${gtk3File}'`);
            GLib.spawn_command_line_async(`sed -i 's/dialog_fg_color white/dialog_fg_color black/g' '${gtk3File}'`);
            GLib.spawn_command_line_async(`sed -i 's/color: white;/color: black;/g' '${gtk3File}'`);
            GLib.spawn_command_line_async(`sed -i 's/fg_color white;/fg_color black;/g' '${gtk3File}'`);
            /*GLib.spawn_command_line_async(`sed -i 's/accent_color @primary/accent_color @on_primary/g' '${gtk4File}'`);
            GLib.spawn_command_line_async(`sed -i 's/accent_bg_color @primary/accent_bg_color @on_primary/g' '${gtk4File}'`);
            GLib.spawn_command_line_async(`sed -i 's/accent_fg_color @on_primary/accent_fg_color @primary/g' '${gtk4File}'`);
            GLib.spawn_command_line_async(`sed -i 's/accent_color @primary/accent_color @on_primary/g' '${gtk3File}'`);
            GLib.spawn_command_line_async(`sed -i 's/accent_bg_color @primary/accent_bg_color @on_primary/g' '${gtk3File}'`);
            GLib.spawn_command_line_async(`sed -i 's/accent_fg_color @on_primary/accent_fg_color @primary/g' '${gtk3File}'`);*/
            GLib.spawn_command_line_async(`sed -i 's/color: @main-fg;/color: @inverse_primary;/g' '${waybarFile}'`);
            GLib.spawn_command_line_async(`sed -i 's/color: @primary_fixed_dim;/color: @primary;/g' '${waybarFile}'`);
            //GLib.spawn_command_line_async(`sed -i '483s/solid @inverse_primary;/solid @primary_fixed_dim;/g; 487s/solid @inverse_primary;/solid @primary_fixed_dim;/g; 2382s/solid @inverse_primary;/solid @primary_fixed_dim;/g' '${utilsFile}'`);
            GLib.spawn_command_line_async(`sed -i 's/@inverse_primary, @scrim/@inverse_primary, @primary_fixed_dim/g' '${waybarFile}'`);
            GLib.spawn_command_line_async(`sed -i '8s/@primary_fixed_dim;/@inverse_primary;/g' '${dockFile}'`);
            GLib.spawn_command_line_async(`sed -i '7s/@primary_fixed_dim;/@inverse_primary;/g' '${swayncFile}'`);
            //GLib.spawn_command_line_async(`bash -c '$HOME/.config/hyprcandy/scripts/toggle-dock.sh --relaunch'`);
            GLib.spawn_command_line_async(`bash -c 'swaync-client -rs'`);
        }
        
        if (schemeName === 'Content') {
            GLib.spawn_command_line_async(`sed -i 's/light/dark/g' '${waypaperIntegrationFile}'`);
            GLib.spawn_command_line_async(`sed -i 's/@on_primary_fixed_variant/@on_secondary/g' '${gtk3File}'`);
            GLib.spawn_command_line_async(`sed -i 's/@on_primary_fixed_variant/@on_secondary/g' '${gtk4File}'`);
            GLib.spawn_command_line_async(`sed -i 's/@primary_fixed_dim/@on_secondary/g' '${gtk3File}'`);
            GLib.spawn_command_line_async(`sed -i 's/@primary_fixed_dim/@on_secondary/g' '${gtk4File}'`);
            GLib.spawn_command_line_async(`sed -i 's/window_fg_color black/window_fg_color white/g' '${gtk4File}'`);
            GLib.spawn_command_line_async(`sed -i 's/view_fg_color black/view_fg_color white/g' '${gtk4File}'`);
            GLib.spawn_command_line_async(`sed -i 's/headerbar_fg_color black/headerbar_fg_color white/g' '${gtk4File}'`);
            GLib.spawn_command_line_async(`sed -i 's/sidebar_fg_color black/sidebar_fg_color white/g' '${gtk4File}'`);
            GLib.spawn_command_line_async(`sed -i 's/card_fg_color black/card_fg_color white/g' '${gtk4File}'`);
            GLib.spawn_command_line_async(`sed -i 's/dialog_fg_color black/dialog_fg_color white/g' '${gtk4File}'`);
            GLib.spawn_command_line_async(`sed -i 's/color: black;/color: white;/g' '${gtk4File}'`);
            GLib.spawn_command_line_async(`sed -i 's/fg_color black;/fg_color white;/g' '${gtk4File}'`);
            GLib.spawn_command_line_async(`sed -i 's/window_fg_color black/window_fg_color white/g' '${gtk3File}'`);
            GLib.spawn_command_line_async(`sed -i 's/view_fg_color black/view_fg_color white/g' '${gtk3File}'`);
            GLib.spawn_command_line_async(`sed -i 's/headerbar_fg_color black/headerbar_fg_color white/g' '${gtk3File}'`);
            GLib.spawn_command_line_async(`sed -i 's/sidebar_fg_color black/sidebar_fg_color white/g' '${gtk3File}'`);
            GLib.spawn_command_line_async(`sed -i 's/card_fg_color black/card_fg_color white/g' '${gtk3File}'`);
            GLib.spawn_command_line_async(`sed -i 's/dialog_fg_color black/dialog_fg_color white/g' '${gtk3File}'`);
            GLib.spawn_command_line_async(`sed -i 's/color: black;/color: white;/g' '${gtk3File}'`);
            GLib.spawn_command_line_async(`sed -i 's/fg_color black;/fg_color white;/g' '${gtk3File}'`);
            /*GLib.spawn_command_line_async(`sed -i 's/accent_color @primary/accent_color @on_primary/g' '${gtk4File}'`);
            GLib.spawn_command_line_async(`sed -i 's/accent_bg_color @primary/accent_bg_color @on_primary/g' '${gtk4File}'`);
            GLib.spawn_command_line_async(`sed -i 's/accent_fg_color @on_primary/accent_fg_color @primary/g' '${gtk4File}'`);
            GLib.spawn_command_line_async(`sed -i 's/accent_color @primary/accent_color @on_primary/g' '${gtk3File}'`);
            GLib.spawn_command_line_async(`sed -i 's/accent_bg_color @primary/accent_bg_color @on_primary/g' '${gtk3File}'`);
            GLib.spawn_command_line_async(`sed -i 's/accent_fg_color @on_primary/accent_fg_color @primary/g' '${gtk3File}'`);*/
            GLib.spawn_command_line_async(`sed -i 's/color: @inverse_primary;/color: @main-fg;/g' '${waybarFile}'`);
            GLib.spawn_command_line_async(`sed -i 's/color: @primary;/color: @primary_fixed_dim;/g' '${waybarFile}'`);
            //GLib.spawn_command_line_async(`sed -i '483s/solid @primary_fixed_dim;/solid @inverse_primary;/g; 487s/solid @primary_fixed_dim;/solid @inverse_primary;/g; 2382s/solid @primary_fixed_dim;/solid @inverse_primary;/g' '${utilsFile}'`);
            GLib.spawn_command_line_async(`sed -i 's/@inverse_primary, @primary_fixed_dim/@inverse_primary, @scrim/g' '${waybarFile}'`);
            GLib.spawn_command_line_async(`sed -i '8s/@primary_fixed_dim;/@inverse_primary;/g' '${dockFile}'`);
            GLib.spawn_command_line_async(`sed -i '7s/@primary_fixed_dim;/@inverse_primary;/g' '${swayncFile}'`);
            //GLib.spawn_command_line_async(`bash -c '$HOME/.config/hyprcandy/scripts/toggle-dock.sh --relaunch'`);
            GLib.spawn_command_line_async(`bash -c 'swaync-client -rs'`);
        }
        
        if (schemeName === 'Expressive') {
            GLib.spawn_command_line_async(`sed -i 's/light/dark/g' '${waypaperIntegrationFile}'`);
            GLib.spawn_command_line_async(`sed -i 's/@on_primary_fixed_variant/@on_secondary/g' '${gtk3File}'`);
            GLib.spawn_command_line_async(`sed -i 's/@on_primary_fixed_variant/@on_secondary/g' '${gtk4File}'`);
            GLib.spawn_command_line_async(`sed -i 's/@primary_fixed_dim/@on_secondary/g' '${gtk3File}'`);
            GLib.spawn_command_line_async(`sed -i 's/@primary_fixed_dim/@on_secondary/g' '${gtk4File}'`);
            GLib.spawn_command_line_async(`sed -i 's/window_fg_color black/window_fg_color white/g' '${gtk4File}'`);
            GLib.spawn_command_line_async(`sed -i 's/view_fg_color black/view_fg_color white/g' '${gtk4File}'`);
            GLib.spawn_command_line_async(`sed -i 's/headerbar_fg_color black/headerbar_fg_color white/g' '${gtk4File}'`);
            GLib.spawn_command_line_async(`sed -i 's/sidebar_fg_color black/sidebar_fg_color white/g' '${gtk4File}'`);
            GLib.spawn_command_line_async(`sed -i 's/card_fg_color black/card_fg_color white/g' '${gtk4File}'`);
            GLib.spawn_command_line_async(`sed -i 's/dialog_fg_color black/dialog_fg_color white/g' '${gtk4File}'`);
            GLib.spawn_command_line_async(`sed -i 's/color: black;/color: white;/g' '${gtk4File}'`);
            GLib.spawn_command_line_async(`sed -i 's/fg_color black;/fg_color white;/g' '${gtk4File}'`);
            GLib.spawn_command_line_async(`sed -i 's/window_fg_color black/window_fg_color white/g' '${gtk3File}'`);
            GLib.spawn_command_line_async(`sed -i 's/view_fg_color black/view_fg_color white/g' '${gtk3File}'`);
            GLib.spawn_command_line_async(`sed -i 's/headerbar_fg_color black/headerbar_fg_color white/g' '${gtk3File}'`);
            GLib.spawn_command_line_async(`sed -i 's/sidebar_fg_color black/sidebar_fg_color white/g' '${gtk3File}'`);
            GLib.spawn_command_line_async(`sed -i 's/card_fg_color black/card_fg_color white/g' '${gtk3File}'`);
            GLib.spawn_command_line_async(`sed -i 's/dialog_fg_color black/dialog_fg_color white/g' '${gtk3File}'`);
            GLib.spawn_command_line_async(`sed -i 's/color: black;/color: white;/g' '${gtk3File}'`);
            GLib.spawn_command_line_async(`sed -i 's/fg_color black;/fg_color white;/g' '${gtk3File}'`);
            /*GLib.spawn_command_line_async(`sed -i 's/accent_color @primary/accent_color @on_primary/g' '${gtk4File}'`);
            GLib.spawn_command_line_async(`sed -i 's/accent_bg_color @primary/accent_bg_color @on_primary/g' '${gtk4File}'`);
            GLib.spawn_command_line_async(`sed -i 's/accent_fg_color @on_primary/accent_fg_color @primary/g' '${gtk4File}'`);
            GLib.spawn_command_line_async(`sed -i 's/accent_color @primary/accent_color @on_primary/g' '${gtk3File}'`);
            GLib.spawn_command_line_async(`sed -i 's/accent_bg_color @primary/accent_bg_color @on_primary/g' '${gtk3File}'`);
            GLib.spawn_command_line_async(`sed -i 's/accent_fg_color @on_primary/accent_fg_color @primary/g' '${gtk3File}'`);*/
            GLib.spawn_command_line_async(`sed -i 's/color: @inverse_primary;/color: @main-fg;/g' '${waybarFile}'`);
            GLib.spawn_command_line_async(`sed -i 's/color: @primary;/color: @primary_fixed_dim;/g' '${waybarFile}'`);
            //GLib.spawn_command_line_async(`sed -i '483s/solid @primary_fixed_dim;/solid @inverse_primary;/g; 487s/solid @primary_fixed_dim;/solid @inverse_primary;/g; 2382s/solid @primary_fixed_dim;/solid @inverse_primary;/g' '${utilsFile}'`);
            GLib.spawn_command_line_async(`sed -i 's/@inverse_primary, @primary_fixed_dim/@inverse_primary, @scrim/g' '${waybarFile}'`);
            GLib.spawn_command_line_async(`sed -i '8s/@primary_fixed_dim;/@inverse_primary;/g' '${dockFile}'`);
            GLib.spawn_command_line_async(`sed -i '7s/@primary_fixed_dim;/@inverse_primary;/g' '${swayncFile}'`);
            //GLib.spawn_command_line_async(`bash -c '$HOME/.config/hyprcandy/scripts/toggle-dock.sh --relaunch'`);
            GLib.spawn_command_line_async(`bash -c 'swaync-client -rs'`);
        }
        
        if (schemeName === 'Fruit-salad') {
            GLib.spawn_command_line_async(`sed -i 's/light/dark/g' '${waypaperIntegrationFile}'`);
            GLib.spawn_command_line_async(`sed -i 's/@on_primary_fixed_variant/@on_secondary/g' '${gtk3File}'`);
            GLib.spawn_command_line_async(`sed -i 's/@on_primary_fixed_variant/@on_secondary/g' '${gtk4File}'`);
            GLib.spawn_command_line_async(`sed -i 's/@primary_fixed_dim/@on_secondary/g' '${gtk3File}'`);
            GLib.spawn_command_line_async(`sed -i 's/@primary_fixed_dim/@on_secondary/g' '${gtk4File}'`);
            GLib.spawn_command_line_async(`sed -i 's/window_fg_color black/window_fg_color white/g' '${gtk4File}'`);
            GLib.spawn_command_line_async(`sed -i 's/view_fg_color black/view_fg_color white/g' '${gtk4File}'`);
            GLib.spawn_command_line_async(`sed -i 's/headerbar_fg_color black/headerbar_fg_color white/g' '${gtk4File}'`);
            GLib.spawn_command_line_async(`sed -i 's/sidebar_fg_color black/sidebar_fg_color white/g' '${gtk4File}'`);
            GLib.spawn_command_line_async(`sed -i 's/card_fg_color black/card_fg_color white/g' '${gtk4File}'`);
            GLib.spawn_command_line_async(`sed -i 's/dialog_fg_color black/dialog_fg_color white/g' '${gtk4File}'`);
            GLib.spawn_command_line_async(`sed -i 's/color: black;/color: white;/g' '${gtk4File}'`);
            GLib.spawn_command_line_async(`sed -i 's/fg_color black;/fg_color white;/g' '${gtk4File}'`);
            GLib.spawn_command_line_async(`sed -i 's/window_fg_color black/window_fg_color white/g' '${gtk3File}'`);
            GLib.spawn_command_line_async(`sed -i 's/view_fg_color black/view_fg_color white/g' '${gtk3File}'`);
            GLib.spawn_command_line_async(`sed -i 's/headerbar_fg_color black/headerbar_fg_color white/g' '${gtk3File}'`);
            GLib.spawn_command_line_async(`sed -i 's/sidebar_fg_color black/sidebar_fg_color white/g' '${gtk3File}'`);
            GLib.spawn_command_line_async(`sed -i 's/card_fg_color black/card_fg_color white/g' '${gtk3File}'`);
            GLib.spawn_command_line_async(`sed -i 's/dialog_fg_color black/dialog_fg_color white/g' '${gtk3File}'`);
            GLib.spawn_command_line_async(`sed -i 's/color: black;/color: white;/g' '${gtk3File}'`);
            GLib.spawn_command_line_async(`sed -i 's/fg_color black;/fg_color white;/g' '${gtk3File}'`);
            /*GLib.spawn_command_line_async(`sed -i 's/accent_color @primary/accent_color @on_primary/g' '${gtk4File}'`);
            GLib.spawn_command_line_async(`sed -i 's/accent_bg_color @primary/accent_bg_color @on_primary/g' '${gtk4File}'`);
            GLib.spawn_command_line_async(`sed -i 's/accent_fg_color @on_primary/accent_fg_color @primary/g' '${gtk4File}'`);
            GLib.spawn_command_line_async(`sed -i 's/accent_color @primary/accent_color @on_primary/g' '${gtk3File}'`);
            GLib.spawn_command_line_async(`sed -i 's/accent_bg_color @primary/accent_bg_color @on_primary/g' '${gtk3File}'`);
            GLib.spawn_command_line_async(`sed -i 's/accent_fg_color @on_primary/accent_fg_color @primary/g' '${gtk3File}'`);*/
            GLib.spawn_command_line_async(`sed -i 's/color: @inverse_primary;/color: @main-fg;/g' '${waybarFile}'`);
            GLib.spawn_command_line_async(`sed -i 's/color: @primary;/color: @primary_fixed_dim;/g' '${waybarFile}'`);
            //GLib.spawn_command_line_async(`sed -i '483s/solid @primary_fixed_dim;/solid @inverse_primary;/g; 487s/solid @primary_fixed_dim;/solid @inverse_primary;/g; 2382s/solid @primary_fixed_dim;/solid @inverse_primary;/g' '${utilsFile}'`);
            GLib.spawn_command_line_async(`sed -i 's/@inverse_primary, @primary_fixed_dim/@inverse_primary, @scrim/g' '${waybarFile}'`);
            GLib.spawn_command_line_async(`sed -i '8s/@primary_fixed_dim;/@inverse_primary;/g' '${dockFile}'`);
            GLib.spawn_command_line_async(`sed -i '7s/@primary_fixed_dim;/@inverse_primary;/g' '${swayncFile}'`);
            //GLib.spawn_command_line_async(`bash -c '$HOME/.config/hyprcandy/scripts/toggle-dock.sh --relaunch'`);
            GLib.spawn_command_line_async(`bash -c 'swaync-client -rs'`);
        }
        
        if (schemeName === 'Neutral') {
            GLib.spawn_command_line_async(`sed -i 's/light/dark/g' '${waypaperIntegrationFile}'`);
            GLib.spawn_command_line_async(`sed -i 's/@on_primary_fixed_variant/@on_secondary/g' '${gtk3File}'`);
            GLib.spawn_command_line_async(`sed -i 's/@on_primary_fixed_variant/@on_secondary/g' '${gtk4File}'`);
            GLib.spawn_command_line_async(`sed -i 's/@primary_fixed_dim/@on_secondary/g' '${gtk3File}'`);
            GLib.spawn_command_line_async(`sed -i 's/@primary_fixed_dim/@on_secondary/g' '${gtk4File}'`);
            GLib.spawn_command_line_async(`sed -i 's/window_fg_color black/window_fg_color white/g' '${gtk4File}'`);
            GLib.spawn_command_line_async(`sed -i 's/view_fg_color black/view_fg_color white/g' '${gtk4File}'`);
            GLib.spawn_command_line_async(`sed -i 's/headerbar_fg_color black/headerbar_fg_color white/g' '${gtk4File}'`);
            GLib.spawn_command_line_async(`sed -i 's/sidebar_fg_color black/sidebar_fg_color white/g' '${gtk4File}'`);
            GLib.spawn_command_line_async(`sed -i 's/card_fg_color black/card_fg_color white/g' '${gtk4File}'`);
            GLib.spawn_command_line_async(`sed -i 's/dialog_fg_color black/dialog_fg_color white/g' '${gtk4File}'`);
            GLib.spawn_command_line_async(`sed -i 's/color: black;/color: white;/g' '${gtk4File}'`);
            GLib.spawn_command_line_async(`sed -i 's/fg_color black;/fg_color white;/g' '${gtk4File}'`);
            GLib.spawn_command_line_async(`sed -i 's/window_fg_color black/window_fg_color white/g' '${gtk3File}'`);
            GLib.spawn_command_line_async(`sed -i 's/view_fg_color black/view_fg_color white/g' '${gtk3File}'`);
            GLib.spawn_command_line_async(`sed -i 's/headerbar_fg_color black/headerbar_fg_color white/g' '${gtk3File}'`);
            GLib.spawn_command_line_async(`sed -i 's/sidebar_fg_color black/sidebar_fg_color white/g' '${gtk3File}'`);
            GLib.spawn_command_line_async(`sed -i 's/card_fg_color black/card_fg_color white/g' '${gtk3File}'`);
            GLib.spawn_command_line_async(`sed -i 's/dialog_fg_color black/dialog_fg_color white/g' '${gtk3File}'`);
            GLib.spawn_command_line_async(`sed -i 's/color: black;/color: white;/g' '${gtk3File}'`);
            GLib.spawn_command_line_async(`sed -i 's/fg_color black;/fg_color white;/g' '${gtk3File}'`);
            /*GLib.spawn_command_line_async(`sed -i 's/accent_color @primary/accent_color @on_primary/g' '${gtk4File}'`);
            GLib.spawn_command_line_async(`sed -i 's/accent_bg_color @primary/accent_bg_color @on_primary/g' '${gtk4File}'`);
            GLib.spawn_command_line_async(`sed -i 's/accent_fg_color @on_primary/accent_fg_color @primary/g' '${gtk4File}'`);
            GLib.spawn_command_line_async(`sed -i 's/accent_color @primary/accent_color @on_primary/g' '${gtk3File}'`);
            GLib.spawn_command_line_async(`sed -i 's/accent_bg_color @primary/accent_bg_color @on_primary/g' '${gtk3File}'`);
            GLib.spawn_command_line_async(`sed -i 's/accent_fg_color @on_primary/accent_fg_color @primary/g' '${gtk3File}'`);*/
            GLib.spawn_command_line_async(`sed -i 's/color: @inverse_primary;/color: @main-fg;/g' '${waybarFile}'`);
            GLib.spawn_command_line_async(`sed -i 's/color: @primary;/color: @primary_fixed_dim;/g' '${waybarFile}'`);
            //GLib.spawn_command_line_async(`sed -i '483s/solid @primary_fixed_dim;/solid @inverse_primary;/g; 487s/solid @primary_fixed_dim;/solid @inverse_primary;/g; 2382s/solid @primary_fixed_dim;/solid @inverse_primary;/g' '${utilsFile}'`);
            GLib.spawn_command_line_async(`sed -i 's/@inverse_primary, @primary_fixed_dim/@inverse_primary, @scrim/g' '${waybarFile}'`);
            GLib.spawn_command_line_async(`sed -i '8s/@primary_fixed_dim;/@inverse_primary;/g' '${dockFile}'`);
            GLib.spawn_command_line_async(`sed -i '7s/@primary_fixed_dim;/@inverse_primary;/g' '${swayncFile}'`);
            //GLib.spawn_command_line_async(`bash -c '$HOME/.config/hyprcandy/scripts/toggle-dock.sh --relaunch'`);
            GLib.spawn_command_line_async(`bash -c 'swaync-client -rs'`);
        }
        
        if (schemeName === 'Rainbow') {
            GLib.spawn_command_line_async(`sed -i 's/light/dark/g' '${waypaperIntegrationFile}'`);
            GLib.spawn_command_line_async(`sed -i 's/@on_primary_fixed_variant/@on_secondary/g' '${gtk3File}'`);
            GLib.spawn_command_line_async(`sed -i 's/@on_primary_fixed_variant/@on_secondary/g' '${gtk4File}'`);
            GLib.spawn_command_line_async(`sed -i 's/@primary_fixed_dim/@on_secondary/g' '${gtk3File}'`);
            GLib.spawn_command_line_async(`sed -i 's/@primary_fixed_dim/@on_secondary/g' '${gtk4File}'`);
            GLib.spawn_command_line_async(`sed -i 's/window_fg_color black/window_fg_color white/g' '${gtk4File}'`);
            GLib.spawn_command_line_async(`sed -i 's/view_fg_color black/view_fg_color white/g' '${gtk4File}'`);
            GLib.spawn_command_line_async(`sed -i 's/headerbar_fg_color black/headerbar_fg_color white/g' '${gtk4File}'`);
            GLib.spawn_command_line_async(`sed -i 's/sidebar_fg_color black/sidebar_fg_color white/g' '${gtk4File}'`);
            GLib.spawn_command_line_async(`sed -i 's/card_fg_color black/card_fg_color white/g' '${gtk4File}'`);
            GLib.spawn_command_line_async(`sed -i 's/dialog_fg_color black/dialog_fg_color white/g' '${gtk4File}'`);
            GLib.spawn_command_line_async(`sed -i 's/color: black;/color: white;/g' '${gtk4File}'`);
            GLib.spawn_command_line_async(`sed -i 's/fg_color black;/fg_color white;/g' '${gtk4File}'`);
            GLib.spawn_command_line_async(`sed -i 's/window_fg_color black/window_fg_color white/g' '${gtk3File}'`);
            GLib.spawn_command_line_async(`sed -i 's/view_fg_color black/view_fg_color white/g' '${gtk3File}'`);
            GLib.spawn_command_line_async(`sed -i 's/headerbar_fg_color black/headerbar_fg_color white/g' '${gtk3File}'`);
            GLib.spawn_command_line_async(`sed -i 's/sidebar_fg_color black/sidebar_fg_color white/g' '${gtk3File}'`);
            GLib.spawn_command_line_async(`sed -i 's/card_fg_color black/card_fg_color white/g' '${gtk3File}'`);
            GLib.spawn_command_line_async(`sed -i 's/dialog_fg_color black/dialog_fg_color white/g' '${gtk3File}'`);
            GLib.spawn_command_line_async(`sed -i 's/color: black;/color: white;/g' '${gtk3File}'`);
            GLib.spawn_command_line_async(`sed -i 's/fg_color black;/fg_color white;/g' '${gtk3File}'`);
            /*GLib.spawn_command_line_async(`sed -i 's/accent_color @primary/accent_color @on_primary/g' '${gtk4File}'`);
            GLib.spawn_command_line_async(`sed -i 's/accent_bg_color @primary/accent_bg_color @on_primary/g' '${gtk4File}'`);
            GLib.spawn_command_line_async(`sed -i 's/accent_fg_color @on_primary/accent_fg_color @primary/g' '${gtk4File}'`);
            GLib.spawn_command_line_async(`sed -i 's/accent_color @primary/accent_color @on_primary/g' '${gtk3File}'`);
            GLib.spawn_command_line_async(`sed -i 's/accent_bg_color @primary/accent_bg_color @on_primary/g' '${gtk3File}'`);
            GLib.spawn_command_line_async(`sed -i 's/accent_fg_color @on_primary/accent_fg_color @primary/g' '${gtk3File}'`);*/
            GLib.spawn_command_line_async(`sed -i 's/color: @inverse_primary;/color: @main-fg;/g' '${waybarFile}'`);
            GLib.spawn_command_line_async(`sed -i 's/color: @primary;/color: @primary_fixed_dim;/g' '${waybarFile}'`);
            //GLib.spawn_command_line_async(`sed -i '483s/solid @primary_fixed_dim;/solid @inverse_primary;/g; 487s/solid @primary_fixed_dim;/solid @inverse_primary;/g; 2382s/solid @primary_fixed_dim;/solid @inverse_primary;/g' '${utilsFile}'`);
            GLib.spawn_command_line_async(`sed -i 's/@inverse_primary, @primary_fixed_dim/@inverse_primary, @scrim/g' '${waybarFile}'`);
            GLib.spawn_command_line_async(`sed -i '8s/@primary_fixed_dim;/@inverse_primary;/g' '${dockFile}'`);
            GLib.spawn_command_line_async(`sed -i '7s/@primary_fixed_dim;/@inverse_primary;/g' '${swayncFile}'`);
            //GLib.spawn_command_line_async(`bash -c '$HOME/.config/hyprcandy/scripts/toggle-dock.sh --relaunch'`);
            GLib.spawn_command_line_async(`bash -c 'swaync-client -rs'`);
        }
        
        if (schemeName === 'Tonal-spot') {
            GLib.spawn_command_line_async(`sed -i 's/light/dark/g' '${waypaperIntegrationFile}'`);
            GLib.spawn_command_line_async(`sed -i 's/@on_primary_fixed_variant/@on_secondary/g' '${gtk3File}'`);
            GLib.spawn_command_line_async(`sed -i 's/@on_primary_fixed_variant/@on_secondary/g' '${gtk4File}'`);
            GLib.spawn_command_line_async(`sed -i 's/@primary_fixed_dim/@on_secondary/g' '${gtk3File}'`);
            GLib.spawn_command_line_async(`sed -i 's/@primary_fixed_dim/@on_secondary/g' '${gtk4File}'`);
            GLib.spawn_command_line_async(`sed -i 's/window_fg_color black/window_fg_color white/g' '${gtk4File}'`);
            GLib.spawn_command_line_async(`sed -i 's/view_fg_color black/view_fg_color white/g' '${gtk4File}'`);
            GLib.spawn_command_line_async(`sed -i 's/headerbar_fg_color black/headerbar_fg_color white/g' '${gtk4File}'`);
            GLib.spawn_command_line_async(`sed -i 's/sidebar_fg_color black/sidebar_fg_color white/g' '${gtk4File}'`);
            GLib.spawn_command_line_async(`sed -i 's/card_fg_color black/card_fg_color white/g' '${gtk4File}'`);
            GLib.spawn_command_line_async(`sed -i 's/dialog_fg_color black/dialog_fg_color white/g' '${gtk4File}'`);
            GLib.spawn_command_line_async(`sed -i 's/color: black;/color: white;/g' '${gtk4File}'`);
            GLib.spawn_command_line_async(`sed -i 's/fg_color black;/fg_color white;/g' '${gtk4File}'`);
            GLib.spawn_command_line_async(`sed -i 's/window_fg_color black/window_fg_color white/g' '${gtk3File}'`);
            GLib.spawn_command_line_async(`sed -i 's/view_fg_color black/view_fg_color white/g' '${gtk3File}'`);
            GLib.spawn_command_line_async(`sed -i 's/headerbar_fg_color black/headerbar_fg_color white/g' '${gtk3File}'`);
            GLib.spawn_command_line_async(`sed -i 's/sidebar_fg_color black/sidebar_fg_color white/g' '${gtk3File}'`);
            GLib.spawn_command_line_async(`sed -i 's/card_fg_color black/card_fg_color white/g' '${gtk3File}'`);
            GLib.spawn_command_line_async(`sed -i 's/dialog_fg_color black/dialog_fg_color white/g' '${gtk3File}'`);
            GLib.spawn_command_line_async(`sed -i 's/color: black;/color: white;/g' '${gtk3File}'`);
            GLib.spawn_command_line_async(`sed -i 's/fg_color black;/fg_color white;/g' '${gtk3File}'`);
            /*GLib.spawn_command_line_async(`sed -i 's/accent_color @primary/accent_color @on_primary/g' '${gtk4File}'`);
            GLib.spawn_command_line_async(`sed -i 's/accent_bg_color @primary/accent_bg_color @on_primary/g' '${gtk4File}'`);
            GLib.spawn_command_line_async(`sed -i 's/accent_fg_color @on_primary/accent_fg_color @primary/g' '${gtk4File}'`);
            GLib.spawn_command_line_async(`sed -i 's/accent_color @primary/accent_color @on_primary/g' '${gtk3File}'`);
            GLib.spawn_command_line_async(`sed -i 's/accent_bg_color @primary/accent_bg_color @on_primary/g' '${gtk3File}'`);
            GLib.spawn_command_line_async(`sed -i 's/accent_fg_color @on_primary/accent_fg_color @primary/g' '${gtk3File}'`);*/
            GLib.spawn_command_line_async(`sed -i 's/color: @inverse_primary;/color: @main-fg;/g' '${waybarFile}'`);
            GLib.spawn_command_line_async(`sed -i 's/color: @primary;/color: @primary_fixed_dim;/g' '${waybarFile}'`);
            //GLib.spawn_command_line_async(`sed -i '483s/solid @primary_fixed_dim;/solid @inverse_primary;/g; 487s/solid @primary_fixed_dim;/solid @inverse_primary;/g; 2382s/solid @primary_fixed_dim;/solid @inverse_primary;/g' '${utilsFile}'`);
            GLib.spawn_command_line_async(`sed -i 's/@inverse_primary, @primary_fixed_dim/@inverse_primary, @scrim/g' '${waybarFile}'`);
            GLib.spawn_command_line_async(`sed -i '8s/@primary_fixed_dim;/@inverse_primary;/g' '${dockFile}'`);
            GLib.spawn_command_line_async(`sed -i '7s/@primary_fixed_dim;/@inverse_primary;/g' '${swayncFile}'`);
            //GLib.spawn_command_line_async(`bash -c '$HOME/.config/hyprcandy/scripts/toggle-dock.sh --relaunch'`);
            GLib.spawn_command_line_async(`bash -c 'swaync-client -rs'`); 
        }
        
        if (schemeName === 'Vibrant') {
            GLib.spawn_command_line_async(`sed -i 's/light/dark/g' '${waypaperIntegrationFile}'`);
            GLib.spawn_command_line_async(`sed -i 's/@on_primary_fixed_variant/@on_secondary/g' '${gtk3File}'`);
            GLib.spawn_command_line_async(`sed -i 's/@on_primary_fixed_variant/@on_secondary/g' '${gtk4File}'`);
            GLib.spawn_command_line_async(`sed -i 's/@primary_fixed_dim/@on_secondary/g' '${gtk3File}'`);
            GLib.spawn_command_line_async(`sed -i 's/@primary_fixed_dim/@on_secondary/g' '${gtk4File}'`);
            GLib.spawn_command_line_async(`sed -i 's/window_fg_color black/window_fg_color white/g' '${gtk4File}'`);
            GLib.spawn_command_line_async(`sed -i 's/view_fg_color black/view_fg_color white/g' '${gtk4File}'`);
            GLib.spawn_command_line_async(`sed -i 's/headerbar_fg_color black/headerbar_fg_color white/g' '${gtk4File}'`);
            GLib.spawn_command_line_async(`sed -i 's/sidebar_fg_color black/sidebar_fg_color white/g' '${gtk4File}'`);
            GLib.spawn_command_line_async(`sed -i 's/card_fg_color black/card_fg_color white/g' '${gtk4File}'`);
            GLib.spawn_command_line_async(`sed -i 's/dialog_fg_color black/dialog_fg_color white/g' '${gtk4File}'`);
            GLib.spawn_command_line_async(`sed -i 's/color: black;/color: white;/g' '${gtk4File}'`);
            GLib.spawn_command_line_async(`sed -i 's/fg_color black;/fg_color white;/g' '${gtk4File}'`);
            GLib.spawn_command_line_async(`sed -i 's/window_fg_color black/window_fg_color white/g' '${gtk3File}'`);
            GLib.spawn_command_line_async(`sed -i 's/view_fg_color black/view_fg_color white/g' '${gtk3File}'`);
            GLib.spawn_command_line_async(`sed -i 's/headerbar_fg_color black/headerbar_fg_color white/g' '${gtk3File}'`);
            GLib.spawn_command_line_async(`sed -i 's/sidebar_fg_color black/sidebar_fg_color white/g' '${gtk3File}'`);
            GLib.spawn_command_line_async(`sed -i 's/card_fg_color black/card_fg_color white/g' '${gtk3File}'`);
            GLib.spawn_command_line_async(`sed -i 's/dialog_fg_color black/dialog_fg_color white/g' '${gtk3File}'`);
            GLib.spawn_command_line_async(`sed -i 's/color: black;/color: white;/g' '${gtk3File}'`);
            GLib.spawn_command_line_async(`sed -i 's/fg_color black;/fg_color white;/g' '${gtk3File}'`);
            /*GLib.spawn_command_line_async(`sed -i 's/accent_color @primary/accent_color @on_primary/g' '${gtk4File}'`);
            GLib.spawn_command_line_async(`sed -i 's/accent_bg_color @primary/accent_bg_color @on_primary/g' '${gtk4File}'`);
            GLib.spawn_command_line_async(`sed -i 's/accent_fg_color @on_primary/accent_fg_color @primary/g' '${gtk4File}'`);
            GLib.spawn_command_line_async(`sed -i 's/accent_color @primary/accent_color @on_primary/g' '${gtk3File}'`);
            GLib.spawn_command_line_async(`sed -i 's/accent_bg_color @primary/accent_bg_color @on_primary/g' '${gtk3File}'`);
            GLib.spawn_command_line_async(`sed -i 's/accent_fg_color @on_primary/accent_fg_color @primary/g' '${gtk3File}'`);*/
            GLib.spawn_command_line_async(`sed -i 's/color: @inverse_primary;/color: @main-fg;/g' '${waybarFile}'`);
            GLib.spawn_command_line_async(`sed -i 's/color: @primary;/color: @primary_fixed_dim;/g' '${waybarFile}'`);
            //GLib.spawn_command_line_async(`sed -i '483s/solid @primary_fixed_dim;/solid @inverse_primary;/g; 487s/solid @primary_fixed_dim;/solid @inverse_primary;/g; 2382s/solid @primary_fixed_dim;/solid @inverse_primary;/g' '${utilsFile}'`);
            GLib.spawn_command_line_async(`sed -i 's/@inverse_primary, @primary_fixed_dim/@inverse_primary, @scrim/g' '${waybarFile}'`);
            GLib.spawn_command_line_async(`sed -i '8s/@primary_fixed_dim;/@inverse_primary;/g' '${dockFile}'`);
            GLib.spawn_command_line_async(`sed -i '7s/@primary_fixed_dim;/@inverse_primary;/g' '${swayncFile}'`);
            //GLib.spawn_command_line_async(`bash -c '$HOME/.config/hyprcandy/scripts/toggle-dock.sh --relaunch'`);
            GLib.spawn_command_line_async(`bash -c 'swaync-client -rs'`);
        }
        GLib.spawn_command_line_async(`bash -c '$HOME/.config/hyprcandy/hooks/waypaper_integration.sh'`);
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
                'Light': 'scheme-fidelity',
                'Dark': 'scheme-monochrome',
                'Content': 'scheme-content',
                'Expressive': 'scheme-expressive',
                'Fruit-salad': 'scheme-fruit-salad',
                'Neutral': 'scheme-neutral',
                'Rainbow': 'scheme-rainbow',
                'Tonal-spot': 'scheme-tonal-spot',
                'Vibrant': 'scheme-vibrant'
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
    
    mainRow.append(themeBox);
    
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
        spacing: 4,
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
            const configFile = GLib.build_filenamev([GLib.get_home_dir(), '.config', 'hypr', 'hyprviz.conf']);
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
            const configFile = GLib.build_filenamev([GLib.get_home_dir(), '.config', 'hypr', 'hyprviz.conf']);
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
            const configFile = GLib.build_filenamev([GLib.get_home_dir(), '.config', 'hypr', 'hyprviz.conf']);
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
    
    // --- Dock Icon Size Control (Translated from Hook Scripts) ---
    function addDockIconSizeRow(label) {
        const row = new Gtk.Box({ orientation: Gtk.Orientation.HORIZONTAL, spacing: 8, halign: Gtk.Align.CENTER, valign: Gtk.Align.CENTER });
        const lbl = new Gtk.Label({ label, halign: Gtk.Align.END, xalign: 1 });
        lbl.set_size_request(110, -1);
        
        const entry = new Gtk.Entry({ 
            placeholder_text: '16-64',
            width_chars: 8,
            halign: Gtk.Align.CENTER
        });
        
        const launchScript = GLib.build_filenamev([GLib.get_home_dir(), '.config', 'nwg-dock-hyprland', 'launch.sh']);
        const leftScript = GLib.build_filenamev([GLib.get_home_dir(), '.config', 'hyprcandy', 'scripts', 'left-dock.sh']);
        const rightScript = GLib.build_filenamev([GLib.get_home_dir(), '.config', 'hyprcandy', 'scripts', 'right-dock.sh']);
        const topScript = GLib.build_filenamev([GLib.get_home_dir(), '.config', 'hyprcandy', 'scripts', 'top-dock.sh']);
        const toggleScript = GLib.build_filenamev([GLib.get_home_dir(), '.config', 'hyprcandy', 'scripts', 'toggle-dock.sh']);
        const settingsFile = GLib.build_filenamev([GLib.get_home_dir(), '.config', 'hyprcandy', 'nwg_dock_settings.conf']);
        
        // Create settings file if it doesn't exist (from hook script logic)
        function ensureSettingsFile() {
            if (!GLib.file_test(settingsFile, GLib.FileTest.EXISTS)) {
                try {
                    GLib.file_set_contents(settingsFile, 'ICON_SIZE=28\nBORDER_RADIUS=16\nBORDER_WIDTH=2\n');
                } catch (e) {
                    print('Error creating settings file: ' + e.message);
                }
            }
        }
        
        // Load current icon size (source settings file logic)
        function loadCurrentIconSize() {
            ensureSettingsFile();
            try {
                let [ok, contents] = GLib.file_get_contents(settingsFile);
                if (ok && contents) {
                    let content = imports.byteArray.toString(contents);
                    let match = content.match(/ICON_SIZE=([0-9]+)/);
                    if (match) {
                        return match[1];
                    }
                }
            } catch (e) {
                print('Error reading settings file: ' + e.message);
            }
            return '28'; // Default value
        }
        
        // Set initial value
        entry.set_text(loadCurrentIconSize());
        
        function updateDockIconSize(newSize) {
            try {
                let numValue = parseInt(newSize);
                if (isNaN(numValue) || numValue < 16 || numValue > 64) {
                    GLib.spawn_command_line_async(`notify-send "Dock" "Invalid value: ${newSize}. Use 16-64" -t 2000`);
                    return;
                }
                
                // Update settings file (sed command from hook script)
                GLib.spawn_command_line_async(`sed -i 's/ICON_SIZE=.*/ICON_SIZE=${numValue}/' '${settingsFile}'`);
                
                // Update launch script and keybinds (sed commands from hook script)  
                GLib.spawn_command_line_async(`sed -i 's/-i [0-9]\\+/-i ${numValue}/g' '${launchScript}'`);
                GLib.spawn_command_line_async(`sed -i 's/-i [0-9]\\+/-i ${numValue}/g' '${leftScript}'`);
                GLib.spawn_command_line_async(`sed -i 's/-i [0-9]\\+/-i ${numValue}/g' '${rightScript}'`);
                GLib.spawn_command_line_async(`sed -i 's/-i [0-9]\\+/-i ${numValue}/g' '${topScript}'`);
                
                // Improved dock relaunch: let the launch script handle everything
                GLib.spawn_command_line_async(`bash -c '
                    chmod +x "${toggleScript}"
                    bash -c "${toggleScript} --relaunch" > /dev/null 2>&1 &
                '`);
                
                GLib.spawn_command_line_async(`notify-send "Dock" "Icon Size: ${numValue}px" -t 2000`);
            } catch (e) {
                print('Error updating dock icon size: ' + e.message);
            }
        }
        
        entry.connect('activate', () => {
            updateDockIconSize(entry.get_text());
        });
        
        row.append(lbl);
        row.append(entry);
        rightTogglesBox.append(row);
    }
    
    // Add dock icon size input
    addDockIconSizeRow('Dock Icon Size');
    
    // --- Dock Border Radius Control (Translated from Hook Scripts) ---
    function addDockRadiusRow(label) {
        const row = new Gtk.Box({ orientation: Gtk.Orientation.HORIZONTAL, spacing: 8, halign: Gtk.Align.CENTER, valign: Gtk.Align.CENTER });
        const lbl = new Gtk.Label({ label, halign: Gtk.Align.END, xalign: 1 });
        lbl.set_size_request(110, -1);
        
        const entry = new Gtk.Entry({ 
            placeholder_text: '0-50',
            width_chars: 8,
            halign: Gtk.Align.CENTER
        });
        
        // File paths (from hook script)
        const styleFile = GLib.build_filenamev([GLib.get_home_dir(), '.config', 'nwg-dock-hyprland', 'style.css']);
        const settingsFile = GLib.build_filenamev([GLib.get_home_dir(), '.config', 'hyprcandy', 'nwg_dock_settings.conf']);
        const toggleScript = GLib.build_filenamev([GLib.get_home_dir(), '.config', 'hyprcandy', 'scripts', 'toggle-dock.sh']);
        
        // Create settings file if it doesn't exist (from hook script logic)
        function ensureSettingsFile() {
            if (!GLib.file_test(settingsFile, GLib.FileTest.EXISTS)) {
                try {
                    GLib.file_set_contents(settingsFile, 'ICON_SIZE=28\nBORDER_RADIUS=16\nBORDER_WIDTH=2\n');
                } catch (e) {
                    print('Error creating settings file: ' + e.message);
                }
            }
        }
        
        // Load current border radius
        function loadCurrentRadius() {
            ensureSettingsFile();
            try {
                let [ok, contents] = GLib.file_get_contents(settingsFile);
                if (ok && contents) {
                    let content = imports.byteArray.toString(contents);
                    let match = content.match(/BORDER_RADIUS=([0-9]+)/);
                    if (match) {
                        return match[1];
                    }
                }
            } catch (e) {
                print('Error reading settings file: ' + e.message);
            }
            return '16'; // Default value
        }
        
        // Set initial value
        entry.set_text(loadCurrentRadius());
        
        function updateDockRadius(newRadius) {
            try {
                let numValue = parseInt(newRadius);
                if (isNaN(numValue) || numValue < 0 || numValue > 50) {
                    GLib.spawn_command_line_async(`notify-send "Dock" "Invalid value: ${newRadius}. Use 0-50" -t 2000`);
                    return;
                }
                
                // Update settings file (from hook script)
                GLib.spawn_command_line_async(`sed -i 's/BORDER_RADIUS=.*/BORDER_RADIUS=${numValue}/' '${settingsFile}'`);
                
                // Update style.css file (from hook script)
                GLib.spawn_command_line_async(`sed -i '5s/border-radius: [0-9]\\+px/border-radius: ${numValue}px/' '${styleFile}'`);
                
                // Get current icon size for relaunch
                function getCurrentIconSize() {
                    try {
                        let [ok, contents] = GLib.file_get_contents(settingsFile);
                        if (ok && contents) {
                            let content = imports.byteArray.toString(contents);
                            let match = content.match(/ICON_SIZE=([0-9]+)/);
                            if (match) {
                                return match[1];
                            }
                        }
                    } catch (e) {}
                    return '28'; // Default
                }
                
                // Improved dock relaunch: let the launch script handle everything
                GLib.spawn_command_line_async(`bash -c '
                    chmod +x "${toggleScript}"
                    bash -c "${toggleScript} --relaunch" > /dev/null 2>&1 &
                '`);
                
                GLib.spawn_command_line_async(`notify-send "Dock" "Border Radius: ${numValue}px" -t 2000`);
            } catch (e) {
                print('Error updating dock radius: ' + e.message);
            }
        }
        
        entry.connect('activate', () => {
            updateDockRadius(entry.get_text());
        });
        
        row.append(lbl);
        row.append(entry);
        rightTogglesBox.append(row);
    }
    
    // Add dock radius input
    addDockRadiusRow('Dock Radius');
    
    // --- Dock Border Width Control (Translated from Hook Scripts) ---
    function addDockWidthRow(label) {
        const row = new Gtk.Box({ orientation: Gtk.Orientation.HORIZONTAL, spacing: 8, halign: Gtk.Align.CENTER, valign: Gtk.Align.CENTER });
        const lbl = new Gtk.Label({ label, halign: Gtk.Align.END, xalign: 1 });
        lbl.set_size_request(110, -1);
        
        const entry = new Gtk.Entry({ 
            placeholder_text: '0-10',
            width_chars: 8,
            halign: Gtk.Align.CENTER
        });
        
        // File paths (from hook script)
        const styleFile = GLib.build_filenamev([GLib.get_home_dir(), '.config', 'nwg-dock-hyprland', 'style.css']);
        const settingsFile = GLib.build_filenamev([GLib.get_home_dir(), '.config', 'hyprcandy', 'nwg_dock_settings.conf']);
        const toggleScript = GLib.build_filenamev([GLib.get_home_dir(), '.config', 'hyprcandy', 'scripts', 'toggle-dock.sh']);
        
        // Create settings file if it doesn't exist (from hook script logic)
        function ensureSettingsFile() {
            if (!GLib.file_test(settingsFile, GLib.FileTest.EXISTS)) {
                try {
                    GLib.file_set_contents(settingsFile, 'ICON_SIZE=28\nBORDER_RADIUS=16\nBORDER_WIDTH=2\n');
                } catch (e) {
                    print('Error creating settings file: ' + e.message);
                }
            }
        }
        
        // Load current border width
        function loadCurrentWidth() {
            ensureSettingsFile();
            try {
                let [ok, contents] = GLib.file_get_contents(settingsFile);
                if (ok && contents) {
                    let content = imports.byteArray.toString(contents);
                    let match = content.match(/BORDER_WIDTH=([0-9]+)/);
                    if (match) {
                        return match[1];
                    }
                }
            } catch (e) {
                print('Error reading settings file: ' + e.message);
            }
            return '2'; // Default value
        }
        
        // Set initial value
        entry.set_text(loadCurrentWidth());
        
        function updateDockWidth(newWidth) {
            try {
                let numValue = parseInt(newWidth);
                if (isNaN(numValue) || numValue < 0 || numValue > 10) {
                    GLib.spawn_command_line_async(`notify-send "Dock" "Invalid value: ${newWidth}. Use 0-10" -t 2000`);
                    return;
                }
                
                // Update settings file (from hook script)
                GLib.spawn_command_line_async(`sed -i 's/BORDER_WIDTH=.*/BORDER_WIDTH=${numValue}/' '${settingsFile}'`);
                
                // Update style.css file (from hook script)
                GLib.spawn_command_line_async(`sed -i 's/border-width: [0-9]\\+px/border-width: ${numValue}px/' '${styleFile}'`);
                
                // Get current icon size for relaunch
                function getCurrentIconSize() {
                    try {
                        let [ok, contents] = GLib.file_get_contents(settingsFile);
                        if (ok && contents) {
                            let content = imports.byteArray.toString(contents);
                            let match = content.match(/ICON_SIZE=([0-9]+)/);
                            if (match) {
                                return match[1];
                            }
                        }
                    } catch (e) {}
                    return '28'; // Default
                }
                
                // Improved dock relaunch: let the launch script handle everything
                GLib.spawn_command_line_async(`bash -c '
                    chmod +x "${toggleScript}"
                    bash -c "${toggleScript} --relaunch" > /dev/null 2>&1 &
                '`);
                
                GLib.spawn_command_line_async(`notify-send "Dock" "Border Width: ${numValue}px" -t 2000`);
            } catch (e) {
                print('Error updating dock width: ' + e.message);
            }
        }
        
        entry.connect('activate', () => {
            updateDockWidth(entry.get_text());
        });
        
        row.append(lbl);
        row.append(entry);
        rightTogglesBox.append(row);
    }
    
    // Add dock width input
    addDockWidthRow('Dock Border');
    
    // --- Hyprland Rounding Control (Translated from Hook Scripts) ---
    function addRoundingRow(label) {
        const row = new Gtk.Box({ orientation: Gtk.Orientation.HORIZONTAL, spacing: 8, halign: Gtk.Align.CENTER, valign: Gtk.Align.CENTER });
        const lbl = new Gtk.Label({ label, halign: Gtk.Align.END, xalign: 1 });
        lbl.set_size_request(110, -1);
        
        const entry = new Gtk.Entry({ 
            placeholder_text: '0-50',
            width_chars: 8,
            halign: Gtk.Align.CENTER
        });
        
        // File path (from hook script)
        const configFile = GLib.build_filenamev([GLib.get_home_dir(), '.config', 'hypr', 'hyprviz.conf']);
        
        // Load current rounding value
        function loadCurrentRounding() {
            try {
                let [ok, contents] = GLib.file_get_contents(configFile);
                if (ok && contents) {
                    let content = imports.byteArray.toString(contents);
                    // grep -E "^\s*rounding\s*=" logic
                    let match = content.match(/^\s*rounding\s*=\s*([0-9]+)/m);
                    if (match) {
                        return match[1];
                    }
                }
            } catch (e) {
                print('Error reading config file: ' + e.message);
            }
            return '10'; // Default value
        }
        
        // Set initial value
        entry.set_text(loadCurrentRounding());
        
        function updateRounding(newRounding) {
            try {
                let numValue = parseInt(newRounding);
                if (isNaN(numValue) || numValue < 0 || numValue > 50) {
                    GLib.spawn_command_line_async(`notify-send "Hyprland" "Invalid value: ${newRounding}. Use 0-50" -t 2000`);
                    return;
                }
                
                // Update config file (sed command from hook script)
                GLib.spawn_command_line_async(`sed -i 's/^\\(\\s*rounding\\s*=\\s*\\)[0-9]*/\\1${numValue}/' '${configFile}'`);
                
                // Apply changes (hyprctl commands from hook script)
                GLib.spawn_command_line_async(`hyprctl keyword decoration:rounding ${numValue}`);
                GLib.spawn_command_line_async('hyprctl reload');
                
                GLib.spawn_command_line_async(`notify-send "Hyprland" "Rounding: ${numValue}" -t 2000`);
            } catch (e) {
                print('Error updating rounding: ' + e.message);
            }
        }
        
        entry.connect('activate', () => {
            updateRounding(entry.get_text());
        });
        
        row.append(lbl);
        row.append(entry);
        rightTogglesBox.append(row);
    }
    
    // Add rounding input
    //addRoundingRow('Rounding');
    
    // --- Hyprland Gaps OUT Control (Translated from Hook Scripts) ---
    function addGapsOutRow(label) {
        const row = new Gtk.Box({ orientation: Gtk.Orientation.HORIZONTAL, spacing: 8, halign: Gtk.Align.CENTER, valign: Gtk.Align.CENTER });
        const lbl = new Gtk.Label({ label, halign: Gtk.Align.END, xalign: 1 });
        lbl.set_size_request(110, -1);
        
        const entry = new Gtk.Entry({ 
            placeholder_text: '0-100',
            width_chars: 8,
            halign: Gtk.Align.CENTER
        });
        
        // File path (from hook script)
        const configFile = GLib.build_filenamev([GLib.get_home_dir(), '.config', 'hypr', 'hyprviz.conf']);
        
        // Load current gaps_out value
        function loadCurrentGapsOut() {
            try {
                let [ok, contents] = GLib.file_get_contents(configFile);
                if (ok && contents) {
                    let content = imports.byteArray.toString(contents);
                    // grep -E "^\s*gaps_out\s*=" logic
                    let match = content.match(/^\s*gaps_out\s*=\s*([0-9]+)/m);
                    if (match) {
                        return match[1];
                    }
                }
            } catch (e) {
                print('Error reading config file: ' + e.message);
            }
            return '20'; // Default value
        }
        
        // Set initial value
        entry.set_text(loadCurrentGapsOut());
        
        function updateGapsOut(newGapsOut) {
            try {
                let numValue = parseInt(newGapsOut);
                if (isNaN(numValue) || numValue < 0 || numValue > 100) {
                    GLib.spawn_command_line_async(`notify-send "Hyprland" "Invalid value: ${newGapsOut}. Use 0-100" -t 2000`);
                    return;
                }
                
                // Update config file (sed command from hook script)
                GLib.spawn_command_line_async(`sed -i 's/^\\(\\s*gaps_out\\s*=\\s*\\)[0-9]*/\\1${numValue}/' '${configFile}'`);
                
                // Apply changes (hyprctl commands from hook script)
                GLib.spawn_command_line_async(`hyprctl keyword general:gaps_out ${numValue}`);
                GLib.spawn_command_line_async('hyprctl reload');
                
                GLib.spawn_command_line_async(`notify-send "Hyprland" "Gaps OUT: ${numValue}" -t 2000`);
            } catch (e) {
                print('Error updating gaps out: ' + e.message);
            }
        }
        
        entry.connect('activate', () => {
            updateGapsOut(entry.get_text());
        });
        
        row.append(lbl);
        row.append(entry);
        rightTogglesBox.append(row);
    }
    
    // --- Hyprland Gaps IN Control (Translated from Hook Scripts) ---
    function addGapsInRow(label) {
        const row = new Gtk.Box({ orientation: Gtk.Orientation.HORIZONTAL, spacing: 8, halign: Gtk.Align.CENTER, valign: Gtk.Align.CENTER });
        const lbl = new Gtk.Label({ label, halign: Gtk.Align.END, xalign: 1 });
        lbl.set_size_request(110, -1);
        
        const entry = new Gtk.Entry({ 
            placeholder_text: '0-50',
            width_chars: 8,
            halign: Gtk.Align.CENTER
        });
        
        // File path (from hook script)
        const configFile = GLib.build_filenamev([GLib.get_home_dir(), '.config', 'hypr', 'hyprviz.conf']);
        
        // Load current gaps_in value
        function loadCurrentGapsIn() {
            try {
                let [ok, contents] = GLib.file_get_contents(configFile);
                if (ok && contents) {
                    let content = imports.byteArray.toString(contents);
                    // grep -E "^\s*gaps_in\s*=" logic
                    let match = content.match(/^\s*gaps_in\s*=\s*([0-9]+)/m);
                    if (match) {
                        return match[1];
                    }
                }
            } catch (e) {
                print('Error reading config file: ' + e.message);
            }
            return '10'; // Default value
        }
        
        // Set initial value
        entry.set_text(loadCurrentGapsIn());
        
        function updateGapsIn(newGapsIn) {
            try {
                let numValue = parseInt(newGapsIn);
                if (isNaN(numValue) || numValue < 0 || numValue > 50) {
                    GLib.spawn_command_line_async(`notify-send "Hyprland" "Invalid value: ${newGapsIn}. Use 0-50" -t 2000`);
                    return;
                }
                
                // Update config file (sed command from hook script)
                GLib.spawn_command_line_async(`sed -i 's/^\\(\\s*gaps_in\\s*=\\s*\\)[0-9]*/\\1${numValue}/' '${configFile}'`);
                
                // Apply changes (hyprctl commands from hook script)
                GLib.spawn_command_line_async(`hyprctl keyword general:gaps_in ${numValue}`);
                GLib.spawn_command_line_async('hyprctl reload');
                
                GLib.spawn_command_line_async(`notify-send "Hyprland" "Gaps IN: ${numValue}" -t 2000`);
            } catch (e) {
                print('Error updating gaps in: ' + e.message);
            }
        }
        
        entry.connect('activate', () => {
            updateGapsIn(entry.get_text());
        });
        
        row.append(lbl);
        row.append(entry);
        rightTogglesBox.append(row);
    }
    
    // Add gaps inputs
    //addGapsOutRow('Gaps OUT');
    //addGapsInRow('Gaps IN');
    
    // --- Hyprland Border Control (Translated from Hook Scripts) ---
    function addBorderRow(label) {
        const row = new Gtk.Box({ orientation: Gtk.Orientation.HORIZONTAL, spacing: 8, halign: Gtk.Align.CENTER, valign: Gtk.Align.CENTER });
        const lbl = new Gtk.Label({ label, halign: Gtk.Align.END, xalign: 1 });
        lbl.set_size_request(110, -1);
        
        const entry = new Gtk.Entry({ 
            placeholder_text: '0-10',
            width_chars: 8,
            halign: Gtk.Align.CENTER
        });
        
        // File path (from hook script)
        const configFile = GLib.build_filenamev([GLib.get_home_dir(), '.config', 'hypr', 'hyprviz.conf']);
        
        // Load current border_size value
        function loadCurrentBorder() {
            try {
                let [ok, contents] = GLib.file_get_contents(configFile);
                if (ok && contents) {
                    let content = imports.byteArray.toString(contents);
                    // grep -E "^\s*border_size\s*=" logic
                    let match = content.match(/^\s*border_size\s*=\s*([0-9]+)/m);
                    if (match) {
                        return match[1];
                    }
                }
            } catch (e) {
                print('Error reading config file: ' + e.message);
            }
            return '2'; // Default value
        }
        
        // Set initial value
        entry.set_text(loadCurrentBorder());
        
        function updateBorder(newBorder) {
            try {
                let numValue = parseInt(newBorder);
                if (isNaN(numValue) || numValue < 0 || numValue > 10) {
                    GLib.spawn_command_line_async(`notify-send "Hyprland" "Invalid value: ${newBorder}. Use 0-10" -t 2000`);
                    return;
                }
                
                // Update config file (sed command from hook script)
                GLib.spawn_command_line_async(`sed -i 's/^\\(\\s*border_size\\s*=\\s*\\)[0-9]*/\\1${numValue}/' '${configFile}'`);
                
                // Apply changes (hyprctl commands from hook script)
                GLib.spawn_command_line_async(`hyprctl keyword general:border_size ${numValue}`);
                GLib.spawn_command_line_async('hyprctl reload');
                
                GLib.spawn_command_line_async(`notify-send "Hyprland" "Border: ${numValue}" -t 2000`);
            } catch (e) {
                print('Error updating border: ' + e.message);
            }
        }
        
        entry.connect('activate', () => {
            updateBorder(entry.get_text());
        });
        
        row.append(lbl);
        row.append(entry);
        rightTogglesBox.append(row);
    }
    
    // Add border input
    //addBorderRow('Border');
    
    // --- Blur Size Control (Adapted from existing logic) ---
    function addBlurSizeRow(label) {
        const row = new Gtk.Box({ orientation: Gtk.Orientation.HORIZONTAL, spacing: 8, halign: Gtk.Align.CENTER, valign: Gtk.Align.CENTER });
        const lbl = new Gtk.Label({ label, halign: Gtk.Align.END, xalign: 1 });
        lbl.set_size_request(110, -1);
        
        const entry = new Gtk.Entry({ 
            placeholder_text: '0-20',
            width_chars: 8,
            halign: Gtk.Align.CENTER
        });
        
        // File path (from existing logic)
        const configFile = GLib.build_filenamev([GLib.get_home_dir(), '.config', 'hypr', 'hyprviz.conf']);
        
        // Load current blur size value
        function loadCurrentBlurSize() {
            try {
                let [ok, contents] = GLib.file_get_contents(configFile);
                if (ok && contents) {
                    let content = imports.byteArray.toString(contents);
                    // Look for size = X inside the blur block (from existing logic)
                    let blurSection = content.match(/blur \{[\s\S]*?\}/);
                    if (blurSection) {
                        let sizeMatch = blurSection[0].match(/size = ([0-9]+)/);
                        if (sizeMatch) {
                            return sizeMatch[1];
                        }
                    }
                }
            } catch (e) {
                print('Error reading config file: ' + e.message);
            }
            return '8'; // Default value
        }
        
        // Set initial value
        entry.set_text(loadCurrentBlurSize());
        
        function updateBlurSize(newSize) {
            try {
                let numValue = parseInt(newSize);
                if (isNaN(numValue) || numValue < 0 || numValue > 20) {
                    GLib.spawn_command_line_async(`notify-send "Blur" "Invalid value: ${newSize}. Use 0-20" -t 2000`);
                    return;
                }
                
                // Read current value and update (exact logic from existing function)
                let [ok, contents] = GLib.file_get_contents(configFile);
                if (ok && contents) {
                    let content = imports.byteArray.toString(contents);
                    let blurSection = content.match(/blur \{[\s\S]*?\}/);
                    if (blurSection) {
                        let sizeMatch = blurSection[0].match(/size = ([0-9]+)/);
                        if (sizeMatch) {
                            let currentValue = parseInt(sizeMatch[1]);
                            // Use the exact sed command from existing logic
                            GLib.spawn_command_line_async(`sed -i '/blur {/,/}/{s/size = ${currentValue}/size = ${numValue}/}' '${configFile}'`);
                            GLib.spawn_command_line_async('hyprctl reload');
                            GLib.spawn_command_line_async(`notify-send "Blur" "Size: ${numValue}" -t 2000`);
                        }
                    }
                }
            } catch (e) {
                print('Error updating blur size: ' + e.message);
            }
        }
        
        entry.connect('activate', () => {
            updateBlurSize(entry.get_text());
        });
        
        row.append(lbl);
        row.append(entry);
        rightTogglesBox.append(row);
    }
    
    // Add blur size input
    //addBlurSizeRow('Blur Size');
    
    // --- Blur Pass Control (Adapted from existing logic) ---
    function addBlurPassRow(label) {
        const row = new Gtk.Box({ orientation: Gtk.Orientation.HORIZONTAL, spacing: 8, halign: Gtk.Align.CENTER, valign: Gtk.Align.CENTER });
        const lbl = new Gtk.Label({ label, halign: Gtk.Align.END, xalign: 1 });
        lbl.set_size_request(110, -1);
        
        const entry = new Gtk.Entry({ 
            placeholder_text: '0-10',
            width_chars: 8,
            halign: Gtk.Align.CENTER
        });
        
        // File path (from existing logic)
        const configFile = GLib.build_filenamev([GLib.get_home_dir(), '.config', 'hypr', 'hyprviz.conf']);
        
        // Load current blur pass value
        function loadCurrentBlurPass() {
            try {
                let [ok, contents] = GLib.file_get_contents(configFile);
                if (ok && contents) {
                    let content = imports.byteArray.toString(contents);
                    // Look for passes = X inside the blur block (from existing logic)
                    let blurSection = content.match(/blur \{[\s\S]*?\}/);
                    if (blurSection) {
                        let passesMatch = blurSection[0].match(/passes = ([0-9]+)/);
                        if (passesMatch) {
                            return passesMatch[1];
                        }
                    }
                }
            } catch (e) {
                print('Error reading config file: ' + e.message);
            }
            return '1'; // Default value
        }
        
        // Set initial value
        entry.set_text(loadCurrentBlurPass());
        
        function updateBlurPass(newPass) {
            try {
                let numValue = parseInt(newPass);
                if (isNaN(numValue) || numValue < 0 || numValue > 10) {
                    GLib.spawn_command_line_async(`notify-send "Blur" "Invalid value: ${newPass}. Use 0-10" -t 2000`);
                    return;
                }
                
                // Read current value and update (exact logic from existing function)
                let [ok, contents] = GLib.file_get_contents(configFile);
                if (ok && contents) {
                    let content = imports.byteArray.toString(contents);
                    let blurSection = content.match(/blur \{[\s\S]*?\}/);
                    if (blurSection) {
                        let passesMatch = blurSection[0].match(/passes = ([0-9]+)/);
                        if (passesMatch) {
                            let currentValue = parseInt(passesMatch[1]);
                            // Use the exact sed command from existing logic
                            GLib.spawn_command_line_async(`sed -i 's/passes = ${currentValue}/passes = ${numValue}/' '${configFile}'`);
                            GLib.spawn_command_line_async('hyprctl reload');
                            GLib.spawn_command_line_async(`notify-send "Blur" "Passes: ${numValue}" -t 2000`);
                        }
                    }
                }
            } catch (e) {
                print('Error updating blur passes: ' + e.message);
            }
        }
        
        entry.connect('activate', () => {
            updateBlurPass(entry.get_text());
        });
        
        row.append(lbl);
        row.append(entry);
        rightTogglesBox.append(row);
    }
    
    // Add blur pass input
    //addBlurPassRow('Blur Pass');
    
    // --- Rofi Border Control (Adapted from existing logic) ---
    function addRofiBorderRow(label) {
        const row = new Gtk.Box({ orientation: Gtk.Orientation.HORIZONTAL, spacing: 8, halign: Gtk.Align.CENTER, valign: Gtk.Align.CENTER });
        const lbl = new Gtk.Label({ label, halign: Gtk.Align.END, xalign: 1 });
        lbl.set_size_request(110, -1);
        
        const entry = new Gtk.Entry({ 
            placeholder_text: '0-10',
            width_chars: 8,
            halign: Gtk.Align.CENTER
        });
        
        // File path (from existing logic)
        const rofiBorderFile = GLib.build_filenamev([GLib.get_home_dir(), '.config', 'hyprcandy', 'settings', 'rofi-border.rasi']);
        
        // Load current rofi border value
        function loadCurrentRofiBorder() {
            try {
                let [ok, contents] = GLib.file_get_contents(rofiBorderFile);
                if (ok && contents) {
                    let content = imports.byteArray.toString(contents);
                    let borderMatch = content.match(/border-width: ([0-9]+)px/);
                    if (borderMatch) {
                        return borderMatch[1];
                    }
                }
            } catch (e) {
                print('Error reading rofi border file: ' + e.message);
            }
            return '2'; // Default value
        }
        
        // Set initial value
        entry.set_text(loadCurrentRofiBorder());
        
        function updateRofiBorder(newBorder) {
            try {
                let numValue = parseInt(newBorder);
                if (isNaN(numValue) || numValue < 0 || numValue > 10) {
                    GLib.spawn_command_line_async(`notify-send "Rofi" "Invalid value: ${newBorder}. Use 0-10" -t 2000`);
                    return;
                }
                
                // Read current value and update (exact logic from existing function)
                let [ok, contents] = GLib.file_get_contents(rofiBorderFile);
                if (ok && contents) {
                    let content = imports.byteArray.toString(contents);
                    let borderMatch = content.match(/border-width: ([0-9]+)px/);
                    if (borderMatch) {
                        let currentValue = parseInt(borderMatch[1]);
                        // Use the exact sed command from existing logic
                        GLib.spawn_command_line_async(`sed -i 's/border-width: ${currentValue}px/border-width: ${numValue}px/' '${rofiBorderFile}'`);
                        GLib.spawn_command_line_async(`notify-send "Rofi" "Border: ${numValue}px" -t 2000`);
                    }
                }
            } catch (e) {
                print('Error updating rofi border: ' + e.message);
            }
        }
        
        entry.connect('activate', () => {
            updateRofiBorder(entry.get_text());
        });
        
        row.append(lbl);
        row.append(entry);
        rightTogglesBox.append(row);
    }
    
    // Add rofi border input
    addRofiBorderRow('Rofi Border');
    
    // --- Rofi Radius Control (Adapted from existing logic) ---
    function addRofiRadiusRow(label) {
        const row = new Gtk.Box({ orientation: Gtk.Orientation.HORIZONTAL, spacing: 8, halign: Gtk.Align.CENTER, valign: Gtk.Align.CENTER });
        const lbl = new Gtk.Label({ label, halign: Gtk.Align.END, xalign: 1 });
        lbl.set_size_request(110, -1);
        
        const entry = new Gtk.Entry({ 
            placeholder_text: '0.0-5.0',
            width_chars: 8,
            halign: Gtk.Align.CENTER
        });
        
        // File path (from existing logic)
        const rofiRadiusFile = GLib.build_filenamev([GLib.get_home_dir(), '.config', 'hyprcandy', 'settings', 'rofi-border-radius.rasi']);
        
        // Load current rofi radius value
        function loadCurrentRofiRadius() {
            try {
                let [ok, contents] = GLib.file_get_contents(rofiRadiusFile);
                if (ok && contents) {
                    let content = imports.byteArray.toString(contents);
                    let radiusMatch = content.match(/border-radius: ([0-9.]+)em/);
                    if (radiusMatch) {
                        return radiusMatch[1];
                    }
                }
            } catch (e) {
                print('Error reading rofi radius file: ' + e.message);
            }
            return '1.0'; // Default value
        }
        
        // Set initial value
        entry.set_text(loadCurrentRofiRadius());
        
        function updateRofiRadius(newRadius) {
            try {
                let numValue = parseFloat(newRadius);
                if (isNaN(numValue) || numValue < 0 || numValue > 5.0) {
                    GLib.spawn_command_line_async(`notify-send "Rofi" "Invalid value: ${newRadius}. Use 0.0-5.0" -t 2000`);
                    return;
                }
                
                // Read current value and update (exact logic from existing function)
                let [ok, contents] = GLib.file_get_contents(rofiRadiusFile);
                if (ok && contents) {
                    let content = imports.byteArray.toString(contents);
                    let radiusMatch = content.match(/border-radius: ([0-9.]+)em/);
                    if (radiusMatch) {
                        let newValueStr = numValue.toFixed(1);
                        // Use the exact sed command from existing logic
                        GLib.spawn_command_line_async(`sed -i 's/border-radius: ${radiusMatch[1]}em/border-radius: ${newValueStr}em/' '${rofiRadiusFile}'`);
                        GLib.spawn_command_line_async(`notify-send "Rofi" "Radius: ${newValueStr}em" -t 2000`);
                    }
                }
            } catch (e) {
                print('Error updating rofi radius: ' + e.message);
            }
        }
        
        entry.connect('activate', () => {
            updateRofiRadius(entry.get_text());
        });
        
        row.append(lbl);
        row.append(entry);
        rightTogglesBox.append(row);
    }
    
    // Add rofi radius input
    addRofiRadiusRow('Rofi Radius');
    
    // --- Opacity Scale Control (Adapted from existing logic) ---
    function addOpacityScaleRow(label) {
        const row = new Gtk.Box({ orientation: Gtk.Orientation.HORIZONTAL, spacing: 8, halign: Gtk.Align.CENTER, valign: Gtk.Align.CENTER });
        const lbl = new Gtk.Label({ label, halign: Gtk.Align.END, xalign: 1 });
        lbl.set_size_request(110, -1);
        
        const entry = new Gtk.Entry({ 
            placeholder_text: '0.0-1.0',
            width_chars: 8,
            halign: Gtk.Align.CENTER
        });
        
        // File path (from existing logic)
        const configFile = GLib.build_filenamev([GLib.get_home_dir(), '.config', 'hypr', 'hyprviz.conf']);
        
        // Load current active_opacity value
        function loadCurrentOpacity() {
            try {
                let [ok, contents] = GLib.file_get_contents(configFile);
                if (ok && contents) {
                    let content = imports.byteArray.toString(contents);
                    let match = content.match(/active_opacity = ([0-9.]+)/);
                    if (match) {
                        return match[1];
                    }
                }
            } catch (e) {
                print('Error reading config file: ' + e.message);
            }
            return '1.0'; // Default value
        }
        
        // Set initial value
        entry.set_text(loadCurrentOpacity());
        
        function updateOpacityScale(newOpacity) {
            try {
                let numValue = parseFloat(newOpacity);
                if (isNaN(numValue) || numValue < 0.0 || numValue > 1.0) {
                    GLib.spawn_command_line_async(`notify-send "Opacity" "Invalid value: ${newOpacity}. Use 0.0-1.0" -t 2000`);
                    return;
                }
                
                // Update using exact logic from existing function
                let newValueStr = numValue.toFixed(2);
                GLib.spawn_command_line_async(`sed -i 's/active_opacity = .*/active_opacity = ${newValueStr}/' "${configFile}"`);
                GLib.spawn_command_line_async('hyprctl reload');
                GLib.spawn_command_line_async(`notify-send "Opacity" "Scale: ${newValueStr}" -t 2000`);
            } catch (e) {
                print('Error updating opacity scale: ' + e.message);
            }
        }
        
        entry.connect('activate', () => {
            updateOpacityScale(entry.get_text());
        });
        
        row.append(lbl);
        row.append(entry);
        rightTogglesBox.append(row);
    }
    
    // Add opacity scale input
    //addOpacityScaleRow('Opacity Scale');
    
    // --- Waybar Padding Control (Converted to Input Box) ---
    function addWaybarPaddingRow(label) {
        const row = new Gtk.Box({ orientation: Gtk.Orientation.HORIZONTAL, spacing: 8, halign: Gtk.Align.CENTER, valign: Gtk.Align.CENTER });
        const lbl = new Gtk.Label({ label, halign: Gtk.Align.END, xalign: 1 });
        lbl.set_size_request(110, -1);
        
        const entry = new Gtk.Entry({ 
            placeholder_text: '0.0-10.0',
            width_chars: 8,
            halign: Gtk.Align.CENTER
        });
        
        // File paths (from existing logic)
        const waybarStyleFile = GLib.build_filenamev([GLib.get_home_dir(), '.config', 'waybar', 'style.css']);
        const waybarPaddingStateFile = GLib.build_filenamev([hyprsunsetStateDir, 'waybar_padding.state']);
        
        // Load current waybar padding value
        function loadCurrentWaybarPadding() {
            try {
                // Try to read from state file first
                let [ok, contents] = GLib.file_get_contents(waybarPaddingStateFile);
                if (ok && contents) {
                    let value = imports.byteArray.toString(contents).trim();
                    if (value && !isNaN(parseFloat(value))) {
                        return value;
                    }
                }
                
                // Fallback: read from CSS file
                let [cssOk, cssContents] = GLib.file_get_contents(waybarStyleFile);
                if (cssOk && cssContents) {
                    let content = imports.byteArray.toString(cssContents);
                    let paddingMatch = content.match(/padding: ([0-9.]+)px;/);
                    if (paddingMatch) {
                        return paddingMatch[1];
                    }
                }
            } catch (e) {
                print('Error reading waybar padding: ' + e.message);
            }
            return '3.5'; // Default value
        }
        
        // Set initial value
        entry.set_text(loadCurrentWaybarPadding());
        
        function updateWaybarPadding(newPadding) {
            try {
                let numValue = parseFloat(newPadding);
                if (isNaN(numValue) || numValue < 0.0 || numValue > 10.0) {
                    GLib.spawn_command_line_async(`notify-send "Waybar" "Invalid value: ${newPadding}. Use 0.0-10.0" -t 2000`);
                    return;
                }
                
                // Read current value and update (exact logic from existing function)
                let [ok, contents] = GLib.file_get_contents(waybarStyleFile);
                if (ok && contents) {
                    let content = imports.byteArray.toString(contents);
                    let paddingMatch = content.match(/padding: ([0-9.]+)px;/);
                    if (paddingMatch) {
                        let newValueStr = numValue.toFixed(1);
                        
                        // Update CSS file (correct line number for padding)
                        GLib.spawn_command_line_async(`sed -i '31s/padding: ${paddingMatch[1]}px;/padding: ${newValueStr}px;/' '${waybarStyleFile}'`);
                        
                        // Update state file
                        GLib.file_set_contents(waybarPaddingStateFile, newValueStr);
                        
                        // Send notification
                        GLib.spawn_command_line_async(`notify-send "Waybar" "Padding: ${newValueStr}px" -t 2000`);
                    }
                }
            } catch (e) {
                print('Error updating waybar padding: ' + e.message);
            }
        }
        
        entry.connect('activate', () => {
            updateWaybarPadding(entry.get_text());
        });
        
        row.append(lbl);
        row.append(entry);
        rightTogglesBox.append(row);
    }
    
    //addWaybarPaddingRow('Waybar Padding');
    
    // --- Waybar Border Size Control (Converted to Input Box) ---
    function addWaybarBorderSizeRow(label) {
        const row = new Gtk.Box({ orientation: Gtk.Orientation.HORIZONTAL, spacing: 8, halign: Gtk.Align.CENTER, valign: Gtk.Align.CENTER });
        const lbl = new Gtk.Label({ label, halign: Gtk.Align.END, xalign: 1 });
        lbl.set_size_request(110, -1);
        
        const entry = new Gtk.Entry({ 
            placeholder_text: '0-10',
            width_chars: 8,
            halign: Gtk.Align.CENTER
        });
        
        // File paths (from existing logic)
        const waybarStyleFile = GLib.build_filenamev([GLib.get_home_dir(), '.config', 'waybar', 'style.css']);
        const waybarBorderSizeStateFile = GLib.build_filenamev([hyprsunsetStateDir, 'waybar_border_size.state']);
        
        // Load current waybar border size value
        function loadCurrentWaybarBorderSize() {
            try {
                // Try to read from state file first
                let [ok, contents] = GLib.file_get_contents(waybarBorderSizeStateFile);
                if (ok && contents) {
                    let value = imports.byteArray.toString(contents).trim();
                    if (value && !isNaN(parseInt(value))) {
                        return value;
                    }
                }
                
                // Fallback: read from CSS file
                let [cssOk, cssContents] = GLib.file_get_contents(waybarStyleFile);
                if (cssOk && cssContents) {
                    let content = imports.byteArray.toString(cssContents);
                    // Look for border with @inverse_primary (exact logic from existing function)
                    let borderMatch = content.match(/border:\s*([0-9]+)px\s*solid\s*@inverse_primary;/);
                    if (borderMatch) {
                        return borderMatch[1];
                    }
                }
            } catch (e) {
                print('Error reading waybar border size: ' + e.message);
            }
            return '2'; // Default value
        }
        
        // Set initial value
        entry.set_text(loadCurrentWaybarBorderSize());
        
        function updateWaybarBorderSize(newBorderSize) {
            try {
                let numValue = parseInt(newBorderSize);
                if (isNaN(numValue) || numValue < 0 || numValue > 10) {
                    GLib.spawn_command_line_async(`notify-send "Waybar" "Invalid value: ${newBorderSize}. Use 0-10" -t 2000`);
                    return;
                }
                
                // Read current value and update (exact logic from existing function)
                let [ok, contents] = GLib.file_get_contents(waybarStyleFile);
                if (ok && contents) {
                    let content = imports.byteArray.toString(contents);
                    
                    // Look specifically for the border in the window#waybar > box section (exact logic)
                    let borderMatch = content.match(/window#waybar > box\s*\{[\s\S]*?border:\s*([0-9]+)px\s*solid\s*@inverse_primary;[\s\S]*?\}/);
                    
                    if (!borderMatch) {
                        // Fallback: try to find any border with @inverse_primary
                        borderMatch = content.match(/border:\s*([0-9]+)px\s*solid\s*@inverse_primary;/);
                    }
                    
                    if (borderMatch) {
                        let currentValue = parseInt(borderMatch[1]);
                        
                        // Update CSS file using the exact current value (exact sed command from existing logic)
                        GLib.spawn_command_line_async(`sed -i '32s/border: ${currentValue}px solid @inverse_primary;/border: ${numValue}px solid @inverse_primary;/' '${waybarStyleFile}'`);
                        
                        // Update state file
                        GLib.file_set_contents(waybarBorderSizeStateFile, numValue.toString());
                        
                        // Send notification
                        GLib.spawn_command_line_async(`notify-send "Waybar" "Border Size: ${numValue}px" -t 2000`);
                    } else {
                        print('Could not find border pattern in CSS file');
                    }
                }
            } catch (e) {
                print('Error updating waybar border size: ' + e.message);
            }
        }
        
        entry.connect('activate', () => {
            updateWaybarBorderSize(entry.get_text());
        });
        
        row.append(lbl);
        row.append(entry);
        rightTogglesBox.append(row);
    }
    
    //addWaybarBorderSizeRow('Waybar Border');
    
    // --- Waybar Side Margins Control ---
    function addWaybarSideMarginsRow(label) {
        const row = new Gtk.Box({ orientation: Gtk.Orientation.HORIZONTAL, spacing: 8, halign: Gtk.Align.CENTER, valign: Gtk.Align.CENTER });
        const lbl = new Gtk.Label({ label, halign: Gtk.Align.END, xalign: 1 });
        lbl.set_size_request(110, -1);
        
        const entry = new Gtk.Entry({ 
            placeholder_text: '0-255',
            width_chars: 8,
            halign: Gtk.Align.CENTER
        });
        
        // Load current value
        const waybarSideMarginsStateFile = GLib.build_filenamev([hyprsunsetStateDir, 'waybar_side_margins.state']);
        try {
            let [ok, contents] = GLib.file_get_contents(waybarSideMarginsStateFile);
            if (ok && contents) {
                let value = imports.byteArray.toString(contents).trim();
                entry.set_text(value);
            }
        } catch (e) {
            // Use default value from CSS if state file doesn't exist
            entry.set_text('4.5');
        }
        
        function updateWaybarSideMargins(value) {
            const waybarStyleFile = GLib.build_filenamev([GLib.get_home_dir(), '.config', 'waybar', 'style.css']);
            
            try {
                let numValue = parseFloat(value);
                if (isNaN(numValue) || numValue < 0 || numValue > 255) {
                    GLib.spawn_command_line_async(`notify-send "Waybar" "Invalid value: ${value}. Use 0-255" -t 2000`);
                    return;
                }
                
                let valueStr = numValue.toFixed(1);
                
                // Update CSS file - both margin-left and margin-right
                GLib.spawn_command_line_async(`sed -i '27s/margin-left: [0-9.]*px;/margin-left: ${valueStr}px;/' '${waybarStyleFile}'`);
                GLib.spawn_command_line_async(`sed -i '28s/margin-right: [0-9.]*px;/margin-right: ${valueStr}px;/' '${waybarStyleFile}'`);
                
                // Update state file
                GLib.file_set_contents(waybarSideMarginsStateFile, valueStr);
                
                // Send notification
                GLib.spawn_command_line_async(`notify-send "Waybar" "Side-margins: ${valueStr}px" -t 2000`);
            } catch (e) {
                print('Error updating waybar side margins: ' + e.message);
            }
        }
        
        entry.connect('activate', () => {
            updateWaybarSideMargins(entry.get_text());
        });
        
        row.append(lbl);
        row.append(entry);
        rightTogglesBox.append(row);
    }
    
    // --- Waybar Top Margin Control ---
    function addWaybarTopMarginRow(label) {
        const row = new Gtk.Box({ orientation: Gtk.Orientation.HORIZONTAL, spacing: 8, halign: Gtk.Align.CENTER, valign: Gtk.Align.CENTER });
        const lbl = new Gtk.Label({ label, halign: Gtk.Align.END, xalign: 1 });
        lbl.set_size_request(110, -1);
        
        const entry = new Gtk.Entry({ 
            placeholder_text: '0-20',
            width_chars: 8,
            halign: Gtk.Align.CENTER
        });
        
        // Load current value
        const waybarTopMarginStateFile = GLib.build_filenamev([hyprsunsetStateDir, 'waybar_top_margin.state']);
        try {
            let [ok, contents] = GLib.file_get_contents(waybarTopMarginStateFile);
            if (ok && contents) {
                let value = imports.byteArray.toString(contents).trim();
                entry.set_text(value);
            }
        } catch (e) {
            // Use default value from CSS if state file doesn't exist
            entry.set_text('4.5');
        }
        
        function updateWaybarTopMargin(value) {
            const waybarStyleFile = GLib.build_filenamev([GLib.get_home_dir(), '.config', 'waybar', 'style.css']);
            
            try {
                let numValue = parseFloat(value);
                if (isNaN(numValue) || numValue < 0 || numValue > 20) {
                    GLib.spawn_command_line_async(`notify-send "Waybar" "Invalid value: ${value}. Use 0-20" -t 2000`);
                    return;
                }
                
                let valueStr = numValue.toFixed(1);
                
                // Update CSS file - margin-top
                GLib.spawn_command_line_async(`sed -i '26s/margin-top: [0-9.]*px;/margin-top: ${valueStr}px;/' '${waybarStyleFile}'`);
                
                // Update state file
                GLib.file_set_contents(waybarTopMarginStateFile, valueStr);
                
                // Send notification
                GLib.spawn_command_line_async(`notify-send "Waybar" "Top-margin: ${valueStr}px" -t 2000`);
            } catch (e) {
                print('Error updating waybar top margin: ' + e.message);
            }
        }
        
        entry.connect('activate', () => {
            updateWaybarTopMargin(entry.get_text());
        });
        
        row.append(lbl);
        row.append(entry);
        rightTogglesBox.append(row);
    }

    // --- Waybar Outer Radius Control ---
    function addWaybarOuterRadiusRow(label) {
        const row = new Gtk.Box({ orientation: Gtk.Orientation.HORIZONTAL, spacing: 8, halign: Gtk.Align.CENTER, valign: Gtk.Align.CENTER });
        const lbl = new Gtk.Label({ label, halign: Gtk.Align.END, xalign: 1 });
        lbl.set_size_request(110, -1);
        
        const entry = new Gtk.Entry({ 
            placeholder_text: '0-20',
            width_chars: 8,
            halign: Gtk.Align.CENTER
        });
        
        // Load current value
        const waybarOuterRadiusStateFile = GLib.build_filenamev([hyprsunsetStateDir, 'waybar_outer_radius.state']);
        try {
            let [ok, contents] = GLib.file_get_contents(waybarOuterRadiusStateFile);
            if (ok && contents) {
                let value = imports.byteArray.toString(contents).trim();
                entry.set_text(value);
            }
        } catch (e) {
            // Use default value from CSS if state file doesn't exist
            entry.set_text('20.0');
        }
        
        function updateWaybarOuterRadius(value) {
            const waybarStyleFile = GLib.build_filenamev([GLib.get_home_dir(), '.config', 'waybar', 'style.css']);
            
            try {
                let numValue = parseFloat(value);
                if (isNaN(numValue) || numValue < 0 || numValue > 20) {
                    GLib.spawn_command_line_async(`notify-send "Waybar" "Invalid value: ${value}. Use 0-20" -t 2000`);
                    return;
                }
                
                let valueStr = numValue.toFixed(1);
                
                // Update CSS file - border-radius
                GLib.spawn_command_line_async(`sed -i '30s/border-radius: [0-9.]*px;/border-radius: ${valueStr}px;/' '${waybarStyleFile}'`);
                GLib.spawn_command_line_async(`sed -i '19s/border-radius: [0-9.]*px;/border-radius: ${valueStr}px;/' '${waybarStyleFile}'`);
                
                // Update state file
                GLib.file_set_contents(waybarOuterRadiusStateFile, valueStr);
                
                // Send notification
                GLib.spawn_command_line_async(`notify-send "Waybar" "Radius: ${valueStr}px" -t 2000`);
            } catch (e) {
                print('Error updating waybar outer radius: ' + e.message);
            }
        }
        
        entry.connect('activate', () => {
            updateWaybarOuterRadius(entry.get_text());
        });
        
        row.append(lbl);
        row.append(entry);
        rightTogglesBox.append(row);
    }
    
    // --- Waybar Bottom Margin Control ---
    function addWaybarBottomMarginRow(label) {
        const row = new Gtk.Box({ orientation: Gtk.Orientation.HORIZONTAL, spacing: 8, halign: Gtk.Align.CENTER, valign: Gtk.Align.CENTER });
        const lbl = new Gtk.Label({ label, halign: Gtk.Align.END, xalign: 1 });
        lbl.set_size_request(110, -1);
        
        const entry = new Gtk.Entry({ 
            placeholder_text: '0-20',
            width_chars: 8,
            halign: Gtk.Align.CENTER
        });
        
        // Load current value
        const waybarBottomMarginStateFile = GLib.build_filenamev([hyprsunsetStateDir, 'waybar_bottom_margin.state']);
        try {
            let [ok, contents] = GLib.file_get_contents(waybarBottomMarginStateFile);
            if (ok && contents) {
                let value = imports.byteArray.toString(contents).trim();
                entry.set_text(value);
            }
        } catch (e) {
            // Use default value from CSS if state file doesn't exist
            entry.set_text('0.0');
        }
        
        function updateWaybarBottomMargin(value) {
            const waybarStyleFile = GLib.build_filenamev([GLib.get_home_dir(), '.config', 'waybar', 'style.css']);
            
            try {
                let numValue = parseFloat(value);
                if (isNaN(numValue) || numValue < 0 || numValue > 20) {
                    GLib.spawn_command_line_async(`notify-send "Waybar" "Invalid value: ${value}. Use 0-20" -t 2000`);
                    return;
                }
                
                let valueStr = numValue.toFixed(1);
                
                // Update CSS file - margin-bottom
                GLib.spawn_command_line_async(`sed -i '29s/margin-bottom: [0-9.]*px;/margin-bottom: ${valueStr}px;/' '${waybarStyleFile}'`);
                
                // Update state file
                GLib.file_set_contents(waybarBottomMarginStateFile, valueStr);
                
                // Send notification
                GLib.spawn_command_line_async(`notify-send "Waybar" "Bottom-margin: ${valueStr}px" -t 2000`);
            } catch (e) {
                print('Error updating waybar bottom margin: ' + e.message);
            }
        }
        
        entry.connect('activate', () => {
            updateWaybarBottomMargin(entry.get_text());
        });
        
        row.append(lbl);
        row.append(entry);
        rightTogglesBox.append(row);
    }
    
    //addWaybarOuterRadiusRow('Waybar Radius');
    //addWaybarSideMarginsRow('Waybar Sides');
    //addWaybarBottomMarginRow('Waybar Bottom');
    //addWaybarTopMarginRow('Waybar Top');
    
    rightBox.append(rightTogglesBox);
    mainRow.append(rightBox);
    return mainRow;
}

var exports = {
    createCandyUtilsBox
};
EOF

fi

cat > "$HOME/.hyprcandy/GJS/src/media.js" << 'EOF'
imports.gi.versions.Gtk = '4.0';
imports.gi.versions.Gio = '2.0';
imports.gi.versions.GLib = '2.0';
imports.gi.versions.Gdk = '4.0';
imports.gi.versions.Soup = '3.0';
imports.gi.versions.GdkPixbuf = '2.0';
const { Gtk, Gio, GLib, Gdk, Soup, GdkPixbuf } = imports.gi;

const scriptDir = GLib.path_get_dirname(imports.system.programInvocationName);
imports.searchPath.unshift(scriptDir);

const BUS_NAME_PREFIX = 'org.mpris.MediaPlayer2.';
const MPRIS_PATH = '/org/mpris/MediaPlayer2';

function getMprisPlayersAsync(callback) {
    Gio.DBus.session.call(
        'org.freedesktop.DBus',
        '/org/freedesktop/DBus',
        'org.freedesktop.DBus',
        'ListNames',
        null,
        null,
        Gio.DBusCallFlags.NONE,
        -1,
        null,
        (source, res) => {
            try {
                let result = source.call_finish(res);
                let names = result.deep_unpack()[0];
                callback(names.filter(name => name.startsWith(BUS_NAME_PREFIX)));
            } catch (e) {
                callback([]);
            }
        }
    );
}

function createMprisProxy(busName) {
    return Gio.DBusProxy.new_sync(
        Gio.DBus.session,
        Gio.DBusProxyFlags.NONE,
        null,
        busName,
        MPRIS_PATH,
        'org.mpris.MediaPlayer2.Player',
        null
    );
}

function getActivePipeWireSinkInfo() {
    try {
        let [ok, stdout, stderr, status] = GLib.spawn_command_line_sync('pw-cli list-objects Node');
        if (!ok || !stdout) return null;
        let output = imports.byteArray.toString(stdout);
        let nodes = output.split('\n\n');
        for (let node of nodes) {
            if (node.includes('state: running') && node.includes('media.class = "Audio/Stream"') && node.includes('direction = output')) {
                let appNameMatch = node.match(/app.name = "([^"]+)"/);
                let appName = appNameMatch ? appNameMatch[1] : null;
                return { appName };
            }
        }
    } catch (e) {
        return null;
    }
    return null;
}

function createMediaBox() {
    // --- Load user GTK color theme CSS (if available) ---
    const userColorsProvider = new Gtk.CssProvider();
    try {
        userColorsProvider.load_from_path(GLib.build_filenamev([GLib.get_home_dir(), '.config', 'gtk-3.0', 'colors.css']));
        Gtk.StyleContext.add_provider_for_display(
            Gdk.Display.get_default(),
            userColorsProvider,
            Gtk.STYLE_PROVIDER_PRIORITY_USER
        );
    } catch (e) {
        // Ignore if not found
    }

    // --- Load custom gradient and widget CSS ---
    const cssProvider = new Gtk.CssProvider();
    let css = `
        .media-player-frame {
            border-radius: 22px;
            min-width: 244px;
            min-height: 118px;
            padding: 0px 0px;
            box-shadow: 0 4px 32px 0 rgba(0,0,0,0.22);
            background: linear-gradient(45deg, @source_color 0%, @background 100%, #9558e1 0%, #16121a 100%);
            background-size: cover;
        }
        .media-player-bg-overlay {
            background-size: cover;
            background-position: center;
            background-repeat: no-repeat;
            filter: blur(12px) brightness(0.7);
            opacity: 0.7;
            border-radius: 22px;
        }
        .media-player-blurred-bg {
            background-size: cover;
            background-position: center;
            background-repeat: no-repeat;
            background-color: rgba(0, 0, 0, 0.12);
            opacity: 0.95;
            border-radius: 22px;
        }
        .media-artist-label {
            font-size: 0.9em;
            font-weight: 700;
            color: #f0f0f0;
            margin-top: 4px;
            text-shadow: 0 0 8px rgba(224, 224, 224, 0.6);
            opacity: 1;
        }
        .media-title-label {
            font-size: 1.1em;
            font-weight: 600;
            color: #ffffff;
            text-shadow: 0 0 8px rgba(255, 255, 255, 0.7);
            opacity: 1;
        }
        .media-progress-bar {
            margin-top: 4px;
            margin-bottom: 4px;
            color: @primary;
            text-shadow: 0 0 8px @primary;
            opacity: 1;
        }
        .media-progress-bar progressbar {
            background-color: @source_color;
            box-shadow: 0 0 8px rgba(0, 255, 255, 0.5);
        }
        .media-progress-bar progressbar trough {
            background-color: rgba(255, 255, 255, 0.2);
            border-radius: 4px;
        }
        .media-progress-bar progressbar fill {
            background-color: @primary;
            border-radius: 4px;
            box-shadow: 0 0 8px rgba(0, 255, 255, 0.6);
        }
        .media-progress-bar.seeking progressbar fill {
            background-color: #ff6b6b;
            box-shadow: 0 0 12px rgba(255, 107, 107, 0.8);
        }
        .media-progress-bar.paused progressbar fill {
            background-color: #666666;
            box-shadow: 0 0 8px rgba(102, 102, 102, 0.6);
        }
        .media-info-center {
            margin: 0px;
            padding: 0px;
        }
        .media-controls-center {
            padding-right: 16px;
            margin-top: 8px;
            margin-bottom: 4px;
        }
        .media-controls-center button {
            background-color: @blur_background;
            border: 1.5px solid @primary;
            border-radius: 4px;
            color: #ffffff;
            text-shadow: 0 0 6px rgba(255, 255, 255, 0.7);
            transition: all 0.2s ease;
            opacity: 1;
            min-width: 24px;
            min-height: 24px;
            padding: 4px;
        }
        .media-controls-center button:hover {
            background-color: @source_color;
            border-color: @source_color;
            box-shadow: 0 0 12px 2px @background, 0 0 0 2px @background inset;
        }
        .media-controls-center button:active {
            background-color: @source_color;
            transform: scale(0.95);
        }
        .media-controls-center button.shuffle-active {
            background-color: @source_color;
            border-color: @source_color;
            box-shadow: 0 0 8px 2px @background, 0 0 0 2px @background inset;
        }
        .media-controls-center button.loop-track {
            background-color: @source_color;
            border-color: @source_color;
            box-shadow: 0 0 8px 2px @background, 0 0 0 2px @background inset;
        }
        .media-controls-center button.loop-playlist {
            background-color: @source_color;
            border-color: @source_color;
            box-shadow: 0 0 10px 2px @background, 0 0 0 2px @background inset;
        }
        .media-info-container {
            margin-bottom: 4px;
        }
        .media-album-art {
            border-radius: 8px;
            margin-right: 8px;
            opacity: 1;
        }
    `;
    cssProvider.load_from_data(css, css.length);
    Gtk.StyleContext.add_provider_for_display(
        Gdk.Display.get_default(),
        cssProvider,
        Gtk.STYLE_PROVIDER_PRIORITY_APPLICATION
    );

    // --- Define loop mode state and labels at the top for scope ---
    let loopMode = 0; // 0: none, 1: track, 2: playlist
    const loopModes = ['None', 'Track', 'Playlist'];
    const loopLabels = ['No Loop', 'Looping Track', 'Looping Playlist'];

    // --- Media player container (top) ---
    const mediaPlayerBox = new Gtk.Box({
        orientation: Gtk.Orientation.HORIZONTAL,
        spacing: 0,
        halign: Gtk.Align.CENTER,
        valign: Gtk.Align.CENTER,
        hexpand: false,
        vexpand: false,
    });
    mediaPlayerBox.set_size_request(500, 118);
    mediaPlayerBox.set_vexpand(true);
    mediaPlayerBox.set_hexpand(true);
    mediaPlayerBox.set_margin_top(12);
    mediaPlayerBox.set_margin_bottom(12);
    mediaPlayerBox.set_margin_start(12);
    mediaPlayerBox.set_margin_end(12);
    mediaPlayerBox.get_style_context().add_class('media-player-frame');

    // --- Define widgets before layout ---
    const artistLabel = new Gtk.Label({
        label: 'Artist Name',
        halign: Gtk.Align.START,
        valign: Gtk.Align.CENTER,
        xalign: 0,
        ellipsize: 3, // PANGO_ELLIPSIZE_END
        max_width_chars: 24,
        wrap: false,
    });
    artistLabel.add_css_class('media-artist-label');
    const titleLabel = new Gtk.Label({
        label: 'Track Title',
        halign: Gtk.Align.START,
        valign: Gtk.Align.CENTER,
        xalign: 0,
        ellipsize: 3,
        max_width_chars: 24,
        wrap: false,
    });
    titleLabel.add_css_class('media-title-label');
    const albumArt = new Gtk.Image({
        pixel_size: 120,
        icon_name: 'media-optical-symbolic',
        halign: Gtk.Align.END,
        valign: Gtk.Align.CENTER,
    });
    albumArt.add_css_class('media-album-art');
    albumArt.set_size_request(180, 180);
    albumArt.set_valign(Gtk.Align.FILL);
    albumArt.set_halign(Gtk.Align.CENTER);
    albumArt.set_margin_top(4);
    albumArt.set_margin_bottom(4);
    albumArt.set_margin_start(4);
    albumArt.set_margin_end(0); // No margin on the right edge
    const progress = new Gtk.ProgressBar({ show_text: true });
    progress.set_fraction(0.0);
    progress.set_text('--:-- / --:--');
    progress.set_hexpand(true);
    progress.set_vexpand(false);
    progress.add_css_class('media-progress-bar');

    // --- Media control buttons ---
    const loopBtn = Gtk.Button.new_from_icon_name('media-playlist-repeat-symbolic');
    loopBtn.set_tooltip_text(loopLabels[loopMode]);
    const shuffleBtn = Gtk.Button.new_from_icon_name('media-playlist-shuffle-symbolic');
    shuffleBtn.set_tooltip_text('Shuffle Off');
    shuffleBtn._isCustomShuffleOn = false;
    shuffleBtn._setShuffleState = function(on) {
        if (on) {
            if (!this._isCustomShuffleOn) {
                this.set_child(new Gtk.Label({ label: '', halign: Gtk.Align.CENTER, valign: Gtk.Align.CENTER }));
                this._isCustomShuffleOn = true;
            }
            this.set_tooltip_text('Shuffling');
            this.add_css_class('shuffle-active');
        } else {
            if (this._isCustomShuffleOn) {
                this.set_child(Gtk.Image.new_from_icon_name('media-playlist-shuffle-symbolic'));
                this._isCustomShuffleOn = false;
            }
            this.set_tooltip_text('Shuffle Off');
            this.remove_css_class('shuffle-active');
        }
    };
    const prevBtn = Gtk.Button.new_from_icon_name('media-skip-backward-symbolic');
    prevBtn.set_tooltip_text('Previous');
    const playBtn = Gtk.Button.new_from_icon_name('media-playback-start-symbolic');
    playBtn.set_tooltip_text('Play/Pause');
    const nextBtn = Gtk.Button.new_from_icon_name('media-skip-forward-symbolic');
    nextBtn.set_tooltip_text('Next');

    // --- Controls row ---
    const controls = new Gtk.Box({
        orientation: Gtk.Orientation.HORIZONTAL,
        spacing: 8,
        halign: Gtk.Align.CENTER,
        margin_start: 16,
        margin_end: 0
    });
    controls.add_css_class('media-controls-center');
    controls.append(shuffleBtn);
    controls.append(prevBtn);
    controls.append(playBtn);
    controls.append(nextBtn);
    controls.append(loopBtn);

    // --- Left column ---
    const leftColumn = new Gtk.Box({
        orientation: Gtk.Orientation.VERTICAL,
        spacing: 8,
        hexpand: true,
        vexpand: true,
        halign: Gtk.Align.CENTER,
        valign: Gtk.Align.CENTER,
    });
    leftColumn.add_css_class('media-info-left-column');
    artistLabel.set_halign(Gtk.Align.CENTER);
    titleLabel.set_halign(Gtk.Align.CENTER);
    progress.set_halign(Gtk.Align.CENTER);
    controls.set_halign(Gtk.Align.CENTER);
    leftColumn.append(artistLabel);
    leftColumn.append(titleLabel);
    leftColumn.append(progress);
    leftColumn.append(controls);

    // --- Album art (right) ---
    albumArt.set_size_request(140, 140);
    albumArt.set_valign(Gtk.Align.FILL);
    albumArt.set_halign(Gtk.Align.CENTER);
    albumArt.set_margin_top(4);
    albumArt.set_margin_bottom(4);
    albumArt.set_margin_start(4);
    albumArt.set_margin_end(0);
    albumArt.get_style_context().add_class('media-album-art');

    // --- Media info container ---
    const mediaInfoContainer = new Gtk.Box({
        orientation: Gtk.Orientation.HORIZONTAL,
        spacing: 8,
        hexpand: true,
        vexpand: true,
        halign: Gtk.Align.FILL,
        valign: Gtk.Align.CENTER,
    });
    mediaInfoContainer.add_css_class('media-info-container');
    mediaInfoContainer.append(leftColumn);
    mediaInfoContainer.append(albumArt);

    // --- Info box ---
    const infoBox = new Gtk.Box({
        orientation: Gtk.Orientation.VERTICAL,
        spacing: 4,
        hexpand: true,
        vexpand: true,
        halign: Gtk.Align.CENTER,
        valign: Gtk.Align.CENTER,
        margin_top: 8,
        margin_bottom: 8
    });
    infoBox.add_css_class('media-info-center');
    infoBox.remove_all && infoBox.remove_all();
    infoBox.append(mediaInfoContainer);

    // --- Overlay for blurred background ---
    const bgOverlay = new Gtk.Box({
        orientation: Gtk.Orientation.VERTICAL,
        hexpand: true,
        vexpand: true,
    });
    bgOverlay.set_size_request(478, 118);
    bgOverlay.add_css_class('media-player-bg-overlay');
    bgOverlay.set_can_target(false);
    const blurredBg = new Gtk.Box({
        hexpand: true,
        vexpand: true,
    });
    blurredBg.add_css_class('media-player-blurred-bg');
    blurredBg.set_can_target(false);
    blurredBg.set_name('blurredBg'); // For CSS selector
    const overlayFiller = new Gtk.Box({ hexpand: true, vexpand: true });
    bgOverlay.append(blurredBg);
    bgOverlay.append(overlayFiller);

    // --- Media Player Container Box ---
    const playerFrame = new Gtk.Overlay({
        halign: Gtk.Align.CENTER,
        valign: Gtk.Align.CENTER,
        hexpand: false,
        vexpand: false,
    });
    playerFrame.set_size_request(500, 118);
    playerFrame.add_css_class('media-player-frame');
    playerFrame.add_overlay(bgOverlay);
    playerFrame.set_child(infoBox);
    mediaPlayerBox.append(playerFrame);

    // --- State and helpers ---
    let player = null;
    let busName = null;
    const session = new Soup.Session();

    function updatePlayerAsync(callback) {
        getMprisPlayersAsync(players => {
            if (players.length > 0 && (!busName || !players.includes(busName))) {
                print('Detected MPRIS players:', JSON.stringify(players));
            }
            if (players.length > 0) {
                // Prefer browser MPRIS player if available
                const browserNames = ['chromium', 'firefox', 'brave', 'vivaldi', 'chrome', 'opera'];
                let selected = players[0];
                for (let name of players) {
                    if (browserNames.some(b => name.toLowerCase().includes(b))) {
                        selected = name;
                        break;
                    }
                }
                busName = selected;
                try {
                    player = createMprisProxy(busName);
                    print('Created proxy for:', busName);
                } catch (e) {
                    print('Error creating proxy:', e);
                    player = null;
                }
            } else {
                player = null;
                busName = null;
            }
            if (callback) callback();
        });
    }

    function updateTrackInfoAsync() {
        if (!player) {
            let sinkInfo = getActivePipeWireSinkInfo();
            if (sinkInfo) {
                let label = 'Audio is playing (non-MPRIS source)';
                if (sinkInfo.appName) label += `\n${sinkInfo.appName}`;
                titleLabel.set_label(label);
                artistLabel.set_label('');
                progress.set_fraction(0.0);
                progress.set_text('--:-- / --:--');
                [shuffleBtn, prevBtn, playBtn, nextBtn, loopBtn].forEach(btn => btn.set_sensitive(false));
                return;
            } else {
                titleLabel.set_label('No Media');
                artistLabel.set_label('');
                progress.set_fraction(0.0);
                progress.set_text('--:-- / --:--');
                [shuffleBtn, prevBtn, playBtn, nextBtn, loopBtn].forEach(btn => btn.set_sensitive(false));
                return;
            }
        }
        [shuffleBtn, prevBtn, playBtn, nextBtn, loopBtn].forEach(btn => btn.set_sensitive(true));
        Gio.DBus.session.call(
            busName,
            '/org/mpris/MediaPlayer2',
            'org.freedesktop.DBus.Properties',
            'Get',
            GLib.Variant.new_tuple([
                GLib.Variant.new_string('org.mpris.MediaPlayer2.Player'),
                GLib.Variant.new_string('Metadata')
            ]),
            null,
            Gio.DBusCallFlags.NONE,
            -1,
            null,
            (source, res) => {
                try {
                    const metaResult = source.call_finish(res);
                    const metadata = metaResult.deep_unpack()[0].deep_unpack();
                    const title = metadata['xesam:title'] ? metadata['xesam:title'].deep_unpack() : 'Unknown Title';
                    const artistArr = metadata['xesam:artist'] ? metadata['xesam:artist'].deep_unpack() : [];
                    const artist = artistArr.length > 0 ? artistArr[0] : '';
                    let artUrl = metadata['mpris:artUrl'] ? metadata['mpris:artUrl'].deep_unpack() : '';
                    const length = metadata['mpris:length'] ? metadata['mpris:length'].deep_unpack() : 0;
                    Gio.DBus.session.call(
                        busName,
                        '/org/mpris/MediaPlayer2',
                        'org.freedesktop.DBus.Properties',
                        'Get',
                        GLib.Variant.new_tuple([
                            GLib.Variant.new_string('org.mpris.MediaPlayer2.Player'),
                            GLib.Variant.new_string('Position')
                        ]),
                        null,
                        Gio.DBusCallFlags.NONE,
                        -1,
                        null,
                        (src2, res2) => {
                            let position = 0;
                            try {
                                const posResult = src2.call_finish(res2);
                                position = posResult.deep_unpack()[0].deep_unpack();
                            } catch (e) {}
                            let playbackState = 'Stopped';
                            try {
                                const stateVariant = player.get_cached_property('PlaybackStatus');
                                playbackState = stateVariant ? stateVariant.deep_unpack() : 'Stopped';
                                // Debug: print(`Playback state: ${playbackState}, Position: ${Math.floor(position/1000000)}s`);
                            } catch (e) {
                                print(`Error getting playback state: ${e}`);
                            }
                            titleLabel.set_label(title);
                            artistLabel.set_label(artist);
                            if (artUrl && typeof artUrl === 'string' && artUrl.length > 0) {
                                let url = artUrl;
                                if (url.startsWith('file://')) {
                                    url = url.replace('file://', '');
                                    albumArt.set_from_file(url);
                                } else if (url.startsWith('http://') || url.startsWith('https://')) {
                                    let message = Soup.Message.new('GET', url);
                                    session.send_and_read_async(message, GLib.PRIORITY_DEFAULT, null, (session, res) => {
                                        try {
                                            let bytes = session.send_and_read_finish(res);
                                            let stream = Gio.MemoryInputStream.new_from_bytes(bytes);
                                            let pixbuf = GdkPixbuf.Pixbuf.new_from_stream(stream, null);
                                            albumArt.set_from_pixbuf(pixbuf);
                                        } catch (e) {
                                            albumArt.set_from_icon_name('media-optical-symbolic');
                                        }
                                    });
                                } else {
                                    try {
                                        albumArt.set_from_file(url);
                                    } catch (e) {
                                        albumArt.set_from_icon_name('media-optical-symbolic');
                                    }
                                }
                            } else {
                                albumArt.set_from_icon_name('media-optical-symbolic');
                            }
                            if (playbackState === 'Playing') {
                                playBtn.set_icon_name('media-playback-pause-symbolic');
                                progress.remove_css_class('paused');
                            } else {
                                playBtn.set_icon_name('media-playback-start-symbolic');
                                progress.add_css_class('paused');
                            }
                            if (length > 0) {
                                // Update last known position and playback state
                                const previousPosition = lastPosition;
                                const previousState = lastPlaybackState;
                                lastPosition = position;
                                lastPlaybackState = playbackState;
                                
                                // Determine which position to display
                                let displayPosition = position;
                                let displayFraction = position / length;
                                
                                // Handle position freezing for paused state
                                if (previousState === 'Playing' && playbackState !== 'Playing') {
                                    // Just transitioned to paused - freeze the position
                                    frozenPosition = previousPosition;
                                    isPositionFrozen = true;
                                    // Debug: print(`Paused detected: freezing at ${Math.floor(frozenPosition/1000000)}s`);
                                } else if (playbackState === 'Playing') {
                                    // Playing - unfreeze position
                                    isPositionFrozen = false;
                                }
                                
                                // Use frozen position if paused, otherwise use current position
                                if (isPositionFrozen && playbackState !== 'Playing') {
                                    displayPosition = frozenPosition;
                                    displayFraction = frozenPosition / length;
                                } else {
                                    displayPosition = position;
                                    displayFraction = position / length;
                                }
                                
                                // Only update progress bar if not currently seeking AND media is playing
                                if (!isSeeking && playbackState === 'Playing') {
                                    progress.set_fraction(displayFraction);
                                } else if (!isSeeking && playbackState !== 'Playing' && previousPosition > 0) {
                                    // When paused, show the frozen position
                                    progress.set_fraction(displayFraction);
                                }
                                
                                const posSec = Math.floor(displayPosition / 1000000);
                                const lenSec = Math.floor(length / 1000000);
                                progress.set_text(`${Math.floor(posSec/60)}:${('0'+(posSec%60)).slice(-2)} / ${Math.floor(lenSec/60)}:${('0'+(lenSec%60)).slice(-2)}`);
                            } else {
                                if (!isSeeking) {
                                    progress.set_fraction(0.0);
                                }
                                progress.set_text('--:-- / --:--');
                            }
                            let shuffleOn = false;
                            try {
                                const shuffleVariant = player.get_cached_property('Shuffle');
                                shuffleOn = shuffleVariant ? shuffleVariant.deep_unpack() : false;
                            } catch (e) {}
                            shuffleBtn._setShuffleState(shuffleOn);
                            let loopValue = null;
                            try {
                                const loopVariant = player.get_cached_property('LoopStatus');
                                loopValue = loopVariant ? loopVariant.deep_unpack() : null;
                            } catch (e) {}
                            loopMode = loopValue ? loopModes.indexOf(loopValue) : 0;
                            loopBtn.remove_css_class('loop-none');
                            loopBtn.remove_css_class('loop-track');
                            loopBtn.remove_css_class('loop-playlist');
                            loopBtn.add_css_class(`loop-${loopModes[loopMode].toLowerCase()}`);
                            loopBtn.set_tooltip_text(loopLabels[loopMode]);
                            if (loopMode === 1) {
                                loopBtn.set_icon_name('media-playlist-repeat-one-symbolic');
                            } else {
                                loopBtn.set_icon_name('media-playlist-repeat-symbolic');
                            }
                        }
                    );
                } catch (e) {
                    titleLabel.set_label('No Media');
                    artistLabel.set_label('');
                    progress.set_fraction(0.0);
                    progress.set_text('--:-- / --:--');
                }
            }
        );
    }

    // --- Button event handlers ---
    playBtn.connect('clicked', () => {
        if (player && busName) {
            let playbackState = 'Stopped';
            try {
                const stateVariant = player.get_cached_property('PlaybackStatus');
                playbackState = stateVariant ? stateVariant.deep_unpack() : 'Stopped';
            } catch (e) {}
            const method = (playbackState === 'Playing') ? 'Pause' : 'Play';
            Gio.DBus.session.call(
                busName,
                '/org/mpris/MediaPlayer2',
                'org.mpris.MediaPlayer2.Player',
                method,
                null,
                null,
                Gio.DBusCallFlags.NONE,
                -1,
                null,
                null
            );
        }
    });
    nextBtn.connect('clicked', () => {
        if (player && busName) {
            Gio.DBus.session.call(
                busName,
                '/org/mpris/MediaPlayer2',
                'org.mpris.MediaPlayer2.Player',
                'Next',
                null,
                null,
                Gio.DBusCallFlags.NONE,
                -1,
                null,
                null
            );
        }
    });
    prevBtn.connect('clicked', () => {
        if (player && busName) {
            Gio.DBus.session.call(
                busName,
                '/org/mpris/MediaPlayer2',
                'org.mpris.MediaPlayer2.Player',
                'Previous',
                null,
                null,
                Gio.DBusCallFlags.NONE,
                -1,
                null,
                null
            );
        }
    });
    loopBtn.connect('clicked', () => {
        if (player && busName) {
            let loopValue = null;
            try {
                const loopVariant = player.get_cached_property('LoopStatus');
                loopValue = loopVariant ? loopVariant.deep_unpack() : null;
            } catch (e) {}
            loopMode = loopValue ? loopModes.indexOf(loopValue) : 0;
            const newLoopMode = (loopMode + 1) % 3;
            const tryLoopMethods = () => {
                try {
                    Gio.DBus.session.call(
                        busName,
                        '/org/mpris/MediaPlayer2',
                        'org.mpris.MediaPlayer2.Player',
                        'SetLoopStatus',
                        GLib.Variant.new_tuple([GLib.Variant.new_string(loopModes[newLoopMode])]),
                        null,
                        Gio.DBusCallFlags.NONE,
                        -1,
                        null,
                        (source, result) => {
                            try {
                                source.call_finish(result);
                                loopMode = newLoopMode;
                            } catch (e) {
                                try {
                                    Gio.DBus.session.call(
                                        busName,
                                        '/org/mpris/MediaPlayer2',
                                        'org.freedesktop.DBus.Properties',
                                        'Set',
                                        GLib.Variant.new_tuple([
                                            GLib.Variant.new_string('org.mpris.MediaPlayer2.Player'),
                                            GLib.Variant.new_string('LoopStatus'),
                                            GLib.Variant.new_variant(GLib.Variant.new_string(loopModes[newLoopMode]))
                                        ]),
                                        null,
                                        Gio.DBusCallFlags.NONE,
                                        -1,
                                        null,
                                        (source2, result2) => {
                                            try {
                                                source2.call_finish(result2);
                                                loopMode = newLoopMode;
                                            } catch (e2) {}
                                        }
                                    );
                                } catch (e2) {}
                            }
                        }
                    );
                } catch (e) {}
            };
            tryLoopMethods();
        }
    });
    shuffleBtn.connect('clicked', () => {
        if (player && busName) {
            let shuffleOn = false;
            try {
                const shuffleVariant = player.get_cached_property('Shuffle');
                shuffleOn = shuffleVariant ? shuffleVariant.deep_unpack() : false;
            } catch (e) {}
            shuffleOn = !shuffleOn;
            const tryShuffleMethods = () => {
                try {
                    Gio.DBus.session.call(
                        busName,
                        '/org/mpris/MediaPlayer2',
                        'org.mpris.MediaPlayer2.Player',
                        'SetShuffle',
                        GLib.Variant.new_tuple([GLib.Variant.new_boolean(shuffleOn)]),
                        null,
                        Gio.DBusCallFlags.NONE,
                        -1,
                        null,
                        (source, result) => {
                            try {
                                source.call_finish(result);
                            } catch (e) {
                                try {
                                    Gio.DBus.session.call(
                                        busName,
                                        '/org/mpris/MediaPlayer2',
                                        'org.freedesktop.DBus.Properties',
                                        'Set',
                                        GLib.Variant.new_tuple([
                                            GLib.Variant.new_string('org.mpris.MediaPlayer2.Player'),
                                            GLib.Variant.new_string('Shuffle'),
                                            GLib.Variant.new_variant(GLib.Variant.new_boolean(shuffleOn))
                                        ]),
                                        null,
                                        Gio.DBusCallFlags.NONE,
                                        -1,
                                        null,
                                        (source2, result2) => {
                                            try {
                                                source2.call_finish(result2);
                                            } catch (e2) {}
                                        }
                                    );
                                } catch (e2) {}
                            }
                        }
                    );
                } catch (e) {}
            };
            tryShuffleMethods();
        }
    });

    // --- Progress bar seeking logic ---
    function getPointerFraction(widget, x) {
        let alloc = widget.get_allocation();
        let fraction = Math.max(0, Math.min(1, x / alloc.width));
        return fraction;
    }
    
    let seekTarget = 0;
    let isSeeking = false;
    let lastPosition = 0;
    let lastPlaybackState = 'Stopped';
    let frozenPosition = 0;
    let isPositionFrozen = false;
    const gesture = new Gtk.GestureClick();
    const dragGesture = new Gtk.GestureDrag();
    
    gesture.connect('pressed', (gesture, n_press, x, y) => {
        if (!player) return;
        isSeeking = true;
        let fraction = getPointerFraction(progress, x);
        seekTarget = fraction;
        progress.set_fraction(fraction);
        // Add visual feedback during seeking
        progress.add_css_class('seeking');
    });
    
    gesture.connect('released', (gesture, n_press, x, y) => {
        if (!player || !isSeeking) return;
        isSeeking = false;
        let fraction = getPointerFraction(progress, x);
        seekTarget = fraction;
        
        let metadataVariant = player.get_cached_property('Metadata');
        let metadata = metadataVariant ? metadataVariant.deep_unpack() : {};
        let length = metadata['mpris:length'] ? metadata['mpris:length'].deep_unpack() : 0;
        
        if (length > 0) {
            let newPos = Math.floor(length * seekTarget);
            
            // Try SetPosition first (more reliable)
            try {
                Gio.DBus.session.call(
                    busName,
                    '/org/mpris/MediaPlayer2',
                    'org.mpris.MediaPlayer2.Player',
                    'SetPosition',
                    GLib.Variant.new_tuple([
                        GLib.Variant.new_object_path('/org/mpris/MediaPlayer2/TrackList/0'),
                        GLib.Variant.new_int64(newPos)
                    ]),
                    null,
                    Gio.DBusCallFlags.NONE,
                    -1,
                    null,
                    (source, result) => {
                        try {
                            source.call_finish(result);
                            print(`Seek successful: ${newPos} microseconds`);
                            // Add a small delay before resuming normal updates
                            GLib.timeout_add(GLib.PRIORITY_DEFAULT, 100, () => {
                                isSeeking = false;
                                progress.remove_css_class('seeking');
                                // Update frozen position after seek
                                try {
                                    const stateVariant = player.get_cached_property('PlaybackStatus');
                                    const currentPlaybackState = stateVariant ? stateVariant.deep_unpack() : 'Stopped';
                                    if (currentPlaybackState !== 'Playing') {
                                        frozenPosition = newPos;
                                    }
                                } catch (e) {
                                    // If we can't get playback state, assume not playing
                                    frozenPosition = newPos;
                                }
                                return false;
                            });
                        } catch (e) {
                            print(`SetPosition failed: ${e}, trying Seek method`);
                            // Fallback to Seek method
                            try {
                                let positionVariant = player.get_cached_property('Position');
                                let currentPos = positionVariant ? positionVariant.deep_unpack() : 0;
                                let offset = newPos - currentPos;
                                Gio.DBus.session.call(
                                    busName,
                                    '/org/mpris/MediaPlayer2',
                                    'org.mpris.MediaPlayer2.Player',
                                    'Seek',
                                    GLib.Variant.new_tuple([
                                        GLib.Variant.new_int64(offset)
                                    ]),
                                    null,
                                    Gio.DBusCallFlags.NONE,
                                    -1,
                                    null,
                                    (source2, result2) => {
                                        try {
                                            source2.call_finish(result2);
                                            print(`Seek fallback successful: ${offset} microseconds offset`);
                                            // Add a small delay before resuming normal updates
                                            GLib.timeout_add(GLib.PRIORITY_DEFAULT, 100, () => {
                                                isSeeking = false;
                                                progress.remove_css_class('seeking');
                                                // Update frozen position after seek
                                                try {
                                                    const stateVariant = player.get_cached_property('PlaybackStatus');
                                                    const currentPlaybackState = stateVariant ? stateVariant.deep_unpack() : 'Stopped';
                                                    if (currentPlaybackState !== 'Playing') {
                                                        frozenPosition = newPos;
                                                    }
                                                } catch (e) {
                                                    // If we can't get playback state, assume not playing
                                                    frozenPosition = newPos;
                                                }
                                                return false;
                                            });
                                        } catch (e2) {
                                            print(`Seek fallback failed: ${e2}`);
                                            isSeeking = false;
                                            progress.remove_css_class('seeking');
                                        }
                                    }
                                );
                            } catch (e2) {
                                print(`Seek calculation failed: ${e2}`);
                            }
                        }
                    }
                );
            } catch (e) {
                print(`SetPosition call failed: ${e}`);
                isSeeking = false;
                progress.remove_css_class('seeking');
            }
        }
    });
    
    // Handle drag gesture for seeking
    dragGesture.connect('drag-update', (gesture, x, y) => {
        if (!player || !isSeeking) return;
        let fraction = getPointerFraction(progress, x);
        seekTarget = fraction;
        progress.set_fraction(fraction);
    });
    
    // Add gesture controllers to progress bar
    progress.add_controller(gesture);
    progress.add_controller(dragGesture);

    // --- Periodic update ---
    updatePlayerAsync(() => updateTrackInfoAsync());
    const mediaInterval = GLib.timeout_add(GLib.PRIORITY_DEFAULT, 1000, () => {
        updatePlayerAsync(() => updateTrackInfoAsync());
        return true;
    });

    // --- Return the fully constructed media player box ---
    return mediaPlayerBox;
}

var exports = {
    createMediaBox
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
    CUSTOM_CONFIG_FILE="$HOME/.config/hypr/hyprviz.conf"
    
    if [ -f "$CUSTOM_CONFIG_FILE" ]; then
        sed -i "s/\$LAYOUT/$KEYBOARD_LAYOUT/g" "$CUSTOM_CONFIG_FILE"
        print_status "Keyboard layout '$KEYBOARD_LAYOUT' has been applied to custom.conf"
    else
        print_error "Custom config file not found at $CUSTOM_CONFIG_FILE"
        print_error "Please run setup_custom_config() first"
    fi

pgrep -x awww-daemon > /dev/null 2>&1 || awww-daemon &
sleep 1
awww img "$HOME/.hyprcandy/.config/background"

# Start the correct services

echo "🔄 Setting up services..."
systemctl --user daemon-reload

if [ "$PANEL_CHOICE" = "waybar" ]; then
    systemctl --user restart waybar.service waybar-idle-monitor.service waypaper-watcher.service background-watcher.service hyprlock-watcher.service rofi-font-watcher.service cursor-theme-watcher.service &>/dev/null
else
    systemctl --user restart hyprpanel.service hyprpanel-idle-monitor.service background-watcher.service rofi-font-watcher.service cursor-theme-watcher.service &>/dev/null
fi

systemctl enable --now bluetooth
echo "✅ Services set..."

# Update SDDM background with sudo
if command -v magick >/dev/null && [ -f "$HOME/.config/background" ]; then
    sudo magick "$HOME/.config/background[0]" "/usr/share/sddm/themes/sugar-candy/Backgrounds/Mountain.jpg"
    sleep 1
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
    echo -e "${YELLOW}Would you like to reboot now? (n/Y)${NC}"
    read -r reboot_choice
    case "$reboot_choice" in
        [nN][oO]|[nN])
            print_status "Reboot skipped. Please reboot manually when convenient and note that some processes won't function properly until you reboot."
            print_status "Run: sudo reboot"
            rm -rf "$HOME/hyprcandyinstall"
            ;;
        *)
            print_status "Rebooting system..."
            sudo reboot && rm -rf "$HOME/hyprcandyinstall"
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
    echo "  • Pre-configured HyprCandy dotfiles"
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
    
    # Automatically setup HyprCandy configuration
    print_status "Proceeding with HyprCandy configuration setup..."
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
    print_status "• Your HyprCandy configs are in: ~/.hyprcandy/"
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
    print_status "• Find default wallpapers check the ${CYAN}~/Pictures/Candy${NC} or ${CYAN}Candy${NC} folder"
    print_status "• Under ${YELLOW}Matugen Settings${NC} toggle the button to enable matugen color application"
    print_status "• If the wallpaper doesn't apply through the configuration interface, then toggle the button to apply wallpapers"
    print_status "• Ths will quickly reset awww and apply the background"
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
