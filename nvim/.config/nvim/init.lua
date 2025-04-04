-- Install package manager
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Remap space as leader key
vim.keymap.set({ "n", "v" }, "<Space>", "<Nop>", { silent = true })
vim.g.mapleader = " "
vim.g.maplocalleader = " "

local onFileEvent = { "BufReadPost", "BufWritePost", "BufNewFile" }

-- Add plugins
require("lazy").setup({
  "tpope/vim-fugitive",                                          -- Git commands in nvim
  "tpope/vim-rhubarb",                                           -- Fugitive-companion to interact with github
  { "numToStr/Comment.nvim", event = onFileEvent, lazy = true }, -- "gc" to comment visual regions/lines
  { "stevearc/oil.nvim" },
  "navarasu/onedark.nvim",                                       -- Colorscheme
  "nvim-lualine/lualine.nvim",                                   -- Fancier statusline
  "tpope/vim-surround",
  -- Add indentation guides even on blank lines
  "lukas-reineke/indent-blankline.nvim",
  -- Add git related info in the signs columns and popups
  { "lewis6991/gitsigns.nvim",                     event = onFileEvent, lazy = true },
  { "nvim-treesitter/nvim-treesitter",             event = onFileEvent, lazy = true }, -- Highlight, edit, and navigate code
  { "nvim-treesitter/nvim-treesitter-textobjects", event = onFileEvent, lazy = true }, -- Additional textobjects for treesitter
  "neovim/nvim-lspconfig",                                                             -- Collection of configurations for built-in LSP client
  "williamboman/mason.nvim",                                                           -- Automatically install LSPs to stdpath for neovim
  "williamboman/mason-lspconfig.nvim",                                                 -- ibid
  "folke/neodev.nvim",                                                                 -- Lua language server configuration for nvim
  {                                                                                    -- Autocompletion
    "hrsh7th/nvim-cmp",
    dependencies = { "hrsh7th/cmp-nvim-lsp", "L3MON4D3/LuaSnip", "saadparwaiz1/cmp_luasnip" },
    event = onFileEvent,
    lazy = true,
  },
  -- Fuzzy Finder (files, lsp, etc)
  { "nvim-telescope/telescope.nvim", version = "*", dependencies = { "nvim-lua/plenary.nvim" } },
  {
    "nvim-telescope/telescope-fzf-native.nvim",
    -- NOTE: If you have trouble with this installation, refer to the README for telescope-fzf-native.
    build = "make",
  },
  {
    "folke/trouble.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    branch = "main",
    --[[ event = onFileEvent, ]]
    keys = {
      {
        "<leader>xx",
        "<cmd>Trouble diagnostics toggle<cr>",
        desc = "Diagnostics (Trouble)",
      },
      {
        "<leader>xX",
        "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
        desc = "Buffer Diagnostics (Trouble)",
      },
      {
        "<leader>cs",
        "<cmd>Trouble symbols toggle focus=false<cr>",
        desc = "Symbols (Trouble)",
      },
      {
        "<leader>cl",
        "<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
        desc = "LSP Definitions / references / ... (Trouble)",
      },
      {
        "<leader>xL",
        "<cmd>Trouble loclist toggle<cr>",
        desc = "Location List (Trouble)",
      },
      {
        "<leader>xQ",
        "<cmd>Trouble qflist toggle<cr>",
        desc = "Quickfix List (Trouble)",
      },
    },
    opts = {
      -- your configuration comes here
      -- or leave it empty to use the default settings
      -- refer to the configuration section below
    },
  },
  {
    "folke/which-key.nvim",
  },
  {
    "stevearc/conform.nvim",
    event = onFileEvent,
    lazy = true,
    opts = {
      formatters_by_ft = {
        lua = { "stylua" },
        -- Use a sub-list to run only the first available formatter
        javascript = { "prettierd", "eslint_d" },
        typescript = { "prettierd", "eslint_d" },
      },
      format_on_save = {
        -- These options will be passed to conform.format()
        timeout_ms = 500,
        lsp_fallback = true,
      },
    },
  },
  { "mfussenegger/nvim-lint",        lazy = true },
  { "github/copilot.vim" },
  {
    "christoomey/vim-tmux-navigator",
    vim.keymap.set("n", "<C-h>", ":TmuxNavigateLeft<CR>", { desc = "Navigate Left" }),
    vim.keymap.set("n", "<C-l>", ":TmuxNavigateRight<CR>", { desc = "Navigate Right" }),
    vim.keymap.set("n", "<C-j>", ":TmuxNavigateDown<CR>", { desc = "Navigate Down" }),
    vim.keymap.set("n", "<C-k>", ":TmuxNavigateUp<CR>", { desc = "Navigate Up" }),
  },
  {
    "vim-test/vim-test",
    event = onFileEvent,
    lazy = true,
    vim.keymap.set("n", "<leader>tt", ":TestFile<CR>", { desc = "Run tests" }),
  },
})

