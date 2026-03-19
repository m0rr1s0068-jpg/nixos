{ config, lib, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
    ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;

  networking.hostName = "rogue";

  networking.useDHCP = false;
  networking.bridges = {
    "br0" = {
      interfaces = [ "enp42s0" ];
    };
  };
  networking.interfaces.br0.ipv4.addresses = [ {
    address = "10.10.10.5";
    prefixLength = 24;
  } ];
  networking.defaultGateway = "10.10.10.1";
  networking.nameservers = ["10.10.10.1" "8.8.8.8"];

  time.timeZone = "US/Eastern";

  services.xserver.enable = true;
  services.xserver.desktopManager.xfce.enable = true;
  services.xserver.displayManager.lightdm.enable = true;

  services.printing.enable = true;

  services.pipewire = {
    enable = true;
    pulse.enable = true;
  };

  users.users.ray = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    packages = with pkgs; [
      tree
    ];
  };

  security.sudo.wheelNeedsPassword = false; 

  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [
    vim
    wget
    git
    curl
    pciutils
    google-chrome
    xfce.xfce4-whiskermenu-plugin
    xfce.xfce4-pulseaudio-plugin
    epson-escpr2
    inputs.helix.packages."${pkgs.stdenv.hostPlatform.system}".helix
  ];

  services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  system.stateVersion = "25.11"; # Did you read the comment?

}

