This playbook automates the process of:

- Connecting to a git repo that you do not have direct access to (using multiple ssh tunnels)
- Clone repos from source git
- Push repos to a new origin

Here's what it looks like:

`workstation:(9000 -> 8000)` => `jumphost:(8000 -> 7999)` => `targethost:(7999)`

Your target host might be behind a different number of hosts/networks, or you may want to connect other ports for other reasons. You can use the techniques in this playbook to solve all sorts of access issues you might be facing.

# Doing it yourself

Here is how you would do this in your own shell/command line (without Ansile) ...

```
# ON YOUR WORKSTATION:
[drew@workstation]$ ssh -nNT -L 9000:localhost:8000 jumphost

# ON THE JUMPBOX:
[drew@jumphost ~]$ ssh -nNT -L 8000:localhost:7999 drew@targethost

# Now, from your workstation, you can connect to the targethost ...
# [drew@localhost]$ ssh-agent bash -c 'ssh-add /home/drew/.ssh/id_rsa_drew_git; git clone ssh://git@localhost:9000/foo/git-example.git'
```

# Ansible

Here is how you would run the playbook (with Ansible) ...

```
[drew@workstation]$ ansible-playbook mass-repo-cloner.yml
```

You can edit variables in `config.yml`.
