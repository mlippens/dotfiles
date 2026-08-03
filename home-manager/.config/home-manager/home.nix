{ pkgs, pkgs-unstable, ... }:

{
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.permittedInsecurePackages = [
    "ventoy-qt5-1.1.12"
  ];
  home.username = "michael";
  home.homeDirectory = "/home/michael";
  # Keep this at the initial Home Manager release you started with.
  home.stateVersion = "26.05";

  programs.home-manager.enable = true;

  programs.gpg.enable = true;
  programs.gpg.settings = {
    keyserver = "hkps://keys.openpgp.org";
    keyserver-options = "auto-key-retrieve";
    default-preference-list = "SHA512 SHA384 SHA256 SHA224 AES256 AES192 AES128 ZLIB ZIP BZIP2 Uncompressed";
    personal-cipher-preferences = "AES256 AES192 AES128";
    personal-digest-preferences = "SHA512 SHA384 SHA256 SHA224";
    cert-digest-algo = "SHA512";
    s2k-digest-algo = "SHA512";
    s2k-cipher-algo = "AES256";
    default-sig-expire = "2y";
    compress-level = "9";
    no-symkey-cache = true;
  };

  services.gpg-agent = {
    enable = true;
    enableSshSupport = false;
    defaultCacheTtl = 3600;
    maxCacheTtl = 86400;
    defaultCacheTtlSsh = 3600;
    maxCacheTtlSsh = 86400;
    # GTK pinentry avoids TTY ioctl issues in IDE/non-tty git flows.
    pinentry.package = pkgs.pinentry-gtk2;
    enableBashIntegration = true;
    enableFishIntegration = true;
    extraConfig = ''
      no-grab
    '';
  };

  # Fish is managed via stow at ~/dotfiles/fish/. HM only handles GPG_TTY
  # init, dropped into conf.d so the stowed config.fish stays in charge.
  home.file.".config/fish/conf.d/99-gpg-tty.fish".text = ''
    if status is-interactive
      set -gx GPG_TTY (tty)
      gpg-connect-agent updatestartuptty /bye >/dev/null 2>/dev/null
    end
  '';

  programs.git = {
    enable = true;
    lfs.enable = true;
    settings = {
      user = {
        email = "michael.lippens@robovision.eu";
        name = "Michael Lippens";
        signingKey = "7209694B7651BDA1";
      };
      commit.gpgSign = true;
      tag.gpgSign = true;
    };
  };
  programs.delta = {
    enable = true;
    enableGitIntegration = true;
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  services.flatpak = {
    enable = true;
    remotes = [
      {
        name = "flathub";
        location = "https://dl.flathub.org/repo/flathub.flatpakrepo";
      }
    ];
    packages = [
      "app.zen_browser.zen"
      "com.stremio.Stremio"
      "com.axosoft.GitKraken"
    ];
  };

  programs.fzf.enable = true;
  programs.zoxide.enable = true;
  programs.starship.enable = true;
  programs.tmux.enable = true;
  programs.neovim.enable = true;
  programs.lazygit.enable = true;
  programs.htop.enable = true;
  programs.btop.enable = true;
  programs.k9s.enable = true;
  programs.jq.enable = true;

  
  home.packages = [
    pkgs.awscli2
    pkgs.bubblewrap
    pkgs.busybox
    pkgs.dbeaver-bin
    pkgs.difftastic
    pkgs.dig
    pkgs.distrobox
    pkgs.docker
    pkgs.docker-compose
    pkgs.dpkg
    pkgs.eza
    pkgs.fastfetch
    pkgs.fd
    pkgs.fish
    pkgs.gemini-cli
    pkgs.gpgme
    pkgs.fnm
    pkgs.git
    pkgs.gh
    pkgs.glab
    pkgs.go
    pkgs.google-cloud-sdk
    pkgs.google-chrome
    pkgs.hyperfine
    pkgs.just
    pkgs.kubectl
    pkgs.k9s
    pkgs.lazydocker
    pkgs.lazygit
    pkgs.ngrok
    pkgs.nodejs
    pkgs.obsidian
    pkgs.podman
    pkgs.podman-desktop
    pkgs.podman-tui
    pkgs.ripgrep
    pkgs.rustup
    pkgs.pass
    pkgs.slack
    pkgs.spotify
    pkgs.socat
    pkgs.sox # claude voice mode
    pkgs.stow
    pkgs.tailscale
    pkgs.terraform
    pkgs.ventoy-full-qt
    pkgs.vim
    pkgs.vscode
    pkgs-unstable.warp-terminal
    pkgs.wezterm
    pkgs.wl-clipboard
    pkgs.yq
    pkgs-unstable.zed-editor
  ];
}
