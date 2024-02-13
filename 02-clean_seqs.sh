#!/bin/bash
#SBATCH -J clean                               # Job name 
#SBATCH -o clean.%A.out                     # File to which stdout will be written
#SBATCH -N 1
#SBATCH -n 16                                    # number of ranks
#SBATCH -t 0-08:00:00                             # Runtime in DD-HH:MM
#SBATCH --mem 40000                              # Memory for all cores in Mbytes (--mem-per-cpu for MPI jobs)
#SBATCH -p test                      # Partition general, serial_requeue, unrestricted, interact


module load python/2.7.14-fasrc01
module load gcc/7.1.0-fasrc01 #R/3.5.0-fasrc01 
module load jdk/1.8.0_45-fasrc01

source activate SECAPR

# Name directories with fastq files as fastq_runX, where X in the number of the run

find . -maxdepth 1 -type d -regextype egrep -regex "./fastq_run[0-9]+" | while read directory
do

	#check quality
	#secapr quality_check --input $directory --output ${directory}_qc

	#clean sequences
	secapr clean_reads --input $directory --output ${directory}_cleaned \
                           --cores $SLURM_NTASKS --read_min 500 --index double \
                           --config trimmomatic_config.cfg

	#check quality of clean sequences
	secapr quality_check --input ${directory}_cleaned --output ${directory}_cleaned_qc
done
