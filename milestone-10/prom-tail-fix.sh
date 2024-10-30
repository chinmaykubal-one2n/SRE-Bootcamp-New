sudo sh -c 'echo "fs.inotify.max_user_instances=8192" >> /etc/sysctl.conf'
sudo sh -c 'echo "fs.inotify.max_user_watches=524288" >> /etc/sysctl.conf'

sudo sysctl -p

sysctl fs.inotify.max_user_instances
sysctl fs.inotify.max_user_watches
