args <- commandArgs()
sample <- args[6]
if(file.exists(args[7])){
    blast_file <- args[7]
    }else{
    blast_file <- args[8]
}

out_dir <- args[9]


context <- readLines(blast_file, n = 20)
fields <- context[grepl(x = context, pattern = "Fields")]
fields <- unlist(strsplit(fields, split = ": "))[2]
fields <- unlist(strsplit(fields, split = ", "))
fields <- gsub(pattern = "% ", replacement = "", x = fields)
fields <- gsub(pattern = " ", replacement = "_", x = fields)
fields <- gsub(pattern = "._", replacement = "_", x = fields)

aligned <- read.table(file = blast_file, sep ="\t", header = F, quote = "")
colnames(aligned) <- fields
for(j in 3 : 12){
    aligned[ , j] <- as.numeric(aligned[ , j])
    }

aligned <- aligned[aligned$identity > 95 , ]
aligned <- aligned[aligned$alignmen_length > 500, ]
aligned <- aligned[!duplicated(aligned$subjec_acc.ver), ]
write.table(aligned$subjec_acc.ver, file = paste(out_dir, "/mito.id.txt", sep = ""), quote = F, row.names = F, col.names = F)



# balst output format 0
if(F){
blast_res <- readLines(blast_file, n = 200)

start_line <- grep(blast_res, pattern = "Sequences producing significant alignments")
end_line <- grep(blast_res, pattern = "^>")

blast_res <- blast_res[(start_line + 1) : (end_line - 1)]
blast_res <- blast_res[nchar(blast_res) > 0 ]

aligned <- lapply(blast_res, function(x) unlist(strsplit(x, split = " +")))
aligned <- do.call(rbind, aligned)
colnames(aligned) <- c("id", "length", "read_counts", "score", "evalue")

aligned <- as.data.frame(aligned)
aligned$score <- as.numeric(aligned$score)
aligned$evalue <- as.numeric(aligned$evalue)

write.table(aligned$id, file = paste(out_dir, "/mito.id.txt", sep = ""), quote = F, row.names = F, col.names = F)
}

write.table(aligned, file = paste(out_dir, "/mito.txt", sep = ""), quote = F, row.names = F)


