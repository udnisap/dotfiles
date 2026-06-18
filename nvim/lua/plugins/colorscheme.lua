return {
  -- Solarized Dark to match tmux (tmux-colors-solarized 'dark')
  {
    "maxmx03/solarized.nvim",
    lazy = false,
    priority = 1000,
    ---@type solarized.config
    opts = {
      variant = "winter", -- "spring" | "summer" | "autumn" | "winter"
      transparent = {
        enabled = false,
      },
    },
  },

  -- Tell LazyVim to use it
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "solarized",
    },
  },
}
