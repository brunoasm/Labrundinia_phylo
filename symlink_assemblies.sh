for genus in Ablabesmyia Chironomus Labrundinia Polypedilum
    do mkdir -p $genus
    cd $genus
    cp ../../assembled_redundans/sample_stats.txt ./
    grep $genus ../genera.txt | cut -f 1 | xargs -I {} ln -sf ../../assembled_redundans/{}.fa {}.fa
    #clean up non-existing links
    for fasta_file in *.fa 
        do [ ! -e $fasta_file ] && rm $fasta_file
    done
    cd ..
done
