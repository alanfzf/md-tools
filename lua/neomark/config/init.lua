local options = {}
local client_id = nil

local M = {}

local load_imgur_cid = function ()
  local imgur_file = vim.fn.stdpath('data')..'/creds.txt'
  local file = io.open(imgur_file, 'r')
  if file then
    client_id = file:read("*a")
    file:close()
  end
end

M.get_imgur_cid= function ()
  return client_id
end

M.set_imgur_cid = function (creds)
  local imgur_file = vim.fn.stdpath('data')..'/creds.txt'
  local file = io.open(imgur_file, "w+")
  if not file then
    return false
  end
  -- save the data to the file
  file:write(creds)
  file:close()
  -- set client id 
  client_id = creds
  return true
end

M.setup = function (opts)
  options = vim.tbl_deep_extend("force", options, opts or {})
  load_imgur_cid()
end

return M
