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
    vim.cmd 'resize 8' -- Set the height to 8 lines
    terminal_win = vim.api.nvim_get_current_win()
    vim.api.nvim_win_set_buf(terminal_win, terminal_buf)

    -- Configure the terminal window
    vim.opt.number = false
    vim.opt.relativenumber = false

    -- Start the terminal
    if vim.b.terminal_job_id == nil then
      vim.fn.termopen(vim.o.shell) -- Start the terminal only if it's not already running
    end
  end
end
-- Function to run the current Python file

function RunPythonFile()
  -- Define filename and command first
  local filename = vim.fn.expand '%' -- Get the relative path of the file
  local command = 'python ' .. filename .. '\r\n' -- Construct the Python command

  -- Ensure the terminal is open
  if not (terminal_win and vim.api.nvim_win_is_valid(terminal_win)) then
    ToggleTerminal() -- Open the terminal if it's not already open
    Terminal_job_id = vim.b.terminal_job_id -- Get the terminal's job ID
  else
    -- Focus the terminal window if it's already open
    vim.api.nvim_set_current_win(terminal_win)
  end

  -- Send the command to the terminal
  if terminal_buf and vim.api.nvim_buf_is_valid(terminal_buf) then
    if Terminal_job_id then
      vim.fn.chansend(Terminal_job_id, command) -- Send the command properly
      vim.cmd 'startinsert' -- Enter insert mode
    else
      print 'Error: Terminal job ID not found.'
    end
  else
    print 'Error: Unable to find a valid terminal buffer.'
  end
end
-- Map keybinds
vim.api.nvim_set_keymap('n', '<leader>To', ':lua ToggleTerminal()<CR>', { noremap = true, silent = true, desc = '[T]oggle terminal [O]pen' }) -- Toggle terminal
vim.api.nvim_set_keymap('n', '<leader>Trp', ':lua RunPythonFile()<CR>', { noremap = true, silent = true, desc = '[T]erminal [R]un [P]ython file' }) -- Run Python file in the terminal
