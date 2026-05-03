local M = {}

local state = {
  buf = -1,
  win = -1,
  opts = {},
}

local function has_valid_window()
  return vim.api.nvim_win_is_valid(state.win)
end

local function has_valid_buffer()
  return vim.api.nvim_buf_is_valid(state.buf)
end

local function terminal_is_running()
  if not has_valid_buffer() or vim.bo[state.buf].buftype ~= 'terminal' then
    return false
  end

  local job_id = vim.b[state.buf].terminal_job_id
  return type(job_id) == 'number' and vim.fn.jobwait({ job_id }, 0)[1] == -1
end

local function reset_stale_terminal()
  if has_valid_buffer() and vim.bo[state.buf].buftype == 'terminal' and not terminal_is_running() then
    state.buf = -1
  end
end

function M.hide()
  if has_valid_window() then
    vim.api.nvim_win_hide(state.win)
    state.win = -1
  end
end

function M.is_current_float()
  return vim.api.nvim_get_current_win() == state.win
end

function M.resize()
  if has_valid_window() then
    vim.api.nvim_win_set_config(state.win, require('floatwin').resolve_config(state.opts))
  end
end

local function map_terminal_buffer()
  vim.keymap.set('t', '<Esc><Esc>', M.hide, {
    buffer = state.buf,
    desc = 'Hide floating terminal',
  })
end

function M.toggle()
  if has_valid_window() then
    M.hide()
    return
  end

  reset_stale_terminal()

  local buf, win = require('floatwin').open_floating_window(
    vim.tbl_extend('force', state.opts, { buf = state.buf })
  )
  state.buf = buf
  state.win = win

  if vim.bo[state.buf].buftype ~= 'terminal' then
    vim.cmd.term()
  end

  map_terminal_buffer()
  vim.api.nvim_set_current_win(state.win)
  vim.cmd.startinsert()
end

function M.setup(opts)
  state.opts = opts or {}

  vim.api.nvim_create_user_command('FloatTerm', M.toggle, {})

  local group = vim.api.nvim_create_augroup('FloatTerm', { clear = true })
  vim.api.nvim_create_autocmd('VimResized', {
    group = group,
    callback = M.resize,
  })
end

return M
