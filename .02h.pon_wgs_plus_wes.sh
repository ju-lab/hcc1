#!/bin/bash
#PBS -q day
#PBS -N pon
#PBS -l nodes=1:ppn=2,mem=17gb
#PBS -e /dev/null
#PBS -o /dev/null
if [ -n "$PBS_O_WORKDIR" ]; then cd $PBS_O_WORKDIR; fi
pon_name=pon_mt2_tmkim_plus_wgs_normal
outdir=mutect2/pon
LOG=log/$pon_name.log
pon=$outdir/$pon_name.vcf.gz

java -Xmx16g -jar gatk4.jar CreateSomaticPanelOfNormals \
	`ls $outdir/*_R.vcf.gz $outdir/tmkim/*DB_WES.vcf.gz | \
	 sed 's/^/-vcfs /'| tr '\n' ' '` \
	-O $outdir/$pon_name.vcf.gz &>> $LOG &&
	echo "# done" >> $LOG &&
	mv $LOG ${LOG/.log/.done}
if [ -f $LOG ]; then
	mv $LOG ${LOG/.log/.fail}
	exit 1
fi
