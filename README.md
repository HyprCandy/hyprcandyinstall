![2025-06-19T17:33:32,983422067+03:00](https://github.com/user-attachments/assets/671960f9-e5ec-42cd-a3ce-87c072ead1eb)
Needed packages: git, hyprland, kitty, then run this commad from inside base hyprland
```shell
git clone https://github.com/HyprCandy/hyprcandyinstall.git && cd hyprcandyinstall
```
followed by
```shell
chmod +x Hyprcandy_installer.sh && ./Hyprcandy_installer.sh
```
The script may also work from TTY but with an error when it tries to reload Hyprland. Shouldn't be an issue after restarting. 

# Post Install 

Configuration management tips:

• Your Hyprcandy configs are in: ~/.hyprcandy/

• To update configs: cd ~/.hyprcandy && git pull && stow */

• To set custom keybinds and other Hyprland settings, create the "hyprcustom" folder in "~/.config" waith a "custom.conf" file

Then in "~/.config/hypr/hyprland.conf" uncomment the line "#source = ~/.config/hyprcustom/custom.conf"

•  Toggle "SUPER + CTRL + K" for the rofi-keybinds menu

═══════════🖥️  Post-Installation Configuration  🖼️═══════════

After rebooting, you may want to configure the following:


[INFO] 📱 Display Configuration:

• Use nwg-displays to configure monitor scaling, resolution, and positioning

• Launch it from the application menu or run: nwg-displays

• Adjust scaling for HiDPI displays if needed

[INFO] 🪄 Zsh Configuration:

• IMPORTANT: If you chose Zsh-shell then use "SUPER + Q" to toggle Kitty scratchpad instance and go through the Zsh setup

• IMPORTANT: (Remember to type no at the end when asked to Apply changes to .zshrc since HyprCandy already has them applied)

• To configure Zsh, in the Home directory edit .hyprcandy-zsh.zsh or .zshrc

• You can also rerun the script to switch from either one or regenerate HyprCandy's default Zsh shell setup

• You can also rerun the script to install Fish shell

• When both are installed switch at anytime by running chsh -s /usr/bin/<name of shell> then reboot

[INFO] 🖼️ Wallpaper Setup (Hyprpanel):

• Through Hyprpanel's configuration interface in the Theming section do the following:

• Under General Settings choose a wallaper to apply where it says None

• Find default wallpapers check the ~/Pictures/HyprCandy or HyprCandy folder

• Under Matugen Settings toggle the button to enable matugen color application

• Incase the wallpaper doesn't apply then reload Hyprpanel and SWWW with the keybind "SUPER + H"

[INFO] 🎨 Font, Icon And Cursor Theming:

• Open the application-finder with "SUPER + A" and search for GTK Settings application

• Prefered font to set through nwg-look is JetBrainsMono Nerd Font Propo Regular at size 10

• Use nwg-look to configure the system-font, tela-icons and cursor themes

• Cursor themes take effect after loging out and back in

[INFO] 🐟 Fish Configuration:

• To configure Fish edit, in the ~/.config/fish directory edit the config.fish file

• You can also rerun the script to switch from either one or regenerate HyprCandy's default Fish shell setup

• You can also rerun the script to install Zsh shell

• When both are installed switch by running chsh -s /usr/bin/<name of shell> then reboot

[INFO] 🎭 Fatfetch:

• In "~/.config/fastfetch" you can editthe "config.jsonc" file to your liking

• You can also add custom images in "png" fomart into the "pngs" folder

• If you wish to disable fastfetch when using Zsh, remove the "fastfetch" comment in "~/.hyprcandy-zsh.zsh"

• If you wish to disable fastfetch when using Fish, remove the "fastfetch" comment in "~/.config/fish/config.fish"

[INFO] 🏠 Clean Home Directory:

• You can delete the HyprCandy images folder since it's copied into Pictures

• The hyprcandyinstall folder can also be deleted since it only takes a few seconds to git clone again
