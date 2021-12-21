#!/usr/bin/env bash
#
# TechDivision client provisioning
#
# This script installs the command line tools and ansible. After this the
# client provisioning via ansible will be done.
#############################################################################
# VARIABLES
#############################################################################
CP_URL="https://client3112:rfc_a_o5xJNyqU3EMNN5@git.tdservice.cloud/fe/ansible/ansible-client-provisioning.git" 
CP_USER=${USER} 
CP_INSTALL_DIR="${HOME}/.ansible"
CP_PLAYBOOKS="$CP_INSTALL_DIR/playbooks"
CP_INCLUDE_URL="https://raw.githubusercontent.com/terfoorthr/install.sh/master/include.sh"
#############################################################################

#import functions-----------------------------------------------
source /dev/stdin <<< "$( curl -sS ${CP_INCLUDE_URL} )"

############## LINUX #########################################################
printf "\e[32mWe bringing up your System  - BE STRONG. BE REAL. BE DIGITAL. - The Client-Provisioning developed by TechDivision, please enter your\e[m\n"
sudo true

if [[ "$OSTYPE" == "linux-gnu" ]]; then
echo "Your operating system," 
hostnamectl

# install Ansible-Repo-dir
    if [ ! -d "${CP_INSTALL_DIR}" ]; then
        mkdir "${CP_INSTALL_DIR}"
        chmod 775 "${CP_INSTALL_DIR}"
        chown "${CP_USER}" "${CP_INSTALL_DIR}"
    
    fi 
# install dependencies 
install_depends_ubuntu

# run Playbooks   
    cd ${HOME} &&
    git clone $CP_URL 
    cd "$CP_PLAYBOOKS" &&
    ansible-playbook ubuntu_admin.yml
        printf "\e[32mprovisioning system for user account finished\e[m\n"  
    rm -r "${CP_INSTALL_DIR}" 
fi

########## MAC OS ###################################################################################################
if [[ "$OSTYPE" == "darwin"* ]]; then
echo "Your operating system is MAC-OSX"

# install X-Code
mac_xcode

#check specs and start Client-Provisioning
echo "checking Hardware and OS Version..."
MAC_TYPE=$(sysctl -a | grep "machdep.cpu.brand_string")
echo "${MAC_TYPE}"

#Install Ansible-Playbooks
if [ ! -d "${CP_INSTALL_DIR}" ]; then
        mkdir "${CP_INSTALL_DIR}"
        chmod 775 "${CP_INSTALL_DIR}"
        chown "${CP_USER}" "${CP_INSTALL_DIR}" 
            cd "${HOME}" &&
            git clone "$CP_URL" 
            mv "${home}"/ansible-client-provisioning "${home}"/.ansible
fi 
sleep 5s
#installation info
message_info_start

# MAC Appel M1 #####################################################################################################

if [[ $MAC_TYPE == "machdep.cpu.brand_string: Apple M1" ]]; then

#install m1 dependencies       
       install_mac_m1

#run playbook for Admin Account
    cd "$CP_PLAYBOOKS" &&
    sleep 5s
    if [[ $CP_USER == "it-support" ]]; then       
        ansible-playbook mac_arm_admin.yml

# info massage for bitdefender installation        
        message_bitdefender

# info massage
        message_info_finish_admin

    else

# run playbook for User-Account
        ansible-playbook mac_user.yml

# info massage        
        message_info_finish_user

    fi      



#Mac INTEL#####################################################################################################
else
    echo -e "Client Provisionin Setup $(system_profiler SPSoftwareDataType -detailLevel mini) starting..."
  
####### ADMIN INSTALL #############                       
    if [[ $CP_USER == "it-support" ]]; then
#instal dependencies
install_mac_intel

### run playbooks        
cd "$CP_PLAYBOOKS" &&
ansible-playbook mac_intel_admin.yml

# info massage for bitdefender installation 
message_bitdefender

# info massage    
# !!new, when filevault status is active provisioning is complete else show error message
        if  fdesetup isactive = true 
            then
            message_info_finish_admin
        else
            message_error
        fi
  
    else

####### USER INSTALL #############  
#install dependencies
install_mac_intel 

#change Homebrew rights
rights_intel "${CP_USER}"

#run playbook
 cd "$CP_PLAYBOOKS" &&                  
 ansible-playbook mac_user.yml

# info massage
    message_info_finish_user    

#Check/install - Dev-setup  
init_dev "${CP_INSTALL_DIR}"
    fi

  fi    

## remove install-dir   
rm -rf "${CP_INSTALL_DIR}" 

fi
