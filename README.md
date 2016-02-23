# linux-tips

Install Packer

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

# Redirections

https://www.gnu.org/software/bash/manual/bashref.html#Redirections

# Creating files via scripts and code snippets

In particular being able to do this using sudo (where your user might not have permission to write to the file directly).

See http://stackoverflow.com/questions/2500436/how-does-cat-eof-work-in-bash and http://stackoverflow.com/questions/82256/how-do-i-use-sudo-to-redirect-output-to-a-location-i-dont-have-permission-to-wr

```
cat <<EOF | sudo tee file > /dev/null
content
EOF
```

- `tee -a` to append.
- `> /dev/null` redirects the output so that it won't be seen (use `&>`) if you want to redirect errors too.
- `cat <<EOF` variables expanded
- `cat <<'EOF'` variables not expanded

`<<-EOF` is useful for ignoring leading tabs, so you can create code like this:
```
if true; then
    cat <<-EOF
    a
    EOF
fi
```