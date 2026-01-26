#!/usr/bin/env bash

#SBATCH -A gen107
#SBATCH -J lammps_container_gpu
#SBATCH -o %j.out
#SBATCH -N 2
#SBATCH -t 00:40:00

module reset
module load PrgEnv-gnu
module load olcf-container-tools
module load apptainer-enable-mpi apptainer-enable-gpu
which apptainer

echo "original LAMMPS image"
srun -N 2 -n 16 --gpus-per-task=1 --gpu-bind=closest --unbuffered  apptainer exec --rocm lammps.sif lmp -k on g 1 -sf kk -pk kokkos gpu/aware on -in ij.in

echo "simple multistage build LAMMPS"
srun -N 2 -n 16 --gpus-per-task=1 --gpu-bind=closest --unbuffered  apptainer exec --rocm lammpsmultistagesimple.sif lmp -k on g 1 -sf kk -pk kokkos gpu/aware on -in ij.in

echo "complex multistage build LAMMPS"
srun -N 2 -n 16 --gpus-per-task=1 --gpu-bind=closest --unbuffered  apptainer exec --rocm lammpsmultistagecomplex.sif lmp -k on g 1 -sf kk -pk kokkos gpu/aware on -in ij.in

