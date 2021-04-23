lokinet_dir="/tmp/lokinet"

function show_splash() {
  raspberry='\033[0;35m'
  green='\033[1;32m'
  cyan='\033[1;36m'
  red='\033[0;31m'
  grey='\033[0;37m'
    echo -e "${green}           __          __   _            __ "
    echo -e "          / /   ____  / /__(_)___  ___  / /_"
    echo -e "         / /   / __ \/ //_/ / __ \/ _ \/ __/ "
    echo -e "        / /___/ /_/ / ,< / / / / /  __/ /_"
    echo -e "       /_____/\____/_/|_/_/_/ /_/\___/\__/ "
    echo -e "${red} __________.____       _____    ____________________ "
    echo -e " \______   \    |     /  _  \  /   _____/\__    ___/ "
    echo -e "  |    |  _/    |    /  /_\  \ \_____  \   |    | "
    echo -e "  |    |   \    |___/    |    \/        \  |    | "
    echo -e "  |______  /_______ \____|__  /_______  /  |____| "
    echo -e "         \/        \/       \/        \/ "
    echo -e "${cyan}by Minotaurware.net${grey}_________________________________  "
    echo -e "|___|___|___|___|___|___|___|___|___|___|___|___|___| "
    echo -e "|_|___|___|___|___|___|___|___|___|___|___|___|___|_| "
    sleep 8
    echo -e "${green}       __ __ "
    echo -e "      / // /__ _______   _    _____   ___ ____ "
    echo -e "     / _  / -_) __/ -_) | |/|/ / -_) / _ \/ _ \ "
    echo -e "    /_//_/\__/_/  \__/  |__,__/\__/  \_, /\___/ "
    echo -e "                                    /___/ "
}

function install_main () {

  install_log "Clone and conduct Lokinet installation"

  sudo modprobe tun
  sudo curl -so /etc/apt/trusted.gpg.d/oxen.gpg https://deb.oxen.io/pub.gpg
  echo "deb https://deb.oxen.io $(lsb_release -sc) main" | sudo tee /etc/apt/sources.list.d/oxen.list

echo "Resync package repositories."

  sudo apt update

echo "Install Lokinet-GUI"

  sudo apt install lokinet-gui -y

}

function resolv_config () {

  install_log "Configure resolvconf installation"

 sudo apt install resolvconf -y
 sudo resolvconf -u
 sudo systemctl restart lokinet
 sudo lxpanelctl restart

}
 # Fetches latest files from github to lokinet installation directory
 function download_latest_files() {

     if [ -d "$lokinet_dir" ]; then
         sudo mv $lokinet_dir "$lokinet_dir.`date +%F-%R`" || install_error "Unable to remove old lokinet-installer directory"
     fi

     install_log "Cloning initialization files from github"
     git clone --depth 1 https://github.com/necro-nemesis/Raspberry-Pi-OS-Lokinet $lokinet_dir || install_error "Unable to download files from github"
     sudo mv $lokinet_dir/assets/Lokinet.desktop /usr/share/applications/Lokinet.desktop || install_error "Unable to add startup entry"
     sudo mv $lokinet_dir/img/lokiremove.png /usr/share/pixmaps/lokiremove.png || install_error "Unable to add startup icon"
     sudo chown -c root:root /usr/share/applications/Lokinet.desktop || install_error "Unable change owner and/or group."
 }

 # Outputs a Install log line
 function install_log() {
     echo -e "\033[1;32mLokinet Install: $*\033[m"
 }

 # Player during install_log
 function player () {
   sudo apt update
   sudo apt install sox libsox-fmt-all -y
   play $lokinet_dir/assets/Stranglehold.mp3 &>/dev/null </dev/null &

 }

function install_lokinet () {

    download_latest_files
    player
    show_splash
    install_main
    resolv_config
    echo "Installation complete!"
    /usr/bin/lokinet-gui --notray &>/dev/null </dev/null &
    sleep 60
    pkill play
}
