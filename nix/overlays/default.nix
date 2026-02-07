{ inputs, ...}: {
    additions = final: _prev: import ../pkgs { inherit inputs; } final.pkgs;
    #unstable-packages = final: _prev: {
    #    unstable = import inputs.nixpkgs-unstable {
    #        system = final.system;
    #    };
    #};
}
