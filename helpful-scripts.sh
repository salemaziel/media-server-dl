
## For check_ports:
## After running, in your browser access http://${IP_ADDRESS}:${PORT/PORT_RANGE}
## It should show you your browser IP address and user agent. You should also see the request logged in the port-checker output.

check_ports(){
echo "enter port/port range to check:"
read "ports_check"
export PORTS_CHECK="$ports_check"
sudo docker exec -it gluetun /bin/sh
# Change amd64 to your CPU architecture
wget -qO port-checker https://github.com/qdm12/port-checker/releases/download/v0.3.0/port-checker_0.3.0_linux_amd64
chmod +x port-checker
./port-checker -port "$PORTS_CHECK"
}


check_dnsleak(){
sudo docker run --rm --network=container:testing_gluetun_1 alpine:3.14 \
	 sh -c "apk add curl iputils bash && curl https://raw.githubusercontent.com/macvk/dnsleaktest/master/dnsleaktest.sh -o dnsleaktest.sh \
		&& chmod a+x dnsleaktest.sh \
			&& bash ./dnsleaktest.sh"
}


# You can run the docker container in CLI operation, check the possible options with:
# docker run -it --rm qmcgaw/gluetun update -help

#To update your servers.json file with, for example mullvad, use:
update_vpnlist(){
read -p "Enter vpn provider name: " "vpn_provider"
export VPN_PROVIDER="$vpn_provider"
sudo docker run -it --rm -v ./gluetun-data:/gluetun qmcgaw/gluetun update -enduser -providers "$VPN_PROVIDER"
}

# Note that this operation is very quick 🚀 for some providers (pia, mullvad, nordvpn, ...) and very slow 🐢 for other providers (cyberghost, windscribe, ...).

# ⚠️ This will show your ISP/Government/Sniffing actors that you access some VPN service providers and try to resolve their server hostnames. That might not be the best solution depending on your location. Plus some of the requests might be blocked, hence not allowing certain server information to be updated.
