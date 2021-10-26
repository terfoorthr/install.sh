#!/usr/bin/env bash
#
# TechDivision client provisioning
#
# This script installs the command line tools and ansible. After this the
# client provisioning via ansible will be done.
#############################################################################
# VARIABLES
#############################################################################
CP_URL="https://github.com/terfoorthr/.ansible.git" 
CP_USER=${USER} 
CP_INSTALL_DIR="${HOME}/.ansible"
CP_PLAYBOOKS="$CP_INSTALL_DIR/playbooks"
CP_INCLUDE_URL="https://raw.githubusercontent.com/terfoorthr/install.sh/master/include.sh"
#############################################################################

#Check system and install recources-----------------------------------------------
source /dev/stdin <<< "$( curl -sS ${CP_INCLUDE_URL} )"
############## LINUX #########################################################
printf "\e[32mWe bringing up your System  - BE STRONG. BE REAL. BE DIGITAL. - The Client-Provisioning developed by TechDivision, please enter your\e[m\n"
sudo true

if [[ "$OSTYPE" == "linux-gnu" ]]; then
echo "Your operating system," 
hostnamectl
# install repo
    if [ ! -d "${CP_INSTALL_DIR}" ]; then
        mkdir "${CP_INSTALL_DIR}"
        chmod 775 "${CP_INSTALL_DIR}"
        chown "${CP_USER}" "${CP_INSTALL_DIR}"
    fi                                               
# install depends       
        yes | sudo apt install git
        yes | sudo apt update
        sudo apt install software-properties-common
        sudo add-apt-repository --yes --update ppa:ansible/ansible
        yes | sudo apt install ansible
# run Playbooks   
        cd ${HOME} &&
        git clone $CP_URL
        cd "$CP_PLAYBOOKS" &&
        ansible-playbook ubuntu_admin.yml
                printf "\e[32mprovisioning system for user account finished\e[m\n"  
fi

########## MAC OS ###################################################################################################
if [[ "$OSTYPE" == "darwin"* ]]; then

mac_install
#Install ansible-Playbooks
if [ ! -d "${CP_INSTALL_DIR}" ]; then
        mkdir "${CP_INSTALL_DIR}"
        chmod 775 "${CP_INSTALL_DIR}"
        chown "${CP_USER}" "${CP_INSTALL_DIR}" 
            cd "${HOME}" &&
            git clone "$CP_URL" 
fi 

osascript -e 'display alert "Wichtig" message "Während des Programmablaufes erscheinen ein paar Bestätigungs Fenster - Diese IMMER erlauben/bestätigen
Insbesondere bei der Bitdefender Installation.

A couple of confirmation popup windows appear during the installation - Always allow / confirm these
Especially when installing Bitdefender."'

# MAC Appel M1 #####################################################################################################

if [[ $MAC_TYPE == "machdep.cpu.brand_string: Apple M1" ]]; then
       install_mac_m1

#run playbooks
    cd "$CP_PLAYBOOKS" &&
    if [[ $CP_USER == "it-support" ]]; then
        ansible-playbook mac_arm_admin.yml
        osascript -e 'display alert "WICHTIG" message "Der Bitdefender wurde installiert, unter manchen MacOS Versionen werden wichtige Dienste nicht mit installiert
        Schauen sie unter -- SYSTEMEINSTELLUNGEN -> SICHERCHEIT -> DATENSCHUTZ --
        dort muss in der seitlichen Katigory -FESTPLATTENVOLLZUGRIFF- 
        - SecurityEndpoind 
        - BDLDeamon
        aktiviert sein. Falls nicht finden sie im TD Confluence die Anleitung zum aktivieren."'    
        osascript -e 'display alert "Finish Admin-Setup" message "Admin-Account ist vollständig eingerichtet. Als nächstes den gleichen Befehl noch im neu erstellten Benutzer-Account ausführen.
                                                    
        Admin account is fully set up. Next, execute the same command in the newly created user account."'
    else
        ansible-playbook mac_user.yml
        osascript -e 'display alert "Finish Install" message "
        Der PC kann nun an den Mitarbeiter übergeben werden und ist vollständig eingerichtet.      
        The working environment is now fully set up for handover to the employee."'
        rm -rf "${CP_INSTALL_DIR}"
            exit 1 
    fi      
#cleaning system    
remove_m1 "${CP_INSTALL_DIR}"                                                             
                                                                                                                   
#Mac INTEL#####################################################################################################
else
    echo -e "Client Provisionin Setup $(system_profiler SPSoftwareDataType -detailLevel mini) starting..."

####### ADMIN INSTALL #############                       
    if [[ $CP_USER == "it-support" ]]; then
#instal brew a. ansible  
install_mac_intel

### run playbooks        
cd "$CP_PLAYBOOKS" &&
ansible-playbook mac_intel_admin.yml

    osascript -e 'display alert "WICHTIG" message "Der Bitdefender wurde installiert.   In seltenen Fällen werden unter manchen MacOS Versionen wichtige Dienste nicht mit installiert. -- Schauen sie unter 
-- SYSTEMEINSTELLUNGEN -> SICHERHEIT -> DATENSCHUTZ --
dort muss in der seitlichen Katigorie
-FESTPLATTENVOLLZUGRIFF-

- Endpoint Security for Mac
- BDLDeamon

aktiviert sein. Falls nicht finden sie im TD Confluence die Anleitung zum aktivieren."'    
osascript -e 'display alert "Finish Admin-Setup" message "Admin-Account ist vollständig eingerichtet. Als nächstes den gleichen Befehl noch im neu erstellten Benutzer-Account ausführen.

Admin account is fully set up. Next, execute the same command in the newly created user account."'

    else
####### USER INSTALL #############  
install_mac_intel 
rights_intel "${CP_USER}"  
cd "$CP_PLAYBOOKS" &&                  
    ansible-playbook mac_user.yml
#Check/install - Dev-setup  
init_dev "${CP_INSTALL_DIR}"
    fi
  fi           
fi