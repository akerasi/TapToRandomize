#!/bin/bash
BaseGameDir=/media/fat/cifs/games
BaseYamlDir=/media/fat/Scripts/yamls
BaseSnesDir=SNES
BaseNesDir=NES
BaseGameboyDir=GAMEBOY
BaseGBADir=GBA
BaseN64Dir=N64
SolarJetmanRandoDir=SolarJetmanRando
SolarJetmanRom='/media/fat/cifs/games/NES/randoroms/Solar Jetman - Hunt for the Golden Warpship (USA).nes'
ALTTPRandoDir=ALTTPRando
ALTTPPlayerDir=$BaseYamlDir/alttp
BaseRandoDir=/tmp/rando/
KeepSeeds=5

#Handle ini file if it exists
if [ "$ORIGINAL_SCRIPT_PATH" == "bash" ]
then
	ORIGINAL_SCRIPT_PATH=$(ps | grep "^ *$PPID " | grep -o "[^ ]*$")
fi
INI_PATH=${ORIGINAL_SCRIPT_PATH%.*}.ini
if [ -f $INI_PATH ]
then
	eval "$(cat $INI_PATH | tr -d '\r')"
fi

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
archipelago_generate(){
        mkdir -p taptorandomizetmp
        cp $BaseYamlDir/host.yaml archipelago-0.5.0-MiSTerFPGA/
        archipelago-0.5.0-MiSTerFPGA/ArchipelagoGenerate --player_files_path $ArchipelagoPlayerDir
        unzip taptorandomizetmp/*.zip
        archipelago-0.5.0-MiSTerFPGA/ArchipelagoPatch AP_*P1*
        cp taptorandomizetmp/*.$ArchipelagoFileEnding $BaseRandoDir/current
        rm taptorandomizetmp/*
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
        alttp)
                BaseRandoDir=$BaseGameDir/$BaseSnesDir/$ALTTPRandoDir
                shift_old_seeds
                ArchipelagoPlayerDir=$ALTTPPlayerDir
                ArchipelagoFileEnding='.sfc'
                archipelago_generate 
        ;;
esac