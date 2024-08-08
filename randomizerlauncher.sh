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
DQ3RandoDir=DQ3Rando
DQ3RomPath='/media/fat/cifs/games/SNES/randoroms/dq3.smc'
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
        python $RandomizerBasedir/yamlupdater.py
        mkdir -p $TmpDir
        rm -Rf $TmpDir/*
        cp $BaseYamlDir/host.yaml $ArchipelagoDir/
        $ArchipelagoDir/ArchipelagoGenerate --player_files_path $ArchipelagoPlayerDir
        unzip $TmpDir/*.zip -d $TmpDir/
        $ArchipelagoDir/ArchipelagoPatch $TmpDir/AP_*P1*.ap*
        cp $TmpDir/AP*$ArchipelagoFileEnding $BaseRandoDir/current
        rm -Rf $TmpDir/*
}
solarjetman(){
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
}
alttp(){
        BaseRandoDir=$BaseGameDir/$BaseSnesDir/$ALTTPRandoDir
        shift_old_seeds
        ArchipelagoPlayerDir=$BaseYamlDir/$ALTTPPlayerDir
        ArchipelagoFileEnding='.sfc'
        archipelago_generate 
        SystemForAutolaunch="SNES"
}
dkc3(){
        BaseRandoDir=$BaseGameDir/$BaseSnesDir/$DKC3RandoDir
        shift_old_seeds
        ArchipelagoPlayerDir=$BaseYamlDir/$DKC3PlayerDir
        ArchipelagoFileEnding='.sfc'
        archipelago_generate 
        SystemForAutolaunch="SNES"
}
cv64(){
        BaseRandoDir=$BaseGameDir/$BaseN64Dir/$CV64RandoDir
        shift_old_seeds
        ArchipelagoPlayerDir=$BaseYamlDir/$CV64PlayerDir
        ArchipelagoFileEnding='.z64'
        archipelago_generate 
        SystemForAutolaunch="N64"
}
kdl3(){
        BaseRandoDir=$BaseGameDir/$BaseSnesDir/$KDL3RandoDir
        shift_old_seeds
        ArchipelagoPlayerDir=$BaseYamlDir/$KDL3PlayerDir
        ArchipelagoFileEnding='.sfc'
        archipelago_generate 
        SystemForAutolaunch="SNES"
}
loz(){
        BaseRandoDir=$BaseGameDir/$BaseNesDir/$LOZRandoDir
        shift_old_seeds
        ArchipelagoPlayerDir=$BaseYamlDir/$LOZPlayerDir
        ArchipelagoFileEnding='.nes'
        archipelago_generate 
        SystemForAutolaunch="NES"
}
l2(){
        BaseRandoDir=$BaseGameDir/$BaseSnesDir/$L2RandoDir
        shift_old_seeds
        ArchipelagoPlayerDir=$BaseYamlDir/$L2PlayerDir
        ArchipelagoFileEnding='.sfc'
        archipelago_generate 
        SystemForAutolaunch="SNES"
}
mmbn3(){
        BaseRandoDir=$BaseGameDir/$BaseGBADir/$MMBN3RandoDir
        shift_old_seeds
        ArchipelagoPlayerDir=$BaseYamlDir/$MMBN3PlayerDir
        ArchipelagoFileEnding='.gba'
        archipelago_generate 
        SystemForAutolaunch="GBA"
}
oot(){
        BaseRandoDir=$BaseGameDir/$BaseN64Dir/$OOTRandoDir
        shift_old_seeds
        ArchipelagoPlayerDir=$BaseYamlDir/$OOTPlayerDir
        ArchipelagoFileEnding='.z64'
        archipelago_generate
        SystemForAutolaunch="N64"
}
pokee(){
        BaseRandoDir=$BaseGameDir/$BaseGBADir/$PokeERandoDir
        shift_old_seeds
        ArchipelagoPlayerDir=$BaseYamlDir/$PokeEPlayerDir
        ArchipelagoFileEnding='.gba'
        archipelago_generate 
        SystemForAutolaunch="GBA"
}
pokerb(){
        BaseRandoDir=$BaseGameDir/$BaseGameboyDir/$PokeRBRandoDir
        shift_old_seeds
        ArchipelagoPlayerDir=$BaseYamlDir/$PokeRBPlayerDir
        ArchipelagoFileEnding='.gb'
        archipelago_generate 
        SystemForAutolaunch="GAMEBOY"
}
smw(){
        BaseRandoDir=$BaseGameDir/$BaseSnesDir/$SMWRandoDir
        shift_old_seeds
        ArchipelagoPlayerDir=$BaseYamlDir/$SMWPlayerDir
        ArchipelagoFileEnding='.sfc'
        archipelago_generate 
        SystemForAutolaunch="SNES"
}
smz3(){
        BaseRandoDir=$BaseGameDir/$BaseSnesDir/$SMZ3RandoDir
        shift_old_seeds
        ArchipelagoPlayerDir=$BaseYamlDir/$SMZ3PlayerDir
        ArchipelagoFileEnding='.sfc'
        archipelago_generate 
        SystemForAutolaunch="SNES"
}
soe(){
        BaseRandoDir=$BaseGameDir/$BaseSnesDir/$SOERandoDir
        shift_old_seeds
        ArchipelagoPlayerDir=$BaseYamlDir/$SOEPlayerDir
        ArchipelagoFileEnding='.sfc'
        archipelago_generate 
        SystemForAutolaunch="SNES"
}
sm(){
        BaseRandoDir=$BaseGameDir/$BaseSnesDir/$SMRandoDir
        shift_old_seeds
        ArchipelagoPlayerDir=$BaseYamlDir/$SMPlayerDir
        ArchipelagoFileEnding='.sfc'
        archipelago_generate 
         SystemForAutolaunch="SNES"
}
yoshi(){
        BaseRandoDir=$BaseGameDir/$BaseSnesDir/$SMW2RandoDir
        shift_old_seeds
        ArchipelagoPlayerDir=$BaseYamlDir/$SMW2PlayerDir
        ArchipelagoFileEnding='.sfc'
        archipelago_generate 
        SystemForAutolaunch="SNES"
}
yugioh06(){
        BaseRandoDir=$BaseGameDir/$BaseGBADir/$YGORandoDir
        shift_old_seeds
        ArchipelagoPlayerDir=$BaseYamlDir/$YGOPlayerDir
        ArchipelagoFileEnding='.gba'
        archipelago_generate 
        SystemForAutolaunch="GBA"
}
zillion(){
        BaseRandoDir=$BaseGameDir/$BaseSMSDir/$ZillionRandoDir
        shift_old_seeds
        ArchipelagoPlayerDir=$BaseYamlDir/$ZillionPlayerDir
        ArchipelagoFileEnding='.sms'
        archipelago_generate 
        SystemForAutolaunch="SMS"
}
dq3(){
        BaseRandoDir=$BaseGameDir/$BaseSnesDir/$DQ3RandoDir
        shift_old_seeds
        mkdir -p $RandomizerBasedir/dq3hf/dev/
        echo "$DQ3RomPath" > $RandomizerBasedir/dq3hf/dev/path.txt
        cd $RandomizerBasedir/dq3hf
        python $RandomizerBasedir/dq3hf/randomizer.py
        cp $DQ3RomPath $BaseRandoDir/current/$RANDOM.sfc
        $RandomizerBasedir/dq3hf/asar/asar --fix-checksum=off --no-title-check "$RandomizerBasedir/dq3hf/asar/patch.asm" "$BaseRandoDir/current/*.sfc"
        rm $RandomizerBasedir/dq3hf/asar/patch_r.asm
        cd /media/fat/Scripts/
        SystemForAutolaunch="SNES"
}
call_menu(){

        items=(solarjetman "Solar Jetman NES (akerasi)"
               alttp "A Link to the Past SNES (Archipelago)"
               dkc3 "Donkey Kong Country 3 SNES (Archipelago)"
               cv64 "Castlevania 64 (Archipelago)"
               kdl3 "Kirby's Dream Land 3 (Archipelago)"
               loz "The Legend of Zelda NES (Archipelago)"
               l2 "Lufia 2 Ancient Caves SNES (Archipelago)"
               mmbn3 "Mega Man Battle Network 3 GBA (Archipelago)"
               pokerb "Pokemon Red/Blue GB (Archipelago)"
               sm "Super Metroid SNES (Archipelago)"
               smw "Super Mario World SNES (Archipelago)"
               soe "Secret of Evermore SNES (Archipelago)"
               smz3 "Super Metroid/A Link to the Past Combo SNES (Archipelago)"
               yoshi "Yoshi's Island SNES (Archipelago)"
               yugioh06 "YuGiOh Ultimate Masters 2006 GBA (Archipelago)"
               zillion "Zillion SMS (Archipelago)"
               dq3 "Dragon's Quest 3 Super Famicom (cleartonic)")

        choice=$(dialog --title "TapToRandomize Launcher" \
                         --menu "Select a randomizer to launch" 50 90 999 "${items[@]}" \
                         2>&1 >/dev/tty2)
        case $choice in
                solarjetman) solarjetman ;; 
                alttp) alttp ;; 
                dkc3) dkc3 ;;
                cv64) cv64 ;;
                kdl3) kdl3 ;;
                loz) loz ;;     
                l2) l2 ;;
                mmbn3) mmbn3 ;;
#        Commented out as it doesn't currently run on MiSTer; left for future fix
#                oot) oot ;;
#                pokee) pokee ;;
                pokerb) pokerb ;;    
                smw) smw ;;
                smz3) smz3 ;;
                soe) soe ;;
                sm) sm ;;
                yoshi) yoshi ;;  
                yugioh06) yugioh06 ;;
                zillion) zillion ;;
                dq3) dq3 ;;
                *) clear
                exit 0 ;;
        esac
        autoload=1
        clear # clear after user pressed Cancel
        
}
case $1 in
        solarjetman) solarjetman ;;
        alttp) alttp ;;
        dkc3) dkc3 ;;
        cv64) cv64 ;;
        kdl3) kdl3 ;;
        loz) loz ;;
        l2) l2 ;;
        mmbn3) mmbn3 ;;
#        Commented out as it doesn't currently run on MiSTer; left for future fix
#        oot) oot ;;
#        pokee) pokee ;;
        pokerb) pokerb ;;    
        smw) smw ;;
        smz3) smz3 ;;
        soe) soe ;;
        sm) sm ;;
        yoshi) yoshi ;;  
        yugioh06) yugioh06 ;;
        zillion) zillion ;;
        dq3) dq3 ;;
        *) call_menu ;;
        #No valid argument entered, start up the menu if we can
esac
if [ "$2" == "autoload" ]; then
        autoload=1
fi
if [ $autoload ]; then
        $RandomizerBasedir/mbc load_rom $SystemForAutolaunch $BaseRandoDir/current/*
fi