local curl = require('plenary.curl')
local config = require('neomark.config')
local fn = vim.fn
-- local api = vim.api

local function  get_cid()
  return config.get_imgur_client_key()
end

local function get_os()
  local windows = fn.has("win32")
  if windows then
    return "windows"
  end
  return nil
end

local function get_clipboard_image()
  local cid = get_cid()
  local distro = get_os()

  if not cid then
    return nil, "The imgur client id has not been specified"
  end

  if distro ~= "windows" then
    return nil, "This feature is only available on windows at the moment"
  end

  local tempFile = os.tmpname()..".png"
  local cmdArgs = string.format([[powershell.exe -Command "$img = Get-Clipboard -Format Image; if ($img) { $img.Save('%s') } else { Write-Host 'No clipboard image' }"]], tempFile)
  local command, errors = io.popen(cmdArgs.. " 2>&1") -- the 2>&1 part outputs any errors that are not catched by popen

  if not command then
    return nil, errors
  end

  local output = string.gsub(command:read("*a"), "^%s*(.-)%s*$", "%1")
  command:close()

  if output ~= '' then
    return nil, output
  end

  return tempFile, nil
end

local function upload_image()
  local tempImg, errors = get_clipboard_image()

  if not tempImg then
    return nil, errors
  end

  -- Doc: https://apidocs.imgur.com/#c85c9dfc-7487-4de2-9ecd-66f727cf3139
  local response = curl.request({
    url = "https://api.imgur.com/3/image",
    method = "POST",
    headers = {
      ["Authorization"] = string.format("Client-ID %s", get_cid()),
      ["Content-Type"] = "application/x-www-form-urlencoded",
    },
    raw = { "--data-binary", "@"..tempImg }
  })
  local status = response.status

  -- always remove the temp file 
  os.remove(tempImg)

  if status ~= 200 then
    return nil, string.format("Imgur couldn't process the request, error code: (%s)", status)
  end

  local body = vim.fn.json_decode(response.body)
  local url = body['data']['link']

  return url, nil
end


---@diagnostic disable-next-line: unused-function
local function _()
  -- local buffer = api.nvim_get_current_buf()
  -- local row,col = unpack(api.nvim_win_get_cursor(0))
  --
  -- local placeholder = 'UPLOADING IMAGE...'
  --
  -- api.nvim_buf_set_text(buffer, row - 1, col, row - 1, col, { placeholder })
  -- api.nvim_win_set_cursor(0, { row, col + placeholder:len() + 1 })
  -- local mark_ns = api.nvim_create_namespace("")
  -- local mark_id = api.nvim_buf_set_extmark(
  --   buffer,
  --   mark_ns,
  --   row - 1,
  --   col,
  --   { end_col = col + placeholder:len(), hl_group = "Whitespace" }
  -- )
end

local M = {}

M.paste_image = function ()
  local img_url, errors = upload_image()

  if errors then
    vim.notify(errors, vim.log.levels.ERROR)
    return
  end

  print(img_url)
end

return M
