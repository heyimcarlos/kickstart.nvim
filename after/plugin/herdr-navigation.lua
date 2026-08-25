-- Seamless <C-h/j/k/l> between Neovim splits and herdr panes
-- (vim-tmux-navigator, ported to herdr).
--
-- Editor side of paulbkim-dev/vim-herdr-navigation. The herdr side is
-- installed by dotfiles/install.sh (`herdr plugin install`) and bound to
-- ctrl+h/j/k/l in ~/.config/herdr/config.toml. Loading from after/plugin
-- ensures these mappings win over LazyVim's default <C-h/j/k/l> window nav.
--
-- The herdr checkout path carries a content hash, so resolve it via glob
-- and survive plugin updates. Falls back silently when herdr (or the
-- plugin) is absent; the file also degrades to tmux/wincmd on its own.
local matches = vim.fn.glob(
  vim.fn.expand("~/.config/herdr/plugins/github/vim-herdr-navigation-*/editor/nvim.lua"),
  true,
  true
)
if #matches > 0 then
  dofile(matches[#matches])
end
