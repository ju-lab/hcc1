#!/bin/bash

# get coverage
if false; then
mkdir -p gcnv/coverage gcnv/log
N=0
for i in bam/WGS_normal/*.bam; do
	if [ "$N" == 4 ]; then N=0; wait; fi
	id=$(basename $i | sed 's/_R.bam//')
	java -jar gatk4.jar CollectReadCounts \
		-L ~/ref/hg19/hg19.chrom.sizes.patched.interest.list \
		-I $i \
		--interval-merging-rule OVERLAPPING_ONLY \
		-O gcnv/hdf5/$id.hdf5 &> gcnv/log/$id.crc.log &
	((N=N+1))
done

wait
echo done
fi

# run cohort mode
if true; then
java -jar gatk4 GermlineCNVCaller \
	--run-mode COHORT \
	-L ~/ref/hg19/hg19.chrom.sizes.patched.interest.list \
	-I bam/WGS_normal/106PB_R.bam \
	-I bam/WGS_normal/116PB_R.bam \
	-I bam/WGS_normal/125PB_R.bam \
	-I bam/WGS_normal/126PB_R.bam \
	-I bam/WGS_normal/128PB_R.bam \
	-I bam/WGS_normal/134N_R.bam \
	-I bam/WGS_normal/136PB_R.bam \
	-I bam/WGS_normal/93PB_R.bam \
	-I bam/WGS_normal/95PB_R.bam \
	-I bam/WGS_normal/99PB_R.bam \
	--output gcnv/cohort \
	--output-prefix hcc_normal_cohort
fi

# run individual mode
if false; then
N=0
mkdir -p gcnv/individual
for i in gcnv/coverage/*.hdf5 ;do
	if [ "$N" == 4 ]; then N=0; wait; fi
	id=$(basename $i | sed 's/.hdf5//')
	java -jar gatk4.jar GermlineCNVCaller \
		--run-mode CASE \
		-L ~/ref/hg19/hg19.chrom.sizes.patched.interest.list \
		--contig-ploidy-calls   \
		--model prev_model_path \
		-I $i \
		--output gcnv/individual \
		--output-prefix case_run.$id &> gcnv/log/$id.individual.log &
	((N=N+1))
done
fi
