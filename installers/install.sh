lokinet_dir="/tmp/lokinet"

function show_splash() {

    cyan='\033[1;36m'

    echo -e "${cyan}\n"
    echo -e "  _           _    _            _ "
    echo -e " | |         | |  (_)          | |  "
    echo -e " | |     ___ | | ___ _ __   ___| |_ "
    echo -e " | |    / _ \| |/ / | '_ \ / _ \ __| "
    echo -e " | |___| (_) |   <| | | | |  __/ |_"
    echo -e " \_____/\___/|_|\_\_|_| |_|\___|\__| "
    echo -e " __________.____       _____    ____________________ "
    echo -e " \______   \    |     /  _  \  /   _____/\__    ___/ "
    echo -e "  |    |  _/    |    /  /_\  \ \_____  \   |    | "
    echo -e "  |    |   \    |___/    |    \/        \  |    | "
    echo -e "  |______  /_______ \____|__  /_______  /  |____| "
    echo -e "         \/        \/       \/        \/ "
echo "This installation adds Lokinet, tun module and resolvconf to your system"

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

 }

 # Outputs a Install log line
 function install_log() {
     echo -e "\033[1;32mLokinet Install: $*\033[m"
 }

function install_lokinet () {
    show_splash
    download_latest_files
    install_main
    resolv_config
    echo "Installation complete!"
}
