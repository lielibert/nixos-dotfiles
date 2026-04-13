{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
# hyprland utils
hyprlock
hypridle
hyprpolkitagent
hyprpicker
waypaper

# xdg-portal
xdg-desktop-portal
xdg-desktop-portal-gtk
xdg-desktop-portal-hyprland

# sound
wireplumber

# notification daemon
dunst

# screenshot
grim
slurp
grimblast

# gtk
gtk4
gtk3

# settings
nwg-look
kdePackages.qt6ct

# icons
papirus-nord

# cursor icon
bibata-cursors

# menu
rofi
rofi-rbw
rofi-nerdy
rofimoji

# clipboard
wl-clipboard
cliphist

# file manager
nautilus
kdePackages.dolphin
yazi

# terminal
foot
zoxide
tmux
zsh
oh-my-zsh
oh-my-posh
zsh-autocomplete
zsh-syntax-highlighting
zsh-fast-syntax-highlighting

# bar
quickshell

# wallpaper
awww

# pdf
zathuraPkgs.zathura_core
zathuraPkgs.zathura_pdf_mupdf

  ];
}
