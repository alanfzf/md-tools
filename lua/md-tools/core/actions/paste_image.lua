local uploader = require('md-tools.util.uploader')

local function paste_image()
  local _result = uploader.upload_image()
end

return paste_image
