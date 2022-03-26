# Welcome to the Ntity Node Image Readme

The default setting are :  
- Image:  Raspberry PI OS 64 (1.1 GB)
- Settings
  - Set hostname : ntity
  - Enable SSH : true
  - Set username & password
    - User : ntity
    - Password : haradev

```bash
# First of all change the password
passwd 

# Update
sudo apt update && sudo apt upgrade

# Get latest version of the code
cd /home/ntity/node/
git pull

# Copy Background image
sudo cp node/ntitybox/usr/share/rpd-wallpaper/ntity-background.jpg /usr/share/rpd-wallpaper/

# Then open a terminal and type
cd node
./run.sh

# If you want more detail go on this page : https://github.com/ntity-core/node
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