## Challenge

Let's assume following configuration:

```
client <--> jumphost <--> target-host-1
                     <--> target-host-2
```

We want the client to be able to login like following

`ssh target-host-1@jumphost`

and automatically force the connection to tunnel to target-host-1.

## Solution

1. (optional, necessary if jumphost and target-host-x not in same network):

   Create persistent reverse tunnel from target-host-x to jumphost
   This requires exchange of publickeys for connection from target-host to jumphost and vice-versa.
2. Create user profile on jumphost
3. Configure forced connection to target-host in ~/.ssh/authorized_keys

## Implementation

1. Template for systemd service:
(depends on autossh)
```
[Unit]
Description=AutoSSH tunnel to public server
After=network.target

[Service]
User=<username>
Group=<username>
Environment="AUTOSSH_GATETIME=0"
ExecStart=autossh -M 0 -N -o "ServerAliveInterval 30" -o "ServerAliveCountMax 3" -R <port-on-jumphost>:localhost:<port-on-target-host> <user-on-jump-host>@<jump-host>

[Install]
WantedBy=multi-user.target
```

3. Add following to ~/.ssh/authorized_keys:
`command="ssh -p <port-on-jumphost> <user-on-target-host>@localhost" <public ssh key>`
