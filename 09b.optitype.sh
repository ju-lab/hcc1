#!/bin/bash
export PATH=/home/users/kjyi/anaconda3/bin:$PATH
mkdir -p optitype/fished
ref=/home/users/kjyi/anaconda3/pkgs/optitype-1.3.1-py27_0/share/optitype-1.3.1-0/data/hla_reference_dna.fasta 
trap 'kill -TERM $PID' TERM INT
for i in fastq/WGS_normal/*.gz; do
#for i in testbam/*.gz; do
	(
	razers3 -i 95  -m 1 -dr 0 -o optitype/fished/$(basename $i | sed 's/.fastq.gz//').bam $ref $i && \
	samtools bam2fq optitype/fished/$(basename $i | sed 's/.fastq.gz//').bam  > $optitype/fished/$(basename $i | sed 's/.fastq.gz//').fastq  && \
	rm fished_fq=optitype/fished/$(basename $i | sed 's/.fastq.gz//').fastq
	) &> log/razer3.$(basename $i | sed 's/.fastq.gz//') &
	PID="$! ${PID} "
done
wait
