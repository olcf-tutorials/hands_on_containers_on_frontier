#!/usr/bin/env bash

#SBATCH -A  stf007uanofn
#SBATCH -J lammps_container_cpu
#SBATCH -o %j.out
#SBATCH -N 2
#SBATCH -t 00:10:00

module reset
module load PrgEnv-gnu
module load olcf-container-tools
module load apptainer-enable-mpi apptainer-enable-gpu
which apptainer

echo "simple multistage build LAMMPS"
srun -N 2 -n 16 --gpus-per-task=1 --gpu-bind=closest --unbuffered  apptainer exec --rocm lammpsmultistagesimple.sif lmp -k on g 1 -sf kk -pk kokkos gpu/aware on -in ij.in

echo "complex multistage build LAMMPS"
srun -N 2 -n 16 --gpus-per-task=1 --gpu-bind=closest --unbuffered  apptainer exec --rocm lammpsmultistagecomplex.sif lmp -k on g 1 -sf kk -pk kokkos gpu/aware on -in ij.in

