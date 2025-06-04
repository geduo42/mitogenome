
dnasp_dir <- "/home/wwj/working/project/sc/Microtendipes/out/evolution/dnasp"
out_dir  <- dnasp_dir

genes <- c("atp6", "atp8", "cob", "cox1", "cox2", "cox3", "nad1", "nad2", "nad3", "nad4", "nad4l", "nad5", "nad6", "mito")

get_DNApolymorphism <- function(gene){
    file <- paste0(dnasp_dir, "/", gene, ".DNApolymorphism.txt")
    content <- readLines(file)
    
    # get length of sequences
    len <- grep(content, pattern = "Total number of sites", value = T)
    len <- unlist(strsplit(len, split = ": "))[2]

    # get Number of Haplotypes of sequence
    nh <- grep(content, pattern = "Number of Haplotypes", value = T)
    nh <- unlist(strsplit(nh, split = ": "))[2]

    # get Number of polymorphic 
    s <- grep(content, pattern = "Number of polymorphic", value = T)
    s <- unlist(strsplit(s, split = ": "))[2]

    # get theta value
    theta <- grep(content, pattern = "Theta.*from S:", value = T)
    theta <- unlist(strsplit(theta, split = ": "))[2]

    df <- data.frame(Gene = gene, Length = len, Nh = nh, S = s, theta = theta)
    return(df)
}

DNApolymorphism <- lapply(genes, function(x) get_DNApolymorphism(x))
DNApolymorphism <- do.call(rbind, DNApolymorphism)
rownames(DNApolymorphism) <- genes

DNApolymorphism$Length <- as.numeric(DNApolymorphism$Length)
DNApolymorphism$Nh <- as.numeric(DNApolymorphism$Nh)
DNApolymorphism$S <- as.numeric(DNApolymorphism$S)
DNApolymorphism$theta <- as.numeric(DNApolymorphism$theta)


# according the equation θ = 4Neμ, μ = 1
Ne4 <- DNApolymorphism["mito", "theta"] 
DNApolymorphism$mu.relative <- DNApolymorphism$theta / Ne4

write.table(DNApolymorphism, file = paste0(out_dir, "/dna.polymorphism.txt"), sep = "\t", row.names = F, quote = F)

