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

```bash
git clone https://github.com/ntity-core/node.git

# Copy Background image
sudo cp node/ntitybox/usr/share/rpd-wallpaper/ntity-background.jpg /usr/share/rpd-wallpaper/
```

