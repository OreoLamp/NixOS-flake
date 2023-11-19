{ pkgs, ...}:
{
    # Enables default font packages
    fonts.enableDefaultPackages = true;

    # Enables ghostscript fonts
    fonts.enableGhostscriptFonts = true;
    
    # Creates a directory with links to all fonts
    # Path: /run/current-system/sw/share/X11/fonts
    fonts.fontDir.enable = true;

    # Decompresses all fonts in /run/current-system/sw/share/X11/fonts
    fonts.fontDir.decompressFonts = true;

    # Font packages
    fonts.packages = with pkgs; [
        font-awesome
        julia-mono
        nerdfonts
        # Overrides the google-fonts package to install all fonts with more than 4 styles available
        # TODO: Rewrite bash script to be less cursed
        (google-fonts.overrideAttrs {
            installPhase = ''
adobeBlankDest=$adobeBlank/share/fonts/truetype
install -m 444 -Dt $adobeBlankDest ofl/adobeblank/AdobeBlank-Regular.ttf
rm -r ofl/adobeblank
dest=$out/share/fonts/truetype
find . -name METADATA.pb -exec bash -c "DIR=\$(dirname \"{}\") ; STYLES=\$(ls -1 --literal \$DIR | sed -n '/\.ttf$/p' | xargs -r -I % echo \$DIR/%) ; STYLECOUNT=\$(echo \$STYLES | wc -w) ; if [ \$STYLECOUNT -ge 4 ]; then echo \$STYLES | sed 's/ $//;s/ /\n/g' | sed '/\].ttf/d' | xargs -I % install -m 444 -Dt $dest % ; fi ; if [[ \"\$STYLES\" =~ ]\.ttf ]]; then echo \$STYLES | sed 's/ $//;s/ /\n/g' | xargs -I % install -m 444 -Dt $dest % ; fi" \; '';
        })
    ];

    fonts.fontconfig = {
        enable = true;

        # Hinting options
        hinting.style = "slight";
        subpixel.rgba = "rgb";
        antialias = true;

        # Disables bitmap fonts
        allowBitmaps = false;
        allowType1 = false;
        useEmbeddedBitmaps = false;

        # Assigns default fonts for monospace, sans serif, and serif fonts
        # Embedded XML because consistency (no option to set system-ui font)
        # TODO: Whole fontconfig section in cuelang
        # TODO: Proper handling of <blank>
        # basically, fonts can include empty codepoints that they don't have 
        # symbols for (???), so fontconfig has <blank>
        # In <blank> you put the blank codepoints in int elements
        # TODO: Get rid of artificial boldening and italics (???)
        # TODO: Proper noto fallbacks
        localConf = ''
<alias>
<!-- Use Noto Sans as default sans-serif, no fallbacks needed -->
    <family>sans-serif</family>
    <prefer>
        <family>Noto Sans</family>
    </prefer>

    <!-- Use jetbrains mono as default monospace, fall back to Noto Sans mono -->
    <family>monospace</family>
    <prefer>
        <family>JetBrainsMono Nerd Font</family>
    </prefer>
    
    <!-- Set noto serif as default serif, no fallbacks needed -->
    <family>serif</family>
    <prefer>
        <family>Noto Serif</family>
    </prefer>

    <!-- Use Blinker as default system-ui, fall back to Noto Sans UI -->
    <family>system-ui</family>
    <prefer>
        <family>Blinker</family>
    </prefer>
</alias>
        '';
    };
}
