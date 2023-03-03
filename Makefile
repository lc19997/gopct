ssh-server:
	adduser -h /home/drone-ssh -s /bin/sh -D -S drone-ssh
	echo drone-ssh:1234 | chpasswd
	mkdir -p /home/drone-ssh/.ssh
	chmod 700 /home/drone-ssh/.ssh
	cat tests/.ssh/id_rsa.pub >> /home/drone-ssh/.ssh/authorized_keys
	cat tests/.ssh/test.pub >> /home/drone-ssh/.ssh/authorized_keys
	chmod 600 /home/drone-ssh/.ssh/authorized_keys
	chown -R drone-ssh /home/drone-ssh/.ssh
	# install ssh and start server
	apk add --update openssh openrc
	rm -rf /etc/ssh/ssh_host_rsa_key /etc/ssh/ssh_host_dsa_key
	sed -i 's/^#PubkeyAuthentication yes/PubkeyAuthentication yes/g' /etc/ssh/sshd_config
	sed -i 's/AllowTcpForwarding no/AllowTcpForwarding yes/g' /etc/ssh/sshd_config
	./tests/entrypoint.sh /usr/sbin/sshd -D &
