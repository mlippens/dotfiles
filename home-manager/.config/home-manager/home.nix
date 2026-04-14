{ pkgs, ... }:

{
  nixpkgs.config.allowUnfree = true;
  home.username = "michael";
  home.homeDirectory = "/home/michael";
  # Keep this at the initial Home Manager release you started with.
  home.stateVersion = "25.11";

  # Let Home Manager install and manage itself.
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

  # Ensure fish shells expose a valid TTY to gpg/pinentry.
  home.file.".config/fish/conf.d/99-gpg-tty.fish".text = ''
    if status is-interactive
      set -gx GPG_TTY (tty)
      gpg-connect-agent updatestartuptty /bye >/dev/null 2>/dev/null
    end
  '';

  home.packages = with pkgs; [
    awscli
    btop
    dbeaver-bin
    delta
    difftastic
    direnv
    docker
    docker-compose
    eza
    fd
    gpgme
    fnm
    fish
    fzf
    git
    gnupg
    pinentry-curses
    go
    google-cloud-sdk
    htop
    hyperfine
    jq
    k9s
    kubectl
    lazydocker
    lazygit
    neofetch
    neovim
    ngrok
    nodejs
    oh-my-zsh
    ripgrep
    starship
    stow
    tailscale
    tmux
    yq
    zoxide
  ];
}
