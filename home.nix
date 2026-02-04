{ config, pkgs, ... }:

{
  home.username = "simon";
  home.homeDirectory = "/home/simon";
  home.stateVersion = "25.05";

  imports = [
    ./home/base/core/editor/emacs
  ];

  xresources.properties = {
    "Xcursor.size" = 32;
    "Xft.dpi" = 192;
  };

  home.packages = with pkgs; [
    ripgrep
    coreutils
    fd
    clang
    fira
    fira-code
    bun
    nodePackages.prettier
    nodePackages.typescript-language-server
    typescript
    nil
    gnupg
    pass
    browserpass
    wl-clipboard   # Wayland (WSLg)
    xclip          # X11 fallback
    racket
    fava
    beancount-language-server
  ];

  programs.git = {
    enable = true;
    userName = "Simon Lau";
    userEmail = "ualnamnuhc@gmail.com";
    signing = {
      key = "7789D9F67AF5E8C3";
      signByDefault = true;
    };

    extraConfig = {
      gpg.program = "gpg";
      init.defaultBranch = "main";
    };
  };

  programs.bash = {
    enable = true;
    shellAliases = {
      emacs = "emacsclient -c -a ''";
    };
  };

  services.ssh-agent.enable = false;

  programs.ssh = {
    enable = true;
    extraConfig = ''
      Host github.com
        HostName ssh.github.com
        User git
        Port 443

      Host *
        AddKeysToAgent yes
        ServerAliveInterval 60
        ServerAliveCountMax 3
    '';
  };

  programs.gpg = {
    enable = true;
    homedir = "${config.home.homeDirectory}/.gnupg";

    mutableTrust = false;
    mutableKeys = false;

    settings = {
      no-greeting = true;
      no-emit-version = true;
      no-comments = true;
      keyid-format = "0xlong";
      with-fingerprint = true;

      list-options = "show-uid-validity";
      verify-options = "show-uid-validity";

      personal-cipher-preferences = "AES256 AES192 AES";
      personal-digest-preferences = "SHA512 SHA384 SHA256";
      personal-compress-preferences = "ZLIB BZIP2 ZIP Uncompressed";
      default-preference-list = "SHA512 SHA384 SHA256 AES256 AES192 AES ZLIB BZIP2 ZIP Uncompressed";

      cipher-algo = "AES256";
      digest-algo = "SHA512";
      cert-digest-algo = "SHA512";
      compress-algo = "ZLIB";

      s2k-cipher-algo = "AES256";
      s2k-digest-algo = "SHA512";
      s2k-mode = "3";
      s2k-count = "65011712";
    };
  };

  services.gpg-agent = {
    enable = true;
    pinentryPackage = pkgs.pinentry-gtk2;

    defaultCacheTtl = 3600;
    defaultCacheTtlSsh = 3600;
    maxCacheTtl = 28800;
    maxCacheTtlSsh = 28800;

    enableSshSupport = true;

    sshKeys = [
      "55545A3A06FF2D2678F2F1FC2749DB3FCFB8B5EF"
    ];
  };

  programs.browserpass = {
    enable = true;
    browsers = [
      "chrome"
      "chromium"
      "firefox"
    ];
  };
}
