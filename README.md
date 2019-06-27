# dpdk_hyperscan_install

## Description
A script to install dpdk 16.11, hyperscan library, intel c compiler(icc) and dependencies 

## Prerequisites
apt repo manager (available in debian ubuntu systems)
yum repo manager (available in centos systems)
Nothing much. Script will install all the support libraries.

## Installing
Execute the script using following command:
for centos
```
./dpdk_hyperscan_icc_for_for_centos.sh
```
for ubuntu
```
dpdk_hyperscan_icc_for_ubuntu.sh
```
Input option number to install given software package.
ex: 1
```
[1] : check cpu and mem info
[2] : install dependancies
[3] : install hyperscan
[4] : install parallel studio
[5] : source intel compiler
[6] : install dpdk
[7] : source dpdk variables
[q] : quit

  ```

Add additional repositories in case repository not available in your system.
Issues might arise for following dependacies:
-issue with gzip-devel
-issue with ccmake
-issue with mysql server (replaced by maria-db)
-issue with boost-devel version	1.57+ required	


## Acknowledgement 
[Hyperscan](https://01.org/hyperscan)
[DPDK](https://www.dpdk.org/)
[Intel ICC](https://software.intel.com/en-us/c-compilers)

## License
[MIT](https://choosealicense.com/licenses/mit/)
