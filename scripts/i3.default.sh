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

CURRENTUSER=$USER

git config --global user.email "anon@anon.com" && git config --global user.name "anon"

sudo pacman -Suuy -q --noconfirm && sudo pacman -S git curl python3 python-pip pacman-contrib go base-devel neovim -q --noconfirm

git clone https://aur.archlinux.org/yay.git /home/$CURRENTUSER/.yay && (cd /home/$CURRENTUSER/.yay && yes | makepkg -si) && yay -Suuy -q --noconfirm

sudo pacman -S -q --noconfirm --needed \
acpi \
dhcpcd \
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
ttf-font-awesome \
w3m-imgcat

if [ "$GPU" = "nvidia" ]; then sudo pacman -S nvidia nvidia-utils nvidia-settings -q --noconfirm --needed; fi

if [ "$VMENGINE" = "vmware" ]; then
sudo pacman -S mesa xf86-video-nouveau open-vm-tools gtkmm3 xf86-video-vmware -q --noconfirm --needed;
yay -S xf86-input-vmmouse -q --noconfirm --needed;
sudo bash -c 'cat /proc/version > /etc/arch-release';
sudo systemctl enable vmtoolsd --now;
sudo systemctl enable vmware-vmblock-fuse --now;
sudo systemctl restart vmtoolsd;

sudo bash -c 'cat << EOF > /etc/systemd/system/vmwareuser.service
"
[Unit]
Description=VmwareUser
After=network.target
StartLimitIntervalSec=0
[Service]
Type=simple
Restart=always
RestartSec=1
User=$CURRENTUSER
ExecStart=vmware-user
[Install]
WantedBy=multi-user.target
"
EOF'

cat << EOF > ~/.xinitrc
"
setxkbmap -model apple -layout us -variant intl
xbindkeys
numlockx &
exec i3
fi
"
EOF

chmod +x ~/.xinitrc
sudo systemctl enable vmwareuser.service --now;

wget https://raw.githubusercontent.com/dontdoxxmeplz/dotfiles-collection/main/zsh/zprofile.default -O ~/.zprofile --no-cache
chmod +x ~/.zprofile
fi

sudo wget https://github.com/dontdoxxmeplz/fonts/raw/main/APL386-Awesome.ttf -O /usr/share/fonts/APL386-Awesome.ttf --no-cache

if [ "$WM" = "i3" ]; then mkdir ~/.config/i3/ && wget https://raw.githubusercontent.com/dontdoxxmeplz/dotfiles-collection/main/i3wm/config.default -O ~/.config/i3/config --no-cache; fi

mkdir -p ~/.config/rofi/ && wget https://raw.githubusercontent.com/dontdoxxmeplz/dotfiles-collection/main/rofi/rofi.rasi.dracula.purple -O ~/.config/rofi/rofi.rasi --no-cache

rm -rf ~/aliases && git clone https://github.com/dontdoxxmeplz/aliases ~/aliases/

wget https://github.com/dontdoxxmeplz/wallpapers/raw/main/wall60.jpg -O ~/.wallpaper.jpg --no-cache

wget https://raw.githubusercontent.com/dontdoxxmeplz/dotfiles-collection/main/urxvt/Xresources.dracula -O ~/.Xresources --no-cache

wget https://raw.githubusercontent.com/dontdoxxmeplz/dotfiles-collection/main/zsh/zshrc.default -O ~/.zshrc --no-cache

wget https://raw.githubusercontent.com/dontdoxxmeplz/dotfiles-collection/main/vim/vimrc.default -O ~/.vimrc --no-cache

sudo usermod --shell $(which zsh) $CURRENTUSER
