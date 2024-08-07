#!/bin/bash
RandomizerBasedir=/media/fat/Scripts/randomizers
BaseGameDir=/media/fat/cifs/games
BaseYamlDir=$RandomizerBasedir/yamls
BaseSnesDir=SNES
BaseNesDir=NES
BaseGameboyDir=GAMEBOY
BaseGBADir=GBA
BaseN64Dir=N64
BaseGenesisDir=Genesis
BaseSMSDir=SMS
TmpDir=$RandomizerBasedir/taptorandomizetmp
ArchipelagoDir=$RandomizerBasedir/archipelago-0.5.0-MiSTerFPGA
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
#PokeERandoDir=PokemonEmeraldRando
#PokeEPlayerDir=pokemonemerald
#OOTRandoDir=OOTRando
#OOTPlayerDir=oot
PokeRBRandoDir=PokeRBRando
PokeRBPlayerDir=pokemonrb
SMWRandoDir=SMWRando
SMWPlayerDir=smw
SMZ3RandoDir=SMZ3Rando
SMZ3PlayerDir=smz3
SOERandoDir=SOERando
SOEPlayerDir=soe
BaseRandoDir=/tmp/rando/
SMRandoDir=SMRando
SMPlayerDir=supermetroid
SMW2RandoDir=YIRando
SMW2PlayerDir=yoshi
YGORandoDir=YGORando
YGOPlayerDir=yugioh
ZillionRandoDir=ZillionRando
ZillionPlayerDir=zillion
SystemForAutolaunch=none
KeepSeeds=5

#Handle ini file if it exists
INI_PATH=/media/fat/Scripts/randomizerlauncher.ini
if [ -f $INI_PATH ]
then
        source <(grep = $INI_PATH|tr -d '\r')
