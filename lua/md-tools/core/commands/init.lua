local paste_image = require('md-tools.core.actions.paste_image')
local toggle_check = require('md-tools.core.actions.toggle_check')

local M = {}

M.setup = function ()
  vim.api.nvim_create_user_command('PasteImage', paste_image, {})
  vim.api.nvim_create_user_command('ToggleCheckBox', toggle_check, {})
end

return M
