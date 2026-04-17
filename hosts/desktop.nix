{ ... }: {
  networking.hostName = "desktop";

  imports = [
    ../hardware_configs/hardware_configuration_desktop.nix
  ];

  # optional desktop-specific stuff
  # services.xserver.videoDrivers = [ "nvidia" ];
}
