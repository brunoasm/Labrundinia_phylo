#!/bin/bash
module load samtools
#here we will collect statistics for understanding the dataset assembly

#we will start with secapr statistics from extraction, but erasing the N extracted since we used exons for that.
awk 'NF{NF-=1};1' extracted/70/sample_stats.txt > .sample_stats.txt

#now, let's loop through lines and collect the remaining statistics

echo $(head -n 1 .sample_stats.txt) extracted mapped mapped_dedup ave_cov > sample_stats.txt

tail -n +2 .sample_stats.txt | while read line
do
    export sample=$(echo $line | cut -d " " -f 1)
    extracted=$(cat contig_alignment/*.fasta | grep -c $sample)
    mapped=$(samtools view -c -F 260 mapped/${sample}_remapped/including_duplicate_reads/${sample}.sorted.bam)
    mapped_dedup=$(samtools view -c -F 260 mapped/${sample}_remapped/${sample}_no_dupls_sorted.bam)
    ave_cov=$(sort -k1,1 -k3,3nr mapped/${sample}_remapped/${sample}_read_depth_per_position.txt | awk '!seen[$1]++' | awk '{sum+=$3}END{print sum / NR}')
    echo $line $extracted $mapped $mapped_dedup $ave_cov >> sample_stats.txt
done

rm .sample_stats.txt

