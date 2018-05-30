#!/bin/bash
set -e
mkdir -p annovar/input annovar/output
for i in mutect2/filter2_hard/*.filter2.vcf.gz; do
	id=`basename $i | sed 's/.filter2.vcf.gz//'`
	echo $id
echo	convert2annovar.pl -format vcf4 $i \> annovar/input/$id.avinput
echo	table_annovar.pl \
		annovar/input/$i.avinput \
		/home/users/kjyi/ref/hg19/annovar/ \
		-buildver hg19 \
		-out annovar/output \
		-remove \
		-protocol refGene,ljb26_all,cosmic70,revel,icgc21 \
		-operation g,g,g,g,g \
		-nastring . \
		-polish 
exit 1
done
