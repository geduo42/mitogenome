library(ggplot2)
library(ggsci)
library(optparse)

option_list <- list(
# general parameters
    make_option(c("-d", "--stats_dir"), type = "character", default = NULL,
                action = "store", help = "the path to data dir"
    )
)

opt <- parse_args(OptionParser(option_list = option_list, usage = "coming soon..."))
stats_dir <- opt$stats_dir

stats_dir <-"~/working/project/sc/Microtendipes/out/basic/stats"
out_dir <- paste0(stats_dir, "/chips.plot")
if(!file.exists(out_dir)) dir.create(out_dir)

gene <- c("atp6", "atp8", "cob", "cox1", "cox2", "cox3", "nad1", "nad2", "nad3", "nad4", "nad4l", "nad5", "nad6")
samples <- c("BSZ01", "BSZ71", "BSZ95", "BSZ99", "WYS168", "WYS209", "WYS260", "WYS265", "WYS273")

get_chips <- function(samples, gene){
    chips.file <- paste0(stats_dir, "/chips/", samples, "/", samples, ".", gene, ".chips")
    chips <- readLines(chips.file)
    chips <- chips[3]
    chips <- strsplit(chips, split = "= ")
    chips <- unlist(chips)[2]
    chips <- as.numeric(chips)
    return(chips)
}

chips <- list()
for(i in 1 : length(samples)){
    chips[[i]] <- sapply(gene, function(x) get_chips(samples[i], x))
}

df <- data.frame(chips = unlist(chips), gene = rep(gene, times = length(samples)), sample = sort(rep(samples, times = length(gene))))

names(chips) <- samples
chips <- do.call(rbind, chips)
chips <- as.data.frame(chips)
chips$sample <- rownames(chips)
chips <- chips[ , c("sample", gene)]
write.table(chips, file = paste0(out_dir, "/chips.txt"), quote = F, row.names = F, sep = "\t")

df$group <- "0"
df[df$sample %in%c("BSZ01", "BSZ95", "WYS260", "WYS265"), "group"] <- "1"

mcol <- c("#4da0a0", "#9b3a74")
mcol <- pal_lancet("lanonc", alpha = 0.5)(9)
ggplot(df, mapping = aes(x = gene, y = chips))+
    geom_point(mapping = aes(col = sample, shape = group), size = 3)+
  #  geom_text(mapping = aes(col = group, label = gene), nudge_y = 0.15 )+
    scale_color_manual(values = mcol)+
    labs(title = "chips")+
    theme_classic()

ggsave(filename = paste0(out_dir, "/chips.svg"), device = "svg")




