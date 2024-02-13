#!/bin/bash
#SBATCH -J phase                               # Job name 
#SBATCH -o phase.%A.out                     # File to which stdout will be written
#SBATCH -N 1                                     # number of nodes
#SBATCH -n 1                                    # number of ranks
#SBATCH -c 1                                     # cores per rank
#SBATCH -t 0-08:00:00                             # Runtime in DD-HH:MM
#SBATCH --mem 10000                              # Memory for all cores in Mbytes (--mem-per-cpu for MPI jobs)
#SBATCH -p test                      # Partition general, serial_requeue, unrestricted, interact


module load python/2.7.14-fasrc01 jdk/1.8.0_45-fasrc01
module load gcc/7.1.0-fasrc01 openmpi/2.1.0-fasrc02 

source activate SECAPR

secapr phase_alleles --input mapped \
                     --output phased \
                     --min_coverage 3 
