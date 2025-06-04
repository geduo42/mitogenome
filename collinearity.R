library(genoPlotR)

version <- "v1.00"

OH_col <- rgb(255, 0, 0, maxColorValue = 255)
trn_col <- rgb(251, 138, 19, maxColorValue = 255)
rrn_col <- rgb(0, 128, 0, maxColorValue = 255)
cox_col <- rgb(9, 9, 106, maxColorValue = 255)
atp_col <- rgb(128, 0, 128, maxColorValue = 255)
nad_col <- rgb(29, 156, 221, maxColorValue = 255)

comparisons_same_direction_color <- rgb(233, 175, 175, maxColorValue = 255)
comparisons_opposite_direction_color <- rgb(179, 179, 179, maxColorValue = 255)

alignment_length_cutoff <-  1000

if(F){
mitos_dir <- "/home/wwj/working/project/sc/Microtendipes/out/annotation/mitos"
blast_dir <- "/home/wwj/working/project/sc/Microtendipes/out/collinearity/blast"
collinearity_dir   <- "/home/wwj/working/project/sc/Microtendipes/out/collinearity"
}

if(T){
    args <- commandArgs()
    print(args) 
    
    collinearity_dir <- args[6]
    blast_dir <- args[7]
    mitos_dir <- args[8]
}

get_segs <- function(query = NA){
    file <- dir(paste(mitos_dir, query, sep = "/"), recursive = T, pattern = "bed")
    file <- paste(mitos_dir, query, file, sep = "/")
    bed <- read.table(file = file, sep ="\t", header = F,  fill = T, quote = "")
    colnames(bed) <- c("query", "start", "end", "name", "score", "strand")
 
    seg <- data.frame(name = bed$name, start = bed$start, end = bed$end, strand = bed$strand, gene_type = "arrows", feature = "feature", col = "blue")
    
    seg[grepl(seg$name, pattern = "^OH") , "feature"] <- "OH"
    seg[grepl(seg$name, pattern = "^trn") , "feature"] <- "trn"
    seg[grepl(seg$name, pattern = "^rrn") , "feature"] <- "rrn"
    seg[grepl(seg$name, pattern = "^cox") , "feature"] <- "cox"
    seg[grepl(seg$name, pattern = "^atp") , "feature"] <- "atp"
    seg[grepl(seg$name, pattern = "^nad") , "feature"] <- "nad"

    seg[seg$feature == "OH", "col"] <- OH_col
    seg[seg$feature == "trn", "col"] <- trn_col
    seg[seg$feature == "rrn", "col"] <- rrn_col
    seg[seg$feature == "cox", "col"] <- cox_col
    seg[seg$feature == "atp", "col"] <- atp_col
    seg[seg$feature == "nad", "col"] <- nad_col
    
    seg[seg$feature == "OH", "gene_type"] <- "side_exons"
    seg$fill <- seg$col

    seg <- dna_seg(seg)

    return(seg)
}

get_annotation <- function(query = NA ){
    temp <- which(names(segs) == query)[1]
    dna_seg <- segs[[temp]]
    mid_pos <- middle(dna_seg)
    n <- length(mid_pos)

    annot <- data.frame(x1 = mid_pos, x2 = NA , text = dna_seg$name, rot = 30,  col = dna_seg$col, cex = 0.8)
    
    annot <- as.annotation(annot)
    return(annot)
    }

read_nsn <- function(){
    ## read the nsn file
    file <- paste(blast_dir, "/all.mito.nsn", sep = "")
    context <- readLines(file, n = 20)
    fields <- context[grepl(x = context, pattern = "Fields")]
    fields <- unlist(strsplit(fields, split = ": "))[2]
    fields <- unlist(strsplit(fields, split = ", "))
    fields <- gsub(pattern = "% ", replacement = "", x = fields)
    fields <- gsub(pattern = " ", replacement = "_", x = fields)
    fields <- gsub(pattern = "._", replacement = "_", x = fields)

    align_out <- read.table(file = file, sep ="\t", header = F, quote = "")
    colnames(align_out) <- fields
    for(j in fields[3 : 12]){
        align_out[ , j] <- as.numeric(align_out[ , j])
    }
    return(align_out)
}

get_direction <- function(df){
    ## get direction and color for comarison. Two sequences with the same direction, get the direction = 1, otherwise -1.
    if(nrow(df) > 0){
        df$direction <- 0
        df$col <- "blue"
        for(i in 1 : nrow(df)){
            if((df$start1[i] - df$end1[i]) * (df$start2[i] - df$end2[i]) > 0){
                df$direction[i] <- 1
                df$col[i] <- comparisons_same_direction_color
                }
            else{
                df$direction[i] <- -1
                df$col[i] <- comparisons_opposite_direction_color
            }
        }
    }
    return(df)
}

get_comparisons <- function(query, subject, alignment_length_cutoff = 1000){
    ## get type comparisons object from align out file created by blastn.
    ## read the nsn file
    align_out <- read_nsn()

    ### simplify
    align_out <- align_out[align_out$alignmen_length > alignment_length_cutoff, ]
    align_out <- align_out[align_out$identity > 80, ]

    keeped_col <- c("q_start", "q_end", "s_start", "s_end", "quer_acc.ver", "subjec_acc.ver", "identity","alignmen_length", "mismatches", "ga_opens", "evalue", "bi_score")

    align_out   <- align_out[align_out$quer_acc.ver   == query,   keeped_col]
    comparisons <- align_out[align_out$subjec_acc.ver == subject, keeped_col]
    colnames(comparisons) <- c("start1", "end1", "start2", "end2", "quer_acc.ver", "subjec_acc.ver", "identity","alignmen_length", "mismatches", "ga_opens", "evalue", "bi_score")
    comparisons <- as.comparison(get_direction(comparisons))

    return(comparisons)
}


seqs <- read.table(paste(collinearity_dir, "/",  "collinearity.id", sep = ""))
seqs <- as.vector(seqs$V1)
print(seqs)

segs <- lapply(seqs, function(x) get_segs(query = x))
names(segs)<- seqs

segs$BSZ99[segs$BSZ99$name == "OH_0", "start"] <- 1

annotations <- lapply(seqs, function(x) get_annotation(x))
names(annotations) <- seqs

comparisons <- list()
for(i in 1 : (length(seqs) - 1)){
    compari <- get_comparisons(seqs[i], seqs[i + 1], alignment_length_cutoff = alignment_length_cutoff)
    compari$col <- apply_color_scheme(compari$identity, direction = compari$direction, color_scheme = "blue_red", rng = c(0, 100))
    comparisons[[i]] <- compari
}

## output svg figure
svg(file = paste(collinearity_dir, "/", "mito_collinearity", ".svg", sep = ""), height = 10, width = 20)
plot_gene_map(segs, annotations = annotations, dna_seg_scale = T, annotation_height = 1.5, annotation_cex = 0.5)
dev.off()


svg(file = paste(collinearity_dir, "/", "mito_collinearity_compari", ".svg", sep = ""), height = 10, width = 20)
plot_gene_map(segs, annotations = annotations, dna_seg_scale = T, annotation_height = 1.5, annotation_cex = 0.5, comparisons = comparisons)
dev.off()

