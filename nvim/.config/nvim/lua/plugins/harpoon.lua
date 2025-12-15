return {
  {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    opts = {
      menu = {
        width = vim.api.nvim_win_get_width(0) - 4,
      },
      settings = {
        save_on_toggle = true,
      },
    },
    keys = function()
      local harpoon = require("harpoon")
      local keys = {
        -- Adicionar arquivo à lista (Append) -> <leader>a
        {
          "<leader>a",
          function()
            harpoon:list():add()
          end,
          desc = "Harpoon Add File",
        },
        -- Alternar menu rápido (Toggle Menu) -> C-p
        {
          "<C-e>",
          function()
            harpoon.ui:toggle_quick_menu(harpoon:list())
          end,
          desc = "Harpoon Quick Menu",
        },
      }

      -- Configuração para navegação dos arquivos 1 até 4
      -- Mapeia: 1->j, 2->k, 3->l, 4->ç (todos com Control)
      local nav_keys = { "<C-j>", "<C-k>", "<C-l>", "<C-h>" }

      for i, key in ipairs(nav_keys) do
        table.insert(keys, {
          key,
          function()
            harpoon:list():select(i)
          end,
          desc = "Harpoon to File " .. i,
        })
      end

      return keys
    end,
  },
}
