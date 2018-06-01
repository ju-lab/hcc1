
R --slave << EOF
library(antigen.garnish)
library(magrittr)
dt <- 
  "antigen.garnish.bak/antigen.garnish_example.vcf"  %>%
  
  # extract variants
  garnish_variants %>%
  
  # add space separated MHC types
  # see list_mhc() for nomenclature of supported alleles
  # separate murine and human alleles into separate rows, even if same sample_id.
  
  .[, MHC := c("HLA-A*02:01 HLA-DRB1*14:67",
               "H-2-Kb H-2-IAd",
               "HLA-A*01:47 HLA-DRB1*03:08")] %>%
  
  # predict neoepitopes
  garnish_predictions

# summarize predictions
dt %>%
  garnish_summary %T>%
  print

# generate summary graphs
#dt %>% garnish_plot
readr::write_rds(dt,"garnish.prediction.rds", compress="gz")

EOF
