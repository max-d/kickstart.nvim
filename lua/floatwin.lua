-- lua/floatwin.lua (or anywhere in your config)
local M = {}

function M.open_floating_window(opts)
  opts = opts or {}
  local ui = vim.api.nvim_list_uis()[1]
  local ui_w, ui_h = ui.width, ui.height

  -- allow ratio (0..1) or absolute cells
  local function resolve(val, ui_dim, default_ratio)
    if val == nil then
      return math.floor(ui_dim * default_ratio)
    elseif val <= 1 then
      return math.floor(ui_dim * val)
    else
      return math.floor(val)
    end
  end

  local win_w = resolve(opts.width, ui_w, 0.80)
  local win_h = resolve(opts.height, ui_h, 0.80)

  local row = math.floor((ui_h - win_h) / 2)
  local col = math.floor((ui_w - win_w) / 2)

  local buf = nil
  if vim.api.nvim_buf_is_valid(opts.buf) then
    buf = opts.buf
  else
    buf = vim.api.nvim_create_buf(false, true) -- scratch, nofile
  end

  local win = vim.api.nvim_open_win(buf, true, {
    relative = 'editor',
    width = win_w,
    height = win_h,
    row = row,
    col = col,
    style = 'minimal',
    border = opts.border or 'rounded',
  })

  return buf, win
end

return M
