#!/bin/bash

#SBATCH -A stf007
#SBATCH -J test
#SBATCH -N 4
#SBATCH -o simplejob_%j.out
#SBATCH -t 00:05:00

srun -N4 --tasks-per-node=1 apptainer exec simpleoras.sif hostname
