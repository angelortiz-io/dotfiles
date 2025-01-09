{ pkgs, ... }: {
  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  # home.username = "coder";
    home = {
        enableNixpkgsReleaseCheck = true;
        stateVersion = "24.11";
        shellAliases = {
            ll = "eza -lF --color-scale --no-user --no-time --no-permissions --group-directories-first --icons -a";
            ls = "eza -lF --group-directories-first --icons -a";
            ".." = "cd ..";
        };
        packages = with pkgs; [
            eza
            neovim
            starship
            htop
            mise
        ];
        file = {
            ".zshrc".source = ./dotfiles/zshrc/zshrc;
            ".wezterm.lua".source = ./dotfiles/wezterm/wezterm.lua;
        };
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
        };
    };
}