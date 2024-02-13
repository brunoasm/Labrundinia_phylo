#!/bin/bash
#SBATCH -J extract_bygenus                               # Job name 
#SBATCH -o extract_bygenus.%A.out                     # File to which stdout will be written
#SBATCH -N 1                                     # number of nodes
#SBATCH -n 1                                    # number of ranks
#SBATCH -c 1                                     # cores per rank
#SBATCH -t 0-08:00:00                             # Runtime in DD-HH:MM
#SBATCH --mem 10000                              # Memory for all cores in Mbytes (--mem-per-cpu for MPI jobs)
#SBATCH -p test                      # Partition general, serial_requeue, unrestricted, interact


module load python/2.7.14-fasrc01 jdk/1.8.0_45-fasrc01
module load gcc/7.1.0-fasrc01 openmpi/2.1.0-fasrc02 

source activate SECAPR

#first, let's create symlinks to the contigs for each genus
mkdir -p extracted_by_genus
cd extracted_by_genus

for genus in Ablabesmyia Chironomus Labrundinia Polypedilum
    do mkdir -p $genus
    cd $genus
    cp ../../assembled_redundans/sample_stats.txt ./
    grep $genus ../../genera.txt | cut -f 1 | xargs -I {} ln -sf ../../assembled_redundans/{}.fa {}.fa
    #clean up non-existing links
    for fasta_file in *.fa 
        do [ ! -e $fasta_file ] && rm $fasta_file
    done
    cd ..
done


for genus in Ablabesmyia Chironomus Labrundinia Polypedilum
do

mkdir extracted_$genus

for identity in `seq 60 90`
do

if [ -d "extracted/$identity" ]; then
  echo extracted/$identity exists, skipping
else
secapr find_target_contigs --contigs $genus \
                           --reference reference_$genus.fasta \
                           --output extracted_$genus/$identity \
                           --min-identity $identity
fi
done

done

#now report total number of loci extracted for each threshold

for genus in Ablabesmyia Chironomus Labrundinia Polypedilum
do
echo $genus
echo Total number of loci extracted for each similarity threshold:
for dir in extracted_$genus/*/ 
do 
n_extracted=$(cut -f 2-  $dir/match_table.txt | tail -n +2 | grep -o 1 | wc -l )
echo $dir $n_extracted
done

done

#This extracts the appropriate level for each genus
cat extracted_Ablabesmyia/81/extracted_target_contigs_all_samples.fasta extracted_Chironomus/76/extracted_target_contigs_all_samples.fasta extracted_Labrundinia/75/extracted_target_contigs_all_samples.fasta extracted_Polypedilum/77/extracted_target_contigs_all_samples.fasta > extracted_target_contigs_all_samples.fasta
