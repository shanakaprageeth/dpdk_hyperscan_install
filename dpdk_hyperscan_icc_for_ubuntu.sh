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
	echo "This script is used to install hyperscan and dpdk on ubuntu 14 or centos 7 servers"
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
	
	sudo apt-get update
	rc=$?; if [[ $rc != 0 ]]; then echo "return code:  ${rc}"; print_error; fi
	sudo apt-get -y insatll build-essential linux-headers-`uname -r`
	rc=$?; if [[ $rc != 0 ]]; then echo "return code:  ${rc}"; print_error; fi
	sudo apt-get install -y libprotobuf-dev libleveldb-dev libsnappy-dev libopencv-dev \
        libhdf5-serial-dev protobuf-compiler \
	libgflags-dev libgoogle-glog-dev liblmdb-dev \
	cmake nginx libunwind8 libunwind-dev \
	libpcap0.8 libpcap-dev  \
	sqlite libsqlite3-dev  \
	gzip bzip2 libbz2-dev \
	libssl-dev zlib1g-dev libnuma-dev numactl
	rc=$?; if [[ $rc != 0 ]]; then echo "return code:  ${rc}"; print_error; fi
	echo "installing python"
	sudo apt-get install -y python3	
	echo "install ragel"
	sudo apt-get install -y ragel
	rc=$?; if [[ $rc != 0 ]]; then echo "return code:  ${rc}"; print_error; fi
	echo "installing mysql"
	sudo apt-get install -y mysql-server libmysqlclient
	rc=$?; if [[ $rc != 0 ]]; then echo "return code:  ${rc}"; print_error; fi
	echo "installing TokyoCabinet"
	sudo apt-get install -y libtokyocabinet-dev
	echo "installing Boost from Source"
	sudo apt-get install -y libboost-all-dev
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
	cmake ../hyperscan/ -DBUILD_SHARED_LIBS=ON
	rc=$?; if [[ $rc != 0 ]]; then echo "return code:  ${rc}"; print_error; fi
	cmake --build .
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
