#!/bin/bash
#SBATCH -J assemble                               # Job name 
#SBATCH -o assemble.%A.out                     # File to which stdout will be written
#SBATCH -N 1                                     # number of nodes
#SBATCH -n 16                                    # number of ranks
#SBATCH -c 1                                     # cores per rank
#SBATCH -t 7-00:00:00                             # Runtime in DD-HH:MM
#SBATCH --mem 40000                              # Memory for all cores in Mbytes (--mem-per-cpu for MPI jobs)
#SBATCH -p shared                      # Partition general, serial_requeue, unrestricted, interact


module load python/2.7.14-fasrc01 jdk/1.8.0_45-fasrc01
module load gcc/7.1.0-fasrc01 openmpi/2.1.0-fasrc02 abyss/2.0.2-fasrc02
#module load centos6 java/1.7.0_60-fasrc01
#module load trinity

source activate SECAPR

#At this stage, all samples should be cleaned and in the directory fastq_cleaned

#secapr assemble_reads --input fastq_cleaned --output assembled_trinity --assembler trinity \
# --contig_length 125 --cores $SLURM_NTASKS --max_memory 39000G

secapr assemble_reads --input fastq_cleaned --output assembled_abyss --assembler abyss \
 --contig_length 125 --kmer 96 --single_reads --cores $SLURM_NTASKS --max_memory 39000
