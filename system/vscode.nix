{ pkgs, inputs, ... }:
{
    users.users.eero.packages = with pkgs; [
        vscode
    ];
    
    # vscode config
    hm.programs.vscode = {
        enable = true;
        package = pkgs.vscode; 
        extensions = let
	    inherit (inputs.nix-vscode-extensions.extensions.${pkgs.system}) vscode-marketplace; 
	  in with vscode-marketplace; [
            vscode-marketplace."13xforever".language-x86-64-assembly
            alefragnani.bookmarks
            alefragnani.project-manager
            antiantisepticeye.vscode-color-picker
            atomiks.moonlight
            brody715.vscode-cuelang
            charliermarsh.ruff
            christian-kohler.path-intellisense
            cschlosser.doxdocgen
            dbaeumer.vscode-eslint
            donjayamanne.python-environment-manager
            ecmel.vscode-html-css
            enkia.tokyo-night
            esbenp.prettier-vscode
            formulahendry.code-runner
            fortran-lang.linter-gfortran
            github.remotehub
            github.vscode-pull-request-github
            golang.go
            grapecity.gc-excelviewer
            haskell.haskell
            ibm.output-colorizer
            jeff-hykin.better-cpp-syntax
            jnoortheen.nix-ide
            julialang.language-julia
            justusadam.language-haskell
            llvm-vs-code-extensions.vscode-clangd
            mads-hartmann.bash-ide-vscode
            mathworks.language-matlab
            mechatroner.rainbow-csv
            miguelsolorio.fluent-icons
            mikestead.dotenv
            mkxml.vscode-filesize
            ms-azuretools.vscode-docker
            ms-python.isort
            ms-python.pylint
            ms-python.python
            ms-python.vscode-pylance
            ms-toolsai.jupyter
            ms-toolsai.jupyter-keymap
            ms-toolsai.jupyter-renderers
            ms-toolsai.vscode-jupyter-cell-tags
            ms-toolsai.vscode-jupyter-slideshow
            ms-vscode.azure-repos
            ms-vscode.cmake-tools
            ms-vscode.cpptools
            ms-vscode.cpptools-extension-pack
            ms-vscode.cpptools-themes
            ms-vscode.hexeditor
            ms-vscode.makefile-tools
            ms-vscode.remote-explorer
            ms-vscode-remote.remote-containers
            ms-vscode-remote.remote-ssh
            ms-vscode-remote.remote-ssh-edit
            ms-vscode-remote.remote-wsl
            ms-vscode.remote-repositories
            ms-vscode.remote-server
            ms-vscode-remote.vscode-remote-extensionpack
            ms-vscode.vscode-github-issue-notebooks
            ms-vscode.vscode-selfhost-test-provider
            # ms-vscode.vscode-serial-monitor
            njpwerner.autodocstring
            platformio.platformio-ide
            rdebugger.r-debugger
            redhat.java
            redhat.vscode-xml
            redhat.vscode-yaml
            reditorsupport.r
            rust-lang.rust-analyzer
            ryu1kn.partial-diff
            scala-lang.scala
            scalameta.metals
            shopify.ruby-lsp
            sonarsource.sonarlint-vscode
            sumneko.lua
            tamasfe.even-better-toml
            techer.open-in-browser
            tomoki1207.pdf
            twxs.cmake
            vadimcn.vscode-lldb
            vscjava.vscode-gradle
            vscjava.vscode-java-debug
            vscjava.vscode-java-dependency
            vscjava.vscode-java-pack
            vscjava.vscode-java-test
            vscjava.vscode-maven
            yzhang.markdown-all-in-one
        ];
    };
}
