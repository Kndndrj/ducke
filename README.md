# DUCKE - le epic game

*Ducke* is a game where you are THE duck. The game is written in lua and is running inside your \*NIX terminal.

```
 ____             _
|  _ \ _   _  ___| | _____
| | | | | | |/ __| |/ / _ \
| |_| | |_| | (__|   <  __/
|____/ \__,_|\___|_|\_\___|
```
This game is designed in a way that every game element is defined by the map. If you change the map, you change the game behaviour.

## Installation
1. Install `luajit` - check if you have it already installed, some packaged pull it as a dependency.

That's it, you are ready to play! Now pull out your terminal, `cd` into this repository and run:
```bash
$ ./ducke.sh
```
If it doesn't work the first time, check if the file has the appropriate permissions ( and then `chmod`...).

## Contributing
You can make your own custom levels for *Ducke*. All you need to do is follow the template in `levels.lua`, create your level in format of array of strings and add the level name to the `ListOfLevels = {Level_1, Level_2, [your_level]}`.

There are only a couple of rules to follow:
1. Map size must be 100x30 characters (it will work with different sizes, but let's be consistent)
2. There are 4 special characters:
  * ":" - Block character (can't pass through)
  * "\*" - Death character (kills you on touch)
  * "~" - Water character (you aren't affected by gravity when you are touching it)
  * "w" - Win character (go to the next level, if the level is the last level, you win the game)
  * objective characters:
    * "f" - First objective.
    * "s" - Second objective.
    * "t" - Third objective.
The player must pick up the objectives from first to last. When all objectives are picked up, the player can proceed to the next level.

If you happen to create a new map, I will be happy to see your pull request!

## Sources
Huge thanks to [ASCII Art archive](https://www.asciiart.eu) for the inspiration and to [ASCII generator](https://ascii-generator.site) for banner creation.
