

if(F){
sample <- "BSZ99"
mitos_dir <- "/home/wwj/working/project/sc/Microtendipes/out/annotation/mitos"
annot_dir <- "/home/wwj/working/project/sc/Microtendipes/out/basic/circos/annot"
}

if(T){
    args <- commandArgs()
    print(args)

    sample <- args[6]
    mitos_dir <- args[7]
    annot_dir <- args[8]
}

get_annotation <- function(query = NA){
    file <- dir(paste(mitos_dir, query, sep = "/"), recursive = T, pattern = "bed")
    file <- paste(mitos_dir, query, file, sep = "/")
    bed <- read.table(file = file, sep ="\t", header = F,  fill = T, quote = "")
    colnames(bed) <- c("query", "start", "end", "name", "score", "strand")

# remove OH
    bed <- bed[!grepl(bed$name, pattern = "^OH"), ]
# remove wrong rRNAL
    bed$name[grepl(bed$name, pattern = "^rrnL_0")] <- "rrnL"
    bed <- bed[!grepl(bed$name, pattern = "^rrnL_"), ]

    annot <- data.frame(seqname = bed$name, source = ".", feature = "CDS", start = bed$start + 1, end = bed$end, score = ".", strand = bed$strand, frame = ".")

# get right feature
    annot[grepl(annot$seqname, pattern = "^rrn"), "feature"] <- "rRNA"
    annot[grepl(annot$seqname, pattern = "^trn"), "feature"] <- "tRNA"

    return(annot)
}

annot <- get_annotation(sample)

write.table(annot, file = paste0(annot_dir, "/", sample, ".annot.txt"), sep = "\t", quote = F, row.names = F)

