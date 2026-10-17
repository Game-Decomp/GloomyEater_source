# Gloomy Eater

Recovered source for **Gloomy Eater**, a Godot game originally distributed as a single
Windows executable. This repository contains the decompiled GDScript source, scenes, and
project configuration — assets are intentionally excluded (see
[What's in the repo](#whats-in-the-repo)).

| | |
|---|---|
| Engine | Godot **3.4.4** (stable) |
| Original build | `Gloomy Eater-64.exe` (45.4 MB, PCK embedded) |
| Main scene | `res://Scenes/Title.tscn` |
| Display | 800 px wide, GLES3, 2D stretch `keep`, gravity 980 |
| Physics layers | 1 = `walls`, 2 = `meat`, 3 = `rumia` |
| Autoloads | `Globals` (`Globals.gd`), `SoundManager` (`SoundManager.tscn`) |
| Files in original PCK | 189 |

## How this was recovered

Unlike most exported Godot games, this one shipped **without script encryption** — the PCK
contained plain compiled `.gdc` files. GDRE Tools v2.6.4 recovered and decompiled all
**13 scripts** and 189 files on the first pass, no key required.

The scripts in this repo are decompiled GDScript text; the game logic, signals, exported
properties, and constants were all recovered faithfully (for example `HungerBar.gd` keeps
its `setget` setter, `win`/`lose` signals, and color interpolation math).

## What's in the repo

Tracked (48 files, ~132 KB):

```
Scenes/          gameplay scenes and scripts
Ending/          BadEnd, GoodEnd
Sound/           audio resources
project.godot    project settings
.gitignore
```

Ignored, because they are binary, generated, or auto-derived:

| Ignored | Why |
|---|---|
| `.import/` | compiled asset cache (`.stex`, `.oggstr`, `.sample`) — 8.6 MB, regenerated on first open |
| `*.png` `*.ogg` `*.wav` `*.ttf` `*.ico` `*.svg` | raw art and audio (~9 MB) |
| `.autoconverted/` | editor-generated binary `.tscn.converted.res`, regenerated from the text scenes |
| `Sound/Sizzle_Sound_lopp.tres` | 7.4 MB `AudioStreamSample` resource with the audio embedded — an asset wearing a `.tres` extension |
| `*.gde` `*.gdc` `*.remap` | original recovered bytecode and remaps, not source |
| `export_presets.cfg` | contains the Android keystore password |
| `*.exe` `*.apk` `*.pck` | build output |

**This repository is code-only.** Cloning it gives you the scripts and scenes but not the
art or audio, so the project will report missing resources until you supply them. If you
want the sizzle-loop sound, delete the single `Sound/Sizzle_Sound_lopp.tres` line from
`.gitignore` and add the file.

## Opening the project

1. Install Godot **3.4.4** (standard build, not .NET/Mono):
   <https://github.com/godotengine/godot/releases/download/3.4.4-stable/Godot_v3.4.4-stable_win64.exe.zip>
2. Open the Godot Project Manager → **Import** → select `project.godot` in this folder.
3. On first open the editor re-imports assets; missing files are reported as errors, which
   is expected for this repo.
4. Run with the ▶ button, or `F5`.

Use the exact 3.4.4 editor. Export templates only load when their version matches the
editor, and opening the project in a different 3.x version rewrites `project.godot`.

## Building

Export templates must match the editor version
(`Godot_v3.4.4-stable_export_templates.tpz` → `editor_data/templates/3.4.4.stable/`).
Export presets are gitignored because the Android preset holds a keystore password — create
your own in **Project → Export** and supply your own keystore before shipping.

Builds produced during recovery (not committed):

| Artifact | Size |
|---|---|
| `GloomyEater64.exe` — Windows x64, icon + version info, embedded PCK | 45.44 MB |
| `GloomyEater64.apk` — Android arm64-v8a, signed, 189 asset files | 20.51 MB |

Notes for rebuilding:

- **Icon:** patch it into the export *template* before exporting. Running `rcedit` during
  export instead rewrites the executable after the PCK is appended and strips the overlay
  footer, producing a file whose embedded pack can no longer be found.
- **Android:** this project renders with GLES3, so `rendering/vram_compression/import_etc2`
  must be `true` in `project.godot` or the editor refuses to export for Android.
- **APK layout:** Godot 3 ships the project as loose files under `assets/` inside the APK;
  `assets/_cl_` is only a 44-byte stub. This is normal, not a packaging error.
- **Signing:** the recovery build used the local debug keystore
  (`~/.android/debug.keystore`, alias `androiddebugkey`, password `android`) and JDK 11+
  for `apksigner`. Fine for sideloading, not for store publishing.
- A `GloomyEater64_debug.exe` console build was also produced to capture runtime output; it
  ran clean (no script errors) and can be deleted.

## Project layout

```
Scenes/            BaseProtoype, Cloud, Heater, HungerBar, Meat,
                   Rumia, ThrowSign, Title            (.tscn)
Ending/            BadEnd, GoodEnd
Sound/             sizzle loop and other audio resources
title/             title screen artwork and fonts
FeedRumiaConcept/  reference/concept artwork
(root)             CookText, Cover, Credits, GrabText, Table, Transition,
                   Globals, SoundManager
```

All 13 recovered scripts: `Globals.gd`, `SoundManager.gd`, and in `Scenes/` — `Food.gd`,
`GoodEndSequence.gd`, `Heater.gd`, `HungerBar.gd`, `Meat.gd`, `MultiSprite.gd`,
`NoEatZone.gd`, `PredictMeatArea.gd`, `Rumia.gd`, `SoundAPI.gd`, `World.gd`.

Script highlights: `World.gd` is the main gameplay loop, `HungerBar.gd` implements the
win/lose hunger meter with a `setget` setter, `Rumia.gd` drives the character,
`PredictMeatArea.gd` and `NoEatZone.gd` handle the feeding interaction, and
`SoundManager.gd` is the audio autoload.

## Tools used

- GDRE Tools v2.6.4 — PCK extraction and script decompilation
- Godot 3.4.4 — export templates, project import, packaging
- rcedit 2.0.0 — Windows icon and version resource patching
- Android SDK build-tools 36 (`apksigner`, `aapt2`) — APK signing and inspection