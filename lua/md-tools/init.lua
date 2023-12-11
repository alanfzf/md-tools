local config = require('md-tools.util.config')
local commands = require('md-tools.core.commands')

local M = {}

M.setup = function (opts)
  config.setup(opts)
  commands.setup()
end

return M
