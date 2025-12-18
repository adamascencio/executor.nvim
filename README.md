# 🪓 Executor.nvim

Run the file you’re editing and see the output with the fewest possible keystrokes.

Executor.nvim is a minimal Neovim plugin that executes the current file (based on its filetype) and displays the results in a floating window. It’s perfect for quick scripting feedback loops without switching between your code and terminal windows.

## 🎯 Features

- Runs the current file with one keymap
- Automatically selects the run command based on filetype
- Shows `stdout`, `stderr`, and exit code in a floating window
- Easy to extend for new languages
- Clear floating window by pressing `q`

## 🚀 Installation

### Lazy.nvim

```lua
{
  "adamascencio/executor.nvim",
  config = function()
    vim.keymap.set("n", "<leader>x", require("executor").run, {
      desc = "Run current file",
    })
  end,
}
