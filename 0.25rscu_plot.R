library(aplot)
library(ggplot2)

data_dir <- "/home/wwj/project/sc/Microtendipes/out/basic/stats/rscu"
out_dir <- "/home/wwj/project/sc/Microtendipes/out/basic/stats/plots"
#BSZ01 BSZ71 BSZ95 BSZ99 WYS168 WYS209 WYS260 WYS265 WYS273
#df <- df[ , !colnames(df) %in% c("WYS265, WYS273")]
# M.baishanzuensis = BSZ71
# M.tuberosus = BSZ99
# M.wuyiensis = WYS209
# M.bimaculatus_Clade1 = BSZ01
# M.bimaculatus_Clade2 = BSZ95
# M.bimaculatus_Clade3 = WYS260, WYS265
# M.robustus = WYS273, WYS168


# for single sample
df <- read.table(paste0(data_dir, "/BSZ01.rscu.txt"), sep = ",")

p1 <- ggplot(df, aes(x = V2, y = V3, fill = as.character(V4)))+
    geom_bar(position = "stack", stat = "identity")+
    theme_bw()+
    scale_y_continuous(expand = c(0, 0),  limits = c(0, 8.2))+
    theme(legend.position = 'none')+
    labs(y = 'RSCU',  x = '')

p2 <- ggplot(df, aes(x = V2, y = V4)) + 
    geom_label(aes(label = V1, fill = as.character(V4)), size = 2)+
    labs(x = '', y = '') +
    ylim(2.4, 6.1)+
    theme_minimal()+
    theme(legend.position = 'none', axis.text = element_blank(), axis.ticks = element_blank(), panel.grid = element_blank())

p1 %>% insert_bottom(p2, height = 0.3)


## for multi samples
interval = 3.2
sample = c("BSZ71", "BSZ01", "BSZ95", "WYS260", "WYS168", "BSZ99", "WYS209")
read_data <- function(sample){
    df <- read.table(paste0(data_dir, "/", sample, ".rscu.txt"), sep = ",")
    colnames(df) <- c("codon", 'aa', 'rscu', 'position')
    df$x <- 0
    df$x[df$aa == "Ala"] = 0.3 + interval * 0
    df$x[df$aa == "Arg"] = 0.3 + interval * 1
    df$x[df$aa == "Asn"] = 0.3 + interval * 2
    df$x[df$aa == "Asp"] = 0.3 + interval * 3
    df$x[df$aa == "Cys"] = 0.3 + interval * 4
    df$x[df$aa == "Gln"] = 0.3 + interval * 5
    df$x[df$aa == "Glu"] = 0.3 + interval * 6
    df$x[df$aa == "Gly"] = 0.3 + interval * 7
    df$x[df$aa == "His"] = 0.3 + interval * 8
    df$x[df$aa == "Ile"] = 0.3 + interval * 9
    df$x[df$aa == "Leu"] = 0.3 + interval * 10
    df$x[df$aa == "Lys"] = 0.3 + interval * 11
    df$x[df$aa == "Met"] = 0.3 + interval * 12
    df$x[df$aa == "Phe"] = 0.3 + interval * 13
    df$x[df$aa == "Pro"] = 0.3 + interval * 14
    df$x[df$aa == "Ser"] = 0.3 + interval * 15
    df$x[df$aa == "Thr"] = 0.3 + interval * 16
    df$x[df$aa == "Trp"] = 0.3 + interval * 17
    df$x[df$aa == "Tyr"] = 0.3 + interval * 18
    df$x[df$aa == "Val"] = 0.3 + interval * 19

    df$sample <- sample
    return(df)
}

