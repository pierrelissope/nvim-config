return {
  "akinsho/bufferline.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    require("bufferline").setup({
      options = {
        mode = "buffers", -- Utilisation de "buffers" (plutôt que "tabs") pour naviguer
        numbers = "none", -- Désactiver les numéros d'onglets
        close_command = "bdelete! %d", -- Fermer le buffer avec `bdelete`
        right_mouse_command = "bdelete! %d", -- Fermer avec le clic droit
        buffer_close_icon = "", -- Icône de fermeture
        close_icon = "", -- Icône globale de fermeture
        modified_icon = "●", -- Icône pour les buffers modifiés
        left_trunc_marker = "", -- Marqueur pour les onglets tronqués à gauche
        right_trunc_marker = "", -- Marqueur pour les onglets tronqués à droite
        max_name_length = 18, -- Limiter la longueur des noms d'onglets
        max_prefix_length = 15, -- Limiter la longueur des préfixes
        tab_size = 20, -- Taille des onglets
        diagnostics = "nvim_lsp", -- Intégrer les diagnostics LSP
        diagnostics_indicator = function(count, level, diagnostics_dict, context)
          local icon = level:match("error") and " " or " "
          return " " .. icon .. count
        end,
        offsets = {
          { filetype = "NvimTree", text = "EXPLORER", text_align = "center", padding = 1 },
        },
        show_buffer_icons = true, -- Afficher les icônes des fichiers
        show_buffer_close_icons = true, -- Afficher les icônes de fermeture de chaque buffer
        show_close_icon = false, -- Désactiver l'icône de fermeture globale
        separator_style = "slant", -- Style de séparateur: "slant", "thick", "thin", etc.
        always_show_bufferline = true, -- Toujours afficher la ligne de buffer
      },
      highlights = {
        fill = {
          fg = { attribute = "fg", highlight = "Normal" },
          bg = { attribute = "bg", highlight = "StatusLineNC" },
        },
        background = {
          fg = { attribute = "fg", highlight = "Comment" },
          bg = { attribute = "bg", highlight = "StatusLine" },
        },
        buffer_visible = {
          fg = { attribute = "fg", highlight = "Normal" },
          bg = { attribute = "bg", highlight = "Normal" },
        },
        buffer_selected = {
          fg = { attribute = "fg", highlight = "Normal" },
          bg = { attribute = "bg", highlight = "Normal" },
          bold = true, -- Utiliser le gras pour l'onglet actif
          italic = false,
        },
        separator = {
          fg = { attribute = "bg", highlight = "StatusLine" },
          bg = { attribute = "bg", highlight = "StatusLine" },
        },
        separator_selected = {
          fg = { attribute = "bg", highlight = "StatusLine" },
          bg = { attribute = "bg", highlight = "StatusLine" },
        },
        separator_visible = {
          fg = { attribute = "bg", highlight = "StatusLine" },
          bg = { attribute = "bg", highlight = "StatusLine" },
        },
        modified = {
          fg = "#e5c07b", -- Couleur pour les buffers modifiés
          bg = { attribute = "bg", highlight = "StatusLine" },
        },
        modified_visible = {
          fg = "#e5c07b",
          bg = { attribute = "bg", highlight = "StatusLine" },
        },
        modified_selected = {
          fg = "#e5c07b",
          bg = { attribute = "bg", highlight = "StatusLine" },
        },
      },
    })
  end,
}
