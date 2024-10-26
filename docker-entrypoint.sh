#!/bin/sh

# Activate Python virtual environment
. /opt/venv/bin/activate

# Create .ssh directory
mkdir -p /root/.ssh

# Add SSH host key to known_hosts
ssh-keyscan -H $(echo $SSH_HOST | cut -d@ -f2) >> /root/.ssh/known_hosts 2>/dev/null

# Create SSH config file to disable strict host key checking
cat << EOF > /root/.ssh/config
Host *
    StrictHostKeyChecking no
    UserKnownHostsFile /dev/null
EOF

# Ensure correct permissions for SSH files
chmod 700 /root/.ssh
chmod 600 /root/.ssh/known_hosts /root/.ssh/config

# Start sshuttle in the background
ruby app.rb -r ${AWS_REGION} -s ${SSH_HOST} -o "${SSHUTTLE_OPTIONS}" &

# Start the SOCKS5 proxy
sockd -f /app/sockd.conf
