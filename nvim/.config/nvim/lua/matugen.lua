 local M = {}

function M.setup()
  require('base16-colorscheme').setup({
    base00 = '#1f1f28',
    base01 = '#2a2a37',
    base02 = '#333343',
    base03 = '#566d79',
    base04 = '#c8c093',
    base05 = '#dcd7ba',
    base06 = '#dcd7ba',
    base07 = '#dcd7ba',
    base08 = '#c4746e',
    base09 = '#938aa9',
    base0A = '#8ea49e',
    base0B = '#c4b28a',
    base0C = '#ae96e9',
    base0D = '#e9cf96',
    base0E = '#96e9d2',
    base0F = '#bef4e5',
  })

  local hi = function(group, opts)
    vim.api.nvim_set_hl(0, group, opts)
  end

  -- telescope.nvim
  hi('TelescopeNormal',         { fg = '#dcd7ba',          bg = '#1f1f28' })
  hi('TelescopeBorder',         { fg = '#566d79',             bg = '#1f1f28' })
  hi('TelescopePromptNormal',   { fg = '#dcd7ba',          bg = '#1f1f28' })
  hi('TelescopePromptBorder',   { fg = '#566d79',             bg = '#1f1f28' })
  hi('TelescopePromptPrefix',   { fg = '#c4b28a',             bg = '#1f1f28' })
  hi('TelescopePromptCounter',  { fg = '#c8c093',  bg = '#1f1f28' })
  hi('TelescopePromptTitle',    { fg = '#1f1f28',             bg = '#c4b28a' })
  hi('TelescopePreviewTitle',   { fg = '#1f1f28',             bg = '#8ea49e' })
  hi('TelescopeResultsTitle',   { fg = '#1f1f28',             bg = '#938aa9' })
  hi('TelescopeSelection',      { fg = '#dcd7ba',          bg = '#333343' })
  hi('TelescopeSelectionCaret', { fg = '#c4b28a',             bg = '#333343' })
  hi('TelescopeMatching',       { fg = '#c4b28a',             bold = true })

  -- mini.pick
  hi('MiniPickNormal',         { fg = '#dcd7ba',          bg = '#1f1f28' })
  hi('MiniPickBorder',         { fg = '#566d79',             bg = '#1f1f28' })
  hi('MiniPickPrompt',   { fg = '#dcd7ba',          bg = '#1f1f28' })
  hi('MiniPickPromptPrefix',   { fg = '#c4b28a',             bg = '#1f1f28' })
  hi('MiniPickBorderText',    { fg = '#1f1f28',             bg = '#c4b28a' })
  hi('MiniPickMatchCurrent',      { fg = '#dcd7ba',          bg = '#333343' })
  hi('MiniPickPromptCaret', { fg = '#c4b28a',             bg = '#333343' })
  hi('MiniPickMatchRanges',       { fg = '#c4b28a',             bold = true })
end

-- Register a signal handler for SIGUSR1 (matugen updates).
-- The handler re-requires this module, which re-runs the code below, so the
-- previous handle is stopped first; otherwise handlers double on every signal.
if _G.__matugen_signal then
  _G.__matugen_signal:stop()
  _G.__matugen_signal:close()
end

local signal = vim.uv.new_signal()
_G.__matugen_signal = signal
signal:start(
  'sigusr1',
  vim.schedule_wrap(function()
    package.loaded['matugen'] = nil
    require('matugen').setup()
  end)
)

return M
