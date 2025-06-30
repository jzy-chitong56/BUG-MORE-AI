@ECHO OFF
ECHO 编译 冰封王座 AMAI VS AMAI
mkdir Scripts\
ECHO =============================
ECHO 战网版
SET RESULTMAKEREF=0
mkdir Scripts\REFORGED\
mkdir Scripts\REFORGED\vsai\
mkdir REFORGED\tmp\
ECHO _____________________________
ECHO 创建公共库
perl ejass.pl common.eai REFORGED VER:REFORGED > Scripts\REFORGED\common.ai
pjass REFORGED\common.j Scripts\REFORGED\common.ai
if "%errorlevel%"=="1" SET RESULTMAKEREF=1
jassparser REFORGED\common.j Scripts\REFORGED\common.ai
if "%errorlevel%"=="1" SET RESULTMAKEREF=1
ECHO _____________________________
ECHO 创建暗夜脚本
perl ejass.pl races.eai REFORGED VER:REFORGED ELF RACE:ELF > Scripts\REFORGED\elf.ai
pjass REFORGED\common.j Scripts\REFORGED\common.ai Scripts\REFORGED\elf.ai
if "%errorlevel%"=="1" SET RESULTMAKEREF=1
jassparser REFORGED\common.j Scripts\REFORGED\common.ai Scripts\REFORGED\elf.ai
if "%errorlevel%"=="1" SET RESULTMAKEREF=1
ECHO _____________________________
ECHO 创建人族脚本
perl ejass.pl races.eai REFORGED VER:REFORGED HUMAN RACE:HUMAN > Scripts\REFORGED\human.ai
pjass REFORGED\common.j Scripts\REFORGED\common.ai Scripts\REFORGED\human.ai
if "%errorlevel%"=="1" SET RESULTMAKEREF=1
jassparser REFORGED\common.j Scripts\REFORGED\common.ai Scripts\REFORGED\human.ai
if "%errorlevel%"=="1" SET RESULTMAKEREF=1
ECHO _____________________________
ECHO 创建兽族脚本
perl ejass.pl races.eai REFORGED VER:REFORGED ORC RACE:ORC > Scripts\REFORGED\orc.ai
pjass REFORGED\common.j Scripts\REFORGED\common.ai Scripts\REFORGED\orc.ai
if "%errorlevel%"=="1" SET RESULTMAKEREF=1
jassparser REFORGED\common.j Scripts\REFORGED\common.ai Scripts\REFORGED\orc.ai
if "%errorlevel%"=="1" SET RESULTMAKEREF=1
ECHO _____________________________
ECHO 创建亡灵脚本
perl ejass.pl races.eai REFORGED VER:REFORGED UNDEAD RACE:UNDEAD > Scripts\REFORGED\undead.ai
pjass REFORGED\common.j Scripts\REFORGED\common.ai Scripts\REFORGED\undead.ai
if "%errorlevel%"=="1" SET RESULTMAKEREF=1
jassparser REFORGED\common.j Scripts\REFORGED\common.ai Scripts\REFORGED\undead.ai
if "%errorlevel%"=="1" SET RESULTMAKEREF=1
ECHO _____________________________
ECHO 创建控制台
perl SplitBlizzardJ.pl REFORGED
perl ejass.pl Blizzard3.eai REFORGED VER:REFORGED > REFORGED\tmp\Blizzard3Gen.j
perl ejass.pl Blizzard.eai REFORGED VER:REFORGED > Scripts\REFORGED\Blizzard.j
pjass REFORGED\common.j Scripts\REFORGED\Blizzard.j
if "%errorlevel%"=="1" SET RESULTMAKEREF=1
jassparser REFORGED\common.j Scripts\REFORGED\Blizzard.j
if "%errorlevel%"=="1" SET RESULTMAKEREF=1
ECHO _____________________________
ECHO 禁用调试代码
perl -i -pe"s#(debug call Trace)#//$1#g" Scripts\REFORGED\common.ai
perl -i -pe"s#(debug call Trace)#//$1#g" Scripts\REFORGED\Blizzard.j
perl -i -pe"s#(debug call Trace)#//$1#g" Scripts\REFORGED\elf.ai
perl -i -pe"s#(debug call Trace)#//$1#g" Scripts\REFORGED\human.ai
perl -i -pe"s#(debug call Trace)#//$1#g" Scripts\REFORGED\orc.ai
perl -i -pe"s#(debug call Trace)#//$1#g" Scripts\REFORGED\undead.ai
perl -i -pe"s#(call TracePlayer)#//$1#g" Scripts\REFORGED\common.ai
perl -i -pe"s#(call TracePlayer)#//$1#g" Scripts\REFORGED\Blizzard.j
perl -i -pe"s#(call TracePlayer)#//$1#g" Scripts\REFORGED\elf.ai
perl -i -pe"s#(call TracePlayer)#//$1#g" Scripts\REFORGED\human.ai
perl -i -pe"s#(call TracePlayer)#//$1#g" Scripts\REFORGED\orc.ai
perl -i -pe"s#(call TracePlayer)#//$1#g" Scripts\REFORGED\undead.ai
perl -i -pe"s#(call Trace)#//$1#g" Scripts\REFORGED\common.ai
perl -i -pe"s#(call Trace)#//$1#g" Scripts\REFORGED\Blizzard.j
perl -i -pe"s#(call Trace)#//$1#g" Scripts\REFORGED\elf.ai
perl -i -pe"s#(call Trace)#//$1#g" Scripts\REFORGED\human.ai
perl -i -pe"s#(call Trace)#//$1#g" Scripts\REFORGED\orc.ai
perl -i -pe"s#(call Trace)#//$1#g" Scripts\REFORGED\undead.ai
perl -i -pe"s#(call UpdateDebugTextTag)#//$1#g" Scripts\REFORGED\common.ai
perl -i -pe"s#(call UpdateDebugTextTag)#//$1#g" Scripts\REFORGED\Blizzard.j
perl -i -pe"s#(call UpdateDebugTextTag)#//$1#g" Scripts\REFORGED\elf.ai
perl -i -pe"s#(call UpdateDebugTextTag)#//$1#g" Scripts\REFORGED\human.ai
perl -i -pe"s#(call UpdateDebugTextTag)#//$1#g" Scripts\REFORGED\orc.ai
perl -i -pe"s#(call UpdateDebugTextTag)#//$1#g" Scripts\REFORGED\undead.ai
perl -i -pe"s#(call CreateDebug)#//$1#g" Scripts\REFORGED\common.ai
perl -i -pe"s#(call CreateDebug)#//$1#g" Scripts\REFORGED\Blizzard.j
perl -i -pe"s#(call CreateDebug)#//$1#g" Scripts\REFORGED\elf.ai
perl -i -pe"s#(call CreateDebug)#//$1#g" Scripts\REFORGED\human.ai
perl -i -pe"s#(call CreateDebug)#//$1#g" Scripts\REFORGED\orc.ai
perl -i -pe"s#(call CreateDebug)#//$1#g" Scripts\REFORGED\undead.ai
perl -i -pe"s#(call DisplayToAllJobDebug)#//$1#g" Scripts\REFORGED\common.ai
perl -i -pe"s#(call DisplayToAllJobDebug)#//$1#g" Scripts\REFORGED\Blizzard.j
perl -i -pe"s#(call DisplayToAllJobDebug)#//$1#g" Scripts\REFORGED\elf.ai
perl -i -pe"s#(call DisplayToAllJobDebug)#//$1#g" Scripts\REFORGED\human.ai
perl -i -pe"s#(call DisplayToAllJobDebug)#//$1#g" Scripts\REFORGED\orc.ai
perl -i -pe"s#(call DisplayToAllJobDebug)#//$1#g" Scripts\REFORGED\undead.ai
ECHO _____________________________
ECHO 优化代码
perl Optimize.pl REFORGED\common.j Scripts\REFORGED\common.ai -l REFORGED\Races.txt Scripts\REFORGED\$2
perl Optimize.pl -b Scripts\REFORGED\Blizzard.j
pjass REFORGED\common.j Scripts\REFORGED\common.ai
if "%errorlevel%"=="1" SET RESULTMAKEREF=1
pjass REFORGED\common.j Scripts\REFORGED\common.ai Scripts\REFORGED\elf.ai
if "%errorlevel%"=="1" SET RESULTMAKEREF=1
pjass REFORGED\common.j Scripts\REFORGED\common.ai Scripts\REFORGED\human.ai
if "%errorlevel%"=="1" SET RESULTMAKEREF=1
pjass REFORGED\common.j Scripts\REFORGED\common.ai Scripts\REFORGED\orc.ai
if "%errorlevel%"=="1" SET RESULTMAKEREF=1
pjass REFORGED\common.j Scripts\REFORGED\common.ai Scripts\REFORGED\undead.ai
if "%errorlevel%"=="1" SET RESULTMAKEREF=1
pjass REFORGED\common.j Scripts\REFORGED\Blizzard.j
if "%errorlevel%"=="1" SET RESULTMAKEREF=1
rmdir /s /q "Scripts/REFORGED/vsai"
ECHO =============================
ECHO 经典版
SET RESULTMAKETFT=0
mkdir Scripts\TFT\
mkdir Scripts\TFT\vsai\
mkdir TFT\tmp\
ECHO _____________________________
ECHO 创建公共库
perl ejass.pl common.eai TFT VER:TFT > Scripts\TFT\common.ai
pjass TFT\common.j Scripts\TFT\common.ai
if "%errorlevel%"=="1" SET RESULTMAKETFT=1
jassparser TFT\common.j Scripts\TFT\common.ai
if "%errorlevel%"=="1" SET RESULTMAKETFT=1
ECHO _____________________________
ECHO 创建暗夜脚本
perl ejass.pl races.eai TFT VER:TFT ELF RACE:ELF > Scripts\TFT\elf.ai
pjass TFT\common.j Scripts\TFT\common.ai Scripts\TFT\elf.ai
if "%errorlevel%"=="1" SET RESULTMAKETFT=1
jassparser TFT\common.j Scripts\TFT\common.ai Scripts\TFT\elf.ai
if "%errorlevel%"=="1" SET RESULTMAKETFT=1
ECHO _____________________________
ECHO 创建人族脚本
perl ejass.pl races.eai TFT VER:TFT HUMAN RACE:HUMAN > Scripts\TFT\human.ai
pjass TFT\common.j Scripts\TFT\common.ai Scripts\TFT\human.ai
if "%errorlevel%"=="1" SET RESULTMAKETFT=1
jassparser TFT\common.j Scripts\TFT\common.ai Scripts\TFT\human.ai
if "%errorlevel%"=="1" SET RESULTMAKETFT=1
ECHO _____________________________
ECHO 创建兽族脚本
perl ejass.pl races.eai TFT VER:TFT ORC RACE:ORC > Scripts\TFT\orc.ai
pjass TFT\common.j Scripts\TFT\common.ai Scripts\TFT\orc.ai
if "%errorlevel%"=="1" SET RESULTMAKETFT=1
jassparser TFT\common.j Scripts\TFT\common.ai Scripts\TFT\orc.ai
if "%errorlevel%"=="1" SET RESULTMAKETFT=1
ECHO _____________________________
ECHO 创建亡灵脚本
perl ejass.pl races.eai TFT VER:TFT UNDEAD RACE:UNDEAD > Scripts\TFT\undead.ai
pjass TFT\common.j Scripts\TFT\common.ai Scripts\TFT\undead.ai
if "%errorlevel%"=="1" SET RESULTMAKETFT=1
jassparser TFT\common.j Scripts\TFT\common.ai Scripts\TFT\undead.ai
if "%errorlevel%"=="1" SET RESULTMAKETFT=1
ECHO _____________________________
ECHO 创建控制台
perl SplitBlizzardJ.pl TFT
perl ejass.pl Blizzard3.eai TFT VER:TFT > TFT\tmp\Blizzard3Gen.j
perl ejass.pl Blizzard.eai TFT VER:TFT > Scripts\TFT\Blizzard.j
pjass TFT\common.j Scripts\TFT\Blizzard.j
if "%errorlevel%"=="1" SET RESULTMAKETFT=1
jassparser TFT\common.j Scripts\TFT\Blizzard.j
if "%errorlevel%"=="1" SET RESULTMAKETFT=1
ECHO _____________________________
ECHO 禁用调试代码
perl -i -pe"s#(debug call Trace)#//$1#g" Scripts\TFT\common.ai
perl -i -pe"s#(debug call Trace)#//$1#g" Scripts\TFT\Blizzard.j
perl -i -pe"s#(debug call Trace)#//$1#g" Scripts\TFT\elf.ai
perl -i -pe"s#(debug call Trace)#//$1#g" Scripts\TFT\human.ai
perl -i -pe"s#(debug call Trace)#//$1#g" Scripts\TFT\orc.ai
perl -i -pe"s#(debug call Trace)#//$1#g" Scripts\TFT\undead.ai
perl -i -pe"s#(call TracePlayer)#//$1#g" Scripts\TFT\common.ai
perl -i -pe"s#(call TracePlayer)#//$1#g" Scripts\TFT\Blizzard.j
perl -i -pe"s#(call TracePlayer)#//$1#g" Scripts\TFT\elf.ai
perl -i -pe"s#(call TracePlayer)#//$1#g" Scripts\TFT\human.ai
perl -i -pe"s#(call TracePlayer)#//$1#g" Scripts\TFT\orc.ai
perl -i -pe"s#(call TracePlayer)#//$1#g" Scripts\TFT\undead.ai
perl -i -pe"s#(call Trace)#//$1#g" Scripts\TFT\common.ai
perl -i -pe"s#(call Trace)#//$1#g" Scripts\TFT\Blizzard.j
perl -i -pe"s#(call Trace)#//$1#g" Scripts\TFT\elf.ai
perl -i -pe"s#(call Trace)#//$1#g" Scripts\TFT\human.ai
perl -i -pe"s#(call Trace)#//$1#g" Scripts\TFT\orc.ai
perl -i -pe"s#(call Trace)#//$1#g" Scripts\TFT\undead.ai
perl -i -pe"s#(call UpdateDebugTextTag)#//$1#g" Scripts\TFT\common.ai
perl -i -pe"s#(call UpdateDebugTextTag)#//$1#g" Scripts\TFT\Blizzard.j
perl -i -pe"s#(call UpdateDebugTextTag)#//$1#g" Scripts\TFT\elf.ai
perl -i -pe"s#(call UpdateDebugTextTag)#//$1#g" Scripts\TFT\human.ai
perl -i -pe"s#(call UpdateDebugTextTag)#//$1#g" Scripts\TFT\orc.ai
perl -i -pe"s#(call UpdateDebugTextTag)#//$1#g" Scripts\TFT\undead.ai
perl -i -pe"s#(call CreateDebug)#//$1#g" Scripts\TFT\common.ai
perl -i -pe"s#(call CreateDebug)#//$1#g" Scripts\TFT\Blizzard.j
perl -i -pe"s#(call CreateDebug)#//$1#g" Scripts\TFT\elf.ai
perl -i -pe"s#(call CreateDebug)#//$1#g" Scripts\TFT\human.ai
perl -i -pe"s#(call CreateDebug)#//$1#g" Scripts\TFT\orc.ai
perl -i -pe"s#(call CreateDebug)#//$1#g" Scripts\TFT\undead.ai
perl -i -pe"s#(call DisplayToAllJobDebug)#//$1#g" Scripts\TFT\common.ai
perl -i -pe"s#(call DisplayToAllJobDebug)#//$1#g" Scripts\TFT\Blizzard.j
perl -i -pe"s#(call DisplayToAllJobDebug)#//$1#g" Scripts\TFT\elf.ai
perl -i -pe"s#(call DisplayToAllJobDebug)#//$1#g" Scripts\TFT\human.ai
perl -i -pe"s#(call DisplayToAllJobDebug)#//$1#g" Scripts\TFT\orc.ai
perl -i -pe"s#(call DisplayToAllJobDebug)#//$1#g" Scripts\TFT\undead.ai
ECHO _____________________________
ECHO 优化代码
perl Optimize.pl TFT\common.j Scripts\TFT\common.ai -l TFT\Races.txt Scripts\TFT\$2
perl Optimize.pl -b Scripts\TFT\Blizzard.j
pjass TFT\common.j Scripts\TFT\common.ai
if "%errorlevel%"=="1" SET RESULTMAKETFT=1
pjass TFT\common.j Scripts\TFT\common.ai Scripts\TFT\elf.ai
if "%errorlevel%"=="1" SET RESULTMAKETFT=1
pjass TFT\common.j Scripts\TFT\common.ai Scripts\TFT\human.ai
if "%errorlevel%"=="1" SET RESULTMAKETFT=1
pjass TFT\common.j Scripts\TFT\common.ai Scripts\TFT\orc.ai
if "%errorlevel%"=="1" SET RESULTMAKETFT=1
pjass TFT\common.j Scripts\TFT\common.ai Scripts\TFT\undead.ai
if "%errorlevel%"=="1" SET RESULTMAKETFT=1
pjass TFT\common.j Scripts\TFT\Blizzard.j
if "%errorlevel%"=="1" SET RESULTMAKETFT=1
rmdir /s /q "Scripts/TFT/vsai"
ECHO =============================
ECHO 输出编译结果
ECHO _____________________________
if "%RESULTMAKEREF%"=="1" (
  rmdir /s /q "Scripts\REFORGED"
  ECHO 战网版编译失败
  echo 战网版不可用--请勿安装并等待新的在线编译附件 > Scripts\战网版脚本不可用.txt
) else (
  ECHO 战网版编译成功
  echo 战网版可用--请按教程安装（代码已优化并失去阅读性）...支持1.33+，平衡性为战网最新正式版-2.02+ > Scripts\战网版脚本可用.txt
)
ECHO _____________________________
if "%RESULTMAKETFT%"=="1" (
  rmdir /s /q "Scripts\TFT"
  ECHO 经典版编译失败
  echo 经典版不可用--请勿安装并等待新的在线编译附件 > Scripts\经典版脚本不可用.txt
) else (
  ECHO 经典版编译成功
  echo 经典版可用--请按教程安装（代码已优化并失去阅读性）...支持冰封王座1.24e+，平衡性为1.24e > Scripts\经典版脚本可用.txt
)
if "%RESULTMAKEREF%"=="1" (
  exit /b %RESULTMAKEREF%
)
if "%RESULTMAKETFT%"=="1" (
  exit /b %RESULTMAKETFT%
)
