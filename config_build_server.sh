#!/bin/sh

echo "start config unbuntu-14.04"


echo "1. install basic tools "

function install_basic()
{
	sudo apt-get install git-core gnupg flex bison gperf build-essential \
	  zip curl zlib1g-dev gcc-multilib g++-multilib libc6-dev-i386 \
	  lib32ncurses5-dev x11proto-core-dev libx11-dev lib32z-dev ccache \
	  libgl1-mesa-dev libxml2-utils xsltproc unzip
} 
  
echo "2. install jdk"
function install_jdk()
{
	sudo mkdir /usr/lib/jvm
    # install jdk 1.6
     
    # install jdk 1.7
    sudo apt-get install openjdk-7-jdk
     
    # for new system build, set default jdk to open jdk7
    sudo ln -s /usr/lib/jvm/java-7-openjdk-amd64 /usr/lib/jvm/java
     
    # added to enveroment
    echo "export JAVA_HOME=/usr/lib/jvm/java" | sudo tee -a /etc/profile
    echo "export JRE_HOME=\${JAVA_HOME}/jre" | sudo tee -a /etc/profile
    echo "export CLASSPATH=.:\${JAVA_HOME}/lib:\${JRE_HOME}/lib" | sudo tee -a /etc/profile
    # you need reboot to let it work and the end of
     
    sudo update-alternatives --install /usr/bin/java java /usr/lib/jvm/java/bin/java 300 
    sudo update-alternatives --install /usr/bin/javac javac /usr/lib/jvm/java/bin/javac 300 
    sudo update-alternatives --install /usr/bin/jar jar /usr/lib/jvm/java/bin/jar 300  
    sudo update-alternatives --install /usr/bin/javah javah /usr/lib/jvm/java/bin/javah 300  
    sudo update-alternatives --install /usr/bin/javap javap /usr/lib/jvm/java/bin/javap 300
    sudo update-alternatives --config java
}

echo "3. install repo "
function install_repo(){
    # install for system
    curl https://storage.googleapis.com/git-repo-downloads/repo > ~/bin/repo
    chmod a+x ~/bin/repo 
	echo "here need change repo source REPO_URL='git://scm/tools/git-repo.git’"
}

echo "4. install ssh"
function install_ssh(){
    sudo apt-get install openssh-server
    if [ $(sudo ps -e | grep ssh) == "" ];then
        sudo service ssh start
    fi
}

echo "5. install smb"
function install_samba(){
    sudo apt-get install samba
     
    # backup smb.conf
    sudo cp /etc/samba/smb.conf /etc/samba/smb.conf.bak
    # enable some config
    sudo sed -i "193s/;\[/\[/" /etc/samba/smb.conf
    sudo sed -i "194s/; / /" /etc/samba/smb.conf
    sudo sed -i "195s/;   read only = no/   read only = no/" /etc/samba/smb.conf
    # read only = yes
    sudo sed -i "199s/; / /" /etc/samba/smb.conf
     
    # add some ext
    echo "[global]" | sudo tee -a /etc/samba/smb.conf
    echo "follow symlinks = yes" | sudo tee -a /etc/samba/smb.conf
    echo "wide links = yes" | sudo tee -a /etc/samba/smb.conf
    echo "unix extensions = no" | sudo tee -a /etc/samba/smb.conf
	# 如果smb 无写权限,则需要在Share Definitions 里面的
	# 将read only = yes 置为 no
}

echo "6. useradd name "
function add_user()
{
	
	echo "sudo useradd -d /home/username -m username"
    echo "passwd username"
	echo "smbpasswd -a username"
}

echo "7. config zsh "
function config_zsh
{
	
}


