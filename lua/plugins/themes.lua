return {
  {
    "Mofiqul/vscode.nvim",
    config = function()
      -- Configurer le thème VSCode
      local c = require("vscode.colors").get_colors()
      require("vscode").setup({
        transparent = false, -- Ne pas utiliser de fond transparent
        italic_comments = true, -- Activer les commentaires en italique
        disable_nvimtree_bg = true, -- Désactiver le fond pour NvimTree
        color_overrides = {
          vscLineNumber = "#383a37", -- Ajuste la couleur des numéros de ligne
          vscBack = "#1e1e1e",
        },
        group_overrides = {
          -- Personnalise la couleur des numéros de ligne et de l'indentation
          LineNr = { fg = "#383a37" }, -- Numéros de ligne normaux
          CursorLineNr = { fg = "#90968d" }, -- Numéro de ligne actuel (curseur)
          IndentBlanklineChar = { fg = "#383a37" }, -- Lignes d'indentation
        },
      })
      -- Charger le thème
      require("vscode").load("dark")
    end,
  },
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v2.x",
    requires = { "nvim-lua/plenary.nvim", "nvim-tree/nvim-web-devicons", "MunifTanjim/nui.nvim" },
    config = function()
      local vscode_colors = require("vscode.colors").get_colors()

      require("neo-tree").setup({
        window = {
          position = "left",
          width = 40,
          -- Personnalisation des couleurs
          highlight = {
            Background = { fg = "white", bg = "#191919" },
          },
        },
        default = {
          highlight = {
            -- Assigner la couleur de l'indentation pour NeoTree
            NeoTreeIndentMarker = { fg = vscode_colors.vscLineNumber }, -- Couleur des marqueurs d'indentation
          },
        },
      })

      -- Ajuster les groupes de mise en surbrillance si nécessaire
      vim.cmd([[
        highlight NeoTreeNormal guibg=#191919
        highlight NeoTreeNormalNC guibg=#191919
        highlight NeoTreeIndentMarker guifg=#383a37
      ]])
    end,
  },
}
