#!/usr/bin/env bash
################################################################################
# ansible-client-provisioning variables and functions for external include usage.
#
# Copyright: (C) 2021 TechDivision GmbH - All Rights Reserved
# Author: Rene Terfoorth
################################################################################


function install_depends_ubuntu() {
# install depends       
        yes | sudo apt install git
        yes | sudo apt update
        sudo apt install software-properties-common
        sudo add-apt-repository --yes --update ppa:ansible/ansible
        yes | sudo apt install ansible
}

function rights_arm() {

sudo chown -R $(whoami) /opt/homebrew/Cellar
}

function install_mac_m1() {
#################install Homebrew and Ansible for Mac M1
     cd /opt &&
              sudo mkdir homebrew 
              sudo chown "$USER" homebrew 
              sudo chgrp admin homebrew 
              curl -L https://github.com/Homebrew/brew/tarball/master | tar xz --strip 1 -C homebrew
              export PATH="/opt/homebrew/bin:$PATH"
        brew install ansible
}

function install_mac_intel() {
################install brew and ansible
if ! command -v brew &> /dev/null
    then  
    yes | /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi
brew install ansible    
}

function rights_intel() {
################set rights for Hombrew on intel Macbook
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

function rights_m1() {
#######################link Homebrew on Macbook m1
CP_USER="${1}"
sudo chown -R "${CP_USER}" /opt/homebrew
export PATH="/opt/homebrew/bin:$PATH"
if ! command -v ansible &> /dev/null
    then
    brew install ansible |
    brew link ansible
fi
}

function mac_xcode() {
##########################install xcode??     
    echo "checking xcode..." 
    xcode-select --install && 
       
    printf "\e[32m___________________________________________________________________\e[m\n"    
    read -p "Press [Enter] key !!AFTER!! X-CODE installation is finished..."
    printf "\e[32m___________________________________________________________________\e[m\n"  
}

function init_dev() {
#########################install developer environment "VALET.SH"
CP_INSTALL_DIR="${1}"   
 
results1=$(osascript -e 'tell app "System Events" to display dialog "Install Developer-Environment Valet.sh"')                               
theButton=$( echo "$results1" | /usr/bin/awk -F "button returned:|," '{print $2}' )

if [[ $theButton == "OK" ]]; then
    bash <(curl -fsSL https://raw.githubusercontent.com/valet-sh/install/master/install.sh)
    valet.sh install                  
    rm -rf "${CP_INSTALL_DIR}"
            osascript -e 'display alert "Finish Install" message "Der PC kann nun an den Mitarbeiter ??bergeben werden und ist vollst??ndig eingerichtet.

The working environment is now fully set up for handover to the employee."'    
            exit 1
        else     
            osascript -e 'display alert "Finish Install" message "Der PC kann nun an den Mitarbeiter ??bergeben werden und ist vollst??ndig eingerichtet.

The working environment is now fully set up for handover to the employee."'
            rm -rf "${CP_INSTALL_DIR}"
            exit 1 
fi         
}

##########################SYSTEM INFOMATION################################
function message_bitdefender()
{
osascript -e 'display alert "WICHTIG" message "Der Bitdefender wurde installiert.   In seltenen F??llen werden unter manchen MacOS Versionen wichtige Dienste nicht mit installiert. -- Schauen sie unter 
-- SYSTEMEINSTELLUNGEN -> SICHERHEIT -> DATENSCHUTZ --
dort muss in der seitlichen Katigorie
-FESTPLATTENVOLLZUGRIFF-

- Endpoint Security for Mac
- BDLDeamon

aktiviert sein. Falls nicht finden sie im TD Confluence die Anleitung zum aktivieren."'
}
function message_info_start()
{
osascript -e 'display alert "Wichtig" message "W??hrend des Programmablaufes erscheinen ein paar Best??tigungs Fenster - Diese IMMER erlauben/best??tigen
Insbesondere bei der Bitdefender Installation.

A couple of confirmation popup windows appear during the installation - Always allow / confirm these
Especially when installing Bitdefender."'
}

function message_info_finish_admin()
{
osascript -e 'display alert "Finish Admin-Setup" message "Admin-Account ist vollst??ndig eingerichtet. Als n??chstes den gleichen Befehl noch im neu erstellten Benutzer-Account ausf??hren.

Admin account is fully set up. Next, execute the same command in the newly created user account."'
}

function message_info_finish_user()
{
osascript -e 'display alert "Finish Install" message "
        Der PC kann nun an den Mitarbeiter ??bergeben werden und ist vollst??ndig eingerichtet.      
        The working environment is now fully set up for handover to the employee."'
}
