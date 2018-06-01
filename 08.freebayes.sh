#!/bin/bash
outdir=freebayes/primary_output
mkdir -p $outdir
interval=purecn/pon/target_bed/S04380110_SureSelectV5_DepthOfCoverage.patched.bed
trap 'kill -TERM $PID' TERM INT
for i in bam/WGS*/*.bam; do
	id=`basename $i|sed 's/_R.bam//'`
	sample=$i
	output=$outdir/${id}.vcf.gz
	freebayes -f ~/ref/hg19.fa -C 5 -t $interval  $sample | gzip > $output &
	PID="$! $PID"
done
wait $PID
echo done
