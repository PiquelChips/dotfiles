{ inputs, ... }:
{
  flake.lib.dotfiles = {
    commonPackages =
      { pkgs }:
      let
        fenix = inputs.fenix.packages.${pkgs.stdenv.hostPlatform.system};
      in
      builtins.filter (pkg: pkg != null) (
        with pkgs;
        [
          tree
          fd
          fzf
          file
          ripgrep
          git
          gh
          git-lfs
          stow
          yazi
          zoxide
          lazydocker
          ffmpeg
          imagemagick
          poppler
          btop
          cloc
          p7zip
          cmake
          pkg-config
          gnumake
          sqlc
          postgresql
          mpv
          just

          rustup
          fenix.stable.toolchain
          gcc
          go
          python3
          deno
          nodejs
          jdk25
          clang
          libcxx
          libgcc
          pnpm

          nil
          nixfmt
          clang-tools
          marksman
          lombok
          gopls
          glsl_analyzer
          jdt-language-server
          dockerfile-language-server
          bash-language-server
          autotools-language-server
          lua-language-server
          tailwindcss-language-server
          svelte-language-server
          typescript-language-server
          vscode-langservers-extracted

          cargo-watch
          cargo-nextest
          cargo-deny
          cargo-workspaces
          cargo-expand

          icu
          premake5
          zlib
          tbb
          dotnetCorePackages.dotnet_9.sdk
        ]
        ++ pkgs.lib.optionals pkgs.stdenv.isLinux [
          feh
          wl-clipboard
          air
          docker-buildx
          tailwindcss_4
          grim
          swappy
          slurp
          wayland-scanner
          gdb
          atlas

          blender
          ghostty
          firefox
          hyprpaper
          prismlauncher
          discord
          heroic
          jetbrains-toolbox
          ladybird
          hyprlauncher
          hyprtoolkit
          hyprpolkitagent
          hyprpwcenter
          pwvucontrol
          spotify
          obsidian

          gtk3
          elfutils
          libunwind
          wayland
          libxkbcommon
          vulkan-loader
          vulkan-validation-layers
        ]
        ++ pkgs.lib.optionals pkgs.stdenv.isDarwin [
          zsh
          zip
          unzip
          inputs.nix-darwin.packages.${pkgs.stdenv.hostPlatform.system}.darwin-rebuild
          obsidian
        ]
      );

    gitConfig = {
      init.defaultBranch = "main";
      core.editor = "vim";
      user = {
        name = "piquel";
        email = "piquel@piquel.fr";
      };
      filter."lfs" = {
        clean = "git-lfs clean -- %f";
        smudge = "git-lfs smudge -- %f";
        process = "git-lfs filter-process";
        required = true;
      };
    };
  };
}
