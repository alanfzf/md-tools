local fn = vim.fn

local M = {}

local command = {
  windows = [[& { Add-Type -AssemblyName System.Windows.Forms; $image = [System.Windows.Forms.Clipboard]::GetImage(); if ($image -ne $null) { $ms = New-Object System.IO.MemoryStream; $image.Save($ms, [System.Drawing.Imaging.ImageFormat]::Png); $imageBytes = $ms.ToArray(); $ms.Close(); return $imageBytes; } }]],
  linux_xorg = [[xclip -selection clipboard -t image/png -o]]
}

local get_unix_display = function()

  if os.getenv("DISPLAY") then
    return "linux_xorg"

  elseif os.getenv("WAYLAND_DISPLAY") then
      return "linux_wayland"
  end

  return nil
end


local get_current_os = function ()
  if fn.has("win32") then
    return "windows"

  elseif fn.has("unix") then
    return get_unix_display()

  elseif fn.has("mac") then
    -- yet to be implemented
    return nil
  end

  return nil
end

-- UTILITY FUNCTIONS
M.get_clipboard_cmd = function ()
  local os = get_current_os()
  return command[os]
end

M.is_read_only = function ()
  return vim.api.nvim_buf_get_option(vim.api.nvim_win_get_buf(0), 'readonly')
end

return M
