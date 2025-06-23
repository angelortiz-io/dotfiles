{
  description = "Nix-darwin system flake";

    inputs = {
        nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
        nix-darwin = {
            url = "github:LnL7/nix-darwin";
            inputs.nixpkgs.follows = "nixpkgs";
        };
        home-manager = {
            url = "github:nix-community/home-manager";
            inputs.nixpkgs.follows = "nixpkgs";
        };
        nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";
    };

    outputs = inputs@{ self, nix-darwin, nixpkgs, nix-homebrew, home-manager }: 
    let
        configuration = { pkgs, ... }: {
            # List packages installed in system profile. To search by name, run:
            # $ nix-env -qaP | grep wget
            environment.systemPackages = [
            ];

            homebrew = {
                enable = true;
                brews = [
                    "mas"
                    "mkvtoolnix"
                    "handbrake"
                ];
                casks = [
                    "visual-studio-code"
                    "keka"
                    "pycharm"
                    "webstorm"
                    "google-chrome"
                    "elmedia-player"
                    "gimp"
                    "inkscape"
                    "beekeeper-studio"
                    "bruno"
                    "discord"
                    "telegram"
                    "fleet"
                    "orbstack"
                    "ghostty"
                    "brave-browser"
                    "google-chrome"
		    "google-chrome@canary"
                    "whatsapp"
                    "slack"
                    "lm-studio"
                    "transmission"
                    "zoom"
                    "anydesk"
                    "android-studio"
                    "vlc"
                    "qbittorrent"
                ];

                masApps = {
                    "SparkMail" = 1176895641; 
                };
                onActivation.cleanup = "zap";
                onActivation.autoUpdate = true;
                onActivation.upgrade = true;
            };

            fonts.packages = [
                pkgs.nerd-fonts.fira-code
            ];

            nix.settings.experimental-features = "nix-command flakes";
            # Enable alternative shell support in nix-darwin.
            # programs.zsh.enable = true;
            system.configurationRevision = self.rev or self.dirtyRev or null;
            system.primaryUser = "coder";
	    # Used for backwards compatibility, please read the changelog before changing.
            # $ darwin-rebuild changelog
            system.stateVersion = 5;
            system.defaults = {
                dock = {
                    autohide = true;
                    tilesize = 32;
                    largesize = 128;
                    show-recents = false;
                    minimize-to-application = true;
                    mineffect = "genie";
                    magnification = true;
                    persistent-apps = [
                        "/Applications/Ghostty.app"
                        "/Applications/Spark.app"
                        "/System/Cryptexes/App/System/Applications/Safari.app"
                        "/Applications/Google Chrome.app"
                        "/Applications/Google Chrome Canary.app"
                        "/Applications/Brave Browser.app"
                        "/Applications/Pycharm.app"
                        "/Applications/WebStorm.app"
                        "/Applications/Visual Studio Code.app"
                        "/System/Applications/Photos.app"
                        "/System/Applications/Calendar.app"
                        "/System/Applications/Contacts.app"
                        "/System/Applications/Reminders.app"
                        "/System/Applications/Notes.app"
                        "/Applications/Microsoft Word.app"
                        "/Applications/Microsoft Excel.app"
                        "/Applications/Microsoft PowerPoint.app"
                        "/System/Applications/Music.app"
                        "/Applications/VLC.app"
                        "/System/Applications/App Store.app"
                        "/System/Applications/System Settings.app"
                    ];
                };
                controlcenter = {
                    AirDrop = true;
                    BatteryShowPercentage = true;
                    Bluetooth = true;
                    NowPlaying = true;
                    Sound = true;
                };
                trackpad = {
                    Clicking = true;
                    Dragging = true;
                };
                finder = {
                    ShowPathbar = true;
                    ShowStatusBar = true;
                    AppleShowAllFiles = false;
                };
                menuExtraClock = {
                    Show24Hour = true;
                    ShowSeconds = true;
                    ShowAMPM = false;
                };
                NSGlobalDomain = {
                    "com.apple.mouse.tapBehavior" = 1;
                    _HIHideMenuBar = false;
                    AppleInterfaceStyle = "Dark";
                    AppleMeasurementUnits = "Centimeters";
                };
                SoftwareUpdate.AutomaticallyInstallMacOSUpdates = true;
            };

            security.pam.services.sudo_local.touchIdAuth = true;

            # The platform the configuration will be used on.
            nixpkgs.hostPlatform = "aarch64-darwin";
            nixpkgs.config.allowUnfree = true;
        };
    in {
        # Build darwin flake using:
        # $ darwin-rebuild build --flake .#simple
        darwinConfigurations."antares" = nix-darwin.lib.darwinSystem {
            modules = [
                configuration
                nix-homebrew.darwinModules.nix-homebrew {
                    nix-homebrew = {
                        enable = true;
                        user = "coder";
                    };
                }
                home-manager.darwinModules.home-manager {
                    home-manager = {
                        useGlobalPkgs = true;
                        useUserPackages = true;
                        users.coder = import ./home.nix;
                    };
                    users.users.coder.home = "/Users/coder";
                }
            ];
        };
    };
}
