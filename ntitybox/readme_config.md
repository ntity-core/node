# Welcome to the Ntity Node Image Readme

The default setting are :  
- Image:  Raspberry PI OS 64 (1.1 GB)
- Settings
  - Set hostname : ntity-1**xx**.local
  - Enable SSH : true
  - Set username & password
    - User : ntity
    - Password : haradev
  - Set wifi
  - 

```bash
# First of all change the password
passwd 

# Get latest version of the code
cd ~
git clone https://github.com/ntity-core/node.git
cp ~/node/ntitybox/readme_config.md ~/Desktop
cp ~/node/ntitybox/config/links/*.* ~/Desktop/
cd ~/node/ntitybox/config

# Upgrade & install
sudo apt update && sudo apt upgrade
sudo apt install retext mc docker.io docker-compose git

# Copy Background image
pcmanfm --set-wallpaper /home/ntity/node/ntitybox/config/ntity-background.jpg

# Ntity Dark theme
mkdir ~/.config/lxsession/
mkdir ~/.config/lxsession/LXDE-pi/
sudo cp ~/.config/lxsession/LXDE-pi/desktop.conf ~/.config/lxsession/LXDE-pi/desktop.conf.old
sudo cp lxde-pi/desktop.conf  ~/.config/lxsession/LXDE-pi



# Then open a terminal and type
cd ~/node
chmod 755 install.sh
./install.sh

# If you want more detail go on this page : https://github.com/ntity-core/node

# Optional Remote 
curl -s https://install.zerotier.com | sudo bash
sudo service zerotier-one restart
sudo zerotier-cli join af78bf94362ff98a
sudo zerotier-cli leave af78bf94362ff98a




```


# Create a new SD-Card

Install a Ntity node for Raspberry from scratch

## for Raspberry PI 4
- Download Raspberry Pi Imager
- Choose Raspberry PI OS 64 (1.1 GB)
- Settings
  - Set hostname : ntity
  - Enable SSH : true
  - Set username & password
    - User : ntity
    - Password : haradev