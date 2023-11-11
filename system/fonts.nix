{ pkgs, ...}:
{
    # Font config (oh god help me)
    # Creates a directory with links to all fonts
    # Path: /run/current-system/sw/share/X11/fonts
    fonts.enableDefaultPackages = true;
    fonts.enableGhostscriptFonts = true;
    fonts.fontDir.enable = true;
    fonts.fontDir.decompressFonts = true;
    fonts.fontconfig = {
        # Hinting options
        hinting.style = "full";
        subpixel.rgba = "rgb";
        allowBitmaps = false;
        allowType1 = false;
        localConf = "
            <!-- Use Blinker as the default system UI font, with a fallback to Noto Sans UI -->
            <alias>
                <family>system-ui</family>
                <prefer>
                    <family>Blinker</family>
                    <family>Noto Sans UI</family>
                </prefer>
            </alias>
        ";
        # Font preferences, these have lower priority than localConf
        # Here mostly as a fallback in case i fuck up something
        defaultFonts = {
            monospace = [
                "JetBrainsMonoNL NerdFont"
                "Noto Sans Mono"
            ];
            sansSerif = [
                "Noto Sans"
            ];
            serif = [
                "Noto Serif"
            ];
        };
    };

    # Font packages (oh god there's so many)
    fonts.packages = with pkgs; [
        font-awesome
        helvetica-neue-lt-std
        julia-mono
        nerdfonts
        # Overrides the google-fonts package to install all fonts with more than 4 styles available
        (google-fonts.overrideAttrs {
            installPhase = ''
            adobeBlankDest=$adobeBlank/share/fonts/truetype
            install -m 444 -Dt $adobeBlankDest ofl/adobeblank/AdobeBlank-Regular.ttf
            rm -r ofl/adobeblank
            dest=$out/share/fonts/truetype
            find . -name METADATA.pb -exec bash -c "DIR=\$(dirname \"{}\") ; STYLES=\$(ls -1 --literal \$DIR | sed -n '/\.ttf$/p' | xargs -r -I % echo \$DIR/%) ; STYLECOUNT=\$(echo \$STYLES | wc -w) ; if [ \$STYLECOUNT -ge 4 ]; then echo \$STYLES | sed 's/ $//;s/ /\n/g' | sed '/\].ttf/d' | xargs -I % install -m 444 -Dt $dest % ; fi ; if [[ \"\$STYLES\" =~ ]\.ttf ]]; then echo \$STYLES | sed 's/ $//;s/ /\n/g' | xargs -I % install -m 444 -Dt $dest % ; fi" \; '';
        })
    ];
}