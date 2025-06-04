library(ggplot2)
library(ggtree)
library(ape)


args <- commandArgs()
tree_dir <- args[6]
gene     <- args[7]
tree.file <- args[8]

out_dir  <- paste0(tree_dir, "/modify")
if(!file.exists(out_dir)){
    dir.create(out_dir)
}

if(grepl(tree.file, pattern = "tre$")){
   # for mrBayes out, nexus forrmat
    tree <- read.nexus(file = tree.file)
    tree <- tree[[1]]
}else{
   #for newick format
    tree <- read.tree(file = tree.file)
}


df = data.frame(id = c("OL753645", "OP950228", "OP950223", "OP950216", "OP950220", "OP950218", "MW677959", "MZ981735", "ON099430", "PQ014458", "PQ014461", "PQ014456", "MZ261913", "ON975027", "PQ014460","ON943041", "MZ150770", "MZ747091", "ON838257", "ON838255", "MW373526"), specie = c("S. okialbus", "E. pekanus", "S. impar", "P. flavipes", "S. baueri", "S. akizukii", "P. unifascium", "P. henicurum", "A. fungorum", "H. angularis", "C. defectus", "D. minus", "M. tabarui", "M. tener", "C. edwardsi", "Einfeldia.ap", "C. kiiensis", "G. tokunagai", "Dicrotendipes.sp", "T. formosanus", "R. villiculus"))

for(i in 1 : length(tree$tip.label)){
    if(tree$tip.label[i] %in% df$id){
	x = which(df$id == tree$tip.label[i])
	tree$tip.label[i] <- df$specie[x]
    }
}


data <- fortify(tree)

## tree-like graph
treegraph <- ggtree(data, layout="rectangular", size=0.8, col="deepskyblue3") +
  # 树体：树文件、树形、粗细、颜色
  geom_tiplab(size=3, color="purple4", hjust=-0.05) +
  # 枝名：大小、颜色、高度
  geom_tippoint(size=1.5, color="deepskyblue3") +
  # 端点：大小、颜色
  geom_nodepoint(color="orange", alpha=1/4, size=2) +
  # 末节点：颜色、透明度、大小
  geom_nodelab(aes(subset = !isTip, label = label), color = "black")+
  #  bootstrap value on node
  theme_tree2() +
  # x轴标尺
  xlim(NA, max(data$x)*1.3)+
  labs(title = gene)

ggsave(treegraph, file = paste0(out_dir, "/", gene, ".treegraph.svg"), device = svg, width = 9, height = 9)


## circular-like graph
circulargraph <- ggtree(tree, layout="circular", ladderize=FALSE, size=0.8, branch.length="none" )  +
    # 树体：树文件、树形、粗细、颜色
    geom_tiplab2(size=3, color="purple4", hjust=-0.3) +
    # 枝名：大小、颜色、高度
    geom_tippoint(size=3, color="deepskyblue3")+
    # 端点颜色、大小
    geom_nodepoint(color="orange", alpha=1/4, size=2) +
    theme(legend.title=element_text(face="bold"), legend.position="bottom", legend.box="horizontal", legend.text=element_text(size=rel(0.8)))+
    # 图例位置、文字大小
    geom_nodelab(aes(subset = !isTip, label = label), color = "black")+
    #  bootstrap value on node
    labs(title = gene)

ggsave(circulargraph, file = paste0(out_dir, "/", gene, ".circulargraph.svg"), device= svg, width=9, height=9)
