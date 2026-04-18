{ config, lib, pkgs, ... }:

let
  anilibrix = pkgs.appimageTools.wrapType2 {
    pname = "anilibrix";
    version = "1.4.3";
    src = ./assets/AniLibrix-linux-x86_64-1.4.3.AppImage;

    extraPkgs = pkgs: [
      pkgs.libxshmfence
    ];
  };
in

{
  imports =
    [
      ./hardware-configuration.nix
    ];

  boot = {
    loader = {
      systemd-boot.enable = true;
      grub.enable = false;
      efi = {
        canTouchEfiVariables = true;
      };
    };
    kernelPackages = pkgs.linuxPackages;
  };

  time.timeZone = "Europe/Kyiv";
  i18n.defaultLocale = "en_US.UTF-8";

  services.dbus.enable = true;
  programs.dconf.enable = true;
  networking = {
    hostName = "nixos";

    networkmanager.enable = true;

    firewall = {
      enable = true;
      allowedTCPPorts = [ ];
      allowedUDPPorts = [ ];
    };
  };

  users.users.kyd0 = {
    isNormalUser = true;
    description = "kyd0";
    extraGroups = [ "wheel" "video" "audio" "input" "networkmanager" "adbusers" ];
    shell = pkgs.zsh;
    packages = with pkgs; [
      ranger
      hyprpaper
      wofi
      waybar
      foot
      mpvpaper
      mpv
      mpc
      mpd
      spotify
      obs-studio
      cheese
      ncmpcpp
      firefox
      telegram-desktop
      libreoffice
      zoom-us
      vesktop
      grim
      shotcut
      wf-recorder
      taterclient-ddnet
      gamescope
      gimp
      slurp
      vscodium
    ];
  };

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = with pkgs; [
      intel-media-driver
      vulkan-tools
      intel-compute-runtime
    ];
  };

  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa = {
      enable = true;
      support32Bit = true;
    };
    pulse.enable = true;
    jack.enable = true;
  };

  services.mpd = {
    enable = true;

    settings = {
      audio_output = [
        {
	  type = "pipewire";
	  name = "PipeWire Output";
	}
      ];
    };

    network.listenAddress = "localhost";
  };

  services.greetd = {
    enable = true;
    settings = rec {
      initial_session = {
        command = "start-hyprland";
        user = "kyd0";
      };
      default_session = initial_session;
    };
  };

  security.sudo.wheelNeedsPassword = true;
  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      PermitRootLogin = "no";
    };
  };

  services.xserver.enable = false;
  programs.hyprland = {
    enable = true;
    withUWSM = false;
    xwayland.enable = true;
  };
  programs.hyprlock.enable = true;
  services.hypridle.enable = true;

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-hyprland
    ];
  };

  programs.zsh = {
    enable = true;
    syntaxHighlighting.enable = true;
    shellAliases = {
      hy = "sudo nvim /home/kyd0/.config/hypr/hyprland.conf";
      nx = "sudo nvim /etc/nixos/configuration.nix";
      rb = "sudo nixos-rebuild switch --flake /etc/nixos#nixos";
      cnx = "sudo nix-env --delete-generations --profile /nix/var/nix/profiles/system +3";
    };
  };

  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
  };

  nixpkgs.config.allowUnfree = true;

  services.flatpak.enable = true;
  systemd.services.flatpak-repo = {
    wantedBy = [ "multi-user.target" ];
    after = [ "network-online.target" ];
    wants = [ "network-online.target" ];

    path = [ pkgs.flatpak ];
    script = ''
      flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
    '';
  };

  programs.steam.enable = true;
  programs.gamemode.enable = true;

  environment.systemPackages = with pkgs; [
    brightnessctl
    anilibrix
    playerctl
    pamixer
    polymc
    xdg-utils
    git
    htop
    btop
    fastfetch
    cava
    wget
    curl
    unzip
    (python3.withPackages (ps: with ps; [
      tkinter
      pip
    ]))
    bibata-cursors
    ffmpeg
    android-tools
    scrcpy
    usbutils
    jdk21
    gcc
    gnumake
    clang
    clang-tools
    cmake
    nodejs
    wl-clipboard
    maxima
    wxmaxima
    mangohud
  ];

  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    WLR_NO_HARDWARE_CURSORS = "1";
    XDG_SESSION_TYPE = "wayland";
    MOZ_ENABLE_WAYLAND = "1";
  };

  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-cjk-serif
    noto-fonts-color-emoji
    font-awesome
  ];

  services.tlp.enable = true;
  services.fstrim.enable = true;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  system.stateVersion = "25.11";

}

