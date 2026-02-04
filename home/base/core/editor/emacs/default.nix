{ inputs, ... }:

{
  imports = [
    inputs.nix-doom-emacs-unstraightened.homeModule
  ];

  programs.doom-emacs = {
    enable = true;
    doomDir = ./doom;
    extraPackages = epkgs: [ epkgs.treesit-grammars.with-all-grammars ];
  };
  services.emacs.enable = true;
}
