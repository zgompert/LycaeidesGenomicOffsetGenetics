# LycaeidesGenomicOffsetGenetics
Genetic analysis for conducting GEA and computing GOs in *Lycaeides* from GBS data

This repository covers the genetic analyses I conducted as part of a an analysis of genotype-evnironment associations (GEAs) and genomic offsets (GOs) in *Lycaeides* butteflies from existing GBS data. Other parts of this study are covered in these repositories:

Actual GEAs and GOs: [https://github.com/Urodelan/LycaeidesGenomicOffset](https://github.com/Urodelan/LycaeidesGenomicOffset)

Genome annotation: [https://github.com/chaturvedi-lab/Lmelissa_genome_annotation](https://github.com/chaturvedi-lab/Lmelissa_genome_annotation)

DNA sequence alignment (which was done as part of a larger project, everything post-alignment was done specifically for the genomic offset project and is described below): [ https://github.com/chaturvedi-lab/Lycaeides_genomic_data_processing_2023]( https://github.com/chaturvedi-lab/Lycaeides_genomic_data_processing_2023)

Files for all of my analyses are on the UofU CHPC: `/uufs/chpc.utah.edu/common/home/gompert-group4/projects/lyc_genomic_offset`.

# Variant calling and filterning

Call varitns with `bcftools` (1.16): [BcfCall.sh](BcfCall.sh), the bam files are listed in [bams](bams)

Filter variants (multiple scripts, commands follow):

```bash
#!/usr/bin/bash

## filter initial set of 1,900,083 putative SNPs
perl vcfFilter.pl lyc_genom_offset.vcf

## filter based on excessive coverage and nearby SNPs
#Finished filtering lyc_genom_offset.vcf
#Retained 227692 variable loci

## get depth information
grep ^Sc filtered2x_lyc_genom_offset.vcf | perl -p -i -e 's/^S.+AD\s+//' | perl -p -i -e 's/[01]\/[01]:[0-9,]+:(\d+):[0-9,]+/\1/g' > depth_filter2x.txt
sumDepth.R

## filter depth and closeness
perl filterSomeMore.pl filtered2x_lyc_genom_offset.vcf
#Retained 142307 variable loci
```

Convert to gl format and split by population (multiple scripts, commands follow):

```bash
#!/usr/bin/bash
## convert to gl
perl vcf2gl.pl morefilter_filtered2x_lyc_genom_offset.vcf

## split by population
perl splitPops.pl lyc_goff.gl
```

The rest is in the `PopGenom` subdirectory on the cluster.

# Population genetic analyses
