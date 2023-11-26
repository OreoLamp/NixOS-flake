{
    # Sets up zram swap (in-place live memory compression)
    zramSwap = {
        enable = true;

        # The amount of stuff that can be put to zram as a percentage of total system memory
        # Note: This is the uncompressed size of whatever happens to be there
        memoryPercent = 100;
        algorithm = "zstd";
    };

    # Kernel parameters set by sysctl for zram swap
    boot.kernel.sysctl = {
        # Swappiness is stupidly high bc zram is really fast
        "vm.swappiness" = 180;

        # pop_os magic settings for zram?
        "vm.watermark_boost_factor" = 0;
        "vm.watermark_scale_factor" = 125;
        "vm.page-cluster" = 0;
    };

    # Sets up a kernel that boots on crash to save crash logs etc
    boot.crashDump.enable = true;
}