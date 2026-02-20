#!/bin/bash
#SBATCH -A stf007
#SBATCH -J frontier_apptainer_pytorch_prebuilt_test
#SBATCH -o logs/%x.%j
#SBATCH -t 00:05:00
#SBATCH -p batch
#SBATCH -q debug
#SBATCH -N 4

# Load modules
module reset
module load cpe/25.09
module load rocm/7.2.0

module load olcf-container-tools
module load apptainer-enable-mpi
export NCCL_NET_GDR_LEVEL=3           # Typically improves performance, but remove this setting if you encounter a hang/crash.
export NCCL_CROSS_NIC=1               # On large systems, this NCCL setting has been found to improve performance
export NCCL_SOCKET_IFNAME=hsn0        # NCCL/RCCL will use the high speed network to coordinate startup.

# Get address of head node
ips=`hostname -I`
read -ra arr <<< ${ips}
export MASTER_ADDR=${arr[0]}
echo "MASTER_ADDR=" $MASTER_ADDR

# Needed to bypass MIOpen, Disk I/O Errors
export MIOPEN_USER_DB_PATH="/tmp/my-miopen-cache"
export MIOPEN_CUSTOM_CACHE_DIR=${MIOPEN_USER_DB_PATH}
rm -rf ${MIOPEN_USER_DB_PATH}
mkdir -p ${MIOPEN_USER_DB_PATH}


# Run script
# TODO fill in $TODOs below!
srun -N4 --tasks-per-node=8 -c7 --gpus-per-task=1 --gpu-bind=closest \
  $TODO_YOUR_APPTAINER_COMMAND --workdir `pwd` $TODO_YOUR_IMAGE_FILE \
  python3 $TODO_YOUR_RUN_FILE $TODO_YOUR_RUN_ARGUMENTS