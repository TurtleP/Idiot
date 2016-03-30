# Idiot
A remake of [Idiot: Puzzles](http://forum.stabyourself.net/viewtopic.php?f=11&t=3311) for Nintendo 3DS and PC

<p align="center">
  <img src="http://i.imgur.com/jN4E68E.png"/>
</p>

# How do I run this on {platform}?

#### Windows/Mac OS/Linux
  Simply download the 'master' branch from this repository and unzip it anywhere.
From there, go into the folder and compress the files into a zip format. 'main.lua' should be on the root of the
newly created zip archive. Rename the extension from .zip to .love. Once this love file has been created, please
download [LÖVE](https://www.love2d.org/) for your respective operating system.

#### Nintendo 3DS Systems
  I have been giving the [releases](https://github.com/TurtleP/Idiot/releases) page the latest LÖVE Potion files, but in 
the event that I don't have it supplied, please download it from [here](https://github.com/VideahGams/LovePotion/releases).
The current release at the time of writing this readme supports v1.0.8. Place the unpacked source files inside of the SD card
at /3DS/Idiot/game/. If this path doesn't exist you should create it. The folder structure should then be:

| SDMC:/3DS/Idiot/ |
--------------------
| game/{source}    |
| LovePotion.3dsx  |
| LovePotion.smdh  |
