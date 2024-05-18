{
  description = "NixOS utility functions";
  inputs = { };
  outputs = { ... }:
    rec {
      unfreeMerger = import ./unfree_merger.nix;
      listDir = dir: builtins.attrNames (builtins.readDir dir);
      trimNixExts = configs: builtins.map (entry: builtins.substring 0 (builtins.stringLength entry - 4) entry) configs;
      findNixFilesInDir = dir: trimNixExts (builtins.filter (u: (builtins.substring (builtins.stringLength u - 4) 4 u) == ".nix") (listDir dir));

      generateUser =
        { name
        , username
        , email
        , groups
        , hosts
        , face
        , background
        , files ? { }
        , extraNixosConfig ? { }
        , extraHomeConfig ? { }
        , extraPackages ? [ ]
        , pkgs
        ,
        }: {
          inherit hosts;
          nixosConfig = {
            isNormalUser = true;
            description = name;
            extraGroups = [ "networkmanager" "video" "audio" ] ++ groups;
            shell = pkgs.zsh;
          } // extraNixosConfig;
          homeConfig = {
            home.username = username;
            home.homeDirectory = "/home/${username}";

            home.packages = extraPackages;

            programs.git.userName = name;
            programs.git.userEmail = email;

            home.file = {
              ".face".source = face;
            } // files;

            dconf.settings = {
              "org/gnome/desktop/background" = {
                "picture-uri" = "file://${background}";
                "picture-uri-dark" = "file://${background}";
                "color-shading-type" = "solid";
                "picture-options" = "zoom";
                "primary-color" = "#000000000000";
                "secondary-color" = "#000000000000";
              };
              "org/gnome/desktop/screensaver" = {
                "picture-uri" = "file://${background}";
                "color-shading-type" = "solid";
                "picture-options" = "zoom";
                "primary-color" = "#000000000000";
                "secondary-color" = "#000000000000";
              };
            };
          } // extraHomeConfig;
        };
    };
}
