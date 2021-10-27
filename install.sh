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

printf "\e[32mWe bringing up your System  - BE STRONG. BE REAL. BE DIGITAL. - The Client-Provisioning developed by TechDivision, please enter your\e[m\n"
sudo true
############## LINUX #########################################################
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

mac_xcode

#check specs and start CP
echo "checking Hardware and OS Version..."
MAC_TYPE=$(sysctl -a | grep "machdep.cpu.brand_string")
echo "${MAC_TYPE}"

#Install ansible-Playbooks
if [ ! -d "${CP_INSTALL_DIR}" ]; then
        mkdir "${CP_INSTALL_DIR}"
        chmod 775 "${CP_INSTALL_DIR}"
        chown "${CP_USER}" "${CP_INSTALL_DIR}" 
            cd "${HOME}" &&
            git clone "$CP_URL" 
fi 

message_info_start

# MAC Appel M1 #####################################################################################################

if [[ $MAC_TYPE == "machdep.cpu.brand_string: Apple M1" ]]; then
        install_mac_m1
        echo -e "Client Provisionin Setup $(system_profiler SPSoftwareDataType -detailLevel mini) starting..."
#run playbooks
    cd "$CP_PLAYBOOKS" &&
    if [[ $CP_USER == "it-support" ]]; then
        
        ansible-playbook mac_arm_admin.yml
        
        message_bitdefender

        message_info_finish_admin

    else

        ansible-playbook mac_user.yml
        
        message_info_finish_user

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

message_bitdefender
    
message_info_finish_admin

    else
####### USER INSTALL #############  
install_mac_intel 

rights_intel "${CP_USER}"

                 
    ansible-playbook mac_user.yml
    
    message_info_finish_user    

#Check/install - Dev-setup  
init_dev "${CP_INSTALL_DIR}"

    fi
  fi           
fi