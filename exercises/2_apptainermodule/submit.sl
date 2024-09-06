#!/bin/bash

#SBATCH -A stf007
#SBATCH -J test
#SBATCH -N 1
#SBATCH -o simplejob_%j.out
#SBATCH -t 00:05:00

# TODO: load the required apptainer modules 

# TODO: modify APPTAINERENV_LD_LIBRARY_PATH

# TODO fill out the rest of this srun to execute your container
srun -N1 --tasks-per-node=1 
