### Introduction

A starting point for neovim that is:

* Small (~325 lines)
* Single-file
* Documented
* Modular

Starter targets *only* the latest stable neovim release (0.8.3) and the nightly.

This repo is meant to be used as a starting point for a user's own configuration; remove the things you don't use and add what you miss.

See the [wiki](https://github.com/mjlbach/starter.nvim/wiki) for additional tips, tricks, and recommended plugins.

### Installation
* Backup your previous configuration
* Copy and paste the starter.nvim `init.lua` into `$HOME/.config/nvim/init.lua`
* start neovim (`nvim`)

### Contribution

Pull-requests are welcome. The goal of this repo is not to create a neovim configuration framework, but to offer a starting template that shows, by example, available features in neovim. Some things that will not be included:

* Custom language server configuration (null-ls templates)
* Theming beyond a default colorscheme necessary for LSP highlight groups
* Lazy-loading. Starter.nvim should start within 40 ms on modern hardware. Please profile and contribute to upstream plugins to optimize startup time instead.

Each PR, especially those which increase the line count, should have a description as to why the PR is necessary.
