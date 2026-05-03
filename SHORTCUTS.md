# Neovim Shortcuts

Leader key: `<Space>`

Modes:
- `n`: normal
- `i`: insert
- `v`: visual/select
- `x`: visual
- `t`: terminal
- `all`: mapping applies to all modes configured by the plugin

This list is based on `init.lua`, `lua/custom/plugins/*.lua`, `lua/kickstart/plugins/*.lua`, and the currently active lazy imports.

## Core / init.lua

| Shortcut | Mode | Action |
| --- | --- | --- |
| `<Esc>` | `n` | Clear search highlights |
| `<leader>q` | `n` | Open diagnostic quickfix/location list |
| `<leader>ww` | `n` | Save file |
| `<leader>wq` | `n` | Save file and quit |
| `<leader>qq` | `n` | Quit all without saving |
| `<C-h>` | `n` | Move focus to the left window |
| `<C-l>` | `n` | Move focus to the right window |
| `<C-j>` | `n` | Move focus to the lower window |
| `<C-k>` | `n` | Move focus to the upper window |

Commented out in `init.lua`:

| Shortcut | Mode | Action |
| --- | --- | --- |
| `<Left>` | `n` | Echo "Use h to move!!" |
| `<Right>` | `n` | Echo "Use l to move!!" |
| `<Up>` | `n` | Echo "Use k to move!!" |
| `<Down>` | `n` | Echo "Use j to move!!" |
| `<C-S-h>` | `n` | Move current window to the left |
| `<C-S-l>` | `n` | Move current window to the right |
| `<C-S-j>` | `n` | Move current window to the lower position |
| `<C-S-k>` | `n` | Move current window to the upper position |
| `<leader>rc` | `n` | Reload Neovim config |

## Terminal / floaterm

Defined in `init.lua` and `lua/floaterm/init.lua`.

| Shortcut | Mode | Action |
| --- | --- | --- |
| `<leader>ts` | `n` | Open a small horizontal terminal split |
| `<leader>tf` | `n` | Toggle floating terminal via `:FloatTerm` |
| `<Esc><Esc>` | `t` | Exit terminal mode in regular terminals |
| `<Esc><Esc>` | `t` | Hide the floating terminal when inside the floating terminal buffer |

## Neovim Project

The commands are mapped in `init.lua`; the plugin itself is expected to provide the `NeovimProject*` commands.

| Shortcut | Mode | Action |
| --- | --- | --- |
| `<leader>sp` | `n` | Discover projects in `~/projects/` |
| `<leader>pp` | `n` | Discover projects in `~/projects/` |
| `<leader>ph` | `n` | Open project history |
| `<leader>pr` | `n` | Open recent project |

## triforce.nvim

| Shortcut | Mode | Action |
| --- | --- | --- |
| `<leader>tp` | `n` | Show Triforce profile |

## opencode.nvim

| Shortcut | Mode | Action |
| --- | --- | --- |
| `<leader>oa` | `n`, `x` | Ask opencode with `@this` and submit |
| `<leader>oe` | `n`, `x` | Execute/select an opencode action |
| `<leader>ot` | `n`, `t` | Toggle opencode |
| `go` | `n`, `x` | Start opencode operator to add a range |
| `goo` | `n` | Add current line to opencode |
| `<leader>oj` | `n` | Scroll opencode up |
| `<leader>ok` | `n` | Scroll opencode down |
| `+` | `n` | Increment number under cursor |
| `-` | `n` | Decrement number under cursor |

### opencode.nvim with snacks.nvim picker

| Shortcut | Mode | Action |
| --- | --- | --- |
| `<A-a>` | `n`, `i` | Send selected picker item to opencode |

## gitsigns.nvim

The active `init.lua` gitsigns setup configures gutter signs only. It does not currently define active gitsigns shortcuts.

Recommended gitsigns shortcuts exist in `lua/kickstart/plugins/gitsigns.lua`, but that module is commented out in `init.lua`. See "Inactive plugin shortcut files" below.

## which-key.nvim

which-key displays pending keymaps and registers these groups:

| Shortcut Prefix | Mode | Group |
| --- | --- | --- |
| `<leader>s` | `n` | Search |
| `<leader>t` | `n` | Toggle |
| `<leader>h` | `n`, `v` | Git hunk |

## telescope.nvim

