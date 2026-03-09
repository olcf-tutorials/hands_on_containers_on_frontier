#!/usr/bin/env bash

#SBATCH -A !!! YOUR PROJECT !!!
#SBATCH -J lammps_container_example
#SBATCH -o %j.out
#SBATCH -N 2
#SBATCH -t 00:05:00

export OMP_NUM_THREADS=7
export OMP_PROC_BIND=true
export OMP_PLACES=cores

srun -N${SLURM_NNODES} -n$(expr ${SLURM_NNODES} \* 8) -c7 --mpi=pmi2 \
    apptainer exec --sharens LAMMPS.sif /opt/lammps/bin/lmp \
    -k on t ${OMP_NUM_THREADS} -sf kk -in ij.in -log none
