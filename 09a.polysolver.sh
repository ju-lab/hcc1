for i in bam/WG*/*.bam; do

	id=`basename $i | sed 's/_R.bam//'`
	mkdir -p polysolver/$id
	polysolver --bam $i --outdir polysolver/$id &> log/polysolver.${id}.log &
done
wait
