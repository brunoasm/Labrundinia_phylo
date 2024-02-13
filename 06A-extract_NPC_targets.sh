#!/bin/bash
#SBATCH -J extract                               # Job name 
#SBATCH -o extract.%A.out                     # File to which stdout will be written
#SBATCH -N 1                                     # number of nodes
#SBATCH -n 1                                    # number of ranks
#SBATCH -c 1                                     # cores per rank
#SBATCH -t 0-08:00:00                             # Runtime in DD-HH:MM
#SBATCH --mem 10000                              # Memory for all cores in Mbytes (--mem-per-cpu for MPI jobs)
#SBATCH -p test                      # Partition general, serial_requeue, unrestricted, interact


module load python/2.7.14-fasrc01 jdk/1.8.0_45-fasrc01
module load gcc/7.1.0-fasrc01 openmpi/2.1.0-fasrc02 

source activate SECAPR

mkdir -p extracted

for identity in `seq 60 90`
do

if [ -d "extracted/$identity" ]; then
  echo extracted/$identity exists, skipping
else
secapr find_target_contigs --contigs assembled_redundans \
                           --reference reference_NPC.fasta \
                           --output extracted/$identity \
                           --min-identity $identity
fi
done

cd extracted

echo Total number of loci extracted for each similarity threshold:
for dir in */ 
do 
n_extracted=$(cut -f 2-  $dir/match_table.txt | tail -n +2 | grep -o 1 | wc -l )
echo $dir $n_extracted
done
