#!/bin/bash
#PBS -q week
#PBS -l nodes=1:ppn=12
#PBS -N annoate
cd $PBS_O_WORKDIR

trap 'kill -TERM $PID' TERM INT
for i in mutect2/filter2_hard/pass/*.vcf.gz; do
	if [ $I == 4 ]; then (( I = I -4 )); wait; fi; (( I++ ))
	(
	annotate_vcf.py -i $i -o mutect2/annotated > log/vep.$(basename $i).log
	PID="$! $PID"
	(( EXIT += $? ))
	)&
done
wait
if [ "x$EXIT" == "x0" ]; then
	touch vep_success
fi
