{ pkgs, inputs, ... }:
{
    users.users.eero.packages = with pkgs; [
        vscode
    ];
    
    # vscode confi
    # TODO: Yeet this and do the whole thing without home-manager
    # TODO: Also add config file and laucnher args (encryption, etc)
    hm.programs.vscode = {
        enable = true;
        package = pkgs.vscode; 
        extensions = 
        with inputs.nix-vscode-extensions.extensions.${pkgs.system}.vscode-marketplace; [
            AtomMaterial.a-file-icon-vscode
            alefragnani.bookmarks
            alefragnani.project-manager
            atomiks.moonlight
            christian-kohler.path-intellisense
            enkia.tokyo-night
            grapecity.gc-excelviewer
            ibm.output-colorizer
            mechatroner.rainbow-csv
            miguelsolorio.fluent-icons
            mikestead.dotenv
            mkxml.vscode-filesize
            ms-vscode.hexeditor
            ms-vscode.remote-explorer
            ms-vscode-remote.remote-containers
            ms-vscode.remote-repositories
            ms-vscode.remote-server
            redhat.vscode-xml
            redhat.vscode-yaml
            ryu1kn.partial-diff
            tamasfe.even-better-toml
            tomoki1207.pdf
            yzhang.markdown-all-in-one
        ];
    };
}
