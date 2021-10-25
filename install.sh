#!/usr/bin/env bash
#
# TechDivision client provisioning
#
# This script installs the command line tools and ansible. After this the
# client provisioning via ansible will be done.
#############################################################################
# VARIABLES
#############################################################################
CP_URL="it-support:Vuxayet0!@10.5.20.61:/home/it-support/.ansible" 
CP_USER=${USER} 
CP_INSTALL_DIR="${HOME}/.ansible"
CP_PLAYBOOKS="$CP_INSTALL_DIR/playbooks"
#############################################################################

#Check system and install recources-----------------------------------------------

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
if [ ! -d "${CP_INSTALL_DIR}" ]; then
        mkdir "${CP_INSTALL_DIR}"
fi
    chmod 775 "${CP_INSTALL_DIR}"
    chown "${CP_USER}" "${CP_INSTALL_DIR}" 
    cd ${HOME} &&
    git clone $CP_URL 
    
osascript -e 'display alert "Wichtig" message "Während des Programmablaufes erscheinen ein paar Bestätigungs Fenster - Diese IMMER erlauben/bestätigen
Insbesondere bei der Bitdefender Installation.

A couple of confirmation popup windows appear during the installation - Always allow / confirm these
Especially when installing Bitdefender."'

# MAC Appel M1 #####################################################################################################

if [[ $MAC_TYPE == "machdep.cpu.brand_string: Apple M1" ]]; then
                        cd /opt &&
                            sudo mkdir homebrew 
                            sudo chown "$USER" homebrew 
                            sudo chgrp admin homebrew 
                            curl -L https://github.com/Homebrew/brew/tarball/master | tar xz --strip 1 -C homebrew
                                export PATH="/opt/homebrew/bin:$PATH"
                            brew install ansible    
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
                                                                                                                   
#Mac INTEL#####################################################################################################
                else
                    echo -e "Client Provisionin Setup $(system_profiler SPSoftwareDataType -detailLevel mini) starting..."                                 
####### ADMIN INSTALL #############                       
                        if [[ $CP_USER == "it-support" ]]; then
#instal brew a. ansible  
                                            sudo dscl . -create /Groups/brewers   
                                            sudo dseditgroup -o edit -a ${CP_USER} -t user brewers
                                            yes | /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
                                            brew install ansible               
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
                                                cd "$CP_PLAYBOOKS" &&
                                                    sudo dseditgroup -o edit -a ${CP_USER} -t user brewers
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
                                                ansible-playbook mac_user.yml
    #Check/install - Dev-setup                      
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
                        fi
                    #cleaning
                    echo "removing install files."               
                    sudo rm -rf "${CP_INSTALL_DIR}"
                    exit 1                                         
            fi
         

              

fi
