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
out_dir <- paste0(stats_dir, "/cai.plot")
if(!file.exists(out_dir)) dir.create(out_dir)

gene <- c("atp6", "atp8", "cob", "cox1", "cox2", "cox3", "nad1", "nad2", "nad3", "nad4", "nad4l", "nad5", "nad6")
samples <- c("BSZ01", "BSZ71", "BSZ95", "BSZ99", "WYS168", "WYS209", "WYS260", "WYS265", "WYS273")

get_cai <- function(samples, gene){
    cai.file <- paste0(stats_dir, "/cai/", samples, "/", samples, ".", gene, ".cai")
    cai <- readLines(cai.file)
    cai <- strsplit(cai, split = ": ")
    cai <- unlist(cai)[3]
    cai <- as.numeric(cai)
    return(cai)
}

cai <- list()
for(i in 1 : length(samples)){
    cai[[i]] <- sapply(gene, function(x) get_cai(samples[i], x))
}

df <- data.frame(cai = unlist(cai), gene = rep(gene, times = length(samples)), sample = sort(rep(samples, times = length(gene))))

names(cai) <- samples
cai <- do.call(rbind, cai)
cai <- as.data.frame(cai)
cai$sample <- rownames(cai)
cai <- cai[ , c("sample", gene)]
write.table(cai, file = paste0(out_dir, "/cai.txt"), quote = F, row.names = F,sep = "\t")

df$group <- "0"
df[df$sample %in%c("BSZ01", "BSZ95", "WYS260", "WYS265"), "group"] <- "1"

mcol <- pal_lancet("lanonc", alpha = 0.5)(9)
ggplot(df, mapping = aes(x = gene, y = cai))+
    geom_point(mapping = aes(col = sample, shape = group), size = 3)+
  #  geom_text(mapping = aes(col = group, label = gene), nudge_y = 0.15 )+
    scale_color_manual(values = mcol)+
    labs(title = "cai")+
    theme_classic()

ggsave(filename = paste0(out_dir, "/cai.svg"), device = "svg")




