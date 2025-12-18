return {
  {
    "saghen/blink.compat",
    -- use the latest release, via version = '*', if you also use the latest release for blink.cmp
    version = "2.*",
    -- lazy.nvim will automatically load the plugin when it's required by blink.cmp
    lazy = true,
    -- make sure to set opts so that lazy.nvim calls blink.compat's setup
    opts = {},
  },
  {
    "saghen/blink.cmp",
    dependencies = {
      "rafamadriz/friendly-snippets",
      {
        "L3MON4D3/LuaSnip",
        version = "v2.*",
        name = "luasnip",
        config = function()
          require("luasnip.loaders.from_vscode").lazy_load()
        end,
      },
    },
    version = "1.*",
    opts = {
      snippets = { preset = "luasnip" },
      sources = {
        default = { "lsp", "path", "snippets", "buffer" },
        per_filetype = {
          sql = { "snippets", "dadbod", "buffer" },
          php = { "lsp", "path", "snippets", "buffer", "laravel" },
          lua = { inherit_defaults = true, "lazydev" },
        },
        providers = {
          dadbod = { name = "Dadbod", module = "vim_dadbod_completion.blink" },
          laravel = { name = "laravel", module = "blink.compat.source", score_offset = 95 },
          lazydev = {
            name = "lazydev",
            module = "lazydev.integrations.blink",
            -- make lazydev completions top priority (see `:h blink.cmp`)
            score_offset = 100,
          },
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
    opts_extended = { "sources.default" },
  },
}
