#!/bin/bash
mkdir assemblies_concatenated

cd mitobim
rm -f mitobim_concatenated.fasta

for dir in */
do 
    sample=$(basename $dir)
    cd $sample
    last=$(\ls -t | head -1)
    [ -e $last/*_noIUPAC.fasta ] && cat $last/*_noIUPAC.fasta | \
                                    sed -E "s/COI_.+/9_${sample} |9/g" | \
                                    sed -E "s/rRNA_.+/8_${sample} |8/g" | \
                                    sed -E "s/Tanytarsus_18S.+/6_${sample} |6/g" | \
                                    sed -E "s/Tanytarsus_28S.+/7_${sample} |7/g" >> ../mitobim_concatenated.fasta
    cd ..
done
cd ..

cp mitobim/mitobim_concatenated.fasta assemblies_concatenated/extracted_target_contigs_all_samples.fasta

#For each genus, we used a different number for minimum identity
#see output of script 7-extract_NPC_bygenus.sh

cd extracted_by_genus

cat extracted_Polypedilum/77/extracted_target_contigs_all_samples.fasta >> ../assemblies_concatenated/extracted_target_contigs_all_samples.fasta
cat extracted_Labrundinia/75/extracted_target_contigs_all_samples.fasta >> ../assemblies_concatenated/extracted_target_contigs_all_samples.fasta
cat extracted_Chironomus/76/extracted_target_contigs_all_samples.fasta >> ../assemblies_concatenated/extracted_target_contigs_all_samples.fasta
cat extracted_Ablabesmyia/81/extracted_target_contigs_all_samples.fasta >> ../assemblies_concatenated/extracted_target_contigs_all_samples.fasta

