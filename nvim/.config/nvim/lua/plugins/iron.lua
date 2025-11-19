return
{
  "hkupty/iron.nvim",
  config = function()
    local iron = require("iron.core")
    local view = require("iron.view")

    iron.setup({
      config = {
        -- Whether a repl should be discarded or not
        scratch_repl = true,
        -- Your repl definitions come here
        repl_definition = {
          sh = {
            -- Can be a table or a function that
            -- returns a table (see below)
            command = { "zsh" },
          },
          python = {
            --command = { "python3" }, -- or { "ipython", "--no-autoindent" }
            command = { "ipython", "--no-autoindent" }, -- or { "ipython", "--no-autoindent" }
            block_dividers = { "# %%", "#%%" },
            env = { PYTHON_BASIC_REPL = "1" }           --this is needed for python3.13 and up.
          }
        },
        -- How the repl window will be displayed
        -- See below for more information
        --repl_open_cmd = require("iron.view").right(60),
        repl_open_cmd = "vertical split"
      },
      -- Iron doesn't set keymaps by default anymore.
      -- You can set them here or manually add keymaps to the functions in iron.core
      keymaps = {
        send_motion = "<space>sc",
        visual_send = "<space>sv",
        send_file = "<space>sf",
        send_line = "<space>sl",
        send_paragraph = "<space>sp",
        send_until_cursor = "<space>su",
        send_code_block = "<space>sb",
        send_code_block_and_move = "<space>sn",
        send_mark = "<space>sm",
        mark_motion = "<space>mc",
        mark_visual = "<space>mc",
        remove_mark = "<space>md",
        cr = "<space>s<cr>",
        interrupt = "<space>s<space>",
        exit = "<space>sq",
        clear = "<space>cl",
      },
      -- If the highlight is on, you can change how it looks
      -- For the available options, check nvim_set_hl
      highlight = {
        italic = true,
      },
      ignore_blank_lines = true, -- ignore blank lines when sending visual select lines
    })

    -- iron also has a list of commands, see :h iron-commands for all available commands
    vim.keymap.set("n", "<space>is", "<cmd>IronRepl<cr>")
    vim.keymap.set("n", "<space>ir", "<cmd>IronRestart<cr>")
    vim.keymap.set("n", "<space>if", "<cmd>IronFocus<cr>")
    vim.keymap.set("n", "<space>ih", "<cmd>IronHide<cr>")
  end,
}
