#!/bin/bash
#SBATCH -J realign_and_trim                               # Job name 
#SBATCH -o realign_and_trim.%A.out                     # File to which stdout will be written
#SBATCH -N 1                                     # number of nodes
#SBATCH -n 8                                    # number of ranks
#SBATCH -c 1                                     # cores per rank
#SBATCH -t 0-08:00:00                             # Runtime in DD-HH:MM
#SBATCH --mem 20000                              # Memory for all cores in Mbytes (--mem-per-cpu for MPI jobs)
#SBATCH -p test,shared                      # Partition general, serial_requeue, unrestricted, interact


# SECAPR alignments are still not entirely adequate for phylogenetic analysis

# We still have to do the following:

# 0 - add outgroups
# 1 - remove Ns at the ends of sequences
# 2 - remove very short sequences
# 3 - use a better alignment algorithm, which can deal propoerly with fragmnetary sequences: UPP
# 4 - manually inspect for weird stuff: 
            # sequences with very low identity in relation to the rest of the alignment
            # indels where they are not supposed to exist (e. g. coding regions of mitochondrial genes)

# This script accomplishes 1-3, for 4 I recommend inspecting alignments in Geneious 

# This script requires as input the path to the folder containing sequences to be realigned

infolder=$(readlink -f $1)
outfolder=${infolder}_realigned

module load python/2.7.14-fasrc01 jdk/1.8.0_45-fasrc01

source activate UPP

rm -r $outfolder
mkdir $outfolder
cd $outfolder

cp $infolder/*.fasta ./

for infile in *.fasta
do
    echo STARTING $infile
    sed -i 's/_R_//g' $infile #SECAPR leaves _R_ in some sequences, remove it
    inbase=$(basename $infile .fasta)
    python ../15.1-strip_N.py $infile $inbase.stripped.fasta
    run_upp.py -l 5 -x $SLURM_NTASKS -M -1 -T 0.2 -s $inbase.stripped.fasta -o $inbase.realigned -p /scratch/
    python ../15.2-trim_alignments.py -a $inbase.realigned_alignment.fasta -o $inbase.aligned.trimmed.fasta --min-data 100 --coverage 0.2 --min-seqs 4
    rm $infile *alignment_masked.fasta *insertion_columns.txt *pasta.fasta *pasta.fasttree    
done


