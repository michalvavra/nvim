--          ╔═════════════════════════════════════════════════════════╗
--          ║                     Json LSP                            ║
--          ╚═════════════════════════════════════════════════════════╝
return {
  -- npm i -g vscode-json-languageserver
  cmd = { 'vscode-json-languageserver', '--stdio' },
  filetypes = { 'json', 'jsonc' },
  init_options = { provideFormatter = true },
  root_markers = { '.git' },
}
