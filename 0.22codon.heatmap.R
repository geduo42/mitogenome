library(optparse)
library(pheatmap)
library(RColorBrewer)

option_list <- list(
    make_option(c("-d", "--data_dir"), type = "character", default = FALSE,
                action = "store", help = "path to dir"
    ),
    make_option(c("-m", "--marker"), type = "character", default = FALSE,
                action = "store", help = "marker"
    )
)


opt <- parse_args(OptionParser(option_list = option_list, usage = "coming soon..."))
print(opt)

data_dir <- opt$data_dir
marker   <- opt$marker

dt <- read.table(paste0(data_dir, "/", marker, ".stats.txt"), header = T)

dt$AT <- as.numeric(dt$AT)
dt$sample <- sapply(dt$id, function(x)unlist(strsplit(x, split = "_"))[1])
dt$gene <- sapply(dt$id, function(x)unlist(strsplit(x, split = "_"))[2])

df <- matrix(nrow = length(unique(dt$sample)), ncol = length(unique(dt$gene)))
rownames(df) <- unique(dt$sample)
colnames(df) <- unique(dt$gene)

for(i in 1 : nrow(df)){
    for(j in 1: ncol(df)){
        df[i, j] <- dt$AT[which(dt$sample == rownames(df)[i] & dt$gene == colnames(df)[j])]
    }
}


col <- colorRampPalette(brewer.pal(9, "Blues"))(100)

svg(paste0(data_dir, "/ATcontent.", marker, ".svg"))
pheatmap(df, cluster_rows = F, cluster_cols = F, scale = "none", border_color = NA, color = col)

dev.off()



