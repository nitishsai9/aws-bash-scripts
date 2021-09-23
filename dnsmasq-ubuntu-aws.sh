		 #!/bin/bash

			#flushing caches
			systemd-resolve --flush-caches
			systemd-resolve --statistics


			apt update

			#installing dnsmasq
			apt-get install dnsmasq

			#adding user as dnsmasq requires root priv
			groupadd -r dnsmasq
			useradd -r -g dnsmasq dnsmasq

			#dnsmasq conf
			cat << EOF > /etc/dnsmasq.conf
			# Server Configuration
			listen-address=127.0.0.1
			port=53
			bind-interfaces
			user=dnsmasq
			group=dnsmasq
			pid-file=/var/run/dnsmasq.pid
			# Name resolution options
			resolv-file=/etc/resolv.dnsmasq
			cache-size=500
			neg-ttl=60
			domain-needed
			bogus-priv
			EOF


			NAMESERVER="169.254.169.253"

			# Populate /etc/resolv.dnsmasq
			echo "nameserver ${NAMESERVER}" > /etc/resolv.dnsmasq


			systemctl start dnsmasq
			systemctl enable dnsmasq

			STATUS="$(systemctl is-active dnsmasq)"
			if [ "${STATUS}" = "active" ]; then
			    
			# Test the service and configure dhclient accordingly
			dig aws.amazon.com @127.0.0.1 && echo "supersede domain-name-servers 127.0.0.1, ${NAMESERVER};" >> /etc/dhcp/dhclient.conf && dhclient
			else 
			    echo " error dnsmasq is not running "  
			    exit 1  
			fi

