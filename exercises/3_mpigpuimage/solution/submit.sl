#!/usr/bin/env bash

#SBATCH -A gen107
#SBATCH -J osubench_exercise
#SBATCH -o %j.out
#SBATCH -N 2
#SBATCH -t 00:20:00

module reset
module load PrgEnv-gnu
module load olcf-container-tools
module load apptainer-enable-mpi apptainer-enable-gpu


srun  -N2 -n8 --tasks-per-node 4 apptainer exec  --rocm osubench.sif /osu-micro-benchmarks-7.5.2/c/mpi/collective/blocking/osu_allgather -d rocm
