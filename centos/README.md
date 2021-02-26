# How to use

run `setup.sh`

# Contents of the setup


# Change docker image directory

edit `/lib/systemd/system/docker.service`

```
[Unit]
Description=Docker Application Container Engine
Documentation=https://docs.docker.com
After=network.target docker.socket
Requires=docker.socket

[Service]
Type=notify
# the default is not to use systemd for cgroups because the delegate issues still
# exists and systemd currently does not support the cgroup feature set required
# for containers run by docker
ExecStart=/usr/bin/docker daemon -H fd://
MountFlags=slave
LimitNOFILE=1048576
LimitNPROC=1048576
LimitCORE=infinity
TimeoutStartSec=0
# set delegate yes so that systemd does not reset the cgroups of docker containers
Delegate=yes

[Install]
WantedBy=multi-user.target
```

ExecStart=/usr/bin/docker daemon -H fd://  
↓  
ExecStart=/usr/bin/docker daemon -h fd:// -g /path/to/dir/to/save/images  

reload daemon and restart docker  
```
$ sudo systemctl daemon-reload
$ sudo systemctl restart docker
```


