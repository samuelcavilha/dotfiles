return {
  {
    "saghen/blink.cmp",
    dependencies = "rafamadriz/friendly-snippets",

    version = "1.*",
    opts = {
      sources = {
        default = { "lsp", "path", "snippets", "buffer" },
        per_filetype = {
          sql = { "snippets", "dadbod", "buffer" },
        },
        -- add vim-dadbod-completion to your completion providers
        providers = {
          dadbod = { name = "Dadbod", module = "vim_dadbod_completion.blink" },
        },
      },
      keymap = {
        preset = "default",
        ["<CR>"] = { "accept", "fallback" },
        ["<C><leader>"] = { "show" },
      },
      appearance = {
        nerd_font_variant = "mono",
      },

      completion = { documentation = { auto_show = true } },

      fuzzy = { implementation = "prefer_rust_with_warning" },
    },
  },
}
