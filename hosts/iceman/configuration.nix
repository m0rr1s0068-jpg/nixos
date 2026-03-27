# Main Configurations
{ 
  imputs,
  lib,
  ...
}:
{
   #Adjust according to yout platform, such as
  imports =
    [
      ./hardware-configuration.nix
      ./services
      ../modules/common
      ../modules/servers
    ];

    isVirtual = true;

    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;

    networking.hostName = "iceman";

    networking.networkmanager.enable = true;

  time.timeZone = "America/New_York";

  users.users.ray = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEXquymX88l82mTrrAGge2sMTeYEresL26qWu2npHnvK ray@rogue"
    ];
    packages = with pkgs; [
      tree
    ];
  };

  environment.systemPackages = with pkgs; [
    vim
    wget
    bat
    btop
    fastfetch
    git
    net-tools
  ];

  services.openssh = {
    enable = true;
    ports = [ 22 ];
    settings = {
      PasswordAuthentication = false;
      AllowUsers = [ "ray" ];
    UseDns = false;
    X11Forwarding = false;
    PermitRootLogin = "prohibit-password";
    };
  };

  security.sudo = {
    enable = true;
    wheelNeedsPassword = false;
  };

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  system.stateVersion = "25.11";
}

