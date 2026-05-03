local M = {}

local function clamp(value, min_value, max_value)
  return math.min(math.max(value, min_value), max_value)
end

function M.resolve_config(opts)
  opts = opts or {}
  local ui = vim.api.nvim_list_uis()[1] or { width = vim.o.columns, height = vim.o.lines }
  local ui_w = math.max(ui.width, 1)
  local ui_h = math.max(ui.height, 1)

  local function resolve(val, ui_dim, default_ratio)
    if val == nil then
      return math.floor(ui_dim * default_ratio)
    elseif val <= 1 then
      return math.floor(ui_dim * val)
    else
      return math.floor(val)
    end
  end

  local max_w = math.max(ui_w - 4, 1)
  local max_h = math.max(ui_h - 4, 1)
  local min_w = math.min(opts.min_width or 20, max_w)
  local min_h = math.min(opts.min_height or 5, max_h)
  local win_w = clamp(resolve(opts.width, ui_w, 0.80), min_w, max_w)
  local win_h = clamp(resolve(opts.height, ui_h, 0.80), min_h, max_h)

  local row = math.floor((ui_h - win_h) / 2)
  local col = math.floor((ui_w - win_w) / 2)

  return {
    relative = 'editor',
    width = win_w,
    height = win_h,
    row = math.max(row, 0),
    col = math.max(col, 0),
    style = 'minimal',
    border = opts.border or 'rounded',
  }
end

function M.open_floating_window(opts)
  opts = opts or {}

  local buf = nil
  if type(opts.buf) == 'number' and vim.api.nvim_buf_is_valid(opts.buf) then
    buf = opts.buf
  else
    buf = vim.api.nvim_create_buf(false, true) -- scratch, nofile
  end

  local win = vim.api.nvim_open_win(buf, true, M.resolve_config(opts))

  return buf, win
end

return M
