{config, pkgs, lib, ... }:
{

  # The home-manager manual is at:
  #
  #   https://rycee.gitlab.io/home-manager/release-notes.html
  #
  # Configuration options are documented at:
  #
  #   https://rycee.gitlab.io/home-manager/options.html

  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  #
  # You need to change these to match your username and home directory
  # path:
  home.username = "takayoshi-s";
  home.homeDirectory = "/home/takayoshi-s";

  # If you use non-standard XDG locations, set these options to the
  # appropriate paths:
  #
  # xdg.cacheHome
  # xdg.configHome
  # xdg.dataHome

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "22.05";

  # Since we do not install home-manager, you need to let home-manager
  # manage your shell, otherwise it will not be able to add its hooks
  # to your profile.
  programs = {
    direnv = {
      enable = true;
      enableBashIntegration = true; # see note on other shells below
      nix-direnv.enable = true;
    };
    bash = {
      enable = true;
  
      sessionVariables = {
        EDITOR ="vim"; # TODO: なぜか効かないので後で修正
      };
      shellAliases = {
        g = "git";
        dc = "docker-compose";
      };
    };
    vscode = {
      enable = true;
      extensions = with pkgs.vscode-extensions; [
        dracula-theme.theme-dracula
        vscodevim.vim
        yzhang.markdown-all-in-one
        ms-vscode-remote.remote-ssh
        github.copilot
      ];
    };
    git = {
      enable = true;
      userName = "Takayoshi Shibahara";
      userEmail = "fractal.civilization@gmail.com";
      aliases = {
        prettylog = "log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(r) %C(bold blue)<%an>%Creset' --abbrev-commit --date=relative";
        root = "rev-parse --show-toplevel";
        co = "checkout";
      };
      extraConfig = {
        branch.autosetuprebase = "always";
        color.ui = true;
        core.askPass = "";
        credential.helper = "store"; # want to make this more secure
        github.user = "fracivilization";
        push.default = "simple";
        init.defaultBranch = "main";
      };
    };
    ssh = {
      enable = true;
      extraConfig = ''
        Host github github.com
          HostName github.com
          IdentityFile ~/.ssh/github/id_ed25519
          User git
        Host raiden
          HostName raiden-l1.riken.jp
          # HostName raiden.riken.jp
          User takayo-s
          IdentityFile  ~/.ssh/riken/id_rsa
      '';
    };
    emacs = {
      enable = true;
      package = pkgs.emacs;
    };
    home-manager.enable = true;
    home-manager.path = https://github.com/nix-community/home-manager/archive/release-23.05.tar.gz;
  };
  nixpkgs.config.allowUnfree = true;
  home.packages = with pkgs; [
    git
    fd
    ripgrep
    vim
    anki-bin
    slack
    qutebrowser
    nyxt
    docker-compose
    zotero
    evince
    gnomeExtensions.burn-my-windows
    gnomeExtensions.tactile
    gnomeExtensions.no-activities-button
    gnomeExtensions.removable-drive-menu
    (appimageTools.wrapType2 {
       name = "upnote";
       src = fetchurl {
         url = "https://upnote-release.s3.us-west-2.amazonaws.com/UpNote.AppImage";
         sha256 = "ced3cf39c1573bd99c861a6e5952f709dd801d2025aeeb501b33fc76273737e1";
       };
       extraPkgs = pkgs: with pkgs; [ ];
    })
    # Defines a python + set of packages.
    (python3.withPackages (ps: with ps; with python3Packages; [
      jupyter
      ipython

      # Uncomment the following lines to make them available in the shell.
      pandas
      numpy
      matplotlib
    ]))
    texlive.combined.scheme-full
    google-chrome
    wget
  ];

  home.activation.installDoomEmacs = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    ${pkgs.writeShellScriptBin "install-doomemacs" ./install-doomemacs.sh}/bin/install-doomemacs
  '';

  # UpnoteをGnomeに認識させる
  # TODO: home-managerの導入が必要らしいのでまた今度(https://www.reddit.com/r/NixOS/comments/scf0ui/how_would_i_update_desktop_file/)
  xdg.desktopEntries.UpNote = {
    name = "UpNote";
    exec = "upnote";
  };

}
