This README.txt file was generated on 2022-11-20 by Christina C. Saak

GENERAL INFORMATION

1. Title of Dataset: Supplemental Material for "Longitudinal, multi-platform metagenomics yields a high-quality genomic catalog and guides an in vitro model for cheese communities"

2. Author Information
	A. First Author Contact Information
		Name: Christina C. Saak
		Institution: University of California San Diego
		Address: Division of Biological Sciences, Section of Molecular Biology, University of California San Diego, 9500 Gilman Drive, La Jolla, CA 92093, USA
		Email: csaak@ucsd.edu/christinacsaak@gmail.com

	B. Second Author Contact Information
		Name: Emily C. Pierce
		Institution: University of California San Diego
		Address: Division of Biological Sciences, Section of Molecular Biology, University of California San Diego, 9500 Gilman Drive, La Jolla, CA 92093, USA

	C. Third Author Contact Information
		Name: Cong B. Dinh
		Institution: University of California San Diego
		Address: Division of Biological Sciences, Section of Molecular Biology, University of California San Diego, 9500 Gilman Drive, La Jolla, CA 92093, USA

	D. Third Author Contact Information
		Name: Daniel Portik	
		Institution: Pacific Biosciences
		Address: 1305 O'Brien Dr, Menlo Park, CA 94025, USA

	E. Fourth Author Contact Information
		Name: Richard Hall
		Institution: Pacific Biosciences
		Address: 1305 O'Brien Dr, Menlo Park, CA 94025, USA

	F. Fifth Author Contact Information
		Name: Meredith Ashby
		Institution: Pacific Biosciences
		Address: 1305 O'Brien Dr, Menlo Park, CA 94025, USA

	G. Principal Investigator Contact Information
		Name: Rachel J. Dutton
		Institution: University of California San Diego
		Address: Division of Biological Sciences, Section of Molecular Biology, University of California San Diego, 9500 Gilman Drive, La Jolla, CA 92093, USA