fi
python $RandomizerBasedir/yamlupdater.py
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
        mkdir -p $TmpDir
        rm -Rf $TmpDir/*
        cp $BaseYamlDir/host.yaml $ArchipelagoDir/
        $ArchipelagoDir/ArchipelagoGenerate --player_files_path $ArchipelagoPlayerDir
        unzip $TmpDir/*.zip -d $TmpDir/
        $ArchipelagoDir/ArchipelagoPatch $TmpDir/AP_*P1*.ap*
        cp $TmpDir/AP*$ArchipelagoFileEnding $BaseRandoDir/current
        rm -Rf $TmpDir/*
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
                SystemForAutolaunch="NES"
        ;;
        alttp)
                BaseRandoDir=$BaseGameDir/$BaseSnesDir/$ALTTPRandoDir
                shift_old_seeds
                ArchipelagoPlayerDir=$BaseYamlDir/$ALTTPPlayerDir
                ArchipelagoFileEnding='.sfc'
                archipelago_generate 
                SystemForAutolaunch="SNES"
        ;;
        dkc3)
                BaseRandoDir=$BaseGameDir/$BaseSnesDir/$DKC3RandoDir
                shift_old_seeds
                ArchipelagoPlayerDir=$BaseYamlDir/$DKC3PlayerDir
                ArchipelagoFileEnding='.sfc'
                archipelago_generate 
                SystemForAutolaunch="SNES"
        ;;
        cv64)
                BaseRandoDir=$BaseGameDir/$BaseN64Dir/$CV64RandoDir
                shift_old_seeds
                ArchipelagoPlayerDir=$BaseYamlDir/$CV64PlayerDir
                ArchipelagoFileEnding='.z64'
                archipelago_generate 
                SystemForAutolaunch="N64"
        ;;
        kdl3)
                BaseRandoDir=$BaseGameDir/$BaseSnesDir/$KDL3RandoDir
                shift_old_seeds
                ArchipelagoPlayerDir=$BaseYamlDir/$KDL3PlayerDir
                ArchipelagoFileEnding='.sfc'
                archipelago_generate 
                SystemForAutolaunch="SNES"
        ;;
        loz)
                BaseRandoDir=$BaseGameDir/$BaseNesDir/$LOZRandoDir
                shift_old_seeds
                ArchipelagoPlayerDir=$BaseYamlDir/$LOZPlayerDir
                ArchipelagoFileEnding='.nes'
                archipelago_generate 
                SystemForAutolaunch="NES"
        ;;
        l2)
                BaseRandoDir=$BaseGameDir/$BaseSnesDir/$L2RandoDir
                shift_old_seeds
                ArchipelagoPlayerDir=$BaseYamlDir/$L2PlayerDir
                ArchipelagoFileEnding='.sfc'
                archipelago_generate 
                SystemForAutolaunch="SNES"
        ;;
        mmbn3)
                BaseRandoDir=$BaseGameDir/$BaseGBADir/$MMBN3RandoDir
                shift_old_seeds
                ArchipelagoPlayerDir=$BaseYamlDir/$MMBN3PlayerDir
                ArchipelagoFileEnding='.gba'
                archipelago_generate 
                SystemForAutolaunch="GBA"
        ;;
#        Commented out as it doesn't currently run on MiSTer; left for future fix
#        oot)
#                BaseRandoDir=$BaseGameDir/$BaseN64Dir/$OOTRandoDir
#                shift_old_seeds
#                ArchipelagoPlayerDir=$BaseYamlDir/$OOTPlayerDir
#                ArchipelagoFileEnding='.z64'
#                archipelago_generate
#                SystemForAutolaunch="N64"
#        ;;
#        pokee)
#                BaseRandoDir=$BaseGameDir/$BaseGBADir/$PokeERandoDir
#                shift_old_seeds
#                ArchipelagoPlayerDir=$BaseYamlDir/$PokeEPlayerDir
#                ArchipelagoFileEnding='.gba'
#                archipelago_generate 
#                SystemForAutolaunch="GBA"
#        ;;
        pokerb)
                BaseRandoDir=$BaseGameDir/$BaseGameboyDir/$PokeRBRandoDir
                shift_old_seeds
                ArchipelagoPlayerDir=$BaseYamlDir/$PokeRBPlayerDir
                ArchipelagoFileEnding='.gb'
                archipelago_generate 
                SystemForAutolaunch="GAMEBOY"
        ;;    
        smw)
                BaseRandoDir=$BaseGameDir/$BaseSnesDir/$SMWRandoDir
                shift_old_seeds
                ArchipelagoPlayerDir=$BaseYamlDir/$SMWPlayerDir
                ArchipelagoFileEnding='.sfc'
                archipelago_generate 
                SystemForAutolaunch="SNES"
        ;;
        smz3)
                BaseRandoDir=$BaseGameDir/$BaseSnesDir/$SMZ3RandoDir
                shift_old_seeds
                ArchipelagoPlayerDir=$BaseYamlDir/$SMZ3PlayerDir
                ArchipelagoFileEnding='.sfc'
                archipelago_generate 
                SystemForAutolaunch="SNES"
        ;;
        soe)
                BaseRandoDir=$BaseGameDir/$BaseSnesDir/$SOERandoDir
                shift_old_seeds
                ArchipelagoPlayerDir=$BaseYamlDir/$SOEPlayerDir
                ArchipelagoFileEnding='.sfc'
                archipelago_generate 
                SystemForAutolaunch="SNES"
        ;;
        sm)
                BaseRandoDir=$BaseGameDir/$BaseSnesDir/$SMRandoDir
                shift_old_seeds
                ArchipelagoPlayerDir=$BaseYamlDir/$SMPlayerDir
                ArchipelagoFileEnding='.sfc'
                archipelago_generate 
                SystemForAutolaunch="SNES"
        ;;
        yoshi)
                BaseRandoDir=$BaseGameDir/$BaseSnesDir/$SMW2RandoDir
                shift_old_seeds
                ArchipelagoPlayerDir=$BaseYamlDir/$SMW2PlayerDir
                ArchipelagoFileEnding='.sfc'
                archipelago_generate 
                SystemForAutolaunch="SNES"
        ;;  
        yugioh06)
                BaseRandoDir=$BaseGameDir/$BaseGBADir/$YGORandoDir
                shift_old_seeds
                ArchipelagoPlayerDir=$BaseYamlDir/$YGOPlayerDir
                ArchipelagoFileEnding='.gba'
                archipelago_generate 
                SystemForAutolaunch="GBA"
        ;;
        zillion)
                BaseRandoDir=$BaseGameDir/$BaseSMSDir/$ZillionRandoDir
                shift_old_seeds
                ArchipelagoPlayerDir=$BaseYamlDir/$ZillionPlayerDir
                ArchipelagoFileEnding='.sms'
                archipelago_generate 
                SystemForAutolaunch="SMS"                     
esac
if [ "$2" == "autoload" ]; then
        $RandomizerBasedir/mbc load_rom $SystemForAutolaunch $BaseRandoDir/current/*
fi