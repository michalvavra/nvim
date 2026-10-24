-- ┌──────────────────────┐
-- │ Ruff (Python linter) │
-- └──────────────────────┘
--
-- Ruff runs alongside 'ty' (type checker). Let 'ty' own hover to avoid
-- duplicate hover windows. Install: `uv tool install ruff`.
return {
  on_attach = function(client) client.server_capabilities.hoverProvider = false end,
}
