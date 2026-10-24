--          ╔═════════════════════════════════════════════════════════╗
--          ║                 TypeScript native LSP                   ║
--          ╚═════════════════════════════════════════════════════════╝
-- 'tsc' replaces the deprecated 'tsgo' config in nvim-lspconfig. It needs a
-- TypeScript 7+ binary with `--lsp`: project `node_modules/.bin/tsc` first,
-- then global `tsc` (`mise use -g npm:typescript@latest`). `cmd` and `root_dir`
-- (incl. Deno exclusion) come from nvim-lspconfig; only settings are set here.
return {
  settings = {
    typescript = {
      locale = 'en-US',
    },
  },
}
