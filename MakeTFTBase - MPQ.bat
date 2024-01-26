@ECHO OFF
ECHO Making AMAI
ECHO _____________________________
ECHO creating \Scripts\TFT\common.ai
perl ejass.pl common.eai TFT VER:TFT > Scripts\TFT\common.ai
ECHO IGNORE jasshelper --scriptonly common.j Scripts\Blizzard.j Scripts\TFT\common.ai Scripts\TFT\common2.ai
ECHO \Scripts\TFT\common.ai created
pjass common.j Scripts\TFT\common.ai
jassparser common.j Scripts\TFT\common.ai
ECHO _____________________________
ECHO creating \Scripts\TFT\elf.ai
perl ejass.pl races.eai TFT VER:TFT ELF RACE:ELF > Scripts\TFT\elf.ai
ECHO \Scripts\TFT\elf.ai created
pjass common.j Scripts\TFT\common.ai Scripts\TFT\elf.ai
jassparser common.j Scripts\TFT\common.ai Scripts\TFT\elf.ai
ECHO _____________________________
ECHO creating \Scripts\TFT\human.ai
perl ejass.pl races.eai TFT VER:TFT HUMAN RACE:HUMAN > Scripts\TFT\human.ai
ECHO \Scripts\TFT\human.ai created
pjass common.j Scripts\TFT\common.ai Scripts\TFT\human.ai
jassparser common.j Scripts\TFT\common.ai Scripts\TFT\human.ai
ECHO _____________________________
ECHO creating \Scripts\TFT\orc.ai
perl ejass.pl races.eai TFT VER:TFT ORC RACE:ORC > Scripts\TFT\orc.ai
ECHO \Scripts\TFT\orc.ai created
pjass common.j Scripts\TFT\common.ai Scripts\TFT\orc.ai
jassparser common.j Scripts\TFT\common.ai Scripts\TFT\orc.ai
ECHO _____________________________
ECHO creating \Scripts\TFT\undead.ai
perl ejass.pl races.eai TFT VER:TFT UNDEAD RACE:UNDEAD > Scripts\TFT\undead.ai
ECHO \Scripts\TFT\undead.ai created
pjass common.j Scripts\TFT\common.ai Scripts\TFT\undead.ai
jassparser common.j Scripts\TFT\common.ai Scripts\TFT\undead.ai
ECHO _____________________________
ECHO creating \Scripts\Blizzard_TFT.j
perl SplitBlizzardJ.pl TFT
perl ejass.pl Blizzard3.eai TFT VER:TFT > TFT\tmp\Blizzard3Gen.j
perl ejass.pl Blizzard.eai TFT VER:TFT > Scripts\Blizzard_TFT.j
ECHO \Scripts\Blizzard_TFT.j created
pjass common.j Scripts\Blizzard_TFT.j
jassparser common.j Scripts\Blizzard_TFT.j
rmdir /s /q "TFT/tmp"
ECHO _____________________________
ECHO creating \Scripts\TFT\AMAI.mpq
copy empty.mpq Scripts\TFT\AMAI.mpq
AddToMPQ Scripts\TFT\AMAI.mpq Scripts\TFT\common.ai Scripts\common.ai Scripts\Blizzard_TFT.j Scripts\Blizzard.j
AddToMPQ Scripts\TFT\AMAI.mpq Scripts\TFT\elf.ai Scripts\elf.ai
AddToMPQ Scripts\TFT\AMAI.mpq Scripts\TFT\human.ai Scripts\human.ai
AddToMPQ Scripts\TFT\AMAI.mpq Scripts\TFT\orc.ai Scripts\orc.ai
AddToMPQ Scripts\TFT\AMAI.mpq Scripts\TFT\undead.ai Scripts\undead.ai
AddToMPQ Scripts\TFT\AMAI.mpq Icons\CommandButtons\BTN_AMAIClawsOfAttack+3.blp ReplaceableTextures\CommandButtons\BTN_AMAIClawsOfAttack+3.blp
AddToMPQ Scripts\TFT\AMAI.mpq Icons\CommandButtons\BTN_AMAIClawsOfAttack+6.blp ReplaceableTextures\CommandButtons\BTN_AMAIClawsOfAttack+6.blp
AddToMPQ Scripts\TFT\AMAI.mpq Icons\CommandButtons\BTN_AMAIClawsOfAttack+9.blp ReplaceableTextures\CommandButtons\BTN_AMAIClawsOfAttack+9.blp
AddToMPQ Scripts\TFT\AMAI.mpq Icons\CommandButtons\BTN_AMAIClawsOfAttack+12.blp ReplaceableTextures\CommandButtons\BTN_AMAIClawsOfAttack+12.blp
AddToMPQ Scripts\TFT\AMAI.mpq Icons\CommandButtons\BTN_AMAIClawsOfAttack+15.blp ReplaceableTextures\CommandButtons\BTN_AMAIClawsOfAttack+15.blp
AddToMPQ Scripts\TFT\AMAI.mpq Icons\CommandButtons\BTN_AMAIRingGreen+1.blp ReplaceableTextures\CommandButtons\BTN_AMAIRingGreen+1.blp
AddToMPQ Scripts\TFT\AMAI.mpq Icons\CommandButtons\BTN_AMAIRingGreen+2.blp ReplaceableTextures\CommandButtons\BTN_AMAIRingGreen+2.blp
AddToMPQ Scripts\TFT\AMAI.mpq Icons\CommandButtons\BTN_AMAIRingGreen+3.blp ReplaceableTextures\CommandButtons\BTN_AMAIRingGreen+3.blp
AddToMPQ Scripts\TFT\AMAI.mpq Icons\CommandButtons\BTN_AMAIRingGreen+4.blp ReplaceableTextures\CommandButtons\BTN_AMAIRingGreen+4.blp
AddToMPQ Scripts\TFT\AMAI.mpq Icons\CommandButtons\BTN_AMAIRingGreen+5.blp ReplaceableTextures\CommandButtons\BTN_AMAIRingGreen+5.blp
AddToMPQ Scripts\TFT\AMAI.mpq Icons\CommandButtonsDisabled\DISBTN_AMAIClawsOfAttack+3.blp ReplaceableTextures\CommandButtonsDisabled\DISBTN_AMAIClawsOfAttack+3.blp
AddToMPQ Scripts\TFT\AMAI.mpq Icons\CommandButtonsDisabled\DISBTN_AMAIClawsOfAttack+6.blp ReplaceableTextures\CommandButtonsDisabled\DISBTN_AMAIClawsOfAttack+6.blp
AddToMPQ Scripts\TFT\AMAI.mpq Icons\CommandButtonsDisabled\DISBTN_AMAIClawsOfAttack+9.blp ReplaceableTextures\CommandButtonsDisabled\DISBTN_AMAIClawsOfAttack+9.blp
AddToMPQ Scripts\TFT\AMAI.mpq Icons\CommandButtonsDisabled\DISBTN_AMAIClawsOfAttack+12.blp ReplaceableTextures\CommandButtonsDisabled\DISBTN_AMAIClawsOfAttack+12.blp
AddToMPQ Scripts\TFT\AMAI.mpq Icons\CommandButtonsDisabled\DISBTN_AMAIClawsOfAttack+15.blp ReplaceableTextures\CommandButtonsDisabled\DISBTN_AMAIClawsOfAttack+15.blp
AddToMPQ Scripts\TFT\AMAI.mpq Icons\CommandButtonsDisabled\DISBTN_AMAIRingGreen+1.blp ReplaceableTextures\CommandButtonsDisabled\DISBTN_AMAIRingGreen+1.blp
AddToMPQ Scripts\TFT\AMAI.mpq Icons\CommandButtonsDisabled\DISBTN_AMAIRingGreen+2.blp ReplaceableTextures\CommandButtonsDisabled\DISBTN_AMAIRingGreen+2.blp
AddToMPQ Scripts\TFT\AMAI.mpq Icons\CommandButtonsDisabled\DISBTN_AMAIRingGreen+3.blp ReplaceableTextures\CommandButtonsDisabled\DISBTN_AMAIRingGreen+3.blp
AddToMPQ Scripts\TFT\AMAI.mpq Icons\CommandButtonsDisabled\DISBTN_AMAIRingGreen+4.blp ReplaceableTextures\CommandButtonsDisabled\DISBTN_AMAIRingGreen+4.blp
AddToMPQ Scripts\TFT\AMAI.mpq Icons\CommandButtonsDisabled\DISBTN_AMAIRingGreen+5.blp ReplaceableTextures\CommandButtonsDisabled\DISBTN_AMAIRingGreen+5.blp
AddToMPQ Scripts\TFT\AMAI.mpq Icons\war3map.imp war3map.imp
AddToMPQ Scripts\TFT\AMAI.mpq Icons\war3mapSkin.w3t war3mapSkin.w3t
ECHO \Scripts\TFT\AMAI.mpq created
ECHO _____________________________
ECHO Making AMAI finished
pause
