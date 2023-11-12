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
        helvetica-neue-lt-std
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
        hinting.style = "full";
        subpixel.rgba = "rgb";
        antialias = true;

        # Disables bitmap fonts
        allowBitmaps = false;
        allowType1 = false;
        useEmbeddedBitmaps = false;

        # Assigns default fonts for monospace, sans serif, and serif fonts
        # Embedded XML because consistency (there's no option to set system-ui font)
        # TODO: Whole fontconfig section in cuelang
        localConf = ''
            <alias>
            <!-- Use Noto Sans as the default sans-serif font -->
                <family>sans-serif</family>
                    <prefer>
                        <family>Noto Sans</family>
			            <family>Noto Emoji</family>
			            <family>Noto Sans Armenian</family>
			            <family>Noto Sans Avestan</family>
			            <family>Noto Sans Balinese</family>
			            <family>Noto Sans Bamum</family>
			            <family>Noto Sans Batak</family>
			            <family>Noto Sans Bengali</family>
			            <family>Noto Sans Brahmi</family>
			            <family>Noto Sans Buginese</family>
			            <family>Noto Sans Buhid</family>
			            <family>Noto Sans Canadian Aboriginal</family>
			            <family>Noto Sans Carian</family>
			            <family>Noto Sans Cham</family>
			            <family>Noto Sans Cherokee</family>
			            <family>Noto Sans CJK JP</family>
			            <family>Noto Sans CJK KR</family>
			            <family>Noto Sans CJK SC</family>
			            <family>Noto Sans CJK TC</family>
			            <family>Noto Sans Coptic</family>
			            <family>Noto Sans Cuneiform</family>
			            <family>Noto Sans Cypriot</family>
			            <family>Noto Sans Deseret</family>
			            <family>Noto Sans Devanagari</family>
			            <family>Noto Sans Egyptian Hieroglyphs</family>
			            <family>Noto Sans Ethiopic</family>
			            <family>Noto Sans Georgian</family>
			            <family>Noto Sans Glagolitic</family>
			            <family>Noto Sans Gothic</family>
			            <family>Noto Sans Gujarati</family>
			            <family>Noto Sans Gurmukhi</family>
			            <family>Noto Sans Hanunoo</family>
			            <family>Noto Sans Hebrew</family>
			            <family>Noto Sans Imperial Aramaic</family>
			            <family>Noto Sans Inscriptional Pahlavi</family>
			            <family>Noto Sans Inscriptional Parthian</family>
			            <family>Noto Sans Javanese</family>
			            <family>Noto Sans Kaithi</family>
			            <family>Noto Sans Kannada</family>
			            <family>Noto Sans Kayah Li</family>
			            <family>Noto Sans Kharoshthi</family>
			            <family>Noto Sans Khmer</family>
			            <family>Noto Sans Lao</family>
			            <family>Noto Sans Lepcha</family>
			            <family>Noto Sans Limbu</family>
			            <family>Noto Sans Linear B</family>
			            <family>Noto Sans Lisu</family>
			            <family>Noto Sans Lycian</family>
			            <family>Noto Sans Lydian</family>
			            <family>Noto Sans Malayalam</family>
			            <family>Noto Sans Mandaic</family>
			            <family>Noto Sans Meetei Mayek</family>
			            <family>Noto Sans Mongolian</family>
			            <family>Noto Sans Mono CJK JP</family>
			            <family>Noto Sans Mono CJK KR</family>
			            <family>Noto Sans Mono CJK SC</family>
			            <family>Noto Sans Mono CJK TC</family>
			            <family>Noto Sans Myanmar</family>
			            <family>Noto Sans New Tai Lue</family>
			            <family>Noto Sans NKo</family>
			            <family>Noto Sans Ogham</family>
			            <family>Noto Sans Ol Chiki</family>
			            <family>Noto Sans Old Italic</family>
			            <family>Noto Sans Old Persian</family>
			            <family>Noto Sans Old South Arabian</family>
			            <family>Noto Sans Old Turkic</family>
			            <family>Noto Sans Oriya</family>
			            <family>Noto Sans Osmanya</family>
			            <family>Noto Sans Phags Pa</family>
			            <family>Noto Sans Phoenician</family>
			            <family>Noto Sans Rejang</family>
			            <family>Noto Sans Runic</family>
			            <family>Noto Sans Samaritan</family>
			            <family>Noto Sans Saurashtra</family>
			            <family>Noto Sans Shavian</family>
			            <family>Noto Sans Sinhala</family>
			            <family>Noto Sans Sundanese</family>
			            <family>Noto Sans Syloti Nagri</family>
			            <family>Noto Sans Symbols</family>
			            <family>Noto Sans Syriac Eastern</family>
			            <family>Noto Sans Syriac Estrangela</family>
			            <family>Noto Sans Syriac Western</family>
			            <family>Noto Sans Tagalog</family>
			            <family>Noto Sans Tagbanwa</family>
			            <family>Noto Sans Tai Le</family>
			            <family>Noto Sans Tai Tham</family>
			            <family>Noto Sans Tai Viet</family>
			            <family>Noto Sans Tamil</family>
			            <family>Noto Sans Telugu</family>
			            <family>Noto Sans Thaana</family>
			            <family>Noto Sans Thai</family>
			            <family>Noto Sans Tibetan</family>
			            <family>Noto Sans Tifinagh</family>
			            <family>Noto Sans Ugaritic</family>
			            <family>Noto Sans Vai</family>
			            <family>Noto Sans Yi</family>
			            <family>Noto Kufi Arabic</family>
			            <family>Noto Naskh Arabic</family>
			            <family>Noto Nastaliq Urdu</family>
                    </prefer>
            <!-- Use the nerdfont version of Jetbrains mono for monospace, with a fallback to Noto Sans mono in case of missing symbols and such -->
                <family>monospace</family>
                <prefer>
                    <family>JetBrainsMono Nerd Font</family>
                    <family>DejaVuSansM Nerd Font</family>
                    <family>Noto Sans Nerd Font</family>
                    <family>Noto Sans Mono</family>
                </prefer>
            <!-- Set noto serif as the default serif font -->
                <family>serif</family>
                <prefer>
                    <family>Noto Serif</family>
                </prefer>
            <!-- Use Blinker as the default system UI font, with a fallback to Noto Sans UI -->
                <family>system-ui</family>
                <prefer>
                    <family>Blinker</family>
                    <family>Noto Sans UI</family>
                </prefer>
            </alias>
        '';
    };
}