library(ape)

args <- commandArgs()
tree.file <- args[6]


   # for mrBayes out, nexus forrmat
    tree <- read.nexus(file = tree.file)
    tree <- tree[[1]]


write.tree(tree, file = paste0(tree.file, ".newick"))

