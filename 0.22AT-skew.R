library(optparse)

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

df <- read.table(paste0(data_dir, "/", marker, ".stats.txt.temp"), header = T)

df2 <- data.frame(id = df$id, Length = df$length, AT = df$AT, AT.Skew = round((df$A - df$T)/(df$A + df$T)*100, 2),  GC = df$GC, GC.Skew = df$GC.Skew)

write.table(df2, file = paste0(data_dir, "/", marker, ".stats.txt"), sep = "\t", row.names = F, quote = F)
