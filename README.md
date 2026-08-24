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

LazyVim configures `tsgo` as the sole TypeScript server. Effect projects supply
the patched project-local TypeScript 7 `tsc` binary; Mason intentionally does
not install or own a second TypeScript server.

Set up each Effect project with TypeScript 7 and Effect's tsgo implementation:

```sh
npx @effect/tsgo setup
```

This patches the project's `node_modules/.bin/tsc`; the editor discovers that
binary from the project root and starts its LSP mode. Keep the Effect source
checkout in the project's `.reference/` directory as you already do.

JavaScript-family formatting is project-driven. The first configured tool wins:
`oxfmt`, then Biome, then Prettier. A tool is skipped unless its project config
exists, so globally installed formatters do not fight each other.

Oxlint is also the preferred JavaScript-family linter. When an Oxlint config is
present, the Biome and ESLint language servers stay detached; without one,
their own project configs can opt them in as fallbacks.

Python uses `ty` for type checking and Ruff for linting and formatting.

Inside Neovim:

- `:Lazy` updates plugins and manages the lockfile.
- `:LazyExtras` shows optional maintained feature bundles.
- `:Mason` shows external language tools.
- `:LspInfo` confirms that exactly one `tsgo` is attached to a TypeScript buffer.
- `<leader>ca` opens TypeScript and Effect refactors/code actions.

Commit `lazy-lock.json` so another machine starts with the same known-good
plugin versions. Run `:Lazy update` when you intentionally want upgrades.
