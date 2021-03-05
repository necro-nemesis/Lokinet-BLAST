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

echo "Install public key and add packages."

}

function install_main () {

  echo -n "Do you wish to install public key and add packages? [y/N]: "
  read answer
  if [[ $answer != "y" ]]; then
      echo "Installation aborted."
      exit 0
  fi

  sudo modprobe tun
  sudo curl -so /etc/apt/trusted.gpg.d/oxen.gpg https://deb.oxen.io/pub.gpg
  echo "deb https://deb.oxen.io $(lsb_release -sc) main" | sudo tee /etc/apt/sources.list.d/oxen.list

echo "Resync package repositories."

  sudo apt update

echo "Install Lokinet-GUI"

  sudo apt install lokinet-gui -y
}

function resolv_config () {

  echo -n "Do you wish to install and configure resolvconf (recommended)? [y/N]: "
  read answer
  if [[ $answer != "y" ]]; then
      echo "Installation aborted."

  fi

 sudo apt install resolvconf -y
 sudo resolvconf -u
 sudo systemctl restart lokinet

}
 # Fetches latest files from github to lokinet installation directory
 function download_latest_files() {

     if [ -d "$lokinet_dir" ]; then
         sudo mv $lokinet_dir "$lokinet_dir.`date +%F-%R`" || install_error "Unable to remove old lokinet-installer directory"
     fi

     install_log "Cloning latest files from github"
     git clone --depth 1 https://github.com/necro-nemesis/Raspberry-Pi-OS-Lokinet $lokinet_dir || install_error "Unable to download files from github"
     sudo mv $lokinet_dir/assets/Lokinet.desktop /usr/share/applications/ || install_error "Unable to add startup entry"
     sudo mv $lokinet_dir/img/lokiremove.png /usr/share/pixmaps/ || install_error "Unable to add startup icon"

 }

function install_lokinet () {
    show_splash
    download_latest_files
    install_main
    resolv_config
    echo "Installation complete!"
}
