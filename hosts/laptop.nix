{ ... }: {
  networking.hostName = "laptop";

  imports = [
    ../hardware_configs/hardware_configuration_laptop.nix
  ];

  # optional laptop-specific stuff
  # powerManagement.enable = true;
}
