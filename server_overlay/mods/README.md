# Mods

`mods/` is a lightweight extension entrypoint for this fork.

- Put new DM files anywhere under `mods/`.
- Run `build.cmd` before compiling or after adding/removing mod files.
- The build script regenerates `mods/_autogen.dm`, which is the only file included from `roguetown.dme`.
- Use this folder for new content instead of editing long include lists in `roguetown.dme`.

The bundled admin spell mod lives in `mods/spells/admin/admin_spells.dm`.
