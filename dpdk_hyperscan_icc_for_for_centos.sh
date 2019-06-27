#!/bin/sh
# author : Shanaka Abeysiriwardhana shanakaprageeth@gmail.com
# description : script to install hyperscan and dpdk on centos 6,7 servers

# please enable these two repos
#vi /etc/yum.repos.d/CentOS-Base.repo
#vi /etc/yum.repos.d/epel.repo

PARALLEL_STUDIO_V="parallel_studio_xe_2017_update1"
DPDK_V="16.11"

print_welcome_message()
{
	echo "======================================================================="
	echo "This script is used to install hyperscan and dpdk on centos 7 servers"
	echo "======================================================================="
}

print_options()
{  
	echo "======================================================================="
	echo "	[1] : check cpu and mem info"
	echo "	[2] : install dependancies"
	echo "	[3] : install hyperscan"
	echo "	[4] : install parallel studio"
	echo "	[5] : source intel compiler"
	echo "	[6] : install dpdk"
	echo "	[7] : source dpdk variables"
	echo "	[8] : install DooR"
	echo "	[q] : quit"
	echo "======================================================================="
}

print_error(){
	echo "WARNING: command return non-zero value. Please check output for errors."
	echo "Press any key to continue...."
	read -n 1 -s
}

option_cpu_mem_info()
{	
	cat /proc/cpuinfo 
	rc=$?; if [[ $rc != 0 ]]; then echo "return code:  ${rc}"; print_error; fi
	cat /proc/meminfo 
	rc=$?; if [[ $rc != 0 ]]; then echo "return code:  ${rc}"; print_error; fi
	dmesg | grep -i numa
	rc=$?; if [[ $rc != 0 ]]; then echo "return code:  ${rc}"; print_error; fi
	
}

