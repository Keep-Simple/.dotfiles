# Keep-Simple .dotfiles

![desktop pic](https://imgur.com/jHYCYtr.png)

## Installing configs

You will need `git` and GNU `stow`

Clone into your `$HOME` directory or `~`

```bash
git clone git@github.com:Keep-Simple/.dotfiles.git ~
```
Remove `personal` folder and `.gitmodules`

If using `Arch`, run this script to symlink everything 
```bash
./archlinux
```
Otherwise copy this script to add/remove program's configs.
[Funny tutorial](https://www.youtube.com/watch?v=tkUllCAGs3c)

## Installing Programs (only for `Arch` users)

Install `packup` from aur
```bash
yay packup
```
start in sudo mode:
```bash
sudo packup
```
Use it to install all `pacman` packages
