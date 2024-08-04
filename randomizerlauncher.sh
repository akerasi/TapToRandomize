#!/bin/bash
BaseGameDir=/media/fat/cifs/games
BaseSnesDir=SNES
BaseNesDir=NES
SolarJetmanRandoDir=SolarJetmanRando
SolarJetmanRom='/media/fat/cifs/games/NES/randoroms/Solar Jetman - Hunt for the Golden Warpship (USA).nes'
BaseRandoDir=/tmp/rando/
KeepSeeds=5
shift_old_seeds(){
        mkdir -p $BaseRandoDir/current
        mkdir -p $BaseRandoDir/archive
        SeedInCurrent=$(ls -1 $BaseRandoDir/current | wc -l)
        if (( SeedInCurrent > 0 )); then
                for filename in $BaseRandoDir/current/*; do
                        mv "$filename" $BaseRandoDir/archive
                done
                cd $BaseRandoDir/archive
                ls -1tr | head -n -$KeepSeeds | xargs -d '\n' rm -f --
                cd /media/fat/Scripts
        fi;
}
case $1 in
        solarjetman)
                BaseRandoDir=$BaseGameDir/$BaseNesDir/$SolarJetmanRandoDir
                shift_old_seeds
                if [ ! -e .venvsj/bin/activate ]; then
                    python -m venv .venvsj
                fi
                source .venvsj/bin/activate
                pip install sj-rando
                sj-rando -i -p --mode normal --rompath "${SolarJetmanRom}"
                deactivate
                mv *.nes "$BaseRandoDir/current"
        ;;

esac