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
    echo "1) Fish - A fast modern shell with intelligent autosuggestions and syntax highlighting"
    echo "2) Zsh - Powerful shell with extensive customization (Oh My Zsh + Powerlevel10k)"
    echo
    
    while true; do
        echo -e "${YELLOW}Enter your choice (1 for Fish, 2 for Zsh):${NC}"
        read -r shell_choice
        case $shell_choice in
            1)
                SHELL_CHOICE="fish"
                print_status "Selected Fish shell with modern configuration"
                break
                ;;
            2)
                SHELL_CHOICE="zsh"
                print_status "Selected Zsh with Oh My Zsh and Powerlevel10k"
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
            "zsh-autocomplete"
            "zsh-autosuggestions"
            "zsh-history-substring-search"
            "zsh-syntax-highlighting"
            "zsh-theme-powerlevel10k"
            "oh-my-zsh-git"
        )
        print_status "Added Zsh and Oh My Zsh ecosystem to package list"
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
symbol = "+ "
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
set -x EDITOR nano
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
    
    # Configure Powerlevel10k theme
    if [ -f "/usr/share/zsh-theme-powerlevel10k/powerlevel10k.zsh-theme" ]; then
        print_status "Configuring Powerlevel10k theme..."
        
        # Create .zshrc with comprehensive configuration
        cat > "$HOME/.zshrc" << 'EOF'
# HyprCandy Zsh Configuration with Oh My Zsh and Powerlevel10k

# Oh My Zsh configuration
export ZSH="$HOME/.oh-my-zsh"

# Source HyprCandy Zsh setup
source ~/.hyprcandy-zsh.zsh

# Start fastfetch
fastfetch
EOF
        
        # Create a basic Powerlevel10k configuration
        cat > "$HOME/.p10k.zsh" << 'EOF'
# Powerlevel10k configuration for HyprCandy

# Temporarily change options.
'builtin' 'local' '-a' 'p10k_config_opts'
[[ ! -o 'aliases'         ]] || p10k_config_opts+=('aliases')
[[ ! -o 'sh_glob'         ]] || p10k_config_opts+=('sh_glob')
[[ ! -o 'no_brace_expand' ]] || p10k_config_opts+=('no_brace_expand')
'builtin' 'setopt' 'no_aliases' 'no_sh_glob' 'brace_expand'

() {
  emulate -L zsh -o extended_glob

  # Unset all configuration options.
  unset POWERLEVEL10K_*

  # Left prompt segments.
  typeset -g POWERLEVEL10K_LEFT_PROMPT_ELEMENTS=(
    os_icon
    dir
    vcs
    prompt_char
  )

  # Right prompt segments.
  typeset -g POWERLEVEL10K_RIGHT_PROMPT_ELEMENTS=(
    status
    command_execution_time
    background_jobs
    time
  )

  # Basic style options.
  typeset -g POWERLEVEL10K_MODE='nerdfont-complete'
  typeset -g POWERLEVEL10K_ICON_PADDING=moderate
  typeset -g POWERLEVEL10K_PROMPT_ADD_NEWLINE=true
  typeset -g POWERLEVEL10K_MULTILINE_FIRST_PROMPT_PREFIX=''
  typeset -g POWERLEVEL10K_MULTILINE_NEWLINE_PROMPT_PREFIX=''
  typeset -g POWERLEVEL10K_MULTILINE_LAST_PROMPT_PREFIX=''
  typeset -g POWERLEVEL10K_MULTILINE_FIRST_PROMPT_SUFFIX=''
  typeset -g POWERLEVEL10K_MULTILINE_NEWLINE_PROMPT_SUFFIX=''
  typeset -g POWERLEVEL10K_MULTILINE_LAST_PROMPT_SUFFIX=''
  typeset -g POWERLEVEL10K_LEFT_SUBSEGMENT_SEPARATOR=''
  typeset -g POWERLEVEL10K_RIGHT_SUBSEGMENT_SEPARATOR=''
  typeset -g POWERLEVEL10K_LEFT_SEGMENT_SEPARATOR=''
  typeset -g POWERLEVEL10K_RIGHT_SEGMENT_SEPARATOR=''
  typeset -g POWERLEVEL10K_LEFT_PROMPT_LAST_SEGMENT_END_SYMBOL=''
  typeset -g POWERLEVEL10K_RIGHT_PROMPT_FIRST_SEGMENT_START_SYMBOL=''
  typeset -g POWERLEVEL10K_LEFT_PROMPT_FIRST_SEGMENT_START_SYMBOL=''
  typeset -g POWERLEVEL10K_RIGHT_PROMPT_LAST_SEGMENT_END_SYMBOL=''
  typeset -g POWERLEVEL10K_EMPTY_LINE_LEFT_PROMPT_FIRST_SEGMENT_END_SYMBOL='%{%G═╮%}'
  typeset -g POWERLEVEL10K_EMPTY_LINE_RIGHT_PROMPT_FIRST_SEGMENT_START_SYMBOL='%{%G╭═%}'
  typeset -g POWERLEVEL10K_EMPTY_LINE_LEFT_PROMPT_LAST_SEGMENT_END_SYMBOL='%{%G═╯%}'
  typeset -g POWERLEVEL10K_EMPTY_LINE_RIGHT_PROMPT_LAST_SEGMENT_END_SYMBOL='%{%G╰═%}'

  # OS icon
  typeset -g POWERLEVEL10K_OS_ICON_FOREGROUND=232
  typeset -g POWERLEVEL10K_OS_ICON_BACKGROUND=7

  # Directory
  typeset -g POWERLEVEL10K_DIR_FOREGROUND=232
  typeset -g POWERLEVEL10K_DIR_BACKGROUND=4
  typeset -g POWERLEVEL10K_SHORTEN_STRATEGY=truncate_to_last
  typeset -g POWERLEVEL10K_SHORTEN_DIR_LENGTH=1

  # VCS (Git)
  typeset -g POWERLEVEL10K_VCS_BRANCH_ICON=''
  typeset -g POWERLEVEL10K_VCS_UNTRACKED_ICON='?'
  typeset -g POWERLEVEL10K_VCS_UNSTAGED_ICON='!'
  typeset -g POWERLEVEL10K_VCS_STAGED_ICON='+'
  typeset -g POWERLEVEL10K_VCS_INCOMING_CHANGES_ICON='⇣'
  typeset -g POWERLEVEL10K_VCS_OUTGOING_CHANGES_ICON='⇡'
  typeset -g POWERLEVEL10K_VCS_COMMIT_ICON=''
  typeset -g POWERLEVEL10K_VCS_CLEAN_FOREGROUND=232
  typeset -g POWERLEVEL10K_VCS_CLEAN_BACKGROUND=2
  typeset -g POWERLEVEL10K_VCS_MODIFIED_FOREGROUND=232
  typeset -g POWERLEVEL10K_VCS_MODIFIED_BACKGROUND=3
  typeset -g POWERLEVEL10K_VCS_UNTRACKED_FOREGROUND=232
  typeset -g POWERLEVEL10K_VCS_UNTRACKED_BACKGROUND=1

  # Prompt character
  typeset -g POWERLEVEL10K_PROMPT_CHAR_OK_{VIINS,VICMD,VIVIS,VIOWR}_FOREGROUND=76
  typeset -g POWERLEVEL10K_PROMPT_CHAR_ERROR_{VIINS,VICMD,VIVIS,VIOWR}_FOREGROUND=196
  typeset -g POWERLEVEL10K_PROMPT_CHAR_{OK,ERROR}_VIINS_CONTENT_EXPANSION='❯'
  typeset -g POWERLEVEL10K_PROMPT_CHAR_{OK,ERROR}_VICMD_CONTENT_EXPANSION='❮'
  typeset -g POWERLEVEL10K_PROMPT_CHAR_{OK,ERROR}_VIVIS_CONTENT_EXPANSION='V'
  typeset -g POWERLEVEL10K_PROMPT_CHAR_{OK,ERROR}_VIOWR_CONTENT_EXPANSION='▶'
  typeset -g POWERLEVEL10K_PROMPT_CHAR_BACKGROUND=''
  typeset -g POWERLEVEL10K_PROMPT_CHAR_LEFT_PROMPT_LAST_SEGMENT_END_SYMBOL=''
  typeset -g POWERLEVEL10K_PROMPT_CHAR_LEFT_PROMPT_FIRST_SEGMENT_START_SYMBOL=''

  # Command execution time
  typeset -g POWERLEVEL10K_COMMAND_EXECUTION_TIME_THRESHOLD=3
  typeset -g POWERLEVEL10K_COMMAND_EXECUTION_TIME_PRECISION=0
  typeset -g POWERLEVEL10K_COMMAND_EXECUTION_TIME_FOREGROUND=232
  typeset -g POWERLEVEL10K_COMMAND_EXECUTION_TIME_BACKGROUND=3

  # Time
  typeset -g POWERLEVEL10K_TIME_FOREGROUND=232
  typeset -g POWERLEVEL10K_TIME_BACKGROUND=7
  typeset -g POWERLEVEL10K_TIME_FORMAT='%D{%H:%M:%S}'

  # Status
  typeset -g POWERLEVEL10K_STATUS_EXTENDED_STATES=true
  typeset -g POWERLEVEL10K_STATUS_OK=false
  typeset -g POWERLEVEL10K_STATUS_OK_FOREGROUND=2
  typeset -g POWERLEVEL10K_STATUS_OK_BACKGROUND=''
  typeset -g POWERLEVEL10K_STATUS_OK_VISUAL_IDENTIFIER_EXPANSION='✓'
  typeset -g POWERLEVEL10K_STATUS_ERROR_FOREGROUND=9
  typeset -g POWERLEVEL10K_STATUS_ERROR_BACKGROUND=''
  typeset -g POWERLEVEL10K_STATUS_ERROR_VISUAL_IDENTIFIER_EXPANSION='✗'

  # Background jobs
  typeset -g POWERLEVEL10K_BACKGROUND_JOBS_FOREGROUND=6
  typeset -g POWERLEVEL10K_BACKGROUND_JOBS_BACKGROUND=''
  typeset -g POWERLEVEL10K_BACKGROUND_JOBS_VISUAL_IDENTIFIER_EXPANSION='⚙'

  # Instant prompt mode.
  typeset -g POWERLEVEL10K_INSTANT_PROMPT=verbose

  # Hot reload.
  typeset -g POWERLEVEL10K_DISABLE_HOT_RELOAD=true

  # If p10k is already loaded, reload configuration.
  (( ! $+functions[p10k] )) || p10k reload
}

