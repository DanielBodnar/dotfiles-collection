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
sudo wget https://github.com/dontdoxxmeplz/fonts/raw/main/APL386-Awesome.ttf -O /usr/share/fonts/APL386-Awesome.ttf

rm -rf ~/.yay;
git clone $YAYURL ~/.yay;
(cd ~/.yay && yes | makepkg -si)

sudo pacman -S -q --noconfirm --needed \
acpi \
dhcpcd \
calc \
docker \
dos2unix \
udisks2 \
mediainfo \
neovim \
openssh \
python3 \
qutebrowser \
wget \
arandr \
firefox \
feh \
imagemagick \
i3-gaps \
linux-lts \
lib32-util-linux \
libvirt \
lightdm \
lightdm-gtk-greeter \
lightdm-gtk-greeter-settings \
lm_sensors \
lxappearance-gtk3 \
nautilus \
rxvt-unicode \
remmina \
virt-install \
xclip \
xbindkeys \
xorg \
xorg-server \
xorg-xinit \
xorg-xprop \
xorg-xrandr \
zsh

yay -S -q --noconfirm --needed \
alternating-layouts-git \
awesome-terminal-fonts \
python-i3ipc \
networkmanager-dmenu-git \
rofi \
polybar \
picom-tryone-git \
ttf-font-awesome \
remmina-plugin-rdesktop \
ttf-meslo-nerd-font-powerlevel10k \
w3m-imgcat

if [ "$GPU" = "nvidia" ]; then sudo pacman -S nvidia nvidia-utils nvidia-settings -q --noconfirm --needed; fi

cat << EOF > ~/.xinitrc
setxkbmap -model apple -layout us -variant intl
xbindkeys
numlockx &
exec i3
EOF

if [ "$VMENGINE" = "vmware" ]; then
echo vmware-user & >> ~/.xinitrc
sudo pacman -S mesa xf86-video-nouveau open-vm-tools gtkmm3 xf86-video-vmware -q --noconfirm --needed;
yay -S xf86-input-vmmouse -q --noconfirm --needed;
sudo bash -c 'cat /proc/version > /etc/arch-release';
sudo systemctl enable vmtoolsd --now;
sudo systemctl enable vmware-vmblock-fuse --now;
fi

git clone https://github.com/zdharma-continuum/zinit.git ~/.zinit/bin
git clone https://github.com/adi1090x/polybar-themes.git ~/.config/polybar-themes

wget "$P10KURL" -O ~/.p10k.zsh
wget "$ZSHRCURL" -O ~/.zshrc
wget "$ZPROFILEURL"  -O ~/.zprofile
wget "$COLORSCHEMEURL" -O ~/.Xresources
wget "$PICOMURL" -O ~/.config/picom/picom.conf
wget "$ZSHENVURL" -O ~/.zshenv --no-cache
wget "$ROFIURL" -O ~/.config/rofi/rofi.rasi
wget "$I3CONFIGURL" -O ~/.config/i3/config
wget "$ALIASESURL" -O ~/aliases/aliases
wget "$WALLPAPERURL" -O ~/.wallpaper.jpg
chmod +x ~/.zprofile ~/.xinitrc ~/.zshenv ~/.zshrc

# Install oh-my-zsh
sh -c "$(wget https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh -O -)"

sudo groupadd docker
sudo usermod -aG docker $CURRENTUSER
sudo usermod -aG sudo $CURRENTUSER
sudo systemctl enable docker.service
sudo systemctl enable containerd.service
sudo usermod --shell $(which zsh) $CURRENTUSER
