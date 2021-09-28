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
echo "We bringing up your System for the Client-Provisioning developed by TechDivision, please enter your,"
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
    yes |  sudo apt install ansible
    yes | sudo apt install python-testresources
    yes | sudo apt install curl
# run Playbooks   
    cd "$CP_PLAYBOOKS" &&
    ansible-playbook ubuntu_admin.yml
#Check/install - Dev-setup
                echo "install developer environment?"
                echo "Please enter y/n"
                read "DEV_SETUP"
        if [[ $DEV_SETUP == "y" ]]; then
                bash <(curl -fsSL https://raw.githubusercontent.com/valet-sh/install/master/install.sh)
                valet.sh xps-setup -d
                echo "provisioning system for user account finished"
        else
                echo "provisioning system for user account finished"  
        fi      
fi
########## MAC OS #########################################################
if [[ "$OSTYPE" == "darwin"* ]]; then
    echo "Your operating system is MAC-OSX"
#check specs and start CP
    echo "checking Hardware and OS Version..."
    MAC_TYPE=$(sysctl -a | grep "machdep.cpu.brand_string")
    echo "${MAC_TYPE}"

#MAC Appel m1---------------------------------------------------------------------------      
if [[ $MAC_TYPE == "machdep.cpu.brand_string: Apple M1" ]]; then
        echo -e "Client Provisionin Setup $(system_profiler SPSoftwareDataType -detailLevel mini) starting..."
#install xcode a. ansible´     
        echo "checking xcode..." 
        xcode-select --install &&      
         read -p "Press [Enter] key to after X-CODE installation is finished..."
              cd /opt &&
              sudo mkdir homebrew 
              sudo chown "$USER" homebrew 
              sudo chgrp admin homebrew 
              curl -L https://github.com/Homebrew/brew/tarball/master | tar xz --strip 1 -C homebrew
              export PATH="/opt/homebrew/bin:$PATH"
        brew install ansible
# install repo
        if [ ! -d "${CP_INSTALL_DIR}" ]; then
                sudo mkdir "${CP_INSTALL_DIR}"
        fi
                cd ${HOME} &&
                git clone $CP_URL
# reset correct permissions
                sudo chmod 775 "${CP_INSTALL_DIR}"
                sudo chown "${CP_USER}" "${CP_INSTALL_DIR}"
#run playbooks
            cd "$CP_PLAYBOOKS" &&
            if [[ $CP_USER == "it-support" ]]; then
                ansible-playbook mac_arm_admin.yml
                echo "provisioning system for Admin-Account finished"
            else
                ansible-playbook mac_user.yml
#Check/install - Dev-setup                
                    echo "install developer environment?"
                    echo "Please enter y/n"
                    read "DEV_SETUP"
                if [[ $DEV_SETUP == "y" ]]; then
                    bash <(curl -fsSL https://raw.githubusercontent.com/valet-sh/install/master/install.sh)
                    valet.sh install
                    echo "provisioning system for user account finished"
                    exit 1
                else
                    echo "provisioning system for user account finished"  
                    exit 1
                fi      
            fi
#cleaning     
yes | /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/uninstall.sh)"          
echo "removing install files, please enter your,"
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
sudo rm -rf /opt/homebrew
sudo rm -rf "/${CP_INSTALL_DIR}"
exit 1                                                  
                                              
                                            
                        
#Mac INTEL -----------------------------------------------------------------------------
 else
    echo -e "Client Provisionin Setup $(system_profiler SPSoftwareDataType -detailLevel mini) starting..."
#install xcode, brew a. ansible
    echo "checking xcode..." 
        xcode-select --install       
        read -p "Press [Enter] key to after X-CODE installation is finished..."
        yes | /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        brew install openssl rust
            export CPPFLAGS=-I/usr/local/opt/openssl/include
            export LDFLAGS=-L/usr/local/opt/openssl/lib
        brew install ansible    
# install repo               
    if [ ! -d "${CP_INSTALL_DIR}" ]; then
                sudo mkdir "${CP_INSTALL_DIR}"
    fi
                sudo chmod 775 "${CP_INSTALL_DIR}"
                sudo chown "${CP_USER}" "${CP_INSTALL_DIR}" 
                cd ${HOME} &&
                git clone $CP_URL    
#run playbooks
            cd "$CP_PLAYBOOKS" &&
                if [[ $CP_USER == "it-support" ]]; then
                    ansible-playbook mac_intel_admin.yml
                    echo "provisioning system for Admin-Account finished"
                else
                    ansible-playbook mac_user.yml
#Check/install - Dev-setup 
                        echo "install developer environment?"
                        echo "Please enter y/n"
                        read "DEV_SETUP"
                    if [[ $DEV_SETUP == "y" ]]; then
                        bash <(curl -fsSL https://raw.githubusercontent.com/valet-sh/install/master/install.sh)
                        valet.sh install
                        echo "provisioning system for user account finished"
                        exit 1
                    else
                        echo "provisioning system for user account finished" 
                        exit 1 
                    fi      
    fi
#cleaning
echo "removing install files, please enter your,"               
yes | /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/uninstall.sh)"                                
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
sudo rm -rf "/${CP_INSTALL_DIR}"
exit 1                                         
        fi
fi 
        
              

              

