return {
  -- LazyVim pour la gestion des plugins
  "folke/lazy.nvim",

  "HelifeWasTaken/VimTek",
  -- Plugin pour l'autocomplétion et LSP
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "onsails/lspkind-nvim",
    },
    config = function()
      local cmp = require("cmp")
      local lspkind = require("lspkind")

      cmp.setup({
        snippet = {
          expand = function(args)
            vim.fn["vsnip#anonymous"](args.body) -- Utiliser vsnip pour les snippets
          end,
        },
        formatting = {
          format = lspkind.cmp_format({
            with_text = true,
            menu = {
              buffer = "[Buffer]",
              nvim_lsp = "[LSP]",
              path = "[Path]",
            },
          }),
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-n>"] = cmp.mapping.select_next_item(), -- Sélectionner l'élément suivant
          ["<C-p>"] = cmp.mapping.select_prev_item(), -- Sélectionner l'élément précédent
          ["<C-d>"] = cmp.mapping.scroll_docs(-4), -- Défilement des documents
          ["<C-f>"] = cmp.mapping.scroll_docs(4), -- Défilement des documents
          ["<C-Space>"] = cmp.mapping.complete(), -- Activer la complétion
          ["<C-e>"] = cmp.mapping.abort(), -- Annuler la complétion
          ["<CR>"] = cmp.mapping.confirm({ select = true }), -- Confirmer la sélection
        }),
        sources = cmp.config.sources({
          { name = "nvim_lsp" }, -- Source LSP
          { name = "buffer" }, -- Source buffer
          { name = "path" }, -- Source path
        }),
        completion = {
          keyword_length = 1, -- Longueur minimale du mot pour la complétion
        },
        experimental = {
          ghost_text = false, -- Désactiver le texte fantôme
        },
        preselect = cmp.PreselectMode.None, -- Aucune pré-sélection
      })
    end,
  },

  -- Plugin pour la configuration LSP
  {
    "neovim/nvim-lspconfig",
    config = function()
      local lspconfig = require("lspconfig")

      -- Configuration pour clangd
      lspconfig["clangd"].setup({
        on_attach = function(client, bufnr)
          local bufopts = { noremap = true, silent = true, buffer = bufnr }
          -- Raccourcis clavier pour les fonctionnalités LSP
          vim.keymap.set("n", "gd", vim.lsp.buf.definition, bufopts)
          vim.keymap.set("n", "K", vim.lsp.buf.hover, bufopts)
          vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, bufopts)
          vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, bufopts)
          vim.keymap.set("n", "gr", vim.lsp.buf.references, bufopts)
        end,
        cmd = { "clangd" }, -- Assure-toi que clangd est installé et accessible
        root_dir = function(fname)
          return lspconfig.util.root_pattern("compile_flags.txt", "compile_commands.json", ".git")(fname)
        end,
      })

      -- Liste des serveurs LSP à configurer
      local servers = {
        "tsserver",
        "pyright",
        "rust_analyzer",
        "sqls",
        "tailwindcss",
        "cssls", -- Vérifiez si "cssls" est correct dans la documentation officielle
      }

      -- Configurer chaque serveur LSP
      for _, lsp in ipairs(servers) do
        lspconfig[lsp].setup({
          on_attach = function(client, bufnr)
            local bufopts = { noremap = true, silent = true, buffer = bufnr }
            -- Raccourcis clavier pour les fonctionnalités LSP
            vim.keymap.set("n", "gd", vim.lsp.buf.definition, bufopts)
            vim.keymap.set("n", "K", vim.lsp.buf.hover, bufopts)
            vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, bufopts)
            vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, bufopts)
            vim.keymap.set("n", "gr", vim.lsp.buf.references, bufopts)
          end,
        })
      end
    end,
  },
  {
    "jose-elias-alvarez/null-ls.nvim",
    config = function()
      local null_ls = require("null-ls")
      local group = vim.api.nvim_create_augroup("lsp_format_on_save", { clear = true })

      null_ls.setup({
        sources = {
          null_ls.builtins.formatting.prettier,
        },
        on_attach = function(client, bufnr)
          if client.supports_method("textDocument/formatting") then
            vim.keymap.set("n", "<Leader>f", function()
              vim.lsp.buf.format({ bufnr = vim.api.nvim_get_current_buf() })
            end, { buffer = bufnr, desc = "[lsp] format" })

            -- Format on save
            vim.api.nvim_clear_autocmds({ buffer = bufnr, group = group })
            vim.api.nvim_create_autocmd("BufWritePre", {
              buffer = bufnr,
              group = group,
              callback = function()
                vim.lsp.buf.format({ bufnr = bufnr, async = true })
              end,
              desc = "[lsp] format on save",
            })
          end
        end,
      })
    end,
  },
  -- Prettier
  {
    "MunifTanjim/prettier.nvim",
    config = function()
      local prettier = require("prettier")

      prettier.setup({
        bin = "prettier", -- ou `'prettierd'` (v0.23.3+)
        filetypes = {
          "css",
          "graphql",
          "html",
          "javascript",
          "javascriptreact",
          "json",
          "less",
          "markdown",
          "scss",
          "typescript",
          "typescriptreact",
          "yaml",
        },
        ["null-ls"] = {
          condition = function()
            return prettier.config_exists({
              check_package_json = true,
            })
          end,
          runtime_condition = function(params)
            return true
          end,
          timeout = 5000,
        },
        cli_options = {
          arrow_parens = "always",
          bracket_spacing = true,
          bracket_same_line = false,
          embedded_language_formatting = "auto",
          end_of_line = "lf",
          html_whitespace_sensitivity = "css",
          jsx_single_quote = false,
          print_width = 80,
          prose_wrap = "preserve",
          quote_props = "as-needed",
          semi = true,
          single_attribute_per_line = false,
          single_quote = false,
          tab_width = 2,
          trailing_comma = "es5",
          use_tabs = false,
          vue_indent_script_and_style = false,
        },
        cli_options = {
          config_precedence = "prefer-file", -- ou "cli-override" ou "file-override"
        },
      })
    end,
  },
  -- Configure telescope
  {
    "nvim-telescope/telescope.nvim",
    requires = { "nvim-lua/plenary.nvim" },
    keys = {
      {
        "<leader>fp",
        function()
          require("telescope.builtin").find_files({ cwd = require("lazy.core.config").options.root })
        end,
        desc = "Find Plugin File",
      },
    },
    opts = {
      defaults = {
        layout_strategy = "horizontal", -- Stratégie de mise en page horizontale
        layout_config = { prompt_position = "top" }, -- Position du prompt en haut
        sorting_strategy = "ascending", -- Tri croissant des résultats
        winblend = 0, -- Transparence de la fenêtre
      },
    },
  },

  -- Configure treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, {
        "tsx",
        "typescript",
        "python",
        "c",
        "cpp",
        "rust",
        "sql",
        "json",
        "json5",
        "jsonc",
      })
    end,
  },

  -- Plugin pour la gestion des outils
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        "stylua",
        "shellcheck",
        "shfmt",
        "flake8",
      },
    },
  },

  -- Plugin pour la gestion des configurations LSP avec Mason
  {
    "williamboman/mason-lspconfig.nvim",
    after = "mason.nvim",
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = {
          "tsserver",
          "tailwindcss",
          "cssls", -- Vérifiez si "cssls" est correct
          "pyright",
          "clangd",
          "rust_analyzer",
          "sqls",
        },
      })
    end,
  },
}
