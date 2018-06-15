#!/bin/bash
#PBS -q week
#PBS -l nodes=1:ppn=12
#PBS -N annotate
if [ -n "$PBS_O_WORKDIR" ]; then cd $PBS_O_WORKDIR; fi

mkdir -p mutect2/annotated/canonical
trap 'kill -TERM $PID' TERM INT
for i in mutect2/annotated/*.vcf.gz; do
	if [ "x$I" == "x4" ]; then (( I = I -4 )); wait; fi; (( I++ ))
	(
	tidy_annotated_vcf.py -i $i -o mutect2/annotated/canonical > log/vep.$(basename $i).log
	PID="$! $PID"
	(( EXIT += $? ))
	)&
done
wait
if [ "x$EXIT" == "x0" ]; then
	touch vep_success
fi
