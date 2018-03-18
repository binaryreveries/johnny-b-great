Johnny B. Great! for The Specialists 2.1
========================================

This is a fun little mod created in celebration of FadedParadigm's upcoming
wedding.

When the "Jonny B. Great!" gamemode is activated (`say /jbg`), the player named
"FadedParadigm" is given 1000 health, their model is set to Gordon, and all
their weapons are stripped. All other players are now considered "Agents" and
have their models set accordingly. Once either FadedParadigm is defeated, or
100 agents the game is over. A new match will then begin automatically.

When FadedParadigm is damaged, a message is broadcasted to the HUD of all
players indicating remaining health.

[![Build Status](https://travis-ci.org/binaryreveries/johnny-b-great.svg?branch=master)](https://travis-ci.org/binaryreveries/johnny-b-great)


Requirements
------------

- AMX Mod X
- The Specialists 2.1
- Half-Life


Dev Requirements
----------------

- AMX Mod X Plugin Compiler

You can download the default version of the toolchain by issuing:

```bash
make amxmodx
```

To remove, issue:

```bash
make clean-amxmodx
```

By default, the plugin targets AMX Mod X version 1.8.2.

If you wish to target a different version, simply set `AMX_MOD_X_VERSION`:

```bash
AMX_MOD_X_VERSION=1.8.1 make
```

*NOTE:* macOS support was not available prior to version 1.8.2.


Compiling
---------

To create: `build/amxmodx-1.8.2/compiled/johnnybgood.amxx`, issue:

```bash
make
```

To remove, issue:

```bash
make clean
```

*NOTE:* You will need to specify `$AMX_MOD_X_VERSION` if it was present when
`make` was issued.
