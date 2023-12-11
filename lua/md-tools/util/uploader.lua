local config = require('md-tools.util.config')


local M = {}

M.upload_image = function()
  local clientId = config.get_imgur_cid()

  if not clientId then
    return false, "Your Imgur Client ID has not been set as an environment variable."
  end

end

return M
