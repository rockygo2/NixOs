# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, inputs, ... }:

{
  imports =
  [ # Include the results of the hardware scan.
    inputs.sops-nix.nixosModules.sops
  ];
  sops.defaultSopsFile = ./secrets/secrets.yaml;
  sops.defaultSopsFormat = "yaml";
  
  sops.age.keyFile = "/home/rockygo2/.config/sops/age/keys.txt";
  sops.secrets.example-key = { };
  
  users.groups.secret_key_service = {};

  # Create a group for shared access
  users.groups.secretusers = {
    members = [ "rockygo2" "secret_key_service" ];
  };

  # Define the service user
  users.users.secret_key_service = {
    home = "/var/lib/secret_key_service";
    createHome = true;
    isSystemUser = true;
    group = "secret_key_service";  # primary group
    extraGroups = [ "secretusers" ]; # secondary group for shared access
  };

  # Configure the secret with multiple owners
  sops.secrets."myservice/my_subdir/my_secret" = {
    owner = "secret_key_service";  # primary owner
    group = "secretusers";          # allows rockygo2 as well
  };

  # Systemd service using the secret
  systemd.services."secret_key_service" = {
    script = ''
        echo "
        Hey bro! I'm a service, and imma send this secure password:
        $(sops -d ${config.sops.secrets."myservice/my_subdir/my_secret".path})
        located in:
        ${config.sops.secrets."myservice/my_subdir/my_secret".path}
        to database and hack the mainframe
        " > /var/lib/secret_key_service/testfile
      '';
    serviceConfig = {
      User = "secret_key_service";
      WorkingDirectory = "/var/lib/secret_key_service";
    };
  };
  
  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.systemd-boot.configurationLimit = 5;
  
  virtualisation.docker.enable = true;

  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Amsterdam";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "nl_NL.UTF-8";
    LC_IDENTIFICATION = "nl_NL.UTF-8";
    LC_MEASUREMENT = "nl_NL.UTF-8";
    LC_MONETARY = "nl_NL.UTF-8";
    LC_NAME = "nl_NL.UTF-8";
    LC_NUMERIC = "nl_NL.UTF-8";
    LC_PAPER = "nl_NL.UTF-8";
    LC_TELEPHONE = "nl_NL.UTF-8";
    LC_TIME = "nl_NL.UTF-8";
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable Plasma 
  services.desktopManager.plasma6.enable = true;

  # Default display manager for Plasma
  services.displayManager.sddm = {
    enable = true;
  
  # To use Wayland (Experimental for SDDM)
    wayland.enable = true;
  };

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.rockygo2 = {
    isNormalUser = true;
    description = "Maurice Ibrahim";
    extraGroups = [ "networkmanager" "wheel" "docker"];
    packages = with pkgs; [
    #  thunderbird
    ];
  };

  # Install firefox.
  programs.firefox.enable = true;

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };
  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
	firefox
	git
	python3
	gh
	signal-desktop
	ghidra
	gcc
	john
	seclists
	gef
	unzip
	gnumake
	home-manager
	obsidian
	vim
	vscode
	discord
	pwninit
 	pwntools
	sops
	tmux
  file
  patchelf
	one_gadget
  thunderbird
	remmina
  nmap
  wireshark
  qemu
  docker
  calibre
  tor-browser
  openvpn
  steam
  burpsuite
  (writeShellScriptBin "gdb" ''
    exec ${gdb}/bin/gdb -x ${gef}/share/gef/gef.py "$@"
  '')
	(let base = pkgs.appimageTools.defaultFhsEnvArgs; in
      		pkgs.buildFHSEnv (base // {
      		name = "fhs";
      		targetPkgs = pkgs:
        	# pkgs.buildFHSEnv provides only a minimal FHS environment,
        	# lacking many basic packages needed by most software.
        	# Therefore, we need to add them manually.

        	# pkgs.appimageTools provides basic packages required by most software.
        	(base.targetPkgs pkgs) ++ (with pkgs; [
          		pkg-config
          		ncurses
          	# Feel free to add more packages here if needed.
        	]
      	);
        profile = ''
    		export FHS=1
    		export PS1="(FHS) $PS1"
  	'';
     	runScript = "bash -i";
      	extraOutputsToInstall = ["dev"];
    	}))
  #  wget
	  ];
  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;
  # Aliases  
  environment.shellAliases = {
  	ll = "ls -l";
    pwninit = "pwninit --template-path ~/nix-config/templates/pwninit-template.py --template-bin-name e";
    pin = "/home/rockygo2/tools/pin-external/pin";
  };

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # nix nh
  programs.nh = {
    enable = true;
    clean.enable = true;
    clean.extraArgs = "--keep-since 4d --keep 3";
    flake = "/home/rockygo2/nix-config"; # sets NH_OS_FLAKE variable for you
  };
  
  # environment variables
  environment.sessionVariables = {
    NH_FLAKE = "/home/rockygo2/nix-config";
  };
  
  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.11"; # Did you read the comment?
  
}
