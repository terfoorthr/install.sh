#!/usr/bin/env bash
################################################################################
# ansible-client-provisioning variables and functions for external include usage.
#
# Copyright: (C) 2021 TechDivision GmbH - All Rights Reserved
# Author: Rene Terfoorth
################################################################################

function install_mac_m1() {
cd /opt &&
    sudo mkdir homebrew 
    sudo chown "$USER" homebrew 
    sudo chgrp admin homebrew 
    curl -L https://github.com/Homebrew/brew/tarball/master | tar xz --strip 1 -C homebrew
        export PATH="/opt/homebrew/bin:$PATH"
brew install ansible    
}

function install_mac_intel() {
#install xcode, brew a. ansible
if ! command -v brew &> /dev/null
    then  
    yes | /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi
brew install ansible    
}

function rights_intel() {
CP_USER="${1}"

        sudo chown -R "${CP_USER}" /usr/local/python3.9/
        sudo chown -R "${CP_USER}" /usr/local/Homebrew
        sudo chown -R "${CP_USER}" /usr/local/var/Homebrew
        sudo chown -R "${CP_USER}" /usr/local/etc/bash_completion.d
        sudo chown -R "${CP_USER}" /usr/local/lib/pkgconfig
        sudo chown -R "${CP_USER}" /usr/local/share/doc
        sudo chown -R "${CP_USER}" /usr/local/share/info
        sudo chown -R "${CP_USER}" /usr/local/share/man
        sudo chown -R "${CP_USER}" /usr/local/share/man/man1
        sudo chown -R "${CP_USER}" /usr/local/share/man/man3
        sudo chown -R "${CP_USER}" /usr/local/share/zsh
        sudo chown -R "${CP_USER}" /usr/local/share/zsh/site_functions       
}

function remove_m1() {
CP_INSTALL_DIR="${1}"

yes | /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/uninstall.sh)"          
echo "removing install files, please enter your,"
sudo true
chmod 775 /opt
rm -rf /opt/homebrew/Frameworks/ 
rm -rf /opt/homebrew/SECURITY.md                       
rm -rf /opt/homebrew/bin/
rm -rf /opt/homebrew/etc/
rm -rf /opt/homebrew/include/
rm -rf /opt/homebrew/lib/
rm -rf /opt/homebrew/opt/
rm -rf /opt/homebrew/sbin/
rm -rf /opt/homebrew/share/
rm -rf /opt/homebrew/var/
rm -rf /opt/homebrew
rm -rf "${CP_INSTALL_DIR}"

}

function mac_install() {

echo "Your operating system is MAC-OSX"
#check specs and start CP
echo "checking Hardware and OS Version..."
    MAC_TYPE=$(sysctl -a | grep "machdep.cpu.brand_string")
echo "${MAC_TYPE}"
#install xcode a. ansible´     
    echo "checking xcode..." 
    xcode-select --install && 
        echo -e "Client Provisionin Setup $(system_profiler SPSoftwareDataType -detailLevel mini) starting..."
    printf "\e[32m___________________________________________________________________\e[m\n"    
    read -p "Press [Enter] key !!AFTER!! X-CODE installation is finished..."
    printf "\e[32m___________________________________________________________________\e[m\n"  
}

function init_dev() {
CP_INSTALL_DIR="${1}"   
 
results1=$(osascript -e 'tell app "System Events" to display dialog "Install Developer-Environment Valet.sh"')                               
theButton=$( echo "$results1" | /usr/bin/awk -F "button returned:|," '{print $2}' )

if [[ $theButton == "OK" ]]; then
    bash <(curl -fsSL https://raw.githubusercontent.com/valet-sh/install/master/install.sh)
    valet.sh install                  
    rm -rf "${CP_INSTALL_DIR}"
            osascript -e 'display alert "Finish Install" message "Der PC kann nun an den Mitarbeiter übergeben werden und ist vollständig eingerichtet.

The working environment is now fully set up for handover to the employee."'    
            exit 1
        else     
            osascript -e 'display alert "Finish Install" message "Der PC kann nun an den Mitarbeiter übergeben werden und ist vollständig eingerichtet.

The working environment is now fully set up for handover to the employee."'
            rm -rf "${CP_INSTALL_DIR}"
            exit 1 
fi         
}