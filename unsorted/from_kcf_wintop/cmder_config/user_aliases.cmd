;= @echo off
;= rem Call DOSKEY and use this file as the macrofile
;= %SystemRoot%\system32\doskey /listsize=1000 /macrofile=%0%
;= rem In batch mode, jump to the end of the file
;= goto:eof
;= Add aliases below here
e.=explorer .
ls=ls --show-control-chars -F --color $*
ll=ls -al $*
l1=ls -1 $*
rf=rm -rf $*
cpr=cp -r $*
pwd=cd
clear=cls
c=cls
e=explorer $*
open=explorer $*
history=cat -n "%CMDER_ROOT%\config\.history"
unalias=alias /d $1
vi=vim $*
cmderr=cd /d "%CMDER_ROOT%"
cdr=cd C:\Users\dpirrone-brusse\root
cdk=cd C:\KCFTech
cdh=cd C:\Users\dpirrone-brusse

pp=jq -R -r -f C:\Users\dpirrone-brusse\root\scripts\prom_pp.jq

;= rem squawk=powershell -c (New-Object Media.SoundPlayer "'C:\Users\dpirrone-brusse\root\audio\failure.wav'").PlaySync()
;= rem chirp=powershell -c (New-Object Media.SoundPlayer "C:\Users\dpirrone-brusse\root\audio\success.wav").PlaySync(); (New-Object Media.SoundPlayer "C:\Users\dpirrone-brusse\root\audio\success.wav").PlaySync();
;= rem Failure powershell -c (New-Object Media.SoundPlayer "'C:\Windows\Media\Windows Battery Critical.wav'").PlaySync();
;= rem Success powershell -c (New-Object Media.SoundPlayer "C:\Windows\Media\Alarm02.wav").PlaySync();
;= rem volume is too low to hear... need a solution there.
