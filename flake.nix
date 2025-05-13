{
  description = "Darwin configuration";

  inputs = {
    # Where we get most of our software. Giant mono repo with recipes, called derivations that say how to build software. Where we get most of our software. Giant mono repo with recipes, called derivations that say how to build software.
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    # Controls system level software and settings including fonts
    darwin.url = "github:lnl7/nix-darwin";
    nix-darwin.url = "github:nix-darwin/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    # Manages configs links thngs into your home directory
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";
    # homebrew-core = { url = "github:homebrew/homebrew-core"; flake = false; };
    # homebrew-cask = { url = "github:homebrew/homebrew-cask"; flake = false; };
  };

  # If homebrew gets added remember to put it as input (nix-homebrew)
  outputs = inputs@{ self, nix-darwin, nixpkgs, home-manager , ... }:
  let

    configuration = { pkgs, ... }: {
      # List packages installed in system profile. To search by name, run:
      # $ nix-env -qaP | grep wget
      environment.systemPackages =
        [ pkgs.vim
          pkgs.ripgrep
          pkgs.neovim
        ];
      environment.systemPath = ["/opt/homebrew/bin/"];
      environment.pathsToLink = ["/Applications"];

      # Necessary for using flakes on this system.
      nix.settings.experimental-features = "nix-command flakes";

      # Enable alternative shell support in nix-darwin.
      environment.shells = [ pkgs.bash pkgs.zsh ];
      # environment.loginShell = pkgs.zsh;
      nix.extraOptions = '' 
        experimental-features = nix-command flakes
      '';


      # fonts.fontDir.enable = false;
      fonts.packages = with pkgs; [
        nerd-fonts.jetbrains-mono
        nerd-fonts.iosevka
        nerd-fonts.blex-mono
        nerd-fonts.meslo-lg
        nerd-fonts.fira-code
        nerd-fonts.fira-mono
      ];
      # services.nix-daemon.enable = true;

      # System Preferences
      system.defaults.finder.AppleShowAllExtensions = true;
      system.defaults.finder._FXShowPosixPathInTitle = true;
      system.defaults.dock.autohide = true;
      system.defaults.NSGlobalDomain.AppleShowAllExtensions = true;
      system.defaults.trackpad.FirstClickThreshold = 0;
      system.defaults.trackpad.Clicking = true;
      # Disable AppleFontSmoothing system-wide
      system.defaults.NSGlobalDomain.AppleFontSmoothing = 0;
      # system.defaults.NSGlobalDomain.InitialKeyRepeat = 1;
      # system.defaults.NSGlobalDomain
      homebrew = {
        enable = true;
        caskArgs.no_quarantine = true; # disables the warning of opening the app in the first time
        global.brewfile = true; # when enabled, this option sets the HOMEBREW_BUNDLE_FILE environment variable to the path of the Brewfile that this module generates in the Nix store, by adding it to.
        masApps = {};
        casks = ["inkdrop" "1password" "1password-cli" "spotify" "raycast" "cursor" "windsurf"];
        taps = [];
        brews = [];
      };

      # Set Git commit hash for darwin-version.
      system.configurationRevision = self.rev or self.dirtyRev or null;

      # Used for backwards compatibility, please read the changelog before changing.
      # $ darwin-rebuild changelog
      system.stateVersion = 6;

      # The platform the configuration will be used on.
      nixpkgs.hostPlatform = "aarch64-darwin";
    };
  in
  {
    # Build darwin flake using:
    # $ darwin-rebuild build --flake .#fernandorojas
    darwinConfigurations."fernandorojas" = nix-darwin.lib.darwinSystem {
      modules = [ 
        configuration
        home-manager.darwinModules.home-manager 
        {
          users.users.fernandorojas.home = /Users/fernandorojas;
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.fernandorojas = import ./home.nix;
        }
        # nix-homebrew.darwinModules.nix-homebrew 
        # {
        #     nix-homebrew.enable = true;
        #     nix-homebrew.enableRosetta = true;
        #     nix-homebrew.autoMigrate = true;
        #     nix-homebrew.user = "fernandorojas";
        #     nix-homebrew.taps = with inputs; {
        #       "homebrew/homebrew-core" = homebrew-core;
        #       "homebrew/homebrew-cask" = homebrew-cask;
        #     };
        # }
      ];
      specialArgs = { inherit inputs; };
    };
  };
}
