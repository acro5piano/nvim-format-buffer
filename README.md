# nvim-format-buffer

A simple Neovim plugin to format current buffer using an external command

Thank you https://github.com/ckipp01/stylua-nvim

# Motivation

There are tons of Vim/Neovim plugins which formats code using external commands, e.g.) Yapf.vim, Stylua.vim, and Pretteier.vim. Some of these plugins has some problems:

- It creates unwanted cursor position history (Especially Prettier.vim)
- Sometimes it fails because it can't find the command
- Compatibility issue

`nvim-format-buffer` is written in Lua so it's fast and does not change cursor positions at all. It also respects your OS settings to find path.

# Install

Using Packer.nvim:

```lua
use("acro5piano/nvim-format-buffer")
```

# Usage

```lua
require("nvim-format-buffer").setup({
  -- If true, print an error message if command fails. default: false
  verbose = false,
  format_rules = {
    { pattern = { "*.rs" }, command = "rustfmt --edition 2021" },

    -- Stdin as `-` is supported in many formatters
    { pattern = { "*.lua" }, command = "stylua -" },

    -- You can pipe multiple commands. No need to escape
    { pattern = { "*.py" }, command = "black -q - | isort -" },

    -- Do not include stderr
    { pattern = { "*.tsx", "*.ts", }, command = "prettier --parser typescript 2>/dev/null" },

    -- command can be a function which returns string
    {
      pattern = { "*.ts", "*.tsx", "*.css" , "*.md", "*.astro" },
      command = function()
        -- Wrap filepath with ' becuase of special filename of Next.js
        return "prettier --stdin-filepath " .. "'" .. vim.api.nvim_buf_get_name(0) .. "'"
      end,
    },
  },
})
```

# Advanced Usage

You can use internal `create_format_fn` to control more flow.

```lua
vim.api.nvim_create_autocmd({ "BufWritePre" }, {
  pattern = { "*.lua" },
  callback = function()
    require("nvim-format-buffer").format_whole_file("stylua -")
    print("Formatted!")
  end,
})
```

# TODO

- [x] Basic Error handling
- [x] Do not include stderr.
- [x] Enable to run dynamic formatter command.
- [ ] Better Error handling (such as non-interraptive notification)
