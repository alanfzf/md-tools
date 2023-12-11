local M = {}

local options = {}
local client_id = os.getenv("IMGUR_CID")

M.get_imgur_cid = function()
  return client_id
end

M.setup = function(opts)
  options = vim.tbl_deep_extend("force", options, opts or {})
end

return M
