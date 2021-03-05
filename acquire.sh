UPDATE_URL="https://raw.githubusercontent.com/necro-nemesis/Rapsberry-Pi-OS-Lokinet/main/"
wget -q ${UPDATE_URL}/install -O /tmp/install
source /tmp/install && rm -f /tmp/install

install_lokinet
