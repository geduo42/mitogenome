library(ape)

msa_dir <- "~/project/sc/Microtendipes/out/phylogenic7/trim"

genes <- c("atp6", "atp8", "cob", "cox1", "cox2", "cox3", "nad1", "nad2", "nad3", "nad4", "nad4l", "nad5", "nad6")

pcg <- lapply(genes, function(x) read.dna(paste0(msa_dir, "/", x, ".fas"), format = "fasta"))
pcg <- do.call(cbind, pcg)

pcgc12 <- pcg[ , -seq(3, length(pcg)/length(labels(pcg)), by = 3)]

as.character(pcg[1:3, 1:30])
as.character(pcgc12[1:3, 1:20])

rnal <- read.dna(paste0(msa_dir, "/rrnL.fas"), format = "fasta")
rnas <- read.dna(paste0(msa_dir, "/rrnS.fas"), format = "fasta")

pcgR <- cbind(pcg, rnal, rnas, fill.with.gaps = T)
pcgc12R <- cbind(pcgc12, rnal, rnas, fill.with.gaps = T)

write.dna(pcg, paste0(msa_dir, "/pcg.ape.fasta"), format = "fasta")
write.dna(pcgR, paste0(msa_dir, "/pcgR.ape.fasta"), format = "fasta")
write.dna(pcgc12, paste0(msa_dir, "/pcgc12.ape.fasta"), format = "fasta")
write.dna(pcgc12R, paste0(msa_dir, "/pcgc12R.ape.fasta"), format = "fasta")

