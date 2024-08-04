#!/bin/bash
BaseGameDir=/media/fat/games
BaseSnesDir=SNES
BaseNesDir=NES
DariusTwinRandoDir=DariusTwinRando
DucktalesRandoDir=DucktalesRando
ClashRandoDir=ClashRando
NinjsGaidenRandoDir=NinjaGaidenRando
MonsterPartyRandoDir=MonsterPartyRando
AdvIsland2RandoDir=AdventureIsland2Rando
SolarJetmanRandoDir=SolarJetmanRando
SolarJetmanRom="$BaseGameDir/$BaseNesDir/EverDrive N8 & PowePak v6.2/1 US - R-Z/Solar Jetman - Hunt for the Golden Warpship (USA).nes"
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
        darius)
                BaseRandoDir=$BaseGameDir/$BaseSnesDir/$DariusTwinRandoDir
                shift_old_seeds
                wget --content-disposition https://micheilskeens.com/dariustwin.php --post-data="submit" --directory-prefix=$BaseRandoDir/current/
        ;;
        ducktales)
                BaseRandoDir=$BaseGameDir/$BaseNesDir/$DucktalesRandoDir
                shift_old_seeds
                wget --content-disposition https://micheilskeens.com/ducktales.php --post-data="submit" --directory-prefix=$BaseRandoDir/current/
        ;;
        clash)
                BaseRandoDir=$BaseGameDir/$BaseNesDir/$ClashRandoDir
                shift_old_seeds
                wget --content-disposition https://micheilskeens.com/CLASH.php --post-data="submit" --directory-prefix=$BaseRandoDir/current/
        ;;
        ninjagaiden)
                BaseRandoDir=$BaseGameDir/$BaseNesDir/$NinjaGaidenRandoDir
                shift_old_seeds
                wget --content-disposition https://micheilskeens.com/ninjagaiden.php --post-data="submit" --directory-prefix=$BaseRandoDir/current/
        ;;
        monsterparty)
                BaseRandoDir=$BaseGameDir/$BaseNesDir/$MonsterPartyRandoDir
                shift_old_seeds
                wget --content-disposition https://micheilskeens.com/monsterparty.php --post-data="submit" --directory-prefix=$BaseRandoDir/current/
        ;;
        advisland2)
                BaseRandoDir=$BaseGameDir/$BaseNesDir/$AdvIsland2RandoDir
                shift_old_seeds
                wget --content-disposition https://micheilskeens.com/adventureisland2.php --post-data="submit" --directory-prefix=$BaseRandoDir/current/
        ;;
        solarjetman)
                ec
                if [ ! -e .venvsj/bin/activate ]; then
                    python -m venv .venvsj
                fi
                source .venvsj/bin/activate
                pip install sj-rando
                BaseRandoDir=$BaseGameDir/$BaseNesDir/$SolarJetmanRandoDir
                shift_old_seeds
                sj-rando --rompath "$SolarJetmanRom"
                mv *.nes "$BaseRandoDir/current"
                

esac