library(ggplot2)

library(optparse)

option_list <- list(
# general parameters
    make_option(c("-g", "--gene"), type = "character", default = NULL,
                action = "store", help = "gene name"
    ),
    make_option(c("-d", "--stats_dir"), type = "character", default = NULL,
                action = "store", help = "the path to data dir"
    ),
    make_option(c("-o", "--out_dir"), type = "character", default = NULL,
                action = "store", help = "the path to out dir")
)

opt <- parse_args(OptionParser(option_list = option_list, usage = "coming soon..."))
stats_dir <- opt$stats_dir
gene <- opt$gene
out_dir <- paste0(stats_dir, "/skew.plot")
if(!file.exists(out_dir)) dir.create(out_dir)

skew.file <- paste0(stats_dir, "/", gene, ".stats.txt")
df <- read.table(skew.file, header = T)
df$id <- sapply(df$id, function(x)unlist(strsplit(x, split = "_"))[1])
rownames(df) <- df$id
df <- df[c("BSZ01", "BSZ95", "BSZ71", "BSZ99", "WYS168", "WYS260", "WYS265", "WYS273", "WYS209"), ]

df$group <- "0"
df[c("BSZ01", "BSZ95", "WYS260", "WYS265"), "group"] <- "1"

mcol <- c("#4da0a0", "#9b3a74")
ggplot(df, mapping = aes(x = AT.Skew, y = GC.Skew))+
    geom_point(mapping = aes(col = group))+
    geom_text(mapping = aes(col = group, label = id), nudge_y = 0.15 )+
    scale_color_manual(values = mcol)+
    labs(title = gene)+
    theme_classic()

ggsave(filename = paste0(out_dir, "/skew.", gene, ".svg"), device = "svg")


ggplot(df, mapping = aes(x = GC, y = GC.Skew))+
    geom_point(mapping = aes(col = group))+
    geom_text(mapping = aes(col = group, label = id), nudge_y = 0.15 )+
    scale_color_manual(values = mcol)+
    labs(title = gene)+
    theme_classic()

ggsave(filename = paste0(out_dir, "/gc.", gene, ".svg"), device = "svg")

