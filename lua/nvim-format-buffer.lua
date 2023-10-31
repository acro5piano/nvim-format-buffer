local M = {}

M.buf_get_full_text = function(bufnr)
  local text = table.concat(vim.api.nvim_buf_get_lines(bufnr, 0, -1, true), "\n")
  if vim.api.nvim_buf_get_option(bufnr, "eol") then
    text = text .. "\n"
  end
  return text
end

M.shell_error = function()
  return vim.v.shell_error ~= 0
end

-- Credit: https://github.com/ckipp01/stylua-nvim/blob/main/lua/stylua-nvim.lua
M.format_whole_file = function(cmd)
  local bufnr = vim.fn.bufnr("%")
  local input = M.buf_get_full_text(bufnr)
  local output = vim.fn.system(cmd, input)
  if M.shell_error() then
    if M.options.verbose then
      print(output)
    end
    return
  end
  if output ~= input then
    local new_lines = vim.fn.split(output, "\n")
    vim.api.nvim_buf_set_lines(0, 0, -1, false, new_lines)
  end
end

M.create_format_fn = function(cmd)
  return function()
    M.format_whole_file(cmd)
  end
end

M.options = {
  -- If true, print an error message if command fails. default: false
  verbose = false,
}

-- Setup plugin. For example,
--
-- ```lua
-- require("nvim-format-buffer").setup({
-- 	format_rules = {
-- 		{ pattern = { "*.lua" }, command = "stylua -" },
-- 		{ pattern = { "*.py" }, command = "black -q - | isort -" },
-- 	},
-- })
-- ```
M.setup = function(options)
  M.options = vim.tbl_deep_extend("force", {}, M.options, options or {})
  for _, rule in ipairs(options.format_rules) do
    if type(rule.command) == "string" then
      vim.api.nvim_create_autocmd({ "BufWritePre" }, {
        pattern = rule.pattern,
        callback = M.create_format_fn(rule.command),
      })
    end
    if type(rule.command) == "function" then
      vim.api.nvim_create_autocmd({ "BufWritePre" }, {
        pattern = rule.pattern,
        callback = function()
          M.format_whole_file(rule.command())
        end,
      })
    end
  end
end

return M
