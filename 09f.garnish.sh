#!/bin/bash
#PBS -q week
#PBS -o /dev/null
#PBS -e /dev/null
#PBS -l nodes=1:ppn=24
#PBS -N antigen.garnish
if [ -n "$PBS_O_WORKDIR" ]; then cd $PBS_O_WORKDIR; fi

for i in mutect2/filter2_hard/pass/*.gz; do
	echo $i
	id=$(basename $i | sed 's/.filter2.vcf.gz//')
	mkdir -p antigen/$id
	idn=$(echo $id | sed 's/T//')
	echo $idn
	mkdir -p antigen/$id
	hla=$(grep $idn polysolver/summary2.txt | cut -f2 )
	R --slave << EOF &> antigen/$id/R.log && mv antigen/$id/R.log antigen/$id/R.done
library(antigen.garnish)
library(magrittr)
dt <- 
  "$i"  %>%
  
  # extract variants
  garnish_variants %>%
  
  # add space separated MHC types
  # see list_mhc() for nomenclature of supported alleles
  # separate murine and human alleles into separate rows, even if same sample_id.
  
  #.[, MHC := c("HLA-A*02:01 HLA-DRB1*14:67",
  #             "H-2-Kb H-2-IAd",
  #             "HLA-A*01:47 HLA-DRB1*03:08")] %>%
  .[, MHC := c("$hla")] %>%
  
  
  # predict neoepitopes
  garnish_predictions

# summarize predictions
dt %>%
  garnish_summary %T>%
  print

# generate summary graphs
#dt %>% garnish_plot
readr::write_rds(dt,"antigen/$id/garnish.prediction.rds", compress="gz")
EOF
exit 0
done
