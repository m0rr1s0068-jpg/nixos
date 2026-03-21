{
  config,
  pkgs,
  inputs,
  ...
}: {
  users.users.ray = {
    initialHashedPassword = "$6$IPRB3G40NlmTOL6m$UrEWbuI0hmxnBMr53YCot8jOXGfZIXlwGDVJmpeP3neYZ15l22eq8T1QXGO9lqQkZGpm4UMxeNhc82g96RbFI0";
    isNormalUser = true;
    description = "Ray Morris";
    extraGroups = [
      "wheel"
      "libvirtd"
      "flatpak"
      "audio"
      "video"
      "plugdev"
      "input"
      "kvm"
      "qemu-libvirtd"
    ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPw5um0N58/qt3HtgSLlaBs7LoTPjiDd3YGMQAdV3h65 ray@rogue"
    ];
    packages = [inputs.home-manager.packages.${pkgs.system}.default];
  };
  home-manager.users.ray =
    import ../../../home/ray/${config.networking.hostName}.nix;
}