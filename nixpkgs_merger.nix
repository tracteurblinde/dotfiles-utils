{ lib, config, ... }:
{
  # Allows unfree packages and insecure packages to be specified as
  # `nixpkgs.allowUnfreePackages = [ "steam" "steam-original" ];`
  # `nixpkgs.permittedInsecurePackages = [ "jitsi-meet" ];`
  # Modified from code by @Majiir https://github.com/NixOS/nixpkgs/issues/197325#issuecomment-1579420085
  options = with lib; {
    nixpkgs.allowUnfreePackages = mkOption {
      type = with types; listOf str;
      default = [ ];
      example = [ "steam" "steam-original" ];
    };
    nixpkgs.permittedInsecurePackages = mkOption {
      type = with types; listOf str;
      default = [ ];
      example = [ "jitsi-meet" ];
    };
  };

  config = {
    nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) config.nixpkgs.allowUnfreePackages;
    nixpkgs.config.allowInsecurePredicate = pkg: builtins.elem "${lib.getName pkg}-${lib.getVersion pkg}" config.nixpkgs.permittedInsecurePackages;
  };
}
