# Install Packer

Note: `packer` may conflict with `cracklib-packer` so it is safer to use something like `packer.io`

```
VERSION=0.8.6
PLATFORM=linux_amd64
sudo mkdir /usr/local/packer
cd /usr/local/packer
wget https://releases.hashicorp.com/packer/${VERSION}/packer_${VERSION}_${PLATFORM}.zip
sudo unzip packer_${VERSION}_${PLATFORM}.zip
sudo rm -f packer_${VERSION}_${PLATFORM}.zip
sudo ln -s /usr/local/packer/packer /usr/bin/packer.io
```
