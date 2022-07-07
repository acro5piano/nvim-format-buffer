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

```
use("acro5piano/nvim-format-buffer")
```

# Usage

```lua
vim.api.nvim_create_autocmd({ "BufWritePre" }, {
	pattern = { "*.lua" },
	callback = require("nvim-format-buffer").create_format_fn("stylua -"),
})

vim.api.nvim_create_autocmd({ "BufWritePre" }, {
	pattern = { "*.js", "*.jsx", "*.ts", "*.tsx" },
	callback = require("nvim-format-buffer").create_format_fn("prettier --parser typescript 2>/dev/null"),
})
```

# TODO

- [ ] Error handling
- [ ] Do not include stderr.
