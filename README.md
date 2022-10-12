# Keep-Simple dotfiles for Macos

![desktop pic](https://i.imgur.com/lc1gM44.jpg)

## Requirements

You will need `git` and GNU `stow`

```bash
brew install git stow
```

## Installing config files

Clone into your home directory and run the install script

```bash
git clone git@github.com:Keep-Simple/.dotfiles.git ~
cd ~/.dotfiles
./macos-dotfiles
```

## Full install (with config)

```bash
bash <(curl -s https://raw.githubusercontent.com/Keep-Simple/.dotfiles/macos/full-install)
```

[Funny tutorial about stow](https://www.youtube.com/watch?v=tkUllCAGs3c)
