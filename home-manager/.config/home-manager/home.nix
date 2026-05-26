{ pkgs, ... }:

{
  nixpkgs.config.allowUnfree = true;
  home.username = "michael";
  home.homeDirectory = "/home/michael";
  # Keep this at the initial Home Manager release you started with.
  home.stateVersion = "25.11";

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

  programs.git.enable = true;
  programs.delta = {
    enable = true;
    enableGitIntegration = true;
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
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

  home.packages = with pkgs; [
    awscli
    dbeaver-bin
    difftastic
    distrobox
    docker
    docker-compose
    eza
    fd
    fish
    gpgme
    fnm
    go
    google-cloud-sdk
    hyperfine
    kubectl
    lazydocker
    neofetch
    ngrok
    nodejs
    podman
    podman-desktop
    podman-tui
    ripgrep
    stow
    tailscale
    terraform
    yq
  ];
}
