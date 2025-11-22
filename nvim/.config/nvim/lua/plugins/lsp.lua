return {
  {
    "williamboman/mason.nvim",
    dependencies = {
      "williamboman/mason-lspconfig.nvim",
      "neovim/nvim-lspconfig",
    },
    opts = {
      servers = {
        lua_ls = {},
        ts_ls = {},
        eslint = {},
        tailwindcss = {},
        phpactor = {},
        gopls = {},
      },
    },
    config = function(_, opts)
      require("mason").setup()

      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("my.lsp", {}),
        callback = function(args)
          local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
          if not client then
            return
          end

          if
              not client:supports_method("textDocument/willSaveWaitUntil")
              and client:supports_method("textDocument/formatting")
          then
            vim.api.nvim_create_autocmd("BufWritePre", {
              group = vim.api.nvim_create_augroup("my.lsp", { clear = false }),
              buffer = args.buf,
              callback = function()
                vim.lsp.buf.format({ bufnr = args.buf, id = client.id, timeout_ms = 1000 })
              end,
            })
          end
        end,
      })
      require("mason-lspconfig").setup({
        ensure_installed = { "lua_ls", "eslint", "ts_ls", "gopls" },
      })

      for server, config in pairs(opts.servers) do
        vim.lsp.config(server, config)
        vim.lsp.enable(server)
      end
    end,
  },
}