-- Oil - default keymaps but override horizontal split for compatibility with tmux
require("oil").setup({
  keymaps = {
    ["g?"] = { "actions.show_help", mode = "n" },
    ["<CR>"] = "actions.select",
    ["<C-s>"] = { "actions.select", opts = { vertical = true } },
    ["<C-f>"] = { "actions.select", opts = { horizontal = true } },
    ["<C-t>"] = { "actions.select", opts = { tab = true } },
    ["<C-p>"] = "actions.preview",
    ["<C-c>"] = { "actions.close", mode = "n" },
    ["<C-l>"] = "actions.refresh",
    ["-"] = { "actions.parent", mode = "n" },
    ["_"] = { "actions.open_cwd", mode = "n" },
    ["`"] = { "actions.cd", mode = "n" },
    ["~"] = { "actions.cd", opts = { scope = "tab" }, mode = "n" },
    ["gs"] = { "actions.change_sort", mode = "n" },
    ["gx"] = "actions.open_external",
    ["g."] = { "actions.toggle_hidden", mode = "n" },
    ["g\\"] = { "actions.toggle_trash", mode = "n" },
  },
  use_default_keymaps = false
})
vim.keymap.set("n", "-", function()
  require("oil").open()
end, { desc = "Open parent directory" })

local lint = require("lint")

lint.linters_by_ft = {
  javascript = { "eslint_d" },
  typescript = { "eslint_d" }
}
-- execute the linter after reading the file and after writing the file
vim.api.nvim_create_autocmd({ "BufReadPost", "BufWritePost" }, {
  callback = function()
    lint.try_lint()
  end,
})

-- Set highlight on search
vim.o.hlsearch = false

-- Make line numbers default
vim.wo.number = true

-- Enable mouse mode
vim.o.mouse = "a"

-- Enable break indent
vim.o.breakindent = true

-- Save undo history
vim.opt.undofile = true

-- Case insensitive searching UNLESS /C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

-- Keep signcolumn on by default
vim.wo.signcolumn = "yes"

-- Decrease update time
vim.o.updatetime = 250

-- Set completeopt to have a better completion experience
vim.o.completeopt = "menuone,noselect"

-- Set colorscheme (order is important here)
vim.o.termguicolors = true
vim.cmd.colorscheme("onedark")

-- Set statusbar
require("lualine").setup({
  options = {
    icons_enabled = false,
    theme = "onedark",
    component_separators = "|",
    section_separators = "",
  },
})

-- Enable Comment.nvim
require("Comment").setup()

-- keymaps for window navigation
vim.keymap.set("n", "<A-h>", [[<Cmd>wincmd h<CR>]])
vim.keymap.set("n", "<A-j>", [[<Cmd>wincmd j<CR>]])
vim.keymap.set("n", "<A-k>", [[<Cmd>wincmd k<CR>]])
vim.keymap.set("n", "<A-l>", [[<Cmd>wincmd l<CR>]])

-- Remap for dealing with word wrap
vim.keymap.set("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- Highlight on yank
local highlight_group = vim.api.nvim_create_augroup("YankHighlight", { clear = true })
vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = "*",
})

-- Add indent guides
require("ibl").setup({
  indent = { char = "┊" },
  whitespace = { remove_blankline_trail = false },
})

-- Gitsigns
require("gitsigns").setup({
  on_attach = function(bufnr)
    vim.keymap.set("n", "[c", require("gitsigns").prev_hunk, { buffer = bufnr })
    vim.keymap.set("n", "]c", require("gitsigns").next_hunk, { buffer = bufnr })
  end,
})

-- Telescope
require("telescope").setup({
  defaults = {
    mappings = {
      i = {
        ["<C-u>"] = false,
        ["<C-d>"] = false,
      },
    },
  },
})

-- Enable telescope fzf native
require("telescope").load_extension("fzf")

-- Add leader shortcuts
vim.keymap.set("n", "<leader><space>", function()
  require("telescope.builtin").buffers({ sort_lastused = true })
end)
vim.keymap.set("n", "<leader>pf", function()
  require("telescope.builtin").find_files({ previewer = false })
end)
vim.keymap.set("n", "<C-p>", function()
  require("telescope.builtin").git_files({ previewer = false })
end)
vim.keymap.set("n", "<leader>sb", function()
  require("telescope.builtin").current_buffer_fuzzy_find()
end)
vim.keymap.set("n", "<leader>sh", function()
  require("telescope.builtin").help_tags()
end)
vim.keymap.set("n", "<leader>st", function()
  require("telescope.builtin").tags()
end)
vim.keymap.set("n", "<leader>ps", function()
  require("telescope.builtin").grep_string({ search = vim.fn.input("Grep > ") })
end)
vim.keymap.set("n", "<leader>pWs", function()
  local word = vim.fn.expand("<cWORD>")
  require("telescope.builtin").grep_string({ search = word })
end)
vim.keymap.set("n", "<leader>sp", function()
  require("telescope.builtin").live_grep()
end)
vim.keymap.set("n", "<leader>?", function()
  require("telescope.builtin").oldfiles()
end)
vim.keymap.set("n", "<leader>gb", function()
  require("telescope.builtin").git_branches()
end)

