#!/bin/bash
BaseGameDir=/media/fat/cifs/games
BaseSnesDir=SNES
BaseNesDir=NES
SolarJetmanRandoDir=SolarJetmanRando
SolarJetmanRom="$BaseGameDir/$BaseNesDir/EverDrive N8 & PowerPak v6.2/1 US - R-Z/Solar Jetman - Hunt for the Golden Warpship (USA).nes"
BaseRandoDir=/tmp/rando/
KeepSeeds=5
shift_old_seeds(){
        mkdir -p $BaseRandoDir/current
        mkdir -p $BaseRandoDir/archive
        SeedInCurrent=$(ls -1 $BaseRandoDir/current | wc -l)
        if (( SeedInCurrent > 0 )); then
                mv $BaseRandoDir/current/* $BaseRandoDir/archive
                cd $BaseRandoDir/archive
                ls -1tr | head -n -$KeepSeeds | xargs -d '\n' rm -f --
        fi;
}
case $1 in
        solarjetman)
                if [ ! -e .venvsj/bin/activate ]; then
                    python -m venv .venvsj
                fi
                source .venvsj/bin/activate
                pip install sj-rando
                BaseRandoDir=$BaseGameDir/$BaseNesDir/$SolarJetmanRandoDir
                shift_old_seeds
                sj-rando --rompath "$SolarJetmanRom"
                mv *.nes "$BaseRandoDir/current"
        ;;

esac