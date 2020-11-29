@echo off
powershell -c (New-Object Media.SoundPlayer "'%DOTFILES_ROOT%\windows\scripts\squawk.wav'").PlaySync();
