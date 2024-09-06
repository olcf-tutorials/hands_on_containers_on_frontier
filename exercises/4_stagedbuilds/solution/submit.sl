#!/usr/bin/env bash

#SBATCH -A  stf007uanofn
#SBATCH -J lammps_container_gpu
#SBATCH -o %j.out
#SBATCH -N 2
#SBATCH -t 00:20:00

module reset
module load PrgEnv-gnu
module load olcf-container-tools
module load apptainer-enable-mpi apptainer-enable-gpu


srun  -N1 -n1 apptainer exec  --rocm osubench.sif ldd /osu_allgather 
srun  -N2 -n8 --tasks-per-node 4 apptainer exec  --rocm osubench.sif /osu_allgather -d rocm
