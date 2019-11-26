;= @echo off
;= rem Call DOSKEY and use this file as the macrofile
;= %SystemRoot%\system32\doskey /listsize=1000 /macrofile=%0%
;= rem In batch mode, jump to the end of the file
;= goto:eof
;= Add aliases below here
e.=explorer .
ls=ls --show-control-chars -F --color $*
ll=ls -al $*
rf=rm -rf $*
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

;= rem Failure powershell -c (New-Object Media.SoundPlayer "'C:\Windows\Media\Windows Battery Critical.wav'").PlaySync();
;= rem Success powershell -c (New-Object Media.SoundPlayer "C:\Windows\Media\Alarm02.wav").PlaySync();
;= rem volume is too low to hear... need a solution there.
