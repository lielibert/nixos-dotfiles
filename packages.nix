{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
# others
vlc
clinfo
imagemagick
yt-dlp
ydotool
btop
htop
aria2
jellyfin-ffmpeg
obs-studio
bluetui
kanata-with-cmd
tree
gnumake42
rustup
unzip
gcc
ripgrep
fzf
  ];
}
