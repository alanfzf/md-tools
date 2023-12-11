local config = require('md-tools.util.config')
local helper = require('md-tools.util.helpers')

-- TODO: refactor this
local api = vim.api
local fn = vim.fn

local M = {}

M.upload_image = function()
  local cid = config.get_imgur_cid()
  local script = helper.get_clipboard_cmd()

  if not cid then
    return false, "Your Imgur Client ID has not been set as an environment variable."
  end

  if not script then
    return false, "Your Operating system is not supported at the moment!"
  end

  -- buffer variables
  local url = nil
  local template_md = "![](%s)"
  local placeholder = string.format(template_md, "Uploading…")
  local message = nil

  local buffer = api.nvim_get_current_buf()
  local row, col = unpack(api.nvim_win_get_cursor(0))

  api.nvim_buf_set_text(buffer, row - 1, col, row - 1, col, { placeholder })
  api.nvim_win_set_cursor(0, { row, col + placeholder:len() + 1 })

  -- Mark the location of the template for replacing later
  local mark_ns = api.nvim_create_namespace("")
  local mark_id = api.nvim_buf_set_extmark(buffer, mark_ns, row - 1, col, { end_col = col + placeholder:len(), hl_group = "Whitespace" })

  local upload_cmd = string.format([[%s | curl --silent --fail --request POST --form 'image=@-' --header 'Authorization: Client-ID %s' 'https://api.imgur.com/3/upload' | jq --raw-output .data.link ]], script, cid)

  if string.sub(upload_cmd, 1, 1) == "&" then
    -- handle fucking autistic windows
    upload_cmd = string.format("pwsh -Command \"& { %s }\"", upload_cmd)
  end

  -- Start uploading
  fn.jobstart(upload_cmd, {stdout_buffered = true,

    on_stdout = function(_, data)
      url = fn.join(data):gsub("^%s*(.-)%s*$", "%1")
    end,

    on_exit = function(_, exit_code)

      local failed = url == "" or exit_code ~= 0
      local replacement = ""

      if failed then
        message = string.format("Failed to upload to imgur, exit code: %s", exit_code)
      else
        replacement = string.format(template_md, url)
      end

      -- Locate the mark
      local mark_row, mark_col = unpack(api.nvim_buf_get_extmark_by_id(buffer, mark_ns, mark_id, {}))

      -- Update the line containing the mark
      api.nvim_buf_del_extmark(buffer, mark_ns, mark_id)
      api.nvim_buf_set_text(buffer, mark_row, mark_col, mark_row, mark_col + placeholder:len(), { replacement })
    end,
  })


  local failed = message == nil

  return failed, message
end

return M
