# nvim

Personal Neovim config built on [MiniMax][minimax].

## Layout

- `init.lua`: plugin manager (`vim.pack`) and loading helpers.
- `plugin/10_options.lua`: built-in Neovim options.
- `plugin/20_keymaps.lua`: custom mappings.
- `plugin/30_mini.lua`: [mini.nvim][mini] modules and the color scheme.
- `plugin/40_plugins.lua`: plugins outside of mini.nvim (tree-sitter, LSP, formatting, etc.).
- `plugin/50_keylog.lua`: keystroke log for reviewing Vim habits.
- `after/`: filetype settings, language server configs and snippets that override plugins.
- `snippets/`: user snippets.
- `nvim-pack-lock.json`: pinned plugin revisions.

## Setup

Requires Neovim 0.12+ (uses the built-in `vim.pack` plugin manager).

```bash
git clone https://github.com/michalvavra/nvim.git ~/.config/nvim
nvim
```

Plugins install on first start. Update them with `:lua vim.pack.update()`.

## Notes

- **Theme**: [github-nvim-theme][github-theme] to match Rex's Merino theme (`github_dark_default`/`github_light`). Follows the terminal's light/dark appearance. Background is transparent to blend with Rex's translucent panes.
- **Habits**: [hardtime.nvim][hardtime] shows hints for better motions; `<Leader>oh` shows a report.
- **Keylog**: daily logs in `stdpath('state')/keylog/` (Insert mode text is not recorded). `<Leader>ok` opens today's log, `:KeylogToggle` pauses it.
- **Practice**: [vim-be-good][vim-be-good], run `:VimBeGood` in an empty buffer.

## Credits

- [nvim-mini/MiniMax][minimax]
- [nvim-mini/mini.nvim][mini]

[minimax]: https://github.com/nvim-mini/MiniMax
[mini]: https://github.com/nvim-mini/mini.nvim
[github-theme]: https://github.com/projekt0n/github-nvim-theme
[hardtime]: https://github.com/m4xshen/hardtime.nvim
[vim-be-good]: https://github.com/ThePrimeagen/vim-be-good
