local CHECKED = "%[X%]"
local UNCHECKED = "%[ %]"

local line_is_unchecked = function(line)
	return string.find(line, UNCHECKED)
end

local toggle_check = function(line, not_checked)
  if not_checked then
    return line:gsub(UNCHECKED, CHECKED)
  else
    return line:gsub(CHECKED, UNCHECKED)
  end
end

local toggle_action = function()
	local bufnr = vim.api.nvim_buf_get_number(0)
	local cursor = vim.api.nvim_win_get_cursor(0)
	local start_line = cursor[1] - 1
	local current_line = vim.api.nvim_buf_get_lines(bufnr, start_line, start_line + 1, false)[1] or ""

  local not_checked = line_is_unchecked(current_line)
  local new_line = toggle_check(current_line, not_checked)

	vim.api.nvim_buf_set_lines(bufnr, start_line, start_line + 1, false, { new_line })
	vim.api.nvim_win_set_cursor(0, cursor)
end


return toggle_action