| Shortcut | Mode | Action |
| --- | --- | --- |
| `<leader>sh` | `n` | Search help tags |
| `<leader>sk` | `n` | Search keymaps |
| `<leader>sf` | `n` | Search files |
| `<leader>ss` | `n` | Search Telescope pickers |
| `<leader>sw` | `n` | Search current word |
| `<leader>sg` | `n` | Live grep |
| `<leader>sd` | `n` | Search diagnostics |
| `<leader>sr` | `n` | Resume last Telescope picker |
| `<leader>s.` | `n` | Search recent files |
| `<leader><leader>` | `n` | Find existing buffers |
| `<leader>/` | `n` | Fuzzy search in current buffer |
| `<leader>s/` | `n` | Live grep in open files |
| `<leader>sn` | `n` | Search Neovim config files |

Useful Telescope picker-local help keys noted in the config:

| Shortcut | Mode | Action |
| --- | --- | --- |
| `<C-/>` | `i` | Show Telescope picker keymaps/help |
| `?` | `n` | Show Telescope picker keymaps/help |

## nvim-lspconfig / LSP

These are buffer-local and appear only after an LSP server attaches to a buffer.

| Shortcut | Mode | Action |
| --- | --- | --- |
| `grn` | `n` | Rename symbol |
| `gra` | `n`, `x` | Code action |
| `grr` | `n` | Find references with Telescope |
| `gri` | `n` | Go to implementation with Telescope |
| `grd` | `n` | Go to definition with Telescope |
| `grD` | `n` | Go to declaration |
| `gO` | `n` | Open document symbols with Telescope |
| `gW` | `n` | Open workspace symbols with Telescope |
| `grt` | `n` | Go to type definition with Telescope |
| `grx` | `n` | Run CodeLens when supported by an attached LSP server |
| `<leader>th` | `n` | Toggle inlay hints, when supported by the server |

## venv-selector.nvim

Loaded for Python files.

| Shortcut | Mode | Action |
| --- | --- | --- |
| `<leader>vs` | `n` | Open virtual environment selector |

## neotest / neotest-python

Loaded for Python files. Uses `pytest` by default.

| Shortcut | Mode | Action |
| --- | --- | --- |
| `<leader>nt` | `n` | Run nearest test |
| `<leader>nf` | `n` | Run tests in current file |
| `<leader>na` | `n` | Run all tests from the current working directory |
| `<leader>nd` | `n` | Debug nearest test with DAP |
| `<leader>no` | `n` | Open test output |
| `<leader>ns` | `n` | Toggle test summary |

## conform.nvim

| Shortcut | Mode | Action |
| --- | --- | --- |
| `<leader>f` | `all` | Format buffer |

## blink.cmp

Configured with `preset = 'enter'`. The config comments document these completion mappings from blink's presets:

| Shortcut | Mode | Action |
| --- | --- | --- |
| `<CR>` | `i` | Accept selected completion item |
| `<Tab>` | `i`, `s` | Move right/forward in snippet expansion |
| `<S-Tab>` | `i`, `s` | Move left/backward in snippet expansion |
| `<C-Space>` | `i` | Open completion menu, or open docs if already open |
| `<C-n>` | `i` | Select next completion item |
| `<C-p>` | `i` | Select previous completion item |
| `<Up>` | `i` | Select previous completion item |
| `<Down>` | `i` | Select next completion item |
| `<C-e>` | `i` | Hide completion menu |
| `<C-k>` | `i` | Toggle signature help |

## LuaSnip

LuaSnip is installed as a dependency of blink.cmp. The config does not define custom LuaSnip shortcuts, but runtime plug mappings are present for snippet expansion, jumping, and choice-node navigation.

## mini.nvim

### mini.ai

The config enables `mini.ai` with its default textobject mappings.

| Shortcut Pattern | Mode | Action |
| --- | --- | --- |
| `a...` | `x`, operator-pending | Around textobject |
| `i...` | `x`, operator-pending | Inside textobject |
| `an...` | `x`, operator-pending | Around next textobject |
| `in...` | `x`, operator-pending | Inside next textobject |
| `al...` | `x`, operator-pending | Around last textobject |
| `il...` | `x`, operator-pending | Inside last textobject |

Examples from `init.lua`:

| Shortcut | Mode | Action |
| --- | --- | --- |
| `va)` | `v` | Select around parentheses |
| `yinq` | `n` | Yank inside next quote |
| `ci'` | `n` | Change inside single quotes |

### mini.surround

The config enables `mini.surround` with its default mappings.

| Shortcut | Mode | Action |
| --- | --- | --- |
| `sa` | `n`, `x` | Add surrounding |
| `sd` | `n` | Delete surrounding |
| `sr` | `n` | Replace surrounding |
| `sf` | `n` | Find right surrounding |
| `sF` | `n` | Find left surrounding |
| `sh` | `n` | Highlight surrounding |
| `sn` suffix | `n` | Use next surrounding for supported surround commands |
| `sl` suffix | `n` | Use previous/last surrounding for supported surround commands |

