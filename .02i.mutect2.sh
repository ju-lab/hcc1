mkdir -p mutect2/primar_call2
for i in bam/WES_tumor/*.bam; do
	tumor_bam=$i
	sample_id=$(basename $i | sed 's/T_.bam//')
	normal_bam=`ls bam/WGS_normal/*PB*.bam bam/WGS_normal/*N*.bam | grep $sample_id`
	echo $tumor_bam
	echo $normal_bam
	sh ~/src/snv/mutect2.sh	\
		--pon mutect2/pon/pon_mt2_tmkim_plus_wgs_normal.vcf.gz \
		-o mutect2/primary_call2 \
		-t $tumor_bam -n $normal_bam \
		-L /home/users/kjyi/Projects/pon/tmkim_wes/target_bed/S04380110_SureSelectV5_DepthOfCoverage.patched.bed	
done
exit 1

