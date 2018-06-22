#!/bin/bash
set -eu

# Generate mean methylation levels into custom bins from per-site BED files
# Provide path of genome .fa file

if [ "$#" -lt 3 ]; then
echo "Missing arguments!"
echo "USAGE: wgbs_custom_bins.sh <sample> <genome fasta> <bin size>"
echo "EXAMPLE: wgbs_custom_bins.sh col0-r1 /home/diep/TAIR10/TAIR10_Chr.all.fasta 1000000"
exit 1
fi

bed=$1
fas=$2
bin=$3
window=$(expr $bin - 1)

echo 'Make genome bed ...'

# use samtools to generate fasta index
samtools faidx $fas

# use awk on index to make genome file
# https://www.biostars.org/p/70795/
awk -v OFS='\t' {'print $1,$2'} ${fas}.fai > temp.genome

# use genome file to make 100bp windows across genome
bedtools makewindows -g temp.genome -w ${window} -s ${bin} > temp.genome.${bin}bp.bed
sortBed -i temp.genome.${bin}bp.bed | awk -F$'\t' ' $1 != "ChrC" && $1 != "ChrM" ' > temp.genome.${bin}bp.sorted.bed

# use bedtool intersect and groupBy to get mean methylation levels per bin based on per-site methylation
echo 'Bedtools CG ...'
bedtools intersect -sorted -a temp.genome.${bin}bp.bed -b ${bed}_CG.bed.bismark.cov > ${bed}_CG_${bin}bp.bed -wo
groupBy -i ${bed}_CG_${bin}bp.bed -g 1,2,3 -c 7,7 -o mean,count > ${bed}_CG_${bin}bp.avg.bed

echo 'Bedtools CHG ...'
bedtools intersect -sorted -a temp.genome.${bin}bp.bed -b ${bed}_CHG.bed.bismark.cov > ${bed}_CHG_${bin}bp.bed -wo
groupBy -i ${bed}_CHG_${bin}bp.bed -g 1,2,3 -c 7,7 -o mean,count > ${bed}_CHG_${bin}bp.avg.bed

echo 'Bedtools CHH ...'
bedtools intersect -sorted -a temp.genome.${bin}bp.bed -b ${bed}_CHH.bed.bismark.cov > ${bed}_CHH_${bin}bp.bed -wo
groupBy -i ${bed}_CHH_${bin}bp.bed -g 1,2,3 -c 7,7 -o mean,count > ${bed}_CHH_${bin}bp.avg.bed

echo 'cleaning ...'
# CLEAN
rm temp.genome*
rm *_${bin}bp.bed

