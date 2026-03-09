#!/bin/bash
#SBATCH -A stf007
#SBATCH -J ddp_test
#SBATCH -o logs/frontier_apptainer_mltests.%j
#SBATCH -e logs/frontier_apptainer_mltests.%j
#SBATCH -t 00:30:00
#SBATCH -p batch
#SBATCH -N 4

export all_proxy=socks://proxy.ccs.ornl.gov:3128/
export ftp_proxy=ftp://proxy.ccs.ornl.gov:3128/
export http_proxy=http://proxy.ccs.ornl.gov:3128/
export https_proxy=http://proxy.ccs.ornl.gov:3128/
export no_proxy='localhost,127.0.0.0/8,*.ccs.ornl.gov'


# Load modules

module load rocm/6.4.0
module load craype-accel-amd-gfx90a


#cloning Jax repo for gaussian_process_regression example
git clone https://github.com/jax-ml/jax.git

set -ex
echo "About to Run Apptainer Exec"

#Run Script 
time srun -N4 -n32 --tasks-per-node=8 -c7 --gpus-per-task=1 --gpu-bind=closest apptainer exec --workdir `pwd` jax_latest.sif  ./pyrun_gaussian_regression.sh
