#!/bin/bash
#for i in fastq/W*/*1.fastq.gz; do
for i in fastq/WE*/128T_1.fastq.gz; do
	outdir=bam/`echo $i | sed -r 's!.*/(.*)/.*!\1!'`
	sample=`basename $i | sed 's/1.fastq.gz//'`
	echo $outdir $sample $i ${i/1.fastq.gz/2.fastq.gz}
	run_bwa.sh $sample $i ${i/1.fastq.gz/2.fastq.gz} -o $outdir
done
exit 0

fastq/WES_tumor/106T_1.fastq.gz
fastq/WES_tumor/106T_2.fastq.gz
fastq/WES_tumor/116T_1.fastq.gz
fastq/WES_tumor/116T_2.fastq.gz
fastq/WES_tumor/125T_1.fastq.gz
fastq/WES_tumor/125T_2.fastq.gz
fastq/WES_tumor/126T_1.fastq.gz
fastq/WES_tumor/126T_2.fastq.gz
fastq/WES_tumor/128T_1.fastq.gz
fastq/WES_tumor/128T_2.fastq.gz
fastq/WES_tumor/134T_1.fastq.gz
fastq/WES_tumor/134T_2.fastq.gz
fastq/WES_tumor/136T_1.fastq.gz
fastq/WES_tumor/136T_2.fastq.gz
fastq/WES_tumor/93T_1.fastq.gz
fastq/WES_tumor/93T_2.fastq.gz
fastq/WES_tumor/95T_1.fastq.gz
fastq/WES_tumor/95T_2.fastq.gz
fastq/WES_tumor/99T_1.fastq.gz
fastq/WES_tumor/99T_2.fastq.gz
fastq/WGS_normal/106PB_R1.fastq.gz
fastq/WGS_normal/106PB_R2.fastq.gz
fastq/WGS_normal/116PB_R1.fastq.gz
fastq/WGS_normal/116PB_R2.fastq.gz
fastq/WGS_normal/125PB_R1.fastq.gz
fastq/WGS_normal/125PB_R2.fastq.gz
fastq/WGS_normal/126PB_R1.fastq.gz
fastq/WGS_normal/126PB_R2.fastq.gz
fastq/WGS_normal/128PB_R1.fastq.gz
fastq/WGS_normal/128PB_R2.fastq.gz
fastq/WGS_normal/128T_R1.fastq.gz
fastq/WGS_normal/128T_R2.fastq.gz
fastq/WGS_normal/134N_R1.fastq.gz
fastq/WGS_normal/134N_R2.fastq.gz
fastq/WGS_normal/136PB_R1.fastq.gz
fastq/WGS_normal/136PB_R2.fastq.gz
fastq/WGS_normal/93PB_R1.fastq.gz
fastq/WGS_normal/93PB_R2.fastq.gz
fastq/WGS_normal/95PB_R1.fastq.gz
fastq/WGS_normal/95PB_R2.fastq.gz
fastq/WGS_normal/99PB_R1.fastq.gz
fastq/WGS_normal/99PB_R2.fastq.gz
