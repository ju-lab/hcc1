#!/bin/bash

# target information: IntervalFile.R
if false; then
bait=./mutect2/pon/cnv/target_bed/S04380110_SureSelectV5_DepthOfCoverage.patched.cut.bed

fa=/home/users/kjyi/ref/hg19.fa
mappa=/home/users/kjyi/ref/hg19/wgEncodeCrgMapabilityAlign100mer_patched.bw
rep=/home/users/kjyi/ref/hg19/wgEncodeUwRepliSeqK562WaveSignalRep1_patched.bigWig
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
	--reptiming $rep --force &> $log && mv $log ${log/%.log/.done}
if [ -f $log ]; then mv $log ${log/%.log/.fail}; exit 1; fi

# Create vcf files
example_vcf=mutect2/filter1_xcontam/106T_.filter1.vcf.gz

# Prepare NormalDB
mkdir -p purecn/pon/purecn/coverage
for i in purecn/pon/bam/*DB*.bam; do
	name=$(basename $i | sed 's/.bam//')
	mkdir -p purecn/pon/purecn/coverage/$name
	purecn Coverage.R --outdir purecn/pon/purecn/coverage/$name \
	--bam $i \
	--intervals purecn/reference/baites_hg19_intervals.txt &
done

ls -a purecn/pon/purecn/coverage/*/*loess.txt | cat > purecn/pon/purecn/normal.list

# mutect2 call (pon generation) and merge all vcfs with gatk3/tabix indexing
pushd purecn/pon/mutect2/pon
for i in *DB*.gz; do
	java -jar gatk.jar \
	--analysis_type SelectVariants -R ~/ref/hg19.fa \
	--exclude_sample_expressions none \
	-V $i -o ${i/.vcf.gz/_no_none.vcf.gz} > ${i}.log &
done
wait
popd
exit 0
# merge and indexing
pushd purecn/pon/mutect2/pon
java -jar gatk.jar -T CombineVariants --minimumN 3 -R ~kjyi/ref/hg19.fa \
	-o merged.vcf.gz \
	--variant D_17_01729_DB_WES_no_none.vcf.gz \
	--variant D_17_01732_DB_WES_no_none.vcf.gz \
	--variant D_17_01735_DB_WES_no_none.vcf.gz \
	--variant D_17_02140_DB_WES_no_none.vcf.gz \
	--variant D_17_02147_DB_WES_no_none.vcf.gz \
	--variant D_17_02392_DB_WES_no_none.vcf.gz \
	--variant D_17_03446_DB_WES_no_none.vcf.gz \
	--variant D_17_03448_DB_WES_no_none.vcf.gz \
	--variant D_17_03450_DB_WES_no_none.vcf.gz \
	--variant D_17_03452_DB_WES_no_none.vcf.gz \
	--variant D_17_03454_DB_WES_no_none.vcf.gz \
	--variant D_17_03883_DB_WES_no_none.vcf.gz \
	--variant D_17_04584_DB_WES_no_none.vcf.gz \
	--variant D_17_04586_DB_WES_no_none.vcf.gz \
	--variant D_17_04588_DB_WES_no_none.vcf.gz \
	--variant D_17_04590_DB_WES_no_none.vcf.gz \
	--variant D_17_05001_DB_WES_no_none.vcf.gz \
	--variant D_17_05430_DB_WES_no_none.vcf.gz \
	--variant D_17_05432_DB_WES_no_none.vcf.gz \
	--variant D_17_05434_DB_WES_no_none.vcf.gz \
	--variant D_18_00941_DB_WES_no_none.vcf.gz \
	--variant D_18_00943_DB_WES_no_none.vcf.gz \
	--variant D_18_00945_DB_WES_no_none.vcf.gz

popd
exit 0

purecn NormalDB.R --outdir purecn/pon/purecn \
	--coveragefiles purecn/pon/purecn/normal.list \
	--genome hg19 \
	--assay agilent_v5 \
	--normal_panel purecn/pon/mutect2/pon/merged.vcf.gz \
	--force
# outputs
#	target_weights_agilent_v5_hg19.txt
#	low_coverage_targets_agilent_v5_hg19.bed
#	normalDB_agilent_v5_hg19.rds
#	mappig_bias_agillent_v5_hg19.rds
exit 0

pushd purecn/reference
ln -s ../pon/purecn/* .
popd
# PureCN CNVkit
# with mutect2 raw-filtered
for i in cnvkit/*.cns;do
	cnvkit.py export seg $i --enumerate-chroms \
		-o ${i/.cns/.seg}&
done
wait
exit 1
fi #---------------------------------------------------------------------------
for i in cnvkit/*.cnr; do
	id=$(basename $i | sed 's/_.cnr//')
	mkdir -p purecn/output/$id
	(purecn PureCN.R --out purecn/output/$id \
		--sampleid $id \
		--tumor $i \
		--segfile ${i/.cnr/.seg} \
		--normal_panel purecn/reference/mapping_bias_agilent_v5_hg19.rds \
		--vcf mutect2/filter1_xcontam/${id}_.filter1.vcf.gz \
		--genome hg19 \
		--funsegmentation none \
		--snpblacklist ~/ref/hg19/hg19_simpleRepeats.bed \
		--force --postoptimize --seed 123 &> log/$id.purecn.log && mv log/$id.purecn.log log/$id.purecn.done ) &
done
wait
echo finish

# PureCN internal
# with mutect2 filter-out
