-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

local terminal_buf = nil
local terminal_win = nil
-- Function to toggle the terminal

function ToggleTerminal()
  if terminal_win and vim.api.nvim_win_is_valid(terminal_win) then
    -- If the terminal is open, hide it (close the window but keep the buffer)
    vim.api.nvim_win_hide(terminal_win)
    terminal_win = nil
  else
    -- Open the terminal
    if not terminal_buf or not vim.api.nvim_buf_is_valid(terminal_buf) then
      terminal_buf = vim.api.nvim_create_buf(false, true) -- Create a new buffer for the terminal
    end

    -- Open a horizontal split window for the terminal
    vim.cmd 'botright split'
    vim.cmd 'resize 10' -- Set the height to 8 lines
    terminal_win = vim.api.nvim_get_current_win()
    vim.api.nvim_win_set_buf(terminal_win, terminal_buf)

    -- Configure the terminal window
    vim.opt.number = false
    vim.opt.relativenumber = false

    -- Start the terminal
    if vim.b.terminal_job_id == nil then
      vim.fn.termopen(vim.o.shell) -- Start the terminal only if it's not already running
    end
    vim.cmd 'startinsert'
  end
end
-- Function to run the current Python file

-- Map keybinds
vim.api.nvim_set_keymap('n', '<leader>tt', ':lua ToggleTerminal()<CR>', { noremap = true, silent = true, desc = '[T]oggle [T]erminal' }) -- Toggle terminal
