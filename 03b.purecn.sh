#!/bin/bash

# target information: IntervalFile.R
bait=./mutect2/pon/cnv/target_bed/S04380110_SureSelectV5_DepthOfCoverage.bed

fa=/home/users/kjyi/ref/hg19.fa
mappa=/home/users/kjyi/ref/hg19/wgEncodeCrgMapabilityAlign100mer.bw
rep=/home/users/kjyi/ref/hg19/wgEncodeUwRepliSeqK562WaveSignalRep1.bigWig
outdir=purecn/reference
log=./log/purecn.IntervalFile.log
mkdir -p $outdir $(dirname $log)
purecn IntervalFile \
	--infile $bait \
	--fasta $fa \
	--outfile $outdir/baites_hg19_intervals.txt \
	--offtarget \
	--genome hg19 \
	--export $outdir/baits_optimized_hg19.bed \
	--mappability $mappa \
	--reptiming $rep &> $log && mv $log ${log/%.log/.done}
if [ -f $log ]; then mv $log ${log/%.log/.fail}; exit 1; fi