# Restore options.
(( ${#p10k_config_opts} )) && setopt ${p10k_config_opts[@]}
'builtin' 'unset' 'p10k_config_opts'
EOF
        
        print_success "Powerlevel10k configured"
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

    # Create the custom settings directory and file if it doesn't already exist 
    if [ ! -d "$HOME/.config/hyprcustom" ]; then
        mkdir -p "$HOME/.config/hyprcustom" && touch "$HOME/.config/hyprcustom/custom.conf"
        echo "📁 Created the custom settings directory and 'custom.conf' file for your personal settings..."
    fi

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

### ✅ Setup Background Hooks
echo "📁 Creating background hook scripts..."
mkdir -p "$HOME/.config/hyprcandy/hooks" "$HOME/.config/systemd/user"

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

# Restart portal

# Setup Timers
_sleep1="1"
_sleep2="2"
_sleep3="3"

# Kill all possible running xdg-desktop-portals
killall -e xdg-desktop-portal-gtk
killall -e xdg-desktop-portal

# Set required environment variables
dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP=hyprland
sleep $_sleep1

# Stop all services
systemctl --user stop xdg-desktop-portal
systemctl --user stop xdg-desktop-portal-gtk
sleep $_sleep2

# Start xdg-desktop-portal-hyprland
/usr/lib/xdg-desktop-portal &
/usr/lib/xdg-desktop-portal-gtk &
sleep $_sleep3

# Start required services
systemctl --user start xdg-desktop-portal
systemctl --user start xdg-desktop-portal-gtk
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
After=graphical-session.target
Wants=graphical-session.target

[Service]
Type=simple
ExecStart=%h/.config/hyprcandy/hooks/hyprpanel_idle_monitor.sh
Restart=always
RestartSec=10
KillMode=mixed
KillSignal=SIGTERM
TimeoutStopSec=10

[Install]
WantedBy=default.target
EOF

### 🔄 Reload and enable services
echo "🔄 Reloading and enabling services..."
systemctl --user daemon-reexec
systemctl --user daemon-reload
systemctl --user enable --now background-watcher.service &>/dev/null
systemctl --user enable --now hyprpanel-idle-monitor.service &>/dev/null
echo "✅ All set! Both services are running and monitoring for changes."

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
    SVG_SOURCE="$HOME/Pictures/HyprCandy/SVGs/grid.svg"
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
    
    # 🔄 Reload Hyprland
    echo
    echo "🔄 Reloading Hyprland with 'hyprctl reload'..."
    if command -v hyprctl > /dev/null 2>&1; then
        hyprctl reload && echo "✅ Hyprland reloaded successfully." || echo "❌ Failed to reload Hyprland."
    else
        echo "⚠️  'hyprctl' not found. Skipping Hyprland reload."
    fi

    print_success "HyprCandy configuration setup completed!"
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
    echo -e "${PURPLE}🪄 Zsh Configuration:${NC}"
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