Examples from `init.lua`:

| Shortcut | Mode | Action |
| --- | --- | --- |
| `saiw)` | `n` | Add parentheses around inner word |
| `sd'` | `n` | Delete single-quote surrounding |
| `sr)'` | `n` | Replace parentheses with single quotes |

## todo-comments.nvim

No shortcuts are configured.

## tokyonight.nvim

No shortcuts are configured.

## nvim-treesitter

No explicit shortcuts are configured.

## guess-indent.nvim

No shortcuts are configured.

## lazydev.nvim

No shortcuts are configured.

## mason.nvim / mason-lspconfig.nvim / mason-tool-installer.nvim

No shortcuts are configured.

## fidget.nvim

No shortcuts are configured.

## neo-tree.nvim

| Shortcut | Mode | Action |
| --- | --- | --- |
| `<leader>rr` | `n` | Reveal current file in Neo-tree |
| `<leader>rt` | `n` | Toggle Neo-tree |
| `<leader>rf` | `n` | Focus Neo-tree |
| `\` | Neo-tree window | Close Neo-tree window |

## harpoon

Defined in `lua/custom/plugins/harpoon.lua`.

| Shortcut | Mode | Action |
| --- | --- | --- |
| `<leader>ha` | `n` | Add current file to Harpoon list |
| `<leader>h1` | `n` | Open Harpoon item 1 |
| `<leader>h2` | `n` | Open Harpoon item 2 |
| `<leader>h3` | `n` | Open Harpoon item 3 |
| `<leader>h4` | `n` | Open Harpoon item 4 |
| `<leader>hh` | `n` | Toggle Harpoon quick menu |

## searchandreplace

Defined in `lua/searchandreplace/init.lua` and loaded by `lua/custom/plugins/searchandreplace.lua`.

| Shortcut | Mode | Action |
| --- | --- | --- |
| `<leader>rs` | `n` | Open search and replace panel |

Panel-local shortcuts:

| Shortcut | Mode | Action |
| --- | --- | --- |
| `q` | `n` | Close panel |
| `<Esc>` | `n` | Close panel |
| `n` | `n` | Cycle to next match |
| `<CR>` | `n`, `i` | Replace all matches |
| `<Down>` | `n`, `i` | Focus replace field |
| `<Right>` | `n`, `i` | Focus replace field |
| `<Up>` | `n`, `i` | Focus search field |
| `<Left>` | `n`, `i` | Focus search field |

## Inactive plugin shortcut files

These plugin modules exist in `lua/kickstart/plugins/`, but their `require` lines are currently commented out in `init.lua`.

### nvim-dap / nvim-dap-ui / nvim-dap-go

Inactive file: `lua/kickstart/plugins/debug.lua`

| Shortcut | Mode | Action |
| --- | --- | --- |
| `<F5>` | `n` | Debug start/continue |
| `<F1>` | `n` | Debug step into |
| `<F2>` | `n` | Debug step over |
| `<F3>` | `n` | Debug step out |
| `<leader>b` | `n` | Toggle breakpoint |
| `<leader>B` | `n` | Set conditional breakpoint |
| `<F7>` | `n` | Toggle DAP UI / last session result |

### gitsigns.nvim recommended keymaps

Inactive file: `lua/kickstart/plugins/gitsigns.lua`

| Shortcut | Mode | Action |
| --- | --- | --- |
| `]c` | `n` | Jump to next git change |
| `[c` | `n` | Jump to previous git change |
| `<leader>hs` | `n`, `v` | Stage hunk |
| `<leader>hr` | `n`, `v` | Reset hunk |
| `<leader>hS` | `n` | Stage buffer |
| `<leader>hu` | `n` | Undo stage hunk as described in config |
| `<leader>hR` | `n` | Reset buffer |
| `<leader>hp` | `n` | Preview hunk |
| `<leader>hb` | `n` | Blame line |
| `<leader>hd` | `n` | Diff against index |
| `<leader>hD` | `n` | Diff against last commit |
| `<leader>tb` | `n` | Toggle current line blame |
| `<leader>tD` | `n` | Preview deleted hunk inline |

### autopairs.nvim

Inactive file: `lua/kickstart/plugins/autopairs.lua`

No shortcuts are configured.

### indent-blankline.nvim

Inactive file: `lua/kickstart/plugins/indent_line.lua`

No shortcuts are configured.

### nvim-lint

Inactive file: `lua/kickstart/plugins/lint.lua`

No shortcuts are configured.