option_install_dependancies()
{
		# issue with gzip-devel
		# issue with ccmake
		# issue with mysql server (replaced by maria-db)
		# issue with boost-devel version	1.57+ required	
	
	sudo yum update
	rc=$?; if [[ $rc != 0 ]]; then echo "return code:  ${rc}"; print_error; fi
	sudo yum -y install yum-utils
	rc=$?; if [[ $rc != 0 ]]; then echo "return code:  ${rc}"; print_error; fi
	sudo yum -y groupinstall development
	rc=$?; if [[ $rc != 0 ]]; then echo "return code:  ${rc}"; print_error; fi
	sudo yum -y install epel-release \
	kernel-headers kernel-devel \
	protobuf-devel leveldb-devel snappy-devel opencv-devel \
	hdf5-devel \
	gflags-devel glog-devel lmdb-devel \
	cmake cmake3 nginx libunwind \
	libpcap libpcap-devel  \
	sqlite sqlite-devel  \
	gzip bzip2 bzip2-devel \
	openssl-devel zlib-devel numactl-devel
	rc=$?; if [[ $rc != 0 ]]; then echo "return code:  ${rc}"; print_error; fi
	echo "installing python"
	sudo yum -y install https://centos7.iuscommunity.org/ius-release.rpm
	rc=$?; if [[ $rc != 0 ]]; then echo "return code:  ${rc}"; print_error; fi
	sudo yum -y install python36u python36u-pip python36u-devel
	rc=$?; if [[ $rc != 0 ]]; then echo "return code:  ${rc}"; print_error; fi
	echo "build and install ragel"
	wget http://www.colm.net/files/ragel/ragel-6.9.tar.gz
	rc=$?; if [[ $rc != 0 ]]; then echo "return code:  ${rc}"; print_error; fi
	tar zxf ragel-6.9.tar.gz
	rc=$?; if [[ $rc != 0 ]]; then echo "return code:  ${rc}"; print_error; fi
	cd ragel-6.9
	rc=$?; if [[ $rc != 0 ]]; then echo "return code:  ${rc}"; print_error; fi
	./configure
	rc=$?; if [[ $rc != 0 ]]; then echo "return code:  ${rc}"; print_error; fi
	make
	rc=$?; if [[ $rc != 0 ]]; then echo "return code:  ${rc}"; print_error; fi
	sudo make install
	rc=$?; if [[ $rc != 0 ]]; then echo "return code:  ${rc}"; print_error; fi
	cd ../
	rc=$?; if [[ $rc != 0 ]]; then echo "return code:  ${rc}"; print_error; fi
	echo "installing mysql"
	wget http://repo.mysql.com/mysql-community-release-el7-5.noarch.rpm
	rc=$?; if [[ $rc != 0 ]]; then echo "return code:  ${rc}"; print_error; fi
	sudo rpm -ivh mysql-community-release-el7-5.noarch.rpm
	rc=$?; if [[ $rc != 0 ]]; then echo "return code:  ${rc}"; print_error; fi
	sudo yum update
	rc=$?; if [[ $rc != 0 ]]; then echo "return code:  ${rc}"; print_error; fi
	sudo yum install -y mysql-community-devel mysql-server
	rc=$?; if [[ $rc != 0 ]]; then echo "return code:  ${rc}"; print_error; fi
	sudo systemctl start mysqld
	rc=$?; if [[ $rc != 0 ]]; then echo "return code:  ${rc}"; print_error; fi
	echo "installing TokyoCabinet"
	wget http://fallabs.com/tokyocabinet/tokyocabinet-1.4.48.tar.gz
	rc=$?; if [[ $rc != 0 ]]; then echo "return code:  ${rc}"; print_error; fi
	tar zxf tokyocabinet-1.4.48.tar.gz 
	rc=$?; if [[ $rc != 0 ]]; then echo "return code:  ${rc}"; print_error; fi
	cd tokyocabinet-1.4.48/
	rc=$?; if [[ $rc != 0 ]]; then echo "return code:  ${rc}"; print_error; fi
	sudo ./configure  
	rc=$?; if [[ $rc != 0 ]]; then echo "return code:  ${rc}"; print_error; fi
	sudo make
	rc=$?; if [[ $rc != 0 ]]; then echo "return code:  ${rc}"; print_error; fi
	sudo make install
	rc=$?; if [[ $rc != 0 ]]; then echo "return code:  ${rc}"; print_error; fi
	cd ../
	rc=$?; if [[ $rc != 0 ]]; then echo "return code:  ${rc}"; print_error; fi
	echo "installing Boost from Source"
	wget https://sourceforge.net/projects/boost/files/boost/1.63.0/boost_1_63_0.tar.gz
	rc=$?; if [[ $rc != 0 ]]; then echo "return code:  ${rc}"; print_error; fi
	tar xvf boost_1_63_0.tar.gz
	rc=$?; if [[ $rc != 0 ]]; then echo "return code:  ${rc}"; print_error; fi
	sudo mv boost_1_63_0/ /usr/local/
	rc=$?; if [[ $rc != 0 ]]; then echo "return code:  ${rc}"; print_error; fi
	sudo ln -s /usr/local/boost_1_63_0/ /usr/local/boost
	rc=$?; if [[ $rc != 0 ]]; then echo "return code:  ${rc}"; print_error; fi
	cd /usr/local/boost_1_63_0
	rc=$?; if [[ $rc != 0 ]]; then echo "return code:  ${rc}"; print_error; fi
	sudo ./bootstrap.sh prefix=/usr/local
	rc=$?; if [[ $rc != 0 ]]; then echo "return code:  ${rc}"; print_error; fi
	sudo ./b2 install -- with=all 
	rc=$?; if [[ $rc != 0 ]]; then echo "return code:  ${rc}"; print_error; fi
	cd -
	rc=$?; if [[ $rc != 0 ]]; then echo "return code:  ${rc}"; print_error; fi
	echo "complete" 
	
}

option_install_hyperscan()
{
	
	git clone https://github.com/intel/hyperscan.git
	rc=$?; if [[ $rc != 0 ]]; then echo "return code:  ${rc}"; print_error; fi
	mkdir hs_build
	rc=$?; if [[ $rc != 0 ]]; then echo "return code:  ${rc}"; print_error; fi
	cd hs_build
	rc=$?; if [[ $rc != 0 ]]; then echo "return code:  ${rc}"; print_error; fi
	cmake3 ../hyperscan/ -DBUILD_SHARED_LIBS=ON
	rc=$?; if [[ $rc != 0 ]]; then echo "return code:  ${rc}"; print_error; fi
	cmake3 --build .
	rc=$?; if [[ $rc != 0 ]]; then echo "return code:  ${rc}"; print_error; fi
	sudo make install
	rc=$?; if [[ $rc != 0 ]]; then echo "return code:  ${rc}"; print_error; fi
	cd ../
	rc=$?; if [[ $rc != 0 ]]; then echo "return code:  ${rc}"; print_error; fi
	
}

