TapToRandomizer is a simple script to automize randomizer usage on MiSTerFPGA, best utilized alongside TapTo (https://github.com/TapToCommunity/tapto)

Usage: randomizerlauncher.sh randomizername

In TapTo, make a card with **mister.script:randomizerlauncher.sh randomizername||**launch.random:/media/fat/path/to/platform/RandoDir

RandoDir for each randomizer is defined in the script or in a .ini file. It's set to sane defaults (at least for people who use a cifs drive like me; if your stuff is on an SD card, remove the cifs from all the configs)

Each Archipelago-based randomizer (all of them but Solar Jetman right now) uses a yaml file, located in yamls, for some of its configs. I plan to make a method for .ini to rewrite the yamls for you, but haven't done that yet. Also important is yamls/host.yaml which has some configs for every Archipelago randomizer. Again, I plan implementing a rewriter for these files, flattening it all into a single, simple .ini file, at some point.

This is EARLY Alpha at this point; it should progress as things go.

Version: 0.1.1
Author: akerasi (Allen Tipper)