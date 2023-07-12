local cfg = require('neomark.config')
local cmds = require('neomark.cmds')

local M = {}

M.setup = function (opts)
  cfg.setup(opts)
  cmds.setup()
end

return M
