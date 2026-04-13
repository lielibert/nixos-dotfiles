{
  config,
  lib,
  pkgs,
  ...
}:

{
  imports = [
    ./hardware-configuration.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "l1";
  # networking.networkmanager.enable = true;
  networking.wireless.enable = true;

  time.timeZone = "Asia/Kolkata";

  services.displayManager.ly.enable = true;
  services.hypridle.enable = true;
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;

  };
  programs.hyprlock.enable = true;

  users.users.last = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
  };

  programs.firefox.enable = true;

  environment.systemPackages = with pkgs; [
    vim
    neovim
    git
    alacritty
    foot
  ];

  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
  ];

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
  system.stateVersion = "25.11";
  environment.stub-ld.enable = true;
}
