{ pkgs, ... }:
{
  imports = [
    ./hardware-configuration.nix
  ];

  boot = {
    binfmt.emulatedSystems = [ "aarch64-linux" ];
    loader = {
      systemd-boot = {
        enable = true;
        configurationLimit = 20;
      };
      efi.canTouchEfiVariables = true;
    };
  };

  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  programs.nix-ld = {
    enable = true;
    libraries = with pkgs; [
      icu # localization lib

      # needs cleaning
      dbus
      pango
      cairo
      alsa-lib
      glib
      nss
      nspr
      at-spi2-core
      libgbm
      libdrm
      expat
      cups
      # this too
      libxcb
      libX11
      libXcomposite
      libXdamage
      libXext
      libXfixes
      libXrandr

      # DirkEngine
      wayland
      libxkbcommon
      vulkan-loader
      vulkan-validation-layers

      # Hazel
      gtk3
      zlib
      elfutils
      libunwind
      tbb
    ];
  };

  networking = {
    hostName = "nixosbtw";
    networkmanager = {
      enable = true;
      wifi.backend = "iwd";
    };
    interfaces."enp39s0".wakeOnLan.enable = true;
    wireless.iwd = {
      enable = true;
      settings = {
        Settings = {
          AutoConnect = true;
        };
      };
    };
    nameservers = [
      "1.1.1.1"
      "1.0.0.1"
    ];
  };

  environment = {
    shells = with pkgs; [ zsh ];
    variables = {
      LANG = "en_US.UTF-8";
      EDITOR = "vim";

      # Vulkan Configuration
      VK_ADD_LAYER_PATH = "${pkgs.vulkan-validation-layers}/share/vulkan/explicit_layer.d";
    };
    systemPackages = with pkgs; [
      zsh
      neovim
      zip
      unzip
      tree
      fd
      fzf
      file
      xdg-user-dirs
      mesa
      alsa-utils
      alsa-scarlett-gui
      rocmPackages.rocm-smi
    ];
  };

  # NIX CONFIGURATION

  nix = {
    gc = {
      automatic = true;
      options = "--delete-older-than 10d";
      dates = "weekly";
    };
    settings = {
      auto-optimise-store = true;
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      trusted-users = [
        "root"
        "@wheel"
        "piquel"
      ];
    };
  };

  system = {
    stateVersion = "25.11";
    userActivationScripts.zshrc = "touch .zshrc";
    autoUpgrade.enable = true;
    autoUpgrade.dates = "daily";
  };

  # LANGUAGE & i18n SETTINGS

  time.timeZone = "Europe/Paris";

  console.keyMap = "fr";
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
}
