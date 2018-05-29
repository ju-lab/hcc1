#!/bin/bash
mkdir -p varscan/output varscan/log
for i in varscan/mpileup/*T_*; do
	tumor=$i
	export tumor
	qsub -v tumor 05b.varscan.qsh
done