3. Information about funding sources that supported the collection of the data
- The Graduate Women in Science fellowship awarded to Christina C. Saak that allowed the generation of metaHi-C data
- The IGM Genomics Center at the University of California San Diego/Illumina for a NovaSeq sequencing grant to Emily C. Pierce 
- The National Institute of Health (DP2 AT010401), the David and Lucile Packard Foundation (#2016-65131) and the Pew Charitable Trusts (Pew Scholar in Biomedical Sciences) awarded to Rachel J. Dutton. 

4. Description of dataset: This dataset constitutes the supplemental material for the manuscript entitled “Longitudinal, multi-platform metagenomics yields a high-quality genomic catalog and guides an in vitro model for cheese communities”


DATA & FILE OVERVIEW

1. File List: 
	A. Individual timepoint assemblies:
		Cheese A:
		Week 2: O2.contigs.fasta
		Week 3: O3.contigs.fasta
		Week 4: O4.contigs.fasta
		Week 9: O5.contigs.fasta
		Week 13: O6.contigs.fasta

		Cheese B:
		Week 2: Wy2.contigs.fasta
		Week 3: Wy3.contigs.fasta
		Week 4: Wy4.contigs.fasta
		Week 9: Wy5.contigs.fasta
		Week 13: Wy6.contigs.fasta

		Cheese C: 
		Week 2: We2.contigs.fasta
		Week 3: We3.contigs.fasta
		Week 4: We4.contigs.fasta
		Week 9: We5.contigs.fasta
		Week 13: We6.contigs.fasta

	B. Co-assemblies:
		Cheese A: Combined-O.contigs.fasta
		Cheese B: Combined-Wy.contigs.fasta
		Cheese C: Combined-We.contigs.fasta

	C.Isolate assemblies:
		156.fasta
		158.fasta
		160.fasta
		164.fasta
		165.fasta
		166.fasta
		169.fasta
		174.fasta
		175.fasta
		176.fasta
		177.fasta
		178.fasta
		179.fasta
		180.fasta
		181.fasta
		182.fasta
		183.fasta
		184.fasta
		196.fasta

	D. Mega-assemblies:
		Cheese A: o_unbin_unmap_priority_1000.fasta
		Cheese B: Wy_unbin_unmap_priority_1000.fasta
		Cheese C: We_unbin_unmap_priority_1000.fasta

	E. Metagenome-assembled genomes (MAGs)
		Cheese A:
		Individual timepoint MAGs
			Week 2: O2_bin.XXX
			Week 3: O3_bin.XXX
			Week 4: O4_bin.XXX
			Week 9: O5_bin.XXX
			Week 13: O6_bin.xxx
		Co-Assembly MAGs
			Combined-O_bin.XXX

		Cheese B:
		Individual timepoint MAGs
			Week 2: Wy2_bin.XXX
			Week 3: Wy3_bin.XXX
			Week 4: Wy4_bin.XXX
			Week 9: Wy5_bin.XXX
			Week 13: Wy6_bin.XXX
		Co-Assembly MAGs
			Combined-Wy_bin.XXX

		Cheese C:
		Individual timepoint MAGs
			Week 2: We2_bin.XXX
			Week 3: We3_bin.XXX
			Week 4: We4_bin.XXX
			Week 9: We5_bin.XXX
			Week 13: We6_bin.XXX
		Co-Assembly MAGs
			Combined-We_bin.XXX

	F. Supplemental tables:

Table S1. Collection schedule of sampled washed-rind cheeses. For three different washed-rind cheeses (Cheeses A, B and C) we followed the aging of three batches produced one week apart. Each of these batches was sampled at six time points (weeks 1, 2, 3, 4, 9 and 13). All samples were subjected to 16S and ITS amplicon (A) sequencing. All samples from batch 3 of each of the three cheeses were subjected to short-read sequencing (SR). The same set, minus the week 1 samples, were subjected to long-read SMRT sequencing (LR). A subset of batch 3 samples of each cheese was further subjected to Hi-C (H). Representative wash and storage schedules are also indicated in the columns, the exact schedules can differ from batch to batch.

Table S2. Sequencing data (in basepairs) generated by short-read shotgun metagenomic sequencing, long-read shotgun metagenomic sequencing and short-read Hi-C metagenomic sequencing.

Table S3. 16S amplicon read classification statistics.

Table S4. ITS amplicon read classification statistics.

Table S5. Long-read based taxonomic classification statistics.

Table S6. Assembly statistics of individual timepoint assemblies, co-assemblies, isolates from Cheese B and mega-assemblies.

Table S7. Full collection of high-quality bins resulting from co- and individual timepoint assemblies.

Table S8. Sequencing data (in basepairs) of short-read and long-read genome sequencing of isolates from Cheese B. 

Table S9. High-quality MAGs (and isolate genomes) recovered from Cheese A, B and C in washed-rind cheese genomic catalog. MAG names contain the bin number, the taxonomic classification to the lowest level available, whether it is linear or circular or an isolate genome and which cheese it originated from. The bin name originates from the original binning procedure. Those bins that contain “Combined” in their name are based on co-assemblies, while the rest are based on individual timepoint assemblies. The number after the first letter indicates the time point they originate from (e.g. Wy2 originates from week 2, 2 = week 2, 3 = week 3, 4 = week 4, 5 = week 9, 6 = week 13)

Table S10. ANI Comparison of high-quality MAGs across the three cheeses.

Table S11. Percentage of Illumina short reads that mapped to the genomic catalog.

Table S12. Plasmid and virus predictions of mega-assemblies. Contigs predicted as “complete circular” by VIBRANT are listed twice, once to indicate circularity and once to indicate predicted quality.

Table S13. Full results from the viralAssociationPipeline. Each tab contains results from a single timepoint of a single cheese. Rows highlighted in yellow indicate that the host contig of the MGE was one of the high-quality MAGs recovered in this study. 

Table S14. Potential host changes of MGEs over time. For each cheese, we identified MGEs that were associated with at least one new host genus (as predicted by Kraken taxonomy and the viralAssociationPipeline) at a later timepoint relative to any previous time points, indicating a potential host change. Rows highlighted in yellow indicate that the host contig of the MGE was part of a high-quality MAG for at least one of the timepoints.

Table S15. Psychrobacter genomes used for pangenome analysis. Database identifier and isolation source for each of the genomes is provided.

Table S16. Functional enrichment in Psychrobacter genomes from cheese versus other environments. Functional categories used in Figure 5B for categories with an adjusted q-value <0.1 are listed in the far right column.

Table S17. “Cloud” gene clusters unique to individual Psychrobacter genomes from Cheese B.

Table S18. CFU counts of in vitro washed-rind communities.

Table S19. Isolate genome statistics (bacteria only) and coverage at days 7 and 21.

In all tables, empty cells contain N/A. 
 Supplemental Table 20. Isolate genome statistics and coverage at days 7 and 2 Supplemental Table 21. “Cloud” gene clusters unique to individual Psychrobacter genomes from Cheese B.

2. Are there multiple versions of the dataset? 
Yes, the first version is associated with a preprint uploaded on bioRxiv (https://doi.org/10.1101/2022.07.01.497845). This updated version includes reformatted supplemental tables.


SHARING/ACCESS INFORMATION

1. Licenses/restrictions placed on the data: n.a.

2. Links to publications that cite or use the data: https://doi.org/10.1101/2022.07.01.497845 (preprint uploaded on bioRxiv)

3. Links to ancillary data sets: 
Raw sequencing data: Fastq files of all metagenomic raw sequencing data are available on the Sequence Read Archive under Accession Number PRJNA778418. Subread files of the HiFi sequencing are available upon demand. Fastq files of all isolate sequencing data are available on the Sequence Read Archive under the Accession Numbers PRJNA837750 (CCS156), PRJNA837754 (CCS158), PRJNA837770 (CCS160), PRJNA837776 (CCS164), PRJNA838264 (CCS165), PRJNA837782 (CCS166), PRJNA837789 (CCS169), PRJNA838091 (CCS174), PRJNA838092 (CCS175), PRJNA838093 (CCS176), PRJNA838094 (CCS177), PRJNA838095 (CCS178), PRJNA838105 (CCS179), PRJNA838104 (CCS180), PRJNA838102 (CCS181), PRJNA838100 (CCS182), PRJNA838106 (CCS183), PRJNA838262 (CCS184), PRJNA838261 (CCS196). Fastq files of the in vitro community sequencing are available on the Sequence Read Archive under Accession Number PRJNA852571.

4. Recommended citation for this dataset: Saak, Christina C. et al. (2022), Supplemental Material for "Longitudinal, multi-platform metagenomics yields a high-quality genomic catalog and guides an in vitro model for cheese communities", Dryad, Dataset, https://doi.org/10.5061/dryad.bg79cnpd8


METHODOLOGICAL INFORMATION
A detailed methods description can be found in the corresponding manuscript "Longitudinal, multi-platform metagenomics yields a high-quality genomic catalog and guides an in vitro model for cheese communities". 


ReadMe template from https://data.research.cornell.edu/content/readme
