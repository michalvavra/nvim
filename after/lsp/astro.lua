-- ┌───────────┐
-- │ Astro LSP │
-- └───────────┘
--
-- `astro-ls` needs a TypeScript SDK (`typescript.tsdk`). Prefer the project's
-- 'node_modules/typescript', fall back to the global one installed with
-- `bun add -g typescript@~6` (TS 7 dropped 'tsserverlibrary.js', so pin to 6).
return {
  before_init = function(_, config)
    local tsdk = require('lspconfig.util').get_typescript_server_path(config.root_dir)
    if tsdk == '' then
      tsdk = vim.fn.expand('~/.bun/install/global/node_modules/typescript/lib')
    end
    config.init_options = config.init_options or {}
    config.init_options.typescript = config.init_options.typescript or {}
    config.init_options.typescript.tsdk = tsdk
  end,
}
