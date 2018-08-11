if [ $1 == "." ]
 then
    ORIG_DIR=$(pwd)
elif [ $1 ]
 then
    ORIG_DIR=$1
else
    echo "----- Please specify ----- "
    echo "1. fstack install location (/data/fstack)    "
    echo "2. network  identifier (eth0)     "
    exit 1001
fi

if [ $2 ]
then 
    NET_BOARD=$2
else 
    echo "----- Please specify ----- "
    echo "1. fstack install location (/data/fstack)    "
    echo "2. network  identifier (eth0)     "
    exit 1002
fi

echo "-------------------------------"
echo "       Installing DPDK         "
echo "-------------------------------"
echo "---------- ORIG-DIR -----------"
echo $ORIG_DIR
echo "---------- NetBoard  -----------"
echo $NET_BOARD
echo "-------------------------------"
echo "-----     DPDK Setup     ------"
echo "-------------------------------"
cd $ORIG_DIR/dpdk/usertools
./dpdk-setup.sh | exit 3
echo "--------------------------------"
echo "----    DPDK Setup End     -----"
echo "----------------------------------"
echo "configure for single node system"
echo "----------------------------------"
echo "echo 1024 > /sys/kernel/mm/hugepages/hugepages-2048kB/nr_hugepages"
echo 1024 > /sys/kernel/mm/hugepages/hugepages-2048kB/nr_hugepages
echo "---  Mounting to /mnt/huge  ---"
mkdir /mnt/huge
mount -t hugetlbfs nodev /mnt/huge
# close ASLR; it is necessary in multiple process
echo 0 > /proc/sys/kernel/randomize_va_space
echo "-------   Mount Finished  ---------"
echo "-----------------------------------"
echo "--- To make this permanant : "
echo " nodev /mnt/huge hugetlbfs defaults 0 0"
echo "-----------------------------------"
echo "-------     Offload NIC     -------"
modprobe uio
insmod $ORIG_DIR/dpdk/x86_64-native-linuxapp-gcc/kmod/igb_uio.ko
insmod $ORIG_DIR/dpdk/x86_64-native-linuxapp-gcc/kmod/rte_kni.ko
python dpdk-devbind.py --status
echo "----------------------------------"
echo "-------- Ifconfig Down  ----------"
echo "----------------------------------"
ifconfig $NET_BOARD down
echo "---------------------------------"
echo "----- Ifconfig down success -----"
echo "---------------------------------"
python dpdk-devbind.py --bind=igb_uio $NET_BOARD || exit 4 # assuming that use 10GE NIC and eth0modprobe ui
echo "--------------------------------"
echo "     Offload         Ended      "
echo "--------------------------------"
echo "=================================="
echo ""
echo ""
echo "================================="
echo "======== Compiling FSTACK ======="
echo "================================="
export FF_PATH=$ORIG_DIR
export FF_DPDK=$ORIG_DIR/dpdk/x86_64-native-linuxapp-gcc
cd ../../
cd lib
echo "=========  Make -j 8 ==========="
make -j 8 || exit 5
echo "================================"
echo "--------------------------------"
echo " *   F-Stack/DPDK Finished   *  "
echo " *                           *  "
echo " *  Please proceed to DH/CH  *  "
echo " *    -->  -->  -->  -->     *  "
echo "--------------------------------"
echo "================================"