option_install_parallel_studio()
{
	
	tar xvf "${PARALLEL_STUDIO_V}.tgz"
	rc=$?; if [[ $rc != 0 ]]; then echo "return code:  ${rc}"; print_error; fi
	cd "${PARALLEL_STUDIO_V}"
	rc=$?; if [[ $rc != 0 ]]; then echo "return code:  ${rc}"; print_error; fi
	echo "Please install parallel studio using the setup GUI"
	rc=$?; if [[ $rc != 0 ]]; then echo "return code:  ${rc}"; print_error; fi
	sudo ./install_GUI.sh
	rc=$?; if [[ $rc != 0 ]]; then echo "return code:  ${rc}"; print_error; fi
	source /opt/intel/bin/compilervars.sh intel64
	rc=$?; if [[ $rc != 0 ]]; then echo "return code:  ${rc}"; print_error; fi
	source /opt/intel/bin/iccvars.sh ia32
	rc=$?; if [[ $rc != 0 ]]; then echo "return code:  ${rc}"; print_error; fi
	cd ../
	rc=$?; if [[ $rc != 0 ]]; then echo "return code:  ${rc}"; print_error; fi
	
}

option_source_icc()
{
	source /opt/intel/bin/compilervars.sh intel64
	rc=$?; if [[ $rc != 0 ]]; then echo "return code:  ${rc}"; print_error; fi
	source /opt/intel/bin/iccvars.sh ia32
	rc=$?; if [[ $rc != 0 ]]; then echo "return code:  ${rc}"; print_error; fi
	
}

option_install_dpdk()
{
	
	wget "http://dpdk.org/browse/dpdk/snapshot/dpdk-${DPDK_V}.tar.gz"
	rc=$?; if [[ $rc != 0 ]]; then echo "return code:  ${rc}"; print_error; fi
	tar -xf "dpdk-${DPDK_V}.tar.gz"
	rc=$?; if [[ $rc != 0 ]]; then echo "return code:  ${rc}"; print_error; fi
	cd "dpdk-${DPDK_V}"
	rc=$?; if [[ $rc != 0 ]]; then echo "return code:  ${rc}"; print_error; fi
	echo "Please compile dpdk using the setup options"
	rc=$?; if [[ $rc != 0 ]]; then echo "return code:  ${rc}"; print_error; fi
	./tools/dpdk-setup.sh
	rc=$?; if [[ $rc != 0 ]]; then ./usertools/dpdk-setup.sh; fi
	rc=$?; if [[ $rc != 0 ]]; then echo "return code:  ${rc}"; print_error; fi
	cd ../
	rc=$?; if [[ $rc != 0 ]]; then echo "return code:  ${rc}"; print_error; fi
	
}

option_set_dpdk_vars()
{
	
	export "RTE_SDK=/home/${USER}/repos/dpdk-${DPDK_V}"
	rc=$?; if [[ $rc != 0 ]]; then echo "return code:  ${rc}"; print_error; fi
	export RTE_TARGET=x86_64-native-linuxapp-gcc
	rc=$?; if [[ $rc != 0 ]]; then echo "return code:  ${rc}"; print_error; fi
	
}


INPUT_OPTION=0
print_welcome_message
print_options
printf "Please select an option:"
cd ../../
read INPUT_OPTION
while [ "$INPUT_OPTION"!="q" ]
do
	case $INPUT_OPTION in
		1)
			option_cpu_mem_info
			;;
		2)
			option_install_dependancies
			;;
		3)
			option_install_hyperscan
			;;
		4)
			option_install_parallel_studio
			;;
		5)
			option_source_icc
			;;
		6)
			option_install_dpdk
			;;
		7)
			option_set_dpdk_vars
			;;
		q)
			exit 0
	esac
	echo "Press any key to continue...."
	read -n 1 -s
	print_options	
	printf "Please select an option:"
	read INPUT_OPTION
done
