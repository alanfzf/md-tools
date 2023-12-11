local uploader = require('md-tools.util.uploader')

local function paste_image()
  local ok, message = uploader.upload_image()

  if not ok then
    vim.notify(message or "", vim.log.levels.ERROR)
  end

end

return paste_image
