table_annovar.pl \
	example/ex1.avinput \
	humandb/ \
	-buildver hg19 \
	-out myanno \
	-remove \
	-protocol refGene,cytoBand,exac03,avsnp147,dbnsfp30a \
	-operation gx,r,f,f,f \
	-nastring . \
	-csvout \
	-polish \
	-xref example/gene_xref.txt
