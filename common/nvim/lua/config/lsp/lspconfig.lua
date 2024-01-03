local M = {}
local lspconfig = require("lspconfig")
local builtin = require("telescope.builtin")
local fidget = require("fidget")

-- nvim-cmp supports additional completion capabilities, so broadcast that to servers
local capabilities = vim.tbl_deep_extend(
  "force",
  vim.lsp.protocol.make_client_capabilities(),
  require("cmp_nvim_lsp").default_capabilities()
)

local on_attach = function(client, bufnr)
  local nmap = function(keys, func, desc)
    vim.keymap.set("n", keys, func, { buffer = bufnr, desc = desc })
  end
  vim.bo[bufnr].omnifunc = "v:lua.vim.lsp.omnifunc"

  nmap("gi", vim.lsp.buf.implementation, "Implementation")
  nmap("gd", vim.lsp.buf.definition, "Definition")
  nmap("gr", builtin.lsp_references, "References")
  nmap("gt", vim.lsp.buf.type_definition, "Type definition")
  nmap("gD", vim.lsp.buf.declaration, "Declaration")

  nmap("K", vim.lsp.buf.hover, "Hover Documentation")
  nmap("[d", vim.diagnostic.goto_prev, "Diagnostics: Go to Previous")
  nmap("]d", vim.diagnostic.goto_next, "Diagnostics: Go to Next")

  nmap("<leader>sx", vim.lsp.buf.signature_help, "Signature Documentation")
  nmap("<leader>st", builtin.treesitter, "Treesitter")
  nmap("<leader>ss", builtin.lsp_document_symbols, "Document symbols")
  nmap("<leader>cr", vim.lsp.buf.rename, "Rename")
  nmap("<leader>ca", vim.lsp.buf.code_action, "Code Action")

  if client.name == "ruff-lsp" then
    client.server_capabilities.hoverProvider = false
  end
end

function M.setup_servers(json_config)
  local f = io.open(json_config, "r")
  if not f then
    return
  end
  local lsp_servers = vim.json.decode(f:read("all*"))
  f:close()
  if lsp_servers == nil then
    return
  end
  local runtime_path = vim.split(package.path, ";")
  table.insert(runtime_path, "lua/?.lua")
  table.insert(runtime_path, "lua/?/init.lua")
  for server, config in pairs(lsp_servers) do
    if server == "lua_ls" then
      config.settings.Lua.workspace.library = vim.api.nvim_get_runtime_file("", true)
      config.settings.Lua.runtime.path = runtime_path
    end
    if server == "denols" then
      config.root_dir = lspconfig.util.root_pattern("deno.json", "deno.jsonc")
    end
    if server == "tsserver" then
      config.root_dir = lspconfig.util.root_pattern("package.json")
      config.single_file_support = false
    end

    config.capabilities = capabilities
    config.on_attach = on_attach
    fidget.setup({
      -- Options related to LSP progress subsystem
      progress = {
        suppress_on_insert = true, -- Suppress new messages while in insert mode
      },
    })
    lspconfig[server].setup(config)
  end
end

return M
