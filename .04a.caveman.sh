if false; then
pushd bam/WE*
for i in *.bai; do ln -s $i ${i/.bai/.bam.bai}; done
popd
pushd bam/WG*
for i in *.bai; do ln -s $i ${i/.bai/.bam.bai}; done
popd
fi

tumors=(106T 116T 125T 126T 128T 134T 136T 93T 95T 99T)
normals=(106PB 116PB 125PB 126PB 128PB 134N 136PB 93PB 95PB 99PB)

for i in ${!tumors[@]}; do
	echo $i ${tumors[i]} ${normals[i]}
	export tumor_id=${tumors[i]}
	export normal_id=${normals[i]}
	qsub -v tumor_id,normal_id 04a.caveman.qsh
done
