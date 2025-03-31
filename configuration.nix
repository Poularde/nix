# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, inputs, home-manager, chaotic, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "garuda"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Paris";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "fr_FR.UTF-8";
    LC_IDENTIFICATION = "fr_FR.UTF-8";
    LC_MEASUREMENT = "fr_FR.UTF-8";
    LC_MONETARY = "fr_FR.UTF-8";
    LC_NAME = "fr_FR.UTF-8";
    LC_NUMERIC = "fr_FR.UTF-8";
    LC_PAPER = "fr_FR.UTF-8";
    LC_TELEPHONE = "fr_FR.UTF-8";
    LC_TIME = "fr_FR.UTF-8";
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment with HDR
  # services.xserver.displayManager.gdm.enable = true;
  # services.xserver.desktopManager.gnome.enable = true;
  # services.colord.enable = true;
  # services.xserver.displayManager.gdm.wayland = true;
  # environment.sessionVariables = {
  #   MUTTER_DEBUG_ENABLE_HARDWARE_HDR = "1";
  # };
  # # Set up an HDR-capable monitor profile (replace with your actual profile)
  # services.udev.extraRules = ''
  #   ACTION=="add", SUBSYSTEM=="drm", KERNEL=="card*", RUN+="${pkgs.coreutils}/bin/echo high > /sys/class/drm/card0/device/power_dpm_force_performance_level"
  # '';
  
  # Enable KDE
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "alt-intl";
  };

  # Configure console keymap
  console.keyMap = "us";

  # Enable CUPS to print documents.
  services.printing.enable = false;

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

  # Enable Bluetooth (KDE)
  hardware.bluetooth.enable = true; # enables support for Bluetooth
  hardware.bluetooth.powerOnBoot = true; # powers up the default Bluetooth controller on boot

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.poularde = {
    isNormalUser = true;
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDViNacBLN5L3mBng9DYfaLiBsCWYwNLsd8D7Ut7Bv4P poularde@nixos"
    ];
    description = "Poularde";
    extraGroups = [ "networkmanager" "wheel" ];
    shell = pkgs.zsh;
    packages = with pkgs; [
      lshw
      brave
      htop
      git
      vscode
      discord
      wowup-cf
    ];
  };
  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    mpv
    steamtinkerlaunch
    lutris
    gnome-tweaks
    gnome-shell-extensions
    libva-utils
    libvdpau
    vkbasalt
    dxvk
    proton-ge-custom
    vulkanPackages_latest.vulkan-extension-layer
    vulkanPackages_latest.vulkan-headers
  ];

  # Steam
  programs.steam = {
    enable = true;
    gamescopeSession.enable = true;
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
    localNetworkGameTransfers.openFirewall = true; # Open ports in the firewall for Steam Local Network Game Transfers
  };

  #AppImage for Shadow
  programs.appimage = {
  enable = true;
  binfmt = true;
  };

  # Nvidia GPU
  boot.kernelParams = [
    "initcall_blacklist=simpledrm_platform_driver_init"
  ];
  # Enable OpenGL
  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      vaapiVdpau
      libvdpau-va-gl
      nvidia-vaapi-driver
    ];
  };
  # Load nvidia driver for Xorg and Wayland
  services.xserver.videoDrivers = ["nvidia"];
  hardware.nvidia = {
  # Modesetting is required.
  modesetting.enable = true;
  # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
  # Enable this if you have graphical corruption issues or application crashes after waking
  # up from sleep. This fixes it by saving the entire VRAM memory to /tmp/ instead 
  # of just the bare essentials.
  powerManagement.enable = false;
  # Fine-grained power management. Turns off GPU when not in use.
  # Experimental and only works on modern Nvidia GPUs (Turing or newer).
  powerManagement.finegrained = false;
  # Use the NVidia open source kernel module (not to be confused with the
  # independent third-party "nouveau" open source driver).
  # Support is limited to the Turing and later architectures. Full list of 
  # supported GPUs is at: 
  # https://github.com/NVIDIA/open-gpu-kernel-modules#compatible-gpus 
  # Only available from driver 515.43.04+
  # Currently alpha-quality/buggy, so false is currently the recommended setting.
  open = false;
  # Enable the Nvidia settings menu,
  # accessible via `nvidia-settings`.
  nvidiaSettings = true;
  # Optionally, you may need to select the appropriate driver version for your specific GPU.
  package = config.boot.kernelPackages.nvidiaPackages.beta;
  };

  # ZSH
  programs = {
    zsh = {
      enable = true;
      ohMyZsh = {
        enable = true;
        theme = "robbyrussell";
        plugins = [
          "git"
          "systemadmin"
        ];
      };
    };
  };

  
  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?
  
  #Flakes
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Garbage colelctor to cleanup old generations
  nix.gc = {
  automatic = true;
  persistent = true;
  dates = "21:00:00";  # Schedule garbage collection at 5 AM
  options = "--delete-older-than 30d";  # Delete generations older than 7 days
  };
}