-- Treesitter configuration
-- Parsers must be installed manually via :TSInstall
require("nvim-treesitter.configs").setup({
  ensure_installed = { "javascript", "typescript", "python" },
  sync_install = false,
  auto_install = true,
  highlight = {
    enable = true, -- false will disable the whole extension
  },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = "<c-space>",
      node_incremental = "<c-space>",
      scope_incremental = "<c-s>",
      node_decremental = "<M-space>",
    },
  },
  indent = {
    enable = true,
  },
  textobjects = {
    select = {
      enable = true,
      lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
      keymaps = {
        -- You can use the capture groups defined in textobjects.scm
        ["aa"] = "@parameter.outer",
        ["ia"] = "@parameter.inner",
        ["af"] = "@function.outer",
        ["if"] = "@function.inner",
        ["ac"] = "@class.outer",
        ["ic"] = "@class.inner",
      },
    },
    move = {
      enable = true,
      set_jumps = true, -- whether to set jumps in the jumplist
      goto_next_start = {
        ["]m"] = "@function.outer",
        ["]]"] = "@class.outer",
      },
      goto_next_end = {
        ["]M"] = "@function.outer",
        ["]["] = "@class.outer",
      },
      goto_previous_start = {
        ["[m"] = "@function.outer",
        ["[["] = "@class.outer",
      },
      goto_previous_end = {
        ["[M"] = "@function.outer",
        ["[]"] = "@class.outer",
      },
    },
    swap = {
      enable = true,
      swap_next = {
        ["<leader>a"] = "@parameter.inner",
      },
      swap_previous = {
        ["<leader>A"] = "@parameter.inner",
      },
    },
  },
})

-- Diagnostic settings
vim.diagnostic.config({
  virtual_text = false,
  update_in_insert = true,
  severity_sort = true,
  signs = {
    text = {
      [vim.diagnostic.severity.HINT] = "⚑",
      [vim.diagnostic.severity.INFO] = "",
      [vim.diagnostic.severity.WARN] = "▲",
      [vim.diagnostic.severity.ERROR] = "✘",
    },
  },
  float = {
    border = "rounded",
  },
})

-- Diagnostic keymaps
vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float)
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev)
vim.keymap.set("n", "]d", vim.diagnostic.goto_next)
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist)
vim.keymap.set("n", "<leader>Q", vim.diagnostic.setqflist)

-- LSP settings
require("mason").setup({})
require("mason-lspconfig").setup()

-- Add nvim-lspconfig plugin
local lspconfig = require("lspconfig")
local on_attach = function(_, bufnr)
  local attach_opts = { silent = true, buffer = bufnr }
  vim.keymap.set("n", "gD", vim.lsp.buf.declaration, attach_opts)
  vim.keymap.set("n", "gd", vim.lsp.buf.definition, attach_opts)
  vim.keymap.set("n", "K", vim.lsp.buf.hover, attach_opts)
  vim.keymap.set("n", "gi", vim.lsp.buf.implementation, attach_opts)
  vim.keymap.set("n", "<C-s>", vim.lsp.buf.signature_help, attach_opts)
  vim.keymap.set("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, attach_opts)
  vim.keymap.set("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, attach_opts)
  vim.keymap.set("n", "<leader>wl", function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, attach_opts)
  vim.keymap.set("n", "<leader>D", vim.lsp.buf.type_definition, attach_opts)
  vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, attach_opts)
  vim.keymap.set("n", "so", require("telescope.builtin").lsp_references, attach_opts)
end

-- nvim-cmp supports additional completion capabilities
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

-- Enable the following language servers
local servers = { "pyright", "vtsls" }
for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup({
    on_attach = on_attach,
    capabilities = capabilities,
  })
end

require("neodev").setup({})

lspconfig.lua_ls.setup({
  on_attach = on_attach,
  capabilities = capabilities,
  settings = {
    Lua = {
      completion = {
        callSnippet = "Replace",
      },
    },
  },
})

-- nvim-cmp setup
local cmp = require("cmp")
local luasnip = require("luasnip")

luasnip.config.setup({})

cmp.setup({
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ["<C-d>"] = cmp.mapping.scroll_docs(-4),
    ["<C-f>"] = cmp.mapping.scroll_docs(4),
    ["<C-Space>"] = cmp.mapping.complete({}),
    ["<CR>"] = cmp.mapping.confirm({
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    }),
    ["<Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end, { "i", "s" }),
    ["<S-Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { "i", "s" }),
  }),
  sources = {
    { name = "nvim_lsp" },
    { name = "luasnip" },
  },
})

vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
-- vim: ts=2 sts=2 sw=2 et
