![2025-06-19T17:33:32,983422067+03:00](https://github.com/user-attachments/assets/671960f9-e5ec-42cd-a3ce-87c072ead1eb)
Needed packages: git, hyprland, kitty, then run this commad from inside base hyprland
```shell
git clone https://github.com/HyprCandy/hyprcandyinstall.git && cd hyprcandyinstall
```
followed by
```shell
chmod +x Hyprcandy_installer.sh && ./Hyprcandy_installer.sh
```
The script may also work from TTY but with an error it tries to reload Hyprland. Shouldn't be an issue post-install. 

# Post Install 

[INFO] Configuration management tips:
[INFO] • Your Hyprcandy configs are in: ~/.hyprcandy/
[INFO] • To update configs: cd ~/.hyprcandy && git pull && stow */
[INFO] • To remove a config: cd ~/.hyprcandy && stow -D <config_name> -t /home/king
[INFO] • To reinstall a config: cd ~/.hyprcandy && stow -R <config_name> -t /home/king

══════════════════════🖥️  Post-Installation Configuration  🖼️══════════════════════

[INFO] After rebooting, you may want to configure the following:

📱 Display Configuration:
[INFO] • Use nwg-displays to configure monitor scaling, resolution, and positioning
[INFO] • Launch it from the application menu or run: nwg-displays
[INFO] • Adjust scaling for HiDPI displays if needed

🪄 Zsh Configuration:
[INFO] • IMPORTANT: If you chose Zsh-shell then use SUPER + Q to toggle Kitty and go through the Zsh setup
[INFO] • IMPORTANT: (Remember to type no at the end when asked to Apply changes to .zshrc since HyprCandy already has them applied)
[INFO] • To configure Zsh, in the Home directory edit .hyprcandy-zsh.zsh or .zshrc
[INFO] • You can also rerun the script to switch from either one or regenerate HyprCandy's default Zsh shell setup
[INFO] • You can also rerun the script to install Fish shell
[INFO] • When both are installed switch at anytime by running chsh -s /usr/bin/<name of shell> then reboot

🖼️ Wallpaper Setup (Hyprpanel):
[INFO] • On the firt login post reboot after running the script, use the keybind SUPER + H
[INFO] • This will reload Hyprpanel and SWWW for fluid wallpaper application
[INFO] • Then through Hyprpanel's configuration interface in the Theming section do the following:
[INFO] • Under General Settings choose a wallaper to apply where it says None
[INFO] • Find default wallpapers check the ~/Pictures/HyprCandy or HyprCandy folder
[INFO] • Under Matugen Settings toggle the button to enable matugen color application

🎨 Font, Icon And Cursor Theming:
[INFO] • Open the application-finder with SUPER + A and search for GTK Settings application
[INFO] • Prefered font to set through nwg-look is JetBrainsMono Nerd Font Propo Regular at size 10
[INFO] • Use nwg-look to configure the system-font, tela-icons and cursor themes
[INFO] • Cursor themes take effect after loging out and back in

🐟 Fish Configuration:
[INFO] • To configure Fish edit, in the ~/.config/fish directory edit the config.fish file
[INFO] • You can also rerun the script to switch from either one or regenerate HyprCandy's default Fish shell setup
[INFO] • You can also rerun the script to install Zsh shell
[INFO] • When both are installed switch by running chsh -s /usr/bin/<name of shell> then reboot

🏠 Clean Home Directory:
[INFO] • You can delete the HyprCandy images folder since it's copied into Pictures
[INFO] • The hyprcandyinstall folder can also be deleted since it only takes a few seconds to git clone again
