library(ape)

msa_dir <- "~/project/sc/Microtendipes/out/phylogenic30/trim"

genes <- c("atp6", "atp8", "cob", "cox1", "cox2", "cox3", "nad1", "nad2", "nad3", "nad4", "nad4l", "nad5", "nad6")

pcg <- lapply(genes, function(x) read.dna(paste0(msa_dir, "/", x, ".mafft.fasta"), format = "fasta"))
pcg <- do.call(cbind, pcg)

pcgc12 <- lapply(genes, function(x) read.dna(paste0(msa_dir, "/", x, ".c12.mafft.fasta"), format = "fasta"))
pcgc12 <- do.call(cbind, pcgc12)

rnal <- read.dna(paste0(msa_dir, "/rrnL.mafft.fasta"), format = "fasta")
rnas <- read.dna(paste0(msa_dir, "/rrnS.mafft.fasta"), format = "fasta")


pcgR <- cbind(pcg, rnal, rnas, fill.with.gaps = T)
pcgc12R <- cbind(pcgc12, rnal, rnas, fill.with.gaps = T)


write.dna(pcg, paste0(msa_dir, "/pcg.ape.fasta"), format = "fasta")
write.dna(pcgc12, paste0(msa_dir, "/pcgc12.ape.fasta"), format = "fasta")
write.dna(pcgR, paste0(msa_dir, "/pcgR.ape.fasta"), format = "fasta")
write.dna(pcgc12R, paste0(msa_dir, "/pcgc12R.ape.fasta"), format = "fasta")
