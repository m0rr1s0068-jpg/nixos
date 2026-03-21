{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  boot.plymouth = {
    enable = true;
    theme = "bgrt";
  };

  boot.initrd.systemd.enable = true;

  boot.consoleLogLevel = 0;
  boot.kernelParams = [
    "quiet"
    "splash"
    "boot.shell_on_fail"
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.kernelPackages = pkgs.linuxPackages_latest;

  networking.hostName = "rogue";

  networking.bridges = {
    "br0" = {
      interfaces = [ "enp42s0" ];
    };
  };

  networking.useDHCP = false;
  networking.interfaces.enp42s0.useDHCP = false;
  networking.interfaces.br0.useDHCP = true;

  virtualisation.libvirtd.enable = true;
  programs.virt-manager.enable = true;

  time.timeZone = "US/Eastern";

  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS        = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT    = "en_US.UTF-8";
    LC_MONETARY       = "en_US.UTF-8";
    LC_NAME           = "en_US.UTF-8";
    LC_NUMERIC        = "en_US.UTF-8";
    LC_PAPER          = "en_US.UTF-8";
    LC_TELEPHONE      = "en_US.UTF-8";
    LC_TIME           = "en_US.UTF-8";
  };

  services.xserver.enable = true;

  services.xserver.displayManager.lightdm.enable = true;
  services.xserver.desktopManager.xfce.enable = true;

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
    extraGroups = [ "wheel" ];
    packages = with pkgs; [
     tree
    ];
  };

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    vim
    wget
    curl
    git
    btop
    net-tools
    bat
    eza
    fastfetch
    btop
    vscode
    vscode.fhs
    google-chrome
    geany
    libreoffice-fresh
    direnv
  ];

#   nixpkgs.config.permittedInsecurePackages = [
#     "openssl-1.1.1w"
#   ];

  services.openssh.enable = true;

  networking.firewall.allowedTCPPorts = [ 22 ];
  networking.firewall.allowedUDPPorts = [  ];
  networking.firewall.enable = true;

  security.sudo.wheelNeedsPassword = false;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  system.stateVersion = "25.11"; # Did you read the comment?
}
