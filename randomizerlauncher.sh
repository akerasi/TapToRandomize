#!/bin/bash
BaseGameDir=/media/fat/cifs/games
BaseYamlDir=/media/fat/Scripts/yamls
BaseSnesDir=SNES
BaseNesDir=NES
BaseGameboyDir=GAMEBOY
BaseGBADir=GBA
BaseN64Dir=N64
BaseGenesisDir=Genesis
SolarJetmanRandoDir=SolarJetmanRando
SolarJetmanRom='/media/fat/cifs/games/NES/randoroms/Solar Jetman - Hunt for the Golden Warpship (USA).nes'
ALTTPRandoDir=ALTTPRando
ALTTPPlayerDir=alttp
DKC3RandoDir=DKC3Rando
DKC3PlayerDir=dkc3
CV64RandoDir=CV64Rando
CV64PlayerDir=cv64
KDL3RandoDir=KDL3Rando
KDL3PlayerDir=kdl3
LOZRandoDir=LOZRando
LOZPlayerDir=loz
L2RandoDir=L2Rando
L2PlayerDir=lufia2
MMBN3RandoDir=MMBN3Rando
MMBN3PlayerDir=mmbn3
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
        unzip taptorandomizetmp/*.zip -d taptorandomizetmp/
        archipelago-0.5.0-MiSTerFPGA/ArchipelagoPatch taptorandomizetmp/AP_*P1*.ap*
        cp taptorandomizetmp/AP*$ArchipelagoFileEnding $BaseRandoDir/current
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
                ArchipelagoPlayerDir=$BaseYamlDir/$ALTTPPlayerDir
                ArchipelagoFileEnding='.sfc'
                archipelago_generate 
        ;;
        dkc3)
                BaseRandoDir=$BaseGameDir/$BaseSnesDir/$DKC3RandoDir
                shift_old_seeds
                ArchipelagoPlayerDir=$BaseYamlDir/$DKC3PlayerDir
                ArchipelagoFileEnding='.sfc'
                archipelago_generate 
        ;;
        cv64)
                BaseRandoDir=$BaseGameDir/$BaseN64Dir/$CV64RandoDir
                shift_old_seeds
                ArchipelagoPlayerDir=$BaseYamlDir/$CV64PlayerDir
                ArchipelagoFileEnding='.z64'
                archipelago_generate 
        ;;
        kdl3)
                BaseRandoDir=$BaseGameDir/$BaseSnesDir/$KDL3RandoDir
                shift_old_seeds
                ArchipelagoPlayerDir=$BaseYamlDir/$KDL3PlayerDir
                ArchipelagoFileEnding='.sfc'
                archipelago_generate 
        ;;
        loz)
                BaseRandoDir=$BaseGameDir/$BaseNesDir/$LOZRandoDir
                shift_old_seeds
                ArchipelagoPlayerDir=$BaseYamlDir/$LOZPlayerDir
                ArchipelagoFileEnding='.nes'
                archipelago_generate 
        ;;
        l2)
                BaseRandoDir=$BaseGameDir/$BaseSnesDir/$L2RandoDir
                shift_old_seeds
                ArchipelagoPlayerDir=$BaseYamlDir/$L2PlayerDir
                ArchipelagoFileEnding='.sfc'
                archipelago_generate 
        ;;
        mmbn3)
                BaseRandoDir=$BaseGameDir/$BaseGBADir/$MMBN3RandoDir
                shift_old_seeds
                ArchipelagoPlayerDir=$BaseYamlDir/$MMBN3PlayerDir
                ArchipelagoFileEnding='.gba'
                archipelago_generate 
        ;;
esac