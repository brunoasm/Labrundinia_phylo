#!/bin/bash
#SBATCH -J redundans                               # Job name 
#SBATCH -o redundans.%A.out                     # File to which stdout will be written
#SBATCH -N 1                                     # number of nodes
#SBATCH -n 20                                    # number of ranks
#SBATCH -c 1                                     # cores per rank
#SBATCH -t 0-08:00:00                             # Runtime in DD-HH:MM
#SBATCH --mem 4000                              # Memory for all cores in Mbytes (--mem-per-cpu for MPI jobs)
#SBATCH -p test                   # Partition general, serial_requeue, unrestricted, interact

module load python/2.7.14-fasrc02 gcc/8.2.0-fasrc01 perl/5.26.1-fasrc01 git/2.17.0-fasrc01 zlib/1.2.8-fasrc09

export PATH=/n/home08/souzademedeiros/programs/redundans:$PATH

mkdir -p assembled_redundans
#mkdir -p assembled_cdhit
cp assembled_abyss/sample_stats.txt assembled_redundans/

cd assembled_redundans

for fasta_file in ../assembled_abyss/*.fa
do
    rm -rf redundans
	root=$(basename -s .fa $fasta_file)
	R1=../fastq_cleaned/${root}_clean/${root}_clean-READ1.fastq
	R2=../fastq_cleaned/${root}_clean/${root}_clean-READ2.fastq
	redundans.py --identity 0.90 --overlap 0.2 --minLength 10 \
                     --iters 4 --limit 1.0 --threads $SLURM_NTASKS \
                     --fastq $R1 $R2 --fasta $fasta_file
	mv redundans/scaffolds.reduced.fa ${root}.fa
done
