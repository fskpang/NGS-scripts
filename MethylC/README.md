# MethylC-seq scripts repository

#### 100bp_dmr_merge.r
Supplemental script for *100bp_dmrs.v0.1.sh* for collapsing/summarising DMRs

#### 100bp_dmrs.v0.1.sh
This script uses 100bp windowed methylation data to call differences across the genome in a defined context with required coverage and a defined difference. These are performed in a pairwise manner between all samples of interest.

#### 100bp_heatmap.sh
Uses the output from *100bp_dmrs.v0.1.sh* to get mC from bed files (individual mC resolution).

#### 100bp_wig_to_dmrs.r
First step of *100bp_dmrs.v0.1.sh* that makes pairwise comparisons of windows showing a defined difference in a given context.

#### BS-SNPer.sh		
Script to perform SNP calling from aligned bisulfite converted reads. Use on sorted BAM file.

#### C_context_window_SREedits.pl	
SRE perl script to create 100bp windows from bismark methylation extractor report files. 

#### DSS_calling.r
Script for performing DSS DMR calling on re-formatted (using DSS_file_prep.r) bed.cov file output.

#### DSS_file_prep.r
Script for re-formatting bed.cov file methylation output for input to DSS.

#### bed_to_rel_dist.sh
Produce genome summarised methylation plots across features of interest e.g. gene models.

#### conversion_rate_check.sh
Calculate bisulfite conversion efficiency by calclulating percent methylated in the chloroplast genome, which itself should be completely unmethylated.

#### dmr_merge.r
Supplemental file for 100bp DMR calling to produce final DMR table.

#### merge_wigs.r
Merge 100bp tiled methylation files (wig) to produce correlation matrices with hierarchical clustering of samples of interest.

#### met-sign.sh
Extract cytosine reports for methylation at non-canonical methylation sequence contexts (see Gouil & Baulcombe, PLoS Gen 2015).

#### methylation_tiling.sh
Use WIG files to obtain methylation values across features of interest (similar to bed_to_rel.sh but without binning values).

#### pca_wigs.r
Perform PCA on 100bp binned weighted methylation levels.

#### rel_methylation_plots.r
Supplementary R script for bed_to_rel.sh to produce binned methylation values summarised across supplied features of interest.

#### rel_methylation_plots_v2.r
Variation on rel_methylation_plots.r to get binned summarised methylation values for non-canonical sequence contexts.

#### scatman_smooth.sh & smooth_scat.r
Pair of scripts (use .sh to run) to take annotation file, bed file, and feature name to make scattersmooth plots in R to correlate methylation levels and feature characteristics (e.g. 5mC vs TE length).

#### wgbs_cov_to_TDF.txt
Produce TDF files from bismark cov file of interest. Check IGV compatible genome build ready.

### wgbs_pipeline_v0.4.sh
Bismark alignment script using Bowtie1 aligner. Has SE and PE options.

### wgbs_pipeline_v0.5.sh
Bismark alignment script using Bowtie2 aligner. Has SE and PE options.