rscu <- lapply(sample, function(x) read_data(x))
mycol <- c("#cc340c", "#e8490f", "#f18800", "#e4ce00", "#9ec417", "#13a983", "#44c1f0", "#3f60aa")
mycol <- mycol[c(1, 3, 5, 7, 2, 4, 6, 8)]
p1 <- ggplot()+
    geom_bar(data = rscu[[1]], aes(x = x, y = rscu, fill = as.character(position)), 
            position = "stack", stat = "identity", width = 0.3)+
    geom_bar(data = rscu[[2]], aes(x = x + 0.4, y = rscu, fill = as.character(position)),
            position = "stack", stat = "identity", width = 0.3)+
    geom_bar(data = rscu[[3]], aes(x = x + 0.8, y = rscu, fill = as.character(position)),
            position = "stack", stat = "identity", width = 0.3)+
    geom_bar(data = rscu[[4]], aes(x = x + 1.2, y = rscu, fill = as.character(position)),
            position = "stack", stat = "identity", width = 0.3)+
    geom_bar(data = rscu[[5]], aes(x = x + 1.6, y = rscu, fill = as.character(position)),
            position = "stack", stat = "identity", width = 0.3)+
    geom_bar(data = rscu[[6]], aes(x = x + 2.0, y = rscu, fill = as.character(position)),
            position = "stack", stat = "identity", width = 0.3)+
    geom_bar(data = rscu[[7]], aes(x = x + 2.4, y = rscu, fill = as.character(position)),
            position = "stack", stat = "identity", width = 0.3)+
    theme_bw()+
    scale_y_continuous(expand = c(0, 0), limits = c(0, 8.2))+
    scale_x_continuous(expand = c(0, 0), limits = c(-0.1, 63.9), labels = NULL, breaks = NULL)+
    scale_fill_manual(values = mycol)+
    theme(legend.position = 'none', panel.grid.major.x = element_blank(), panel.grid.minor.x = element_blank(), axis.title = element_text(family = "Arial", face = 'bold', size = 15), axis.text = element_text(family = "Arial", face = 'bold'))+
    labs(y = 'RSCU',  x = '')

p2 <- ggplot(rscu[[1]], aes(x = x + 1.2, y = 1)) +
    geom_label(aes(label = aa, size = 4))+
    labs(x = '', y = '') +
    ylim(-0.2, 2.2)+
    scale_x_continuous(expand = c(0, 0), limits = c(-0.1, 63.9))+
    theme_minimal()+
    theme(legend.position = 'none', axis.text = element_blank(), axis.ticks = element_blank(), panel.grid = element_blank())
p3 <- p1 %>% insert_bottom(p2, height = 0.05)

p4 <- ggplot(rscu[[1]], aes(x = x + 1.2, y = position)) +
    geom_label(aes(label = codon, fill = as.character(position)), size = 4)+
    labs(x = '', y = '') +
    ylim(2, 6)+
    scale_fill_manual(values = mycol)+
    scale_x_continuous(expand = c(0, 0), limits = c(-0.1, 63.9))+
    theme_minimal()+
    theme(legend.position = 'none', axis.text = element_blank(), axis.ticks = element_blank(), panel.grid = element_blank())

p5 <- p3 %>% insert_bottom(p4, height = 0.35)

ggsave(p5, filename = paste0(out_dir, "/rscu.svg"), width = 12, height = 8)

## an instance 
if(F){
dat <- data.frame(
  year=factor(sample(2010:2014, 400, replace=T)), 
  continent=factor(sample(c("EU", "US", "Asia"), 
                          400, replace=T)),
  gender=factor(sample(c("male", "female"), 
                       400, replace=T)),
  amount=sample(20:5000, 400, replace=T))

ggplot(dat,aes(x=year,y=amount,fill=gender))+
  geom_bar(stat="identity",position = "stack")+
  facet_wrap(~continent)+
  theme_bw()


dat$x<-ifelse(dat$continent=="Asia",1,
              ifelse(dat$continent=="EU",2,3))
df1<-dat[dat$year==2010, ]
df2<-dat[dat$year==2011, ]
head(df1)
head(df2)
ggplot()+
  geom_bar(data=df1,
           aes(x=x,y=amount,fill=gender),
           stat = "identity",position = "stack",width=0.3)+
  geom_bar(data=df2,aes(x=x+0.3+0.1,y=amount,fill=gender),
           stat="identity",position = "stack",width=0.3)+
  scale_x_continuous(breaks = c(1.2,2.2,3.2),
                     labels = c("Asia","EU","US"))+
  scale_fill_manual(values = c("red","blue","orange","yellow"))+
  theme_bw()
}

