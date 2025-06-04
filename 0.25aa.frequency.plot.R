library(ggplot2)
library(reshape2)
wkdir <- "~/project/sc/Microtendipes/out/basic/stats"
out_dir <- paste0(wkdir, "/plots")

data.file <- paste0(wkdir, "/codons/aa_usage.txt")
df <- read.table(data.file, sep = "\t", header = T, row.names = 1)
df <- df[!rownames(df) %in% c("X", "*"), ]
colnames(df)
colnames(df) <- c("M.bimaculatus_Clade1", "M.baishanzuensis", "M.bimaculatus_Clade2", "M.tuberosus", "M.robustus", "M.wuyiensis", "M.bimaculatus_Clade3", "M.bimaculatus_Clade3_1", "M.robustus_1")

df <- df[sort(rownames(df)),  c("M.baishanzuensis", "M.bimaculatus_Clade1", "M.bimaculatus_Clade2", "M.bimaculatus_Clade3", "M.robustus", "M.tuberosus", "M.wuyiensis")]
rownames(df) <- c("Ala", "Cys", "Asp", "Glu", "Phe", "Gly", "His", "Ile", "Lys", "Lue", "Met", "Asn", "Pro", "Gln", "Arg", "Ser", "Thr", "Val", "Trp", "Tyr")

#BSZ01 BSZ71 BSZ95 BSZ99 WYS168 WYS209 WYS260 WYS265 WYS273
#df <- df[ , !colnames(df) %in% c("WYS265, WYS273")]
# M.baishanzuensis = BSZ71
# M.tuberosus = BSZ99
# M.wuyiensis = WYS209
# M.bimaculatus_Clade1 = BSZ01
# M.bimaculatus_Clade2 = BSZ95
# M.bimaculatus_Clade3 = WYS260, WYS265
# M.robustus = WYS273, WYS168

df$aa <- rownames(df)
df <- melt(df)
colnames(df) <- c("aa", "species", "num")

mycol <- c("#cc340c", "#e8490f", "#f18800", "#e4ce00", "#9ec417", "#13a983", "#44c1f0", "#3f60aa")
mycol <- mycol[-1]

p <- ggplot(df, mapping = aes(x = aa, y = num))+
    geom_bar(mapping = aes(fill = species), stat = 'identity', position = "dodge")+
    scale_fill_manual(values = mycol)+
    labs(x = NULL, y = "Frequency")+
    scale_y_continuous(expand = c(0, 0), limits = c(0, 600))+
    theme_bw()+
    theme(panel.grid.major.x = element_blank(), panel.grid.minor.x = element_blank(), axis.title = element_text(family = "Arial", face = 'bold', size = 15), axis.text = element_text(family = "Arial", face = 'bold'), legend.position = "inside", legend.position.inside = c(.9, .8))

ggsave(p, filename = paste0(out_dir, '/aa_frequency.svg'), width = 12, unit = "in", device = 'svg')

