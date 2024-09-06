#!/bin/bash

#SBATCH -A stf007
#SBATCH -J test
#SBATCH -N 1
#SBATCH -o simplejob_%j.out
#SBATCH -t 00:05:00

# TODO: load the required apptainer modules 
module load olcf-container-tools
module load apptainer-enable-mpi
module load apptainer-enable-gpu

# TODO: modify APPTAINERENV_LD_LIBRARY_PATH
export APPTAINERENV_LD_LIBRARY_PATH=/lustre/orion/stf008/world-shared/libs

# TODO fill out the rest of this srun to execute your container
srun -N1 --tasks-per-node=1 apptainer exec simple.sif /checkldlibs.sh
