# Neovim

Personal [LazyVim](https://www.lazyvim.org/) configuration, migrated from
Kickstart.nvim.

```text
init.lua
  -> lazy.nvim (plugin manager and lockfile)
    -> LazyVim (maintained editor defaults)
      -> Extras (TypeScript, ESLint, Prettier, DAP, other languages)
        -> lua/config/* (personal behavior)
        -> lua/plugins/* (small overrides)
```

## TypeScript and Effect

LazyVim installs and configures `vtsls`. It uses each project's workspace
TypeScript SDK so TypeScript language-service plugins can load correctly.

For an Effect project using TypeScript 5.x or 6.x:

```sh
pnpm add -D typescript @effect/language-service
pnpm exec effect-language-service setup
```

The resulting `tsconfig.json` should include the plugin last:

```json
{
  "$schema": "./node_modules/@effect/language-service/schema.json",
  "compilerOptions": {
    "plugins": [{ "name": "@effect/language-service" }]
  }
}
```

For TypeScript 7+, use the separate `@effect/tsgo` setup. It must replace the
ordinary `tsgo` process as the sole TypeScript server; do not merely enable
LazyVim's stock `tsgo` Extra alongside it.

Inside Neovim:

- `:Lazy` updates plugins and manages the lockfile.
- `:LazyExtras` shows optional maintained feature bundles.
- `:Mason` shows external language tools.
- `:LspInfo` confirms that `vtsls` is attached to a TypeScript buffer.
- `<leader>cV` selects the workspace TypeScript version.
- `<leader>ca` opens TypeScript and Effect refactors/code actions.

Commit `lazy-lock.json` so another machine starts with the same known-good
plugin versions. Run `:Lazy update` when you intentionally want upgrades.
