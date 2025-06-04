if(F){
args <- commandArgs()
tree_dir <- args[6]
gene     <- args[7]
}

mitos_dir <- "/home/wwj/working/project/sc/Microtendipes/out/mitos"
query <- "BSZ01"

samp <- c("BSZ01", "BSZ20", "BSZ71", "BSZ95", "BSZ99", "WYS168", "WYS209", "WYS260", "WYS265", "WYS273")

get.order <- function(query){
    file <- dir(paste(mitos_dir, query, sep = "/"), recursive = T, pattern = ".geneorder")
    file <- paste(mitos_dir, query, file, sep = "/")
    gene.order <- readLines(file)[2]
    gene.order <- unlist(strsplit(gene.order, split = " "))

    # remove  OH
    gene.order <- gene.order[!grepl(gene.order, pattern="^OH")]
    return(gene.order)
}

gene.order <- lapply(samp, function(x) get.order(x))
names(gene.order) <- samp
gene.order <- do.call(cbind, gene.order)

write.table(gene.order, file = paste0(mitos_dir, "/gene.order.txt"), sep = "\t", quote = F, row.names = F)


