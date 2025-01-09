{ pkgs, ... }: {
  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  # home.username = "coder";
    home = {
        enableNixpkgsReleaseCheck = true;
        stateVersion = "24.11";
        packages = with pkgs; [
            eza
            bat
            neovim
            starship
            htop
            mise
        ];
    };
    # Let Home Manager install and manage itself.
    programs = {
        home-manager = {
            enable = true;
            path = "$HOME/.config/nix-darwin/nixpkgs/";
        };
        git = {
            enable = true;
            userName = "Angel Ortiz";
            userEmail = "aandresortiz@gmail.com";
            ignores = [ "**/.idea/" "**/.vscode/settings.json" "**/.direnv/" "**/.DS_Store" ];
        };
        zsh = {
            enable = true;
            autocd = true;
            enableCompletion = true;
            autosuggestion.enable = true;
            syntaxHighlighting.enable = true;
            shellAliases = {
                ll = "eza -lF --color-scale --no-user --no-time --no-permissions --group-directories-first --icons -a";
                ls = "eza -lF --group-directories-first --icons -a";
                ".." = "cd ..";
            };
            history = {
                save = 1;
                size = 10000;
            };
            initExtra = ''
              eval "$(starship init zsh)"
              eval "$(/etc/profiles/per-user/coder/bin/mise activate zsh)"
            '';
        };
    };
}