@echo off
powershell -c (New-Object Media.SoundPlayer "'%DOTFILES_ROOT%\windows\scripts\chirp.wav'").PlaySync(); (New-Object Media.SoundPlayer "'%DOTFILES_ROOT%\windows\scripts\chirp.wav'").PlaySync();
