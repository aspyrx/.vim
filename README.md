# .vim
My Vim configuration. Works with Vim, but some plugins require [Neovim][neovim].

### Installation
1. Clone the repository: `git clone https://github.com/aspyrx/.vim ~/.vim`
2. Symlink `~/.vimrc` to the `.vimrc` in this repository:
   `ln -s ~/.vim/.vimrc ~/.vimrc`
3. `cd ~/.vim`
4. Fetch the dependency plugins: `git submodule update --init --recursive`

If you're using Neovim, then you should also symlink your Neovim configuration
directory (by default, `~/.config/nvim`) to `~/.vim`.

### Screenshot
![Screenshot](screenshot.png)

The font is [Fira Code](https://github.com/tonsky/FiraCode). Note that a font
that supports/is patched with the powerline symbols is recommended.

[neovim]: https://github.com/neovim/neovim "neovim on GitHub"

