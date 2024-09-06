-- ~/.config/nvim/lua/plugins.lua ou similaire

return {
  -- LazyVim pour la gestion des plugins
  "folke/lazy.nvim",

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
            vim.fn["vsnip#anonymous"](args.body)
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
          ["<C-n>"] = cmp.mapping.select_next_item(),
          ["<C-p>"] = cmp.mapping.select_prev_item(),
          ["<C-d>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<C-e>"] = cmp.mapping.abort(),
          ["<CR>"] = cmp.mapping.confirm({ select = true }),
        }),
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "buffer" },
          { name = "path" },
        }),
        completion = {
          keyword_length = 1,
        },
        experimental = {
          ghost_text = false,
        },
        preselect = cmp.PreselectMode.None,
      })
    end,
  },

  -- Plugin pour la configuration LSP
  {
    "neovim/nvim-lspconfig",
    config = function()
      local lspconfig = require("lspconfig")

      lspconfig["clangd"].setup({
        on_attach = function(client, bufnr)
          local bufopts = { noremap = true, silent = true, buffer = bufnr }
          vim.keymap.set("n", "gd", vim.lsp.buf.definition, bufopts)
          vim.keymap.set("n", "K", vim.lsp.buf.hover, bufopts)
          vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, bufopts)
          vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, bufopts)
          vim.keymap.set("n", "gr", vim.lsp.buf.references, bufopts)
        end,
        cmd = { "clangd" }, -- Assure-toi que clangd recherche dans le bon répertoire
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
        "eslint",
        "tailwindcss",
        "cssls", -- Vérifiez si "cssls" est correct dans la documentation officielle
      }

      -- Configurer chaque serveur LSP
      for _, lsp in ipairs(servers) do
        lspconfig[lsp].setup({
          on_attach = function(client, bufnr)
            local bufopts = { noremap = true, silent = true, buffer = bufnr }
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
        layout_strategy = "horizontal",
        layout_config = { prompt_position = "top" },
        sorting_strategy = "ascending",
        winblend = 0,
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
          "eslint",
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
