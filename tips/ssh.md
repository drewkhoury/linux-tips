# linux-tips :: ssh

## Configure SSH connection multiplexing

```bash
cat <<EOF | sudo tee -a file > ~/.ssh/config > /dev/null

#
# Configure SSH connection multiplexing
#
# This will let you use the same SSH connection/tunnel 
# that has been established for many connections.
# It will speed up your connection and reduce the load 
# on the remote service.
#
# DO NOT configure this on shared servers.
#
Host *
  ControlMaster auto
  ControlPath /tmp/%r@%h:%p
  TCPKeepAlive yes                                                             
  ServerAliveInterval 60
  ControlPersist 1h

EOF
```

## Configure SSH Forwarding through a Jumpbox

In this use case you want to SSH into `Final Host` but you need to SSH into `Jumpbox` first. Typically this means SSH'ing twice, and storing your private key on the `Jumpbox` as well as your `Workstation`.

Here is what it looks like:
`Workstation ---> Jumpbox ---> Final Host`

### SSH Config on the workstation

```bash
JUMPBOX_HOSTNAME=1.2.3.4
FINAL_HOST_ALIAS=10.*
USER_FOR_FINAL_HOST=user
USER_FOR_JUMPBOX=user

cat <<EOF | sudo tee -a file > ~/.ssh/config > /dev/null

##### Agent forwarding :: [Workstation ---> Jumpbox ---> Final Host] :: start
#

# JUMPBOX (from your workstation)
Host jumpbox
  Hostname ${JUMPBOX_HOSTNAME}

# FINAL HOST (forwarded/proxied from your workstation to the jumpbox)
Host ${FINAL_HOST_ALIAS}
  User ${USER_FOR_FINAL_HOST}
  ForwardAgent yes
  ProxyCommand ssh -W %h:%p ${USER_FOR_JUMPBOX}@jumpbox

#
##### Agent forwarding :: [Workstation ---> Jumpbox ---> Final Host] :: end

EOF
```

Update the following:
- 1.2.3.4 (the ip of your jumpbox)
- 10.* (the ip wildcard of your final host, or use a specific ip like 10.0.0.1)
- user_for_final_host
- user_for_jumpbox

### SSH Keys on the Workstation

Make sure you're using an ssh agent to manage your keys. List them with `ssh-add -L` and add them with `ssh-add yourkey`.

### SSH Keys on the Workstation :: Autoload

For OSX make sure your keys are always loaded.

```bash
cat <<EOF | sudo tee -a file > ~/.bash_profile > /dev/null

# --- SSH AGENT ---
# This will create /tmp/agent if it doesn't exist,
# else it will use /tmp/agent
#
# Load keys below via ssh-add
#
# All keys will be tried for any ssh connections
#
# Use `ssh-add -L` to check which keys are loaded
#
if [ ! -f /tmp/agent ];then
  ssh-agent > /tmp/agent
  eval $(< /tmp/agent) > /dev/null 2>&1

  echo "--- SSH AGENT ---"
  echo "Loading the following keys..."

  ssh-add ~/.ssh/my_key

fi
eval $(< /tmp/agent) > /dev/null 2>&1

EOF
```

Update the `~/.ssh/my_key` line with your key and add more lines as required.

### SSH Config on the Jumpbox

Make sure ssh forwarding is allowed on the Jumpbox too.
