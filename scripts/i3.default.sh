#!/bin/bash

# Variables.
# $THEMENAME: Theme name
# $WM: Windows Manager (i3)
# $GPU: System GPU brand (nvidia)
# VMENGINE: virtualization (vmware)

THEMENAME="example"
GPU="nvidia"
WM="i3"
VMENGINE="vmware"
PICOMURL="https://raw.githubusercontent.com/dontdoxxmeplz/dotfiles-collection/main/picom/picom.conf.shadows"
WALLPAPERURL="https://github.com/dontdoxxmeplz/wallpapers/raw/main/wall59.jpg"
COLORSCHEMEURL="https://raw.githubusercontent.com/dontdoxxmeplz/dotfiles-collection/main/urxvt/Xresources.nightburns"
ZSHRCURL="https://raw.githubusercontent.com/dontdoxxmeplz/dotfiles-collection/main/zsh/zshrc.default"
P10KURL="https://raw.githubusercontent.com/dontdoxxmeplz/dotfiles-collection/main/zsh/p10k.zsh"
ZPROFILEURL="https://raw.githubusercontent.com/dontdoxxmeplz/dotfiles-collection/main/zsh/zprofile.default"
ZSHENVURL="https://raw.githubusercontent.com/dontdoxxmeplz/dotfiles-collection/main/zsh/zshenv.default"
ROFIURL="https://raw.githubusercontent.com/dontdoxxmeplz/dotfiles-collection/main/rofi/rofi.rasi.dracula.purple"
I3CONFIGURL="https://raw.githubusercontent.com/dontdoxxmeplz/dotfiles-collection/main/i3wm/config.default"
ALIASESURL="https://raw.githubusercontent.com/dontdoxxmeplz/aliases/main/aliases"
YAYURL="https://aur.archlinux.org/yay.git"
CURRENTUSER=$USER

git config --global user.email "anon@anon.com" && git config --global user.name "anon"

sudo pacman -Suuy -q --noconfirm && sudo pacman -S git curl python3 python-pip pacman-contrib go base-devel neovim -q --noconfirm
sudo wget https://github.com/dontdoxxmeplz/fonts/raw/main/APL386-Awesome.ttf -O /usr/share/fonts/APL386-Awesome.ttf --no-cache"

rm -rf ~/.yay;
git clone $YAYURL ~/.yay;
(cd ~/.yay && yes | makepkg -si)

sudo pacman -S -q --noconfirm --needed \
acpi \
dhcpcd \
calc \
dos2unix \
udisks2 \
mediainfo \
neovim \
openssh \
python3 \
wget \
arandr \
firefox \
feh \
imagemagick \
i3-gaps \
i3status-rust \
linux-lts \
lightdm \
lightdm-gtk-greeter \
lightdm-gtk-greeter-settings \
lm_sensors \
lxappearance-gtk3 \
nautilus \
rxvt-unicode \
xclip \
xbindkeys \
xorg \
xorg-server \
xorg-xinit \
xorg-xprop \
xorg-xrandr \
zsh

yay -S -q --noconfirm --needed \
python-i3ipc \
alternating-layouts-git \
networkmanager-dmenu-git \
rofi \
polybar \
ttf-font-awesome \
w3m-imgcat

if [ "$GPU" = "nvidia" ]; then sudo pacman -S nvidia nvidia-utils nvidia-settings -q --noconfirm --needed; fi

cat << EOF > ~/.xinitrc
setxkbmap -model apple -layout us -variant intl
xbindkeys
numlockx &
exec i3
EOF

if [ "$VMENGINE" = "vmware" ]; then
echo "vmware-user &" >> ~/.xinitrc
sudo pacman -S mesa xf86-video-nouveau open-vm-tools gtkmm3 xf86-video-vmware -q --noconfirm --needed;
yay -S xf86-input-vmmouse -q --noconfirm --needed;
sudo bash -c 'cat /proc/version > /etc/arch-release';
sudo systemctl enable vmtoolsd --now;
sudo systemctl enable vmware-vmblock-fuse --now;
fi

rm -rf \
~/.zprofile \
~/.zshenv \
~/.p10k.zsh \
~/.zinit/bin \
 ~/aliases \
~/.vimrc \
~/.zshrc \
~/.Xresources \
~/.wallpaper.jpg \
~/.config/rofi/rofi.rasi \
~/.config/i3 \
~/.config/picom

mkdir -p \
~/.zinit/bin \
~/aliases \
~/.config/rofi \
~/.config/i3 \
~/.config/picom

git clone https://github.com/zdharma-continuum/zinit.git ~/.zinit/bin
git clone https://github.com/adi1090x/polybar-themes.git ~/.config/polybar-themes

wget $P10KURL -O ~/.p10k.zsh --no-cache;
wget $ZSHRCURL -O ~/.zshrc --no-cache;
wget $ZPROFILEURL  -O ~/.zprofile --no-cache;
wget $COLORSCHEMEURL -O ~/.Xresources --no-cache;
wget $PICOMURL -O ~/.config/picom/picom.conf --no-cache
wget $ZSHENVURL -O ~/.zshenv --no-cache;
wget $ROFIURL -O ~/.config/rofi/rofi.rasi --no-cache;
wget $I3CONFIGURL -O ~/.config/i3/config --no-cache;
wget $ALIASESURL -O ~/aliases/aliases;
wget $WALLPAPERURL -O ~/.wallpaper.jpg;

chmod +x ~/.zprofile ~/.xinitrc ~/.zshenv ~/.zshrc

sudo usermod --shell $(which zsh) $CURRENTUSER
