{ ... }:
{
  # nixpkgs' rustup patchelfs every toolchain it installs, hardcoding two store
  # paths into it: the glibc loader, and its own ld-wrapper (wrapping rust-lld).
  # Once a nixpkgs update garbage-collects those paths, every installed
  # toolchain breaks ("cargo: not found", then "ld-wrapper.sh: No such file").
  # Point both at stable paths instead, so toolchains survive updates:
  # - the loader at nix-ld's FHS loader,
  # - the ld-wrapper at /etc/rustup/ld-wrapper.sh, which each rebuild repoints
  #   at the current rustup.
  flake.nixosModules.rustup =
    { pkgs, ... }:
    {
      programs.nix-ld.enable = true;

      nixpkgs.overlays = [
        (_final: prev: {
          rustup = prev.rustup.overrideAttrs (old: {
            # The override misses the binary cache, so it builds locally on
            # every nixpkgs update; its serial test suite takes ages.
            doCheck = false;
            postPatch = (old.postPatch or "") + ''
              substituteInPlace src/dist/component/package.rs \
                --replace-fail "$(cat ${prev.stdenv.cc}/nix-support/dynamic-linker)" \
                  /lib64/ld-linux-x86-64.so.2 \
                --replace-fail 'ld_wrapper_path.to_string_lossy().to_string(),' \
                  '"/etc/rustup/ld-wrapper.sh",'
            '';
          });
        })
      ];

      environment.etc."rustup/ld-wrapper.sh".source = "${pkgs.rustup}/nix-support/ld-wrapper.sh";
    };
}
