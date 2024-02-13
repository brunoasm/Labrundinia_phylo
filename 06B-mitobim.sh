#!/bin/bash
#SBATCH -J mitobim                               # Job name 
#SBATCH -o mitobim.%A.out                     # File to which stdout will be written
#SBATCH -N 1                                     # number of nodes
#SBATCH -n 24                                    # number of ranks
#SBATCH -c 1                                     # cores per rank
#SBATCH -t 3-00:00:00                             # Runtime in DD-HH:MM
#SBATCH --mem 120000                              # Memory for all cores in Mbytes (--mem-per-cpu for MPI jobs)
#SBATCH -p shared                      # Partition general, serial_requeue, unrestricted, interact

#function to enable parallelization
#first argument is folder with sequence reads
#second argument is reference root: mito or ribo

assemble_mito () { 

samp=$(basename $1 | cut -d _ -f 1 )
bash ../interleave_fastq.sh $1/*READ1.fastq $1/*READ2.fastq > ${samp}_interleaved.fastq
rm -rf $samp
mkdir -p $samp
cd $samp

MITObim.pl -quick ../../references_mitobim.fasta -end 10 -sample ${samp} -readpool ../${samp}_interleaved.fastq \
           -ref mitoribo --NFS_warn_only --pair --clean --min_cov 5
} 

export -f assemble_mito

module load gcc/7.1.0-fasrc01 perl parallel
module load mira/4.0.2-fasrc02

export PATH=/n/home08/souzademedeiros/programs/MITObim:$PATH

#mkdir -p mitobim_ribo
#cd mitobim_ribo
#find ../fastq_cleaned/ -name '*_clean' -type d  | parallel --jobs $SLURM_NTASKS assemble_mito {} ribo
#cd ..

mkdir -p mitobim
cd mitobim
find ../fastq_cleaned/ -name '*_clean' -type d  | parallel --jobs $SLURM_NTASKS assemble_mito {}
