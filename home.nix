{ lib, pkgs, ...}: {
  home = {
    packages = with pkgs; [
      hello
    ];

    username ="ray";
    homeDirectory = "/home/ray";

    stateVersion = "25.11";
  }
}