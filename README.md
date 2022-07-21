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
  format_rules = {
    { pattern = { "*.lua" }, command = "stylua -" },
    { pattern = { "*.py" }, command = "black -q - | isort -" },
    { pattern = { "*.js", "*.jsx", "*.ts", "*.tsx" }, command = "prettier --parser typescript 2>/dev/null" },
    { pattern = { "*.md" }, command = "prettier --parser markdown 2>/dev/null" },
    { pattern = { "*.md" }, command = "prettier --parser markdown 2>/dev/null" },
    { pattern = { "*.css" }, command = "prettier --parser css" },
    { pattern = { "*.rs" }, command = "rustfmt --edition 2021" },
    { pattern = { "*.sql" }, command = "sql-formatter --config ~/sql-formatter.json" }, -- requires `npm -g i sql-formatter`
  },
})
```

# Advanced Usage

You can use internal `create_format_fn` to control more flow.

```lua
local run_stylua = require("nvim-format-buffer").create_format_fn("stylua -")
vim.api.nvim_create_autocmd({ "BufWritePre" }, {
  pattern = { "*.lua" },
  callback = function()
    run_stylua()
    print("Formatted!")
  end,
})
```

# TODO

- [ ] Error handling
- [ ] Do not include stderr.
