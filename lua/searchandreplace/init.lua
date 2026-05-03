local M = {}

local ns = vim.api.nvim_create_namespace('searchandreplace')
local panel_filetype = 'searchandreplace'

local state = {
  target_buf = nil,
  target_win = nil,
  panel_buf = nil,
  panel_win = nil,
  augroup = nil,
  matches = {},
  current = 0,
  updating_panel = false,
}

local labels = {
  search = 'search: ',
  replace = 'replace: ',
}

local function valid_buf(buf)
  return buf and vim.api.nvim_buf_is_valid(buf)
end

local function valid_win(win)
  return win and vim.api.nvim_win_is_valid(win)
end

local function clear_highlights()
  if valid_buf(state.target_buf) then
    vim.api.nvim_buf_clear_namespace(state.target_buf, ns, 0, -1)
  end
end

local function get_field(line_nr, label)
  if not valid_buf(state.panel_buf) then
    return ''
  end

  local ok, line = pcall(vim.api.nvim_buf_get_lines, state.panel_buf, line_nr - 1, line_nr, false)
  if not ok or not line[1] then
    return ''
  end

  if line[1]:sub(1, #label) ~= label then
    return ''
  end

  return line[1]:sub(#label + 1)
end

local function get_search()
  return get_field(1, labels.search)
end

local function get_replace()
  return get_field(2, labels.replace)
end

local function notify_status(message)
  if valid_buf(state.panel_buf) then
    state.updating_panel = true
    vim.api.nvim_buf_set_lines(state.panel_buf, 4, 5, false, { message })
    state.updating_panel = false
  end
end

local function find_matches(pattern)
  local matches = {}

  if pattern == '' or not valid_buf(state.target_buf) then
    return matches, nil
  end

  local lines = vim.api.nvim_buf_get_lines(state.target_buf, 0, -1, false)

  for lnum, line in ipairs(lines) do
    local start_col = 0

    while start_col <= #line do
      local result = vim.fn.matchstrpos(line, pattern, start_col)
      local text, start_idx, end_idx = result[1], result[2], result[3]

      if start_idx == -1 then
        break
      end

      if end_idx == start_idx then
        start_col = start_idx + 1
      else
        table.insert(matches, {
          lnum = lnum - 1,
          start_col = start_idx,
          end_col = end_idx,
          text = text,
        })

        start_col = end_idx
      end
    end
  end

  return matches, nil
end

local function render_highlights()
  clear_highlights()

  if not valid_buf(state.target_buf) then
    return
  end

  for idx, match in ipairs(state.matches) do
    local group = idx == state.current and 'IncSearch' or 'Search'
    vim.api.nvim_buf_set_extmark(state.target_buf, ns, match.lnum, match.start_col, {
      end_col = match.end_col,
      hl_group = group,
      priority = idx == state.current and 250 or 200,
    })
  end
end

local function update_matches()
  if not valid_buf(state.target_buf) then
    clear_highlights()
    notify_status('Original buffer is no longer available.')
    return
  end

  local pattern = get_search()
  local ok, matches_or_err = pcall(find_matches, pattern)

  if not ok then
    state.matches = {}
    state.current = 0
    clear_highlights()
    notify_status('Invalid regex.')
    return
  end

  state.matches = matches_or_err

  if #state.matches == 0 then
    state.current = 0
    notify_status(pattern == '' and 'Type a Vim regex in search.' or 'No matches.')
  else
    if state.current < 1 or state.current > #state.matches then
      state.current = 1
    end
    notify_status(string.format('%d match%s. n cycles, Enter replaces all.', #state.matches, #state.matches == 1 and '' or 'es'))
  end

  render_highlights()
end

local function move_to_match()
  if not valid_win(state.target_win) or not state.matches[state.current] then
    return
  end

  local match = state.matches[state.current]
  vim.api.nvim_win_set_cursor(state.target_win, { match.lnum + 1, match.start_col })
  vim.api.nvim_win_call(state.target_win, function()
    vim.cmd.normal({ 'zz', bang = true })
  end)
end

local function cycle_match()
  if #state.matches == 0 then
    return
  end

  state.current = state.current % #state.matches + 1
  render_highlights()
  move_to_match()
end

local function replace_all()
  local replacement = get_replace()

  update_matches()

  if #state.matches == 0 or not valid_buf(state.target_buf) then
    return
  end

  local by_line = {}
  for _, match in ipairs(state.matches) do
    by_line[match.lnum] = by_line[match.lnum] or {}
    table.insert(by_line[match.lnum], match)
  end

  for lnum, matches in pairs(by_line) do
    table.sort(matches, function(a, b)
      return a.start_col > b.start_col
    end)

    local line = vim.api.nvim_buf_get_lines(state.target_buf, lnum, lnum + 1, false)[1]
    for _, match in ipairs(matches) do
      line = line:sub(1, match.start_col) .. replacement .. line:sub(match.end_col + 1)
    end
    vim.api.nvim_buf_set_lines(state.target_buf, lnum, lnum + 1, false, { line })
  end

  update_matches()
  notify_status('Replaced all matches.')
end

local function focus_field(line_nr)
  if not valid_win(state.panel_win) then
    return
  end

  vim.api.nvim_set_current_win(state.panel_win)
  local label = line_nr == 1 and labels.search or labels.replace
  local line = vim.api.nvim_buf_get_lines(state.panel_buf, line_nr - 1, line_nr, false)[1] or label
  local col = math.max(#label, #line)
  vim.api.nvim_win_set_cursor(state.panel_win, { line_nr, col })
end

local function close_panel()
  clear_highlights()

  if valid_win(state.panel_win) then
    vim.api.nvim_win_close(state.panel_win, true)
  end

  state.panel_win = nil
  state.panel_buf = nil
  state.matches = {}
  state.current = 0
end

local function configure_panel()
  vim.bo[state.panel_buf].buftype = 'nofile'
  vim.bo[state.panel_buf].bufhidden = 'wipe'
  vim.bo[state.panel_buf].swapfile = false
  vim.bo[state.panel_buf].filetype = panel_filetype

  vim.wo[state.panel_win].number = false
  vim.wo[state.panel_win].relativenumber = false
  vim.wo[state.panel_win].signcolumn = 'no'
  vim.wo[state.panel_win].foldcolumn = '0'
  vim.wo[state.panel_win].wrap = false

  vim.api.nvim_buf_set_lines(state.panel_buf, 0, -1, false, {
    labels.search,
    labels.replace,
    '',
    'Search and Replace',
    'Type a Vim regex in search.',
  })

  local opts = { buffer = state.panel_buf, silent = true }
  vim.keymap.set('n', 'q', close_panel, vim.tbl_extend('force', opts, { desc = 'Close search and replace' }))
  vim.keymap.set('n', '<Esc>', close_panel, vim.tbl_extend('force', opts, { desc = 'Close search and replace' }))
  vim.keymap.set('n', 'n', cycle_match, vim.tbl_extend('force', opts, { desc = 'Next match' }))
  vim.keymap.set({ 'n', 'i' }, '<CR>', replace_all, vim.tbl_extend('force', opts, { desc = 'Replace all matches' }))
  vim.keymap.set({ 'n', 'i' }, '<Down>', function()
    focus_field(2)
    vim.cmd.startinsert()
  end, vim.tbl_extend('force', opts, { desc = 'Focus replace field' }))
  vim.keymap.set({ 'n', 'i' }, '<Right>', function()
    focus_field(2)
    vim.cmd.startinsert()
  end, vim.tbl_extend('force', opts, { desc = 'Focus replace field' }))
  vim.keymap.set({ 'n', 'i' }, '<Up>', function()
    focus_field(1)
    vim.cmd.startinsert()
  end, vim.tbl_extend('force', opts, { desc = 'Focus search field' }))
  vim.keymap.set({ 'n', 'i' }, '<Left>', function()
    focus_field(1)
    vim.cmd.startinsert()
  end, vim.tbl_extend('force', opts, { desc = 'Focus search field' }))

  state.augroup = vim.api.nvim_create_augroup('searchandreplace-panel-' .. state.panel_buf, { clear = true })
  vim.api.nvim_create_autocmd({ 'TextChanged', 'TextChangedI' }, {
    group = state.augroup,
    buffer = state.panel_buf,
    callback = function()
      if not state.updating_panel then
        update_matches()
      end
    end,
  })

  vim.api.nvim_create_autocmd('BufWipeout', {
    group = state.augroup,
    buffer = state.panel_buf,
    callback = clear_highlights,
  })
end

function M.open()
  state.target_buf = vim.api.nvim_get_current_buf()
  state.target_win = vim.api.nvim_get_current_win()
  state.matches = {}
  state.current = 0

  if valid_win(state.panel_win) then
    vim.api.nvim_set_current_win(state.panel_win)
    focus_field(1)
    vim.cmd.startinsert()
    return
  end

  vim.cmd('botright 34vnew')
  state.panel_win = vim.api.nvim_get_current_win()
  state.panel_buf = vim.api.nvim_get_current_buf()

  configure_panel()
  focus_field(1)
  vim.cmd.startinsert()
end

function M.setup()
  vim.keymap.set('n', '<leader>rs', M.open, { desc = '[R]eplace [S]earch panel' })
end

return M
