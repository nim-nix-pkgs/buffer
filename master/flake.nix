{
  description = ''buffer'';

  inputs.flakeNimbleLib.owner = "riinr";
  inputs.flakeNimbleLib.ref   = "master";
  inputs.flakeNimbleLib.repo  = "nim-flakes-lib";
  inputs.flakeNimbleLib.type  = "github";
  inputs.flakeNimbleLib.inputs.nixpkgs.follows = "nixpkgs";
  
  inputs.src-buffer-master.flake = false;
  inputs.src-buffer-master.ref   = "refs/heads/master";
  inputs.src-buffer-master.owner = "bung87";
  inputs.src-buffer-master.repo  = "buffer";
  inputs.src-buffer-master.type  = "github";
  
  inputs."struct".owner = "nim-nix-pkgs";
  inputs."struct".ref   = "master";
  inputs."struct".repo  = "struct";
  inputs."struct".dir   = "v0_2_3";
  inputs."struct".type  = "github";
  inputs."struct".inputs.nixpkgs.follows = "nixpkgs";
  inputs."struct".inputs.flakeNimbleLib.follows = "flakeNimbleLib";
  
  outputs = { self, nixpkgs, flakeNimbleLib, ...}@deps:
  let 
    lib  = flakeNimbleLib.lib;
    args = ["self" "nixpkgs" "flakeNimbleLib" "src-buffer-master"];
    over = if builtins.pathExists ./override.nix 
           then { override = import ./override.nix; }
           else { };
  in lib.mkRefOutput (over // {
    inherit self nixpkgs ;
    src  = deps."src-buffer-master";
    deps = builtins.removeAttrs deps args;
    meta = builtins.fromJSON (builtins.readFile ./meta.json);
  } );
}