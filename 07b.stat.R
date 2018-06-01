if (F) {
	system("mkdir -p stat")
	rmarkdown::render("07b.stat.R",
					  output_format = "pdf_document",
					  clean = TRUE)
	rmarkdown::render("07b.stat.R",
					  output_format =
					  	rmarkdown::pdf_document(
					  		toc = TRUE,
					  		latex_engine = 'xelatex',
					  		pandoc_args =
					  			c("--variable",
					  			  "mainfont='NanumGothic'")),
					  clean = TRUE)
}

suppressMessages(library(tidyverse))
library(stringr)
library(gridExtra)

merged <- read_tsv("mutation_summary/merged.tsv")
purity <- read_tsv("mutation_summary/purity_ploidy.tsv")
# total mutation count, purity, flag -------------------------------------------
count1 <- merged %>% group_by(pd1, id) %>% summarise(n = n()) %>%
	left_join(purity, by = "id") %>% arrange(pd1, -n)
color_vector <- c("red", "black")[c(2,2,2,2,2,2,1,1,1,1)]
count1

p1 <- count1 %>%
	bind_cols(alpha_vector = ifelse(is.na(count1$Comment), 1, 0.3)) %>%
	ggplot(aes(x = reorder(id, -n), y = n, fill = pd1, alpha = I(alpha_vector))) +
	geom_col() +
	theme(axis.text.x = element_text(colour = color_vector))

p2 <- count1 %>%
	bind_cols(alpha_vector = ifelse(is.na(count1$Comment), 1, 0.3)) %>%
	ggplot(aes(x = reorder(id, -n), y = Purity, fill = pd1, alpha = I(alpha_vector))) +
	geom_col() +
	theme(axis.text.x = element_text(colour = color_vector))
grid.arrange(p1, p2, nrow = 2)

count1 %>% filter(is.na(Comment)) %>%
	with(t.test(n ~ factor(pd1)))

count1 %>% filter(is.na(Comment)) %>%
	with(wilcox.test(n ~ factor(pd1)))

merged$type %>% table %>% sort %>%
	pie(labels = paste(names(.), "\n", ., sep = ""), main = "Mutation Type")

merged$type %>% table %>% sort(decreasing = T)

merged$type2 <- factor(merged$type)
levels(merged$type2)

levels(merged$type2) <- c("Silent",
						  "Undetermined",
						  "frameshift_indel",
						  "Inframe",
						  "unknown",
						  "inframe_indel"
)[c(1, 5, 3,
	3, 1, 1,
	1, 1, 6,
	6, 4, 4,
	4, 1, 5,
	1, 1, 1,
	1)]

merged %>% group_by(type, type2) %>% summarize(n = n()) %>% arrange(desc(type2))

merged$type2 %>% table %>% sort %>%
	pie(labels = paste(names(.), "\n", ., sep = ""), main = "Mutation Type")

count2 <- merged %>%
	group_by(pd1, id) %>%
	mutate(N = n()) %>%
	group_by(pd1, id, type2) %>%

	summarise(n = n(), N = max(N),
			  cellfrac_over_0.5 = sum(CELLFRACTION > .5, na.rm = T),
			  cellfrac_over_0.7 = sum(CELLFRACTION > .7, na.rm = T)) %>%
	filter(type2 != "unknown") %>%
	left_join(purity, by = "id") %>% arrange(pd1, -n)
count2 %>%
	bind_cols(alpha_vector = ifelse(is.na(count2$Comment), 1, 0.3)) %>%
	ggplot(aes(x = reorder(id, -N), y = n, fill = pd1, alpha = I(alpha_vector))) +
	geom_col() +
	theme(axis.text.x = element_text(colour = color_vector)) +
	facet_grid(type2 ~ .)

count2 %>%
	bind_cols(alpha_vector = ifelse(is.na(count2$Comment), 1, 0.3)) %>%
	ggplot(aes(x = reorder(id, -N), y = cellfrac_over_0.7, fill = pd1, alpha = I(alpha_vector))) +
	geom_col() +
	theme(axis.text.x = element_text(colour = color_vector))

count2 %>% filter(is.na(Comment)) %>%
	with(t.test(cellfrac_over_0.7 ~ factor(pd1)))

count2 %>%
	bind_cols(alpha_vector = ifelse(is.na(count2$Comment), 1, 0.3)) %>%
	ggplot(aes(x = reorder(id, -N), y = cellfrac_over_0.7, fill = pd1, alpha = I(alpha_vector))) +
	geom_col() +
	theme(axis.text.x = element_text(colour = color_vector)) +
	facet_grid(type2 ~ .)

count2 %>% filter(is.na(Comment)) %>%
	with(wilcox.test(cellfrac_over_0.7 ~ factor(pd1)))

