#!/bin/bash
#SBATCH -J consensus_align                               # Job name 
#SBATCH -o consensus_align.%A.out                     # File to which stdout will be written
#SBATCH -N 1                                     # number of nodes
#SBATCH -n 16                                    # number of ranks
#SBATCH -c 1                                     # cores per rank
#SBATCH -t 0-08:00:00                             # Runtime in DD-HH:MM
#SBATCH --mem 80000                              # Memory for all cores in Mbytes (--mem-per-cpu for MPI jobs)
#SBATCH -p test                      # Partition general, serial_requeue, unrestricted, interact


module load python/2.7.14-fasrc01 jdk/1.8.0_45-fasrc01
module load gcc/7.1.0-fasrc01 openmpi/2.1.0-fasrc02 

source activate SECAPR

secapr align_sequences --sequences mapped/joined_unphased_fastas.fasta \
                       --output consensus_alignment \
                       --aligner mafft \
                       --output-format fasta \
                       --ambiguous \
                       --no-trim \
                       --cores $SLURM_NTASKS 

