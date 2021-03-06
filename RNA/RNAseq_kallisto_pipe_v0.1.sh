#!/bin/bash

# Use kallisto to perform k-mer based transcript quantification
# https://www.nature.com/articles/nbt.3519

set -eu

if [ "$#" -lt 5 ]; then
	echo "Missing arguments!"
	echo "USAGE: kallisto.sh <SE,PE> <R1> <R2> <strandedness> <annotation> <name>"
	echo "strand: unstranded, fr_stranded, rf_stranded"
	echo "EXAMPLE: kallisto.sh PE SRR5724597_1.fastq.gz SRR5724597_2.fastq.gz unstranded AtRTD2_19April2016.fa col0-r1"
exit 1
fi

dow=$(date +"%F-%H-%m-%S")

###########
### SINGLE END
###########

if [ "$1" == "SE" ]; then
	# requirements
	if [ "$#" -ne 5 ]; then
		echo "Missing required arguments for single-end!"
		echo "USAGE: kallisto.sh <SE> <R1> <strandedness> <annotation> <name>"
		exit 1
	fi

R1=$2
strand=$3
annotation=$4
name=$5

kallito index -i 

fi

##########################
############# PAIRED END
##########################

if [ "$1" == "PE" ]; then
	# requirements
	if [ "$#" -ne 6 ]; then
		echo "Missing required arguments for single-end!"
		echo "USAGE: kallisto.sh <PE> <R1> <R2> <strandedness> <annotation> <name>" 
		exit 1
	fi

# gather input variables
type=$1
R1=$2
R2=$3
strand=$4
annotation=$5
name=$6

echo "##################"
echo "Performing paired-end kallisto RNA-seq alignment"
echo "Type: $type"
echo "Input Files: $R1 $R2"
echo "Annotation: $annotation"
echo "Sample: $name"
echo "Time of analysis: $dow"
echo "##################"

# file structure
mkdir ${name}_kallisto_${dow}
mv $R1 $R2 -t ${name}_kallisto_${dow}
cd ${name}_kallisto_${dow}
mkdir 0_fastq
mv $R1 $R2 -t 0_fastq/

# FastQC
echo "QC ..."
mkdir 1_fastqc 
fastqc -t 4 0_fastq/$R1 0_fastq/$R2 2>&1 | tee -a ${name}_logs_${dow}.log
mv 0_fastq/${R1%%.fastq*}_fastqc* 1_fastqc/
mv 0_fastq/${R2%%.fastq*}_fastqc* 1_fastqc/

### Read trimming
echo "Adapter and quality trimming"

mkdir 2_trimmed_fastq
cd 2_trimmed_fastq
trim_galore --fastqc --paired ../0_fastq/$R1 ../0_fastq/$R2 | tee -a ../${name}_logs_${dow}.log

## Generate kallisto index
echo "kallisto"

kallisto index -i "${annotation%%.fa}.idx" $annotation 2>&1 | tee -a ${name}_logs_${dow}.log

if [ $strand == "unstranded" ]; then

	kallisto quant -i ${annotation%%.fa}.idx -t 4 --bias 2_trimmed_fastq/${R1%%.fastq*}_trimmed.fq* 2_trimmed_fastq/${R2%%.fastq*}_trimmed.fq* -o ./ 2>&1 | tee -a ${name}_logs_${dow}.log

elif [ $strand == "fr_stranded" ]; then
	kallisto quant -i "${annotation%%.fa}.idx" --fr-stranded -t 4 --bias 2_trimmed_fastq/${R1%%.fastq*}_trimmed.fq* 2_trimmed_fastq/${R2%%.fastq*}_trimmed.fq* -o ./ 2>&1 | tee -a ${name}_logs_${dow}.log

else kallisto quant -i "${annotation%%.fa}.idx" --rf-stranded -t 4 --bias 2_trimmed_fastq/${R1%%.fastq*}_trimmed.fq* 2_trimmed_fastq/${R2%%.fastq*}_trimmed.fq* -o ./ 2>&1 | tee -a ${name}_logs_${dow}.log

fi
 
mv abundance.h5 ${name}.h5
mv abundance.tsv ${name}.tsv

echo "Complete"

fi

