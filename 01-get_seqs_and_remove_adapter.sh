#!/bin/bash
#SBATCH -J preprocess                               # Job name 
#SBATCH -o preprocess.%A.out                     # File to which stdout will be written
#SBATCH -N 1
#SBATCH -n 8                                    # number of ranks
#SBATCH -t 0-08:00:00                             # Runtime in DD-HH:MM
#SBATCH --mem 2000                              # Memory for all cores in Mbytes (--mem-per-cpu for MPI jobs)
#SBATCH -p test                      # Partition general, serial_requeue, unrestricted, interact


#This script gets demultiplexed reads, renames them and runs NGmerge to remove adapters
#change the following two variables according to the project:

#fastq_dir is the folder where raw fastq files are
fastq_dir=$HOME/labdir/archived_runs/BdM_ILL_007/180525_NS500422_0651_AHWLKMAFXX_8_8/Weevils/

#outfolder is the folder where filtered files will be saved
outfolder=fastq_run1

module load NGmerge

#1 - make a file with all sample IDs
find $fastq_dir/ -name '*X*.gz' | xargs -I {} basename {} | cut -d _ -f 1 > all_samples.txt

#2 - remove adapters with NGmerge
mkdir -p $outfolder
cd $outfolder
cat ../all_samples.txt | parallel -j $SLURM_NTASKS \
    NGmerge -a -y -1 "$fastq_dir/{}_*R1*.gz" -2 "$fastq_dir/{}_*R2*.gz" -o {}

#3 - rename all files
rename _1.fastq _R1.fastq *
rename _2.fastq _R2.fastq *
