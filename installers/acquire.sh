UPDATE_URL="https://raw.githubusercontent.com/necro-nemesis/Raspberry-Pi-OS-Lokinet/main/"
wget -q ${UPDATE_URL}/installers/install.sh -O /tmp/install.sh
source /tmp/install.sh && rm -f /tmp/install.sh

install_lokinet
