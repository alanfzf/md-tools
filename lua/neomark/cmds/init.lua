local clipboard = require('neomark.util.clipboard')
local config = require('neomark.config')

local M = {}

M.setup = function ()
  -- command to paste the image
  vim.api.nvim_create_user_command('PasteImage', function ()
    local cid = config.get_imgur_cid()
    if not cid then
      vim.notify("You have not set your imgur client id, use, :SetImgurClientId to establish it", vim.log.levels.WARN)
      return
    end
    print(cid)
    -- clipboard.paste_image()
  end, {})

  -- command to set imgur credentials
  vim.api.nvim_create_user_command('SetImgurClientId', function (opts)
    local client_id = opts.args
    local result = config.set_imgur_cid(client_id)

    if result then
      vim.notify("Set imgur client id to: "..client_id, vim.log.levels.INFO)
      print()
    else
      vim.notify("An error has occurred trying to set the imgur client id", vim.log.levels.ERROR)
    end
  end, {nargs=1})
end

return M
