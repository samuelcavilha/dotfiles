require("config.set")
require("config.remap")
require("config.lazy")
require("config.harpoon")

vim.cmd([[
  highlight LineNr guifg=#C0CAF5
  highlight LineNrBelow guifg=#AAAAAA
  highlight LineNrAbove guifg=#AAAAAA
  highlight CursorLineNr guifg=#FFFFFF gui=bold
]])
