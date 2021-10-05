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
#CP_FILES_DIR="${CP_INSTALL_DIR}/files"
CP_PLAYBOOKS="$CP_INSTALL_DIR/playbooks"
DEV_SETUP=""
#############################################################################

#Check system and install recources-----------------------------------------------

############## LINUX #########################################################
printf "\e[32mWe bringing up your System  - BE STRONG. BE REAL. BE DIGITAL - The Client-Provisioning developed by TechDivision.\e[m\n"
echo "please enter your,"
sudo true

if [[ "$OSTYPE" == "linux-gnu" ]]; then
echo "Your operating system," 
hostnamectl
# install repo
    if [ ! -d "${CP_INSTALL_DIR}" ]; then
         sudo mkdir "${CP_INSTALL_DIR}"
    fi
        cd ${HOME} &&
        git clone $CP_URL
# install depends       
    yes | sudo apt update
    sudo apt install software-properties-common
    sudo add-apt-repository --yes --update ppa:ansible/ansible
    yes | sudo apt install ansible
    yes | sudo apt install python-testresources
    yes | sudo apt install curl
# run Playbooks   
    cd "$CP_PLAYBOOKS" &&
    ansible-playbook ubuntu_admin.yml
#Check/install - Dev-setup
                printf "\e[32mINSTALL DEVELOPER ENVIRONMENT\e[m\n"
                printf "\e[32mPlease enter y/n\e[m\n"
                read "DEV_SETUP"
        if [[ $DEV_SETUP == "y" ]]; then
                bash <(curl -fsSL https://raw.githubusercontent.com/valet-sh/install/master/install.sh)
                valet.sh xps-setup -d
                printf "\e[32mprovisioning system for user account finished\e[m\n"
        else
                printf "\e[32mprovisioning system for user account finished\e[m\n" 
        fi      
fi
########## MAC OS #########################################################
if [[ "$OSTYPE" == "darwin"* ]]; then
    echo "Your operating system is MAC-OSX"
#check specs and start CP
    echo "checking Hardware and OS Version..."
    MAC_TYPE=$(sysctl -a | grep "machdep.cpu.brand_string")
    echo "${MAC_TYPE}"
    
osascript -e 'display alert "WICHTIG!" message "Während des Programmablaufes erscheinen ein paar Bestätigungs Fenster - Diese IMMER erlauben/bestätigen
Insbesondere bei der Bitdefender Installation.

A couple of confirmation popup windows appear during the installation - Always allow / confirm these
Especially when installing Bitdefender."'

#MAC Appel m1---------------------------------------------------------------------------      
if [[ $MAC_TYPE == "machdep.cpu.brand_string: Apple M1" ]]; then
    if [[ $CP_USER == "it-support" ]]; then
        echo -e "Client Provisionin Setup $(system_profiler SPSoftwareDataType -detailLevel mini) starting..."
#install xcode a. ansible´     
        echo "checking xcode..." 
        xcode-select --install && 
        printf "\e[32m___________________________________________________________________\e[m\n"    
        read -p "Press [Enter] key !!AFTER!! X-CODE installation is finished..."
        printf "\e[32m___________________________________________________________________\e[m\n"  
              cd /opt &&
              chmod 775 /opt
              sudo mkdir homebrew 
              sudo chown "$USER" homebrew 
              sudo chgrp admin homebrew 
              curl -L https://github.com/Homebrew/brew/tarball/master | tar xz --strip 1 -C homebrew
              export PATH="/opt/homebrew/bin:$PATH"
        brew install ansible
# install repo
        if [ ! -d "${CP_INSTALL_DIR}" ]; then
                mkdir "${CP_INSTALL_DIR}"
        fi
                chmod 775 "${CP_INSTALL_DIR}"
                chown "${CP_USER}" "${CP_INSTALL_DIR}"
                cd ${HOME} &&
                git clone $CP_URL
# reset correct permissions
               
#run playbooks
            cd "$CP_PLAYBOOKS" &&
                ansible-playbook mac_arm_admin.yml
                 osascript -e 'display alert "WICHTIG" message "Der Bitdefender wurde installiert, unter manchen MacOS Versionen werden wichtige Dienste nicht mit installiert Schauen sie unter -- SYSTEMEINSTELLUNGEN -> SICHERCHEIT -> DATENSCHUTZ -- dort muss in der seitlichen Katigory - FESTPLATTENVOLLZUGRIFF - 
                - SecurityEndpoint 
                - BDLDeamon
                - sshd 
aktiviert sein. Falls nicht finden sie im TD Confluence die Anleitung zum aktivieren."'    
                osascript -e 'display alert "Finish Admin-Setup" message "Admin-Account ist vollständig eingerichtet. Als nächstes den gleichen Befehl noch im neu erstellten Benutzer-Account ausführen. 
Admin account is fully set up. Next, execute the same command in the newly created user account."'
            
            else
            osascript -e 'display alert "Install User-Setup" message "Der Benutzer Setup wird nun ausgeführt.    The user setup is now carried out."'
                cd /opt &&
                chmod 775 /opt
                sudo mkdir homebrew 
                sudo chown "$USER" homebrew 
                sudo chgrp admin homebrew 
                curl -L https://github.com/Homebrew/brew/tarball/master | tar xz --strip 1 -C homebrew
                export PATH="/opt/homebrew/bin:$PATH"
                brew install ansible
# install repo
                if [ ! -d "${CP_INSTALL_DIR}" ]; then
                        mkdir "${CP_INSTALL_DIR}"
                fi
                        chmod 775 "${CP_INSTALL_DIR}"
                        chown "${CP_USER}" "${CP_INSTALL_DIR}"
                        cd ${HOME} &&
                        git clone $CP_URL
                        ansible-playbook mac_user.yml
#Check/install - Dev-setup 
          
                        results1=$(osascript -e 'tell app "System Events" to display dialog "Install Developer-Environment"')                               
                        theButton=$( echo "$results1" | /usr/bin/awk -F "button returned:|," '{print $2}' )

                    if [[ $theButton == "OK" ]]; then
                        bash <(curl -fsSL https://raw.githubusercontent.com/valet-sh/install/master/install.sh)
                        valet.sh install
#Dont deletes Homebrew only the install dir                       
                        rm -rf "${CP_INSTALL_DIR}"
                        osascript -e 'display alert "Finish Install" message "
                        Der PC kann nun an den Mitarbeiter übergeben werden und ist vollständig eingerichtet.      
                        The working environment is now fully set up for handover to the employee."'    
                            exit 1
                    else     
                        osascript -e 'display alert "Finish Install" message "
                        Der PC kann nun an den Mitarbeiter übergeben werden und ist vollständig eingerichtet.      
                        The working environment is now fully set up for handover to the employee."'
                        rm -rf "${CP_INSTALL_DIR}"
                            exit 1 
                fi      
        fi
#cleaning     
yes | /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/uninstall.sh)"          
echo "removing install files, please enter your,"
sudo rm -rf /opt/homebrew/Frameworks/ 
sudo rm -rf /opt/homebrew/SECURITY.md                       
sudo rm -rf /opt/homebrew/bin/
sudo rm -rf /opt/homebrew/etc/
sudo rm -rf /opt/homebrew/include/
sudo rm -rf /opt/homebrew/lib/
sudo rm -rf /opt/homebrew/opt/
sudo rm -rf /opt/homebrew/sbin/
sudo rm -rf /opt/homebrew/share/
sudo rm -rf /opt/homebrew/var/
sudo rm -rf /opt/homebrew
sudo rm -rf "${CP_INSTALL_DIR}"
exit 1                                                  
                                                                                         
                        
#Mac INTEL#########################################################################################################

 else
 if [[ $CP_USER == "it-support" ]]; then
    echo -e "Client Provisionin Setup $(system_profiler SPSoftwareDataType -detailLevel mini) starting..."
#install xcode, brew a. ansible
    echo "checking xcode..." 
        xcode-select --install  
        printf "\e[32m___________________________________________________________________\e[m\n" 
        read -p "Press [Enter] key !!AFTER!! X-CODE installation is finished..."
        printf "\e[32m___________________________________________________________________\e[m\n"    
        yes | /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        brew install ansible    
# install repo               
    if [ ! -d "${CP_INSTALL_DIR}" ]; then
                mkdir "${CP_INSTALL_DIR}"
    fi
                chmod 775 "${CP_INSTALL_DIR}"
                chown "${CP_USER}" "${CP_INSTALL_DIR}" 
                cd ${HOME} &&
                git clone $CP_URL    
#run playbooks
            cd "$CP_PLAYBOOKS" &&   
            ansible-playbook mac_intel_admin.yml
                osascript -e 'display alert "WICHTIG!" message "Der Bitdefender wurde installiert, unter manchen MacOS Versionen werden wichtige Dienste nicht mit installiert. Schauen sie unter -- SYSTEMEINSTELLUNGEN -> SICHERCHEIT -> DATENSCHUTZ -- dort muss in der seitlichen Katigory -FESTPLATTENVOLLZUGRIFF- 
                - SecurityEndpoind 
                - BDLDeamon
aktiviert sein. Falls nicht finden sie im TD Confluence die Anleitung zum aktivieren."'    
                osascript -e 'display alert "Finish Admin-Setup" message "Admin-Account ist vollständig eingerichtet. Als nächstes den gleichen Befehl noch im neu erstellten Benutzer-Account ausführen.
            
Admin account is fully set up. Next, execute the same command in the newly created user account."'
        else
            osascript -e 'display alert "Install User-Setup" message "Der Benutzer Setup wird nun ausgeführt.    The user setup is now carried out."'
            yes | /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
            brew install ansible    
# install repo               
                if [ ! -d "${CP_INSTALL_DIR}" ]; then
                    mkdir "${CP_INSTALL_DIR}"
                fi
                    chmod 775 "${CP_INSTALL_DIR}"
                    chown "${CP_USER}" "${CP_INSTALL_DIR}" 
                    cd ${HOME} &&
                    git clone $CP_URL    
#run playbooks
                    cd "$CP_PLAYBOOKS" &&   
                    ansible-playbook mac_user.yml
#Check/install - Dev-setup           
                    results1=$(osascript -e 'tell app "System Events" to display dialog "Install Developer-Environment"')                               
                    theButton=$( echo "$results1" | /usr/bin/awk -F "button returned:|," '{print $2}' )
                if [[ $theButton == "OK" ]]; then
                    bash <(curl -fsSL https://raw.githubusercontent.com/valet-sh/install/master/install.sh)
                    valet.sh install
            #Dont deletes Homebrew only install dir                       
                    rm -rf "${CP_INSTALL_DIR}"
                    osascript -e 'display alert "Finish Install" message "
                    Der PC kann nun an den Mitarbeiter übergeben werden und ist vollständig eingerichtet.      
                    The working environment is now fully set up for handover to the employee."'    
                        exit 1
                else     
                    osascript -e 'display alert "Finish Install" message "
                    Der PC kann nun an den Mitarbeiter übergeben werden und ist vollständig eingerichtet.      
                    The working environment is now fully set up for handover to the employee."'
                    rm -rf "${CP_INSTALL_DIR}"
                        exit 1 
                fi      
        fi
#cleaning
echo "removing install files."               
yes | sudo /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/uninstall.sh)"                              
 sudo rm -rf /usr/local/bin/
 sudo rm -rf /usr/local/etc/
 sudo rm -rf /usr/local/include/
 sudo rm -rf /usr/local/lib/
 sudo rm -rf /usr/local/opt/
 sudo rm -rf /usr/local/sbin/
 sudo rm -rf /usr/local/share/
 sudo rm -rf /usr/local/var/
 sudo rm -rf /usr/local/homebrew/
 sudo rm -rf /usr/local/Cellar/
 sudo rm -rf /usr/local/Frameworks/
 sudo rm -rf "${CP_INSTALL_DIR}"
exit 1                                         
        fi
fi 
        
              

              

