# linux_setup

Automated Linux development environment setup script for Ubuntu/Debian systems.

> [!WARNING]
> This is designed to run on a *CLEAN* system. Some parts may work on an existing
> setup, some parts may not work, and some parts may break your existing setup.

## Quick Start

```bash
# Clone the repository
git clone <repository-url> ~/linux_setup
cd ~/linux_setup

# Run the full setup
./setup.sh

# Or customize the installation
./setup.sh --skip-tailscale --skip-fonts
```

> [!NOTE]
> If you use Neovim, on first launch it will install all of the plugins. One of these
> `calc.nvim` requires some additional setup. View the [Github Page](https://github.com/lcford2/calc.nvim)
> for detailed instructions, but essentially all that is required is
> running `:UpdateRemotePlugins` in nvim and then exiting and re-opening nvim.


## What Gets Installed

The script installs and configures:

- **System packages**: Build tools, curl, git, zsh, tmux, python3, stow, and more
- **Homebrew**: Linux package manager with neovim, htop, jq, and tmux
- **Node.js**: via NVM for Neovim LSP support
- **Rust**: via rustup for building modern CLI utilities
- **Modern utilities**: fzf, bat, eza, ripgrep, fd-find, zoxide, starship, delta, dust, procs, tealdeer, alacritty
- **NerdFonts**: DejaVuSansMono, UbuntuMono, Ubuntu, and Hack
- **Tmux Plugin Manager (TPM)**: Plugin manager for tmux
- **Tailscale**: VPN mesh network
- **Zsh with Zap**: Modern shell with plugin manager
- **Dotfiles**: Linked via GNU stow

## Usage

```bash
./setup.sh [OPTIONS]
```

### Options

| Option | Description |
|--------|-------------|
| `-h, --help` | Show help message and exit |
| `--skip-brew` | Skip Homebrew and its packages installation |
| `--skip-node` | Skip Node.js/NVM installation |
| `--skip-rust` | Skip Rust/rustup installation |
| `--skip-fonts` | Skip NerdFonts installation |
| `--skip-tmux` | Skip Tmux Plugin Manager installation |
| `--skip-tailscale` | Skip Tailscale installation |
| `--skip-modern-utils` | Skip modern CLI utilities (bat, eza, ripgrep, etc.) |
| `--nvm-version=VERSION` | Specify NVM version to install (default: v0.39.7) |

### Examples

**Skip network-related tools:**
```bash
./setup.sh --skip-tailscale
```

**Minimal development setup (skip fonts and VPN):**
```bash
./setup.sh --skip-fonts --skip-tailscale
```

**Install with a specific NVM version:**
```bash
./setup.sh --nvm-version=v0.40.0
```


**Quick workstation setup (skip rust utilities):**
```bash
./setup.sh --skip-modern-utils --skip-rust
```

**Combine multiple options:**
```bash
./setup.sh --skip-fonts --skip-tailscale --skip-tmux --nvm-version=v0.39.7
```

## What Runs Unconditionally

These core setup steps always run regardless of flags:

- System package updates (`apt update && apt upgrade`)
- Git submodule initialization
- Directory structure creation (`~/source`, `~/projects`, `~/.config`, `~/.local/bin`, `~/.fonts`)
- Dotfile configuration (via stow)
- Script linking to `~/.local/bin`
- Zsh installation and setup with Zap

## Post-Installation

1. Restart your terminal or source your shell configuration
2. For tmux plugins: Launch tmux and press `prefix + I` to install TPM plugins
3. For Tailscale: Run `sudo tailscale up` to connect to your network
4. Neovim LSPs will be configured automatically on first launch

## Requirements

- Ubuntu/Debian-based Linux distribution
- Sudo privileges
- Internet connection

## Directory Structure

```
~/linux_setup/
├── setup.sh              # Main setup script
├── dotfiles/             # Configuration files (managed by stow)
│   └── .config/          # Application configs
├── scripts/              # Custom scripts (linked to ~/.local/bin)
└── README.md             # This file
```
