#!/bin/bash
for i in fastq/WES*/*1.fastq.gz;do
	R1=$i
	R2=${i/_1./_2.}
	sample_name=$(basename $i | sed 's/_1.fastq.gz//')
	if [ I == 5 ]; then ((I = I - 5)); wait; fi; ((I++))
	outdir=hlareporter
	log=log/hlareporter.$sample_name.log
	hlareporter.sh $sample_name $R1 $R2 $outdir
done
