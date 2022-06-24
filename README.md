# nvim-format-buffer

A simple Neovim plugin to format current buffer using an external command

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
	callback = require("nvim-format-buffer").create_format_fn("prettier --parser typescript"),
})
```
