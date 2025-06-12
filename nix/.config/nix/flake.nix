{
  description = "Example nix-darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:LnL7/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";
  };

  outputs = inputs@{ self, nix-darwin, nix-homebrew, nixpkgs }:
  let
    configuration = { pkgs, ... }: {
      # List packages installed in system profile. To search by name, run:
      # $ nix-env -qaP | grep wget
      environment.systemPackages =
        [ 
	  pkgs.amazon-ecr-credential-helper
	  pkgs.awscli2
	  pkgs.aws-sam-cli
	  pkgs.btop
	  pkgs.cargo
	  pkgs.colima
	  pkgs.curl
	  pkgs.dbeaver-bin
	  pkgs.direnv
	  pkgs.docker
	  pkgs.eza
	  pkgs.fish
	  pkgs.fnm
	  pkgs.fzf
	  pkgs.gh
	  pkgs.jdk23
	  pkgs.kubernetes-helm
	  pkgs.lazydocker
	  pkgs.lazygit
	  pkgs.lima
	  pkgs.neovim
	  pkgs.neofetch
	  pkgs.python312
	  pkgs.python312Packages.pipx
	  pkgs.python312Packages.pip
	  pkgs.starship
	  pkgs.stow
	  pkgs.tmux
	  pkgs.tree
	  pkgs.zoxide
        ];

      homebrew = {
	enable = true;
	brews = [
	  "argocd"
	  "eksctl"
	  "k9s"
	  "minikube"
	  "libomp"
    "sops"
	];
	casks = [
	  "1password-cli"
	  "betterdisplay"
	  "bluesnooze"
	  "caffeine"
	  "electorrent"
	  "ghostty"
	  "gpg-suite"
	  "miniforge"
	  "mos"
      "nikitabobko/tap/aerospace"
	  "notion"
	  "raycast"
	  "shottr"
	  "stats"
	];
      };

      # Necessary for using flakes on this system.
      nix.settings.experimental-features = "nix-command flakes";

      # Enable alternative shell support in nix-darwin.
      # programs.fish.enable = true;

      # Set Git commit hash for darwin-version.
      system.configurationRevision = self.rev or self.dirtyRev or null;

      # Used for backwards compatibility, please read the changelog before changing.
      # $ darwin-rebuild changelog
      system.stateVersion = 6;

      system.primaryUser = "michael";

      # The platform the configuration will be used on.
      nixpkgs.hostPlatform = "aarch64-darwin";
    };
  in
  {
    # Build darwin flake using:
    # $ darwin-rebuild build --flake .#Michaels-MacBook-Pro
    darwinConfigurations."michael-macbook" = nix-darwin.lib.darwinSystem {
      modules = [ 
	configuration
	nix-homebrew.darwinModules.nix-homebrew
	{
	  nix-homebrew = {
	    enable = true;
	    enableRosetta = true;
	    user = "michael";
	    autoMigrate = true;
	  };
	}
      ];
    };
  };
}
