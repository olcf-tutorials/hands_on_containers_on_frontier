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
module load rocm/5.7.1


srun  -N2 -n8 --tasks-per-node 4 apptainer exec  --rocm osubench.sif /osu-micro-benchmarks-7.2/c/mpi/collective/blocking/osu_allgather -d rocm
