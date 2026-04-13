{ config, pkgs, ... }:

let
  dotfiles = "${config.home.homeDirectory}/nixos-dotfiles/config";
  create_symlink = path: config.lib.file.mkOutOfStoreSymlink path;
  configs = {
  nvim = "nvim";
  hypr = "hypr";
  quickshell = "quickshell";
  };

in
{

imports = [ ./main-packages.nix ./packages.nix ];
  home.username = "last";
  home.homeDirectory = "/home/last";
  programs.git.enable = true;
  home.stateVersion = "25.11";
  home.packages = with pkgs; [
	clinfo
  ];
  programs.bash = {
	  enable = true;
  };
  xdg.configFile = builtins.mapAttrs (name: subpath:{
  source = create_symlink "${dotfiles}/${subpath}";
  recursive = true;
  })
  configs;

}
