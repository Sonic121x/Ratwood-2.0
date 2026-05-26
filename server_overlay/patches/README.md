Store mod prelude patch files here for `auto_update.py`.

- Supported files: `*.patch`
- Apply order: lexical sort of relative paths under `server_overlay/patches/`
- Apply timing: after repo `patches/` are applied, before `server_overlay/mods/` is copied

Recommended layout:

```text
server_overlay/patches/
  001-mod-prelude.patch
  010-admin-hooks.patch
```

Use small, focused patch files so upstream updates are easier to maintain.
