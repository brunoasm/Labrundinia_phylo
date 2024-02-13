# Anchored hybrid enrichment using PCR-based probes for chironomid phylogenies

This repository includes code used to assemble genes sequenced with anchored hybrid enrichment. For more information, check the publication:

Silva, F.L., de Medeiros, B.A.S., & Farrell, B.D. (2024). Once upon a fly: The biogeographical odyssey of Labrundinia (Chironomidae, Tanypodinae), an aquatic non-biting midge towards diversification. Molecular Phylogenetics and Evolution, 108025. https://doi.org/10.1016/j.ympev.2024.108025


# Modifications to standard SECAPR assembly

This dataset presents some complications that required modifications from standard SECAPR assembly:

1 - abyss cannot assemble large contigs, likely due to high heterozygosity
Solution: use redundans to refine assemblies

2 - genera sequenced have a large divergence and no close references for each one
Solution: extract contigs in two rounds: 

First with a single similarity threshold for all samples and a single reference
Second, choose references from extract genes, blast them on NCBI to validate, and redo extraction independently for each genus

Reference sample used in second round:
|            | EF1A | CAD1 | CAD4 | AATS | PGDI | TPI  |
|------------|------|------|------|------|------|------|
| Ablabesmyia| 23X1 | 23X1 | 23X1 | 23X1 | 23X1 | 45X1 |
| Chironomus | 29X1 | 31X22| 31X22| 31X22| 31X22| 31X22|
| Labrundinia| 4X1  | 4X1  | 4X1  | 31X9 | 4X1  | 4X1  |
| Polypedilum| 42X6 | 42X6 | 42X6 | 42X6 | 42X6 | 42X6 |



I manually concatenated the references for each genus in a fasta file. These are stored in the folder extracted_by_genus as reference_$GENUS.fasta


3 - There are ribosomal and mitochondrial genes
These were assembled with mitobim instead of abyss, and assemblies concatenated to nuclear protein coding genes for alignment


4 - coverage for some samples is too low after duplicate removal and SECAPR halts
To overcome this limitation, mapping and consensus was done in 2 steps:
First, mapping without removing duplicates
Based on this, mannually removing sequences with low coverage from alignments
These new alignments are in folder contig_alignment_filtered
Then redoing mapping, this time removing duplicates


These are the genes for final alignments:

| ID  |          NAME             |
|---|-----------------------|
| 0 | Tanytarsus_EF1alpha  |
| 1 | Tanytarsus_CAD1      |
| 2 | Tanytarsus_CAD4      |
| 3 | Tanytarsus_AATS      |
| 4 | Tanytarsus_PGDI      |
| 5 | Tanytarsus_TPI       |
| 6 | 18S                   |
| 7 | 28S                   |
| 8 | 16S                   |
| 9 | COI_COII              |

