# collect mutect2 filtered call and purecn clonality estimation
# ------------------------------------------------------------------------------
suppressMessages(library(tidyverse))
library(stringr)
suppressMessages(library(doMC))
merged <- foreach(file = dir("annovar", full.names = T),
				  .combine = bind_rows) %do% {
	id <- basename(file) %>% str_replace(".filter2.vcf.anv", "")
	snv <- read_tsv(file, guess_max = 20000) %>%
		filter(FILTER == "PASS") %>%
		select(`#CHROM`, POS, REF, ALT, gene_info2, gene_info1, exon_info1) %>%
		mutate(key = paste0(`#CHROM`, "-", POS),
			   gene_name = gene_info2,
			   type = ifelse(is.na(exon_info1), gene_info1, exon_info1)) %>%
		select(-c(gene_info2:exon_info1))
	file2 <- dir(paste0("purecn/output/", id), "_variants.csv", full.names = T)
	purecn <- read_csv(file2, guess_max = 20000) %>%
		select(chr:end, REF, ALT, ML.C, ML.M.SEGMENT, ML.M, M.SEGMENT.FLAGGED,
			   CN.SUBCLONAL, CELLFRACTION, FLAGGED) %>%
		mutate(key = paste0(chr, "-", start)) %>%
		select(-c(chr:ALT))
	merged <- left_join(snv, purecn, by = "key") %>%
		rename(chr = `#CHROM`, pos = POS) %>%
		mutate(id = id) %>%
		select(id, everything(), -key)
	merged
}
rm(id, file, file2, purecn, snv)

unique(merged$id)
group_info <- list(high = c("95T", "106T", "128T", "134T", "136T"),
				   low = c("116T", "125T", "126T", "93T", "99T"))
merged <- merged %>%
	mutate(pd1 = ifelse(id %in% group_info$high, "high", "low")) %>%
	select(id, pd1, everything())
merged %>% group_by(pd1, id) %>% summarize(n = n())

system("mkdir -p mutation_summary")
write_tsv(merged, "mutation_summary/merged.tsv")

# purity/ploidy
pp <- foreach(id = dir("purecn/output"), .combine = bind_rows) %do% {
	file3 <- dir(paste0("purecn/output/", id), paste0(id, ".csv"), full.names = T)
	read_csv(file3, col_types = cols(.default = col_character())) %>%
		mutate(Sampleid = str_replace(Sampleid, "_", "")) %>%
		rename(id = Sampleid)
}
write_tsv(pp, "mutation_summary/purity_ploidy.tsv")

rm(pp, file3, id, group_info)
