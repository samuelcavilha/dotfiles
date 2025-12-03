return {
  {
    "saghen/blink.cmp",
    dependencies = "rafamadriz/friendly-snippets",

<<<<<<< HEAD
  version = '1.*',
  opts = {
    sources = {
      default = { "lsp", "path", "snippets", "buffer" },
      per_filetype = {
        sql = { 'snippets', 'dadbod', 'buffer' },
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
      nerd_font_variant = 'mono'
    },

    completion = { documentation = { auto_show = true } },

    fuzzy = { implementation = "prefer_rust_with_warning" }
=======
    version = "v0.*",

    opts = {
      keymap = {
        preset = "default",
        ["<CR>"] = { "accept", "fallback" },
        ["<C><leader>"] = { "show" },
      },
      appearance = {
        use_nvim_cmp_as_default = true,
        nerd_font_variant = "mono",
      },

      signature = { enabled = true },
    },
>>>>>>> 51f043d (changed some omarchy configs with the new update. Tomux: projects/go)
  },
}
