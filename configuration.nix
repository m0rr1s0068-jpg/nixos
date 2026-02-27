{ config, pkgs, ... }:
let
   home-manager = builtins.fetchTarball "https://github.com/nix-community/home-manager/archive/release-25.11.tar.gz";
in
{
  imports =
    [
      /etc/nixos/hardware-configuration.nix
      (import "${home-manager}/nixos")
    ];

  home-manager.useUserPackages = true;
  home-manager.useGlobalPackages = true;
  home-manager.backupFileExtention = "backup";
  home-manager.user.ray = import ./home.nix;

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "contender";

  networking.networkmanager.enable = true;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  time.timeZone = "US/Eastern";

  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  services.xserver.enable = true;

  services.xserver.displayManager.lightdm.enable = true;
  services.desktopManager.pantheon.enable = true;

  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };
  
  services.printing.enable = true;

  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  users.users.ray = {
    isNormalUser = true;
    description = "Ray Morris";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
    ];
  };

  programs.firefox.enable = true;

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
  vim
  wget
  git
  tealdeer
  xclip
  bat
  btop
  ];

  services.openssh.enable = true;

  networking.firewall.allowedTCPPorts = [ 22 ];
  networking.firewall.allowedUDPPorts = [ ];
  networking.firewall.enable = true;

  system.stateVersion = "25.11";

}
