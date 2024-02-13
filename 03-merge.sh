#!/bin/bash
#SBATCH -J merge                               # Job name 
#SBATCH -o merge.%A.out                     # File to which stdout will be written
#SBATCH -N 1
#SBATCH -n 16                                    # number of ranks
#SBATCH -t 0-08:00:00                             # Runtime in DD-HH:MM
#SBATCH --mem 40000                              # Memory for all cores in Mbytes (--mem-per-cpu for MPI jobs)
#SBATCH -p test                      # Partition general, serial_requeue, unrestricted, interact


######################################################
## All commented below will not be run
## Merging is not necessary here, since only one run was done
## Instead, we will simply symlink the folder with cleaned reads, for folder name consistency
#####################################################


ln -sf fastq_run1_cleaned fastq_cleaned

#module load python/2.7.14-fasrc01
#module load gcc/7.1.0-fasrc01 
#module load jdk/1.8.0_45-fasrc01
#
#source activate SECAPR
#
## In this step we will merge files from all runs and re-run secapr clean_reads to get a stats file
## Running clean_reads separately is good to check any lane-level effects, but to follow the pipeline it is easier to merge them before cleaning
#
## first, merging fastq files:
#
#find ./fastq_run*/ -maxdepth 1 -name '*.fastq' -exec basename {} \; | \
#    grep -v clean | sort | uniq | \
#    parallel -I ,, 'find ./fastq_run*/ -maxdepth 1 -name ,, -exec cat {} > fastq_merged/,, \;'
#
## now, cleaning using SECAPR
#secapr clean_reads --input fastq_merged --output fastq_cleaned --cores $SLURM_NTASKS --read_min 500 \
#                   --index double --config trimmomatic_config.cfg
#
