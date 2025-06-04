
df <- read.table("~/working/project/sc/Microtendipes/out/basic/upload/feature_table.tbl", sep = "\t", fill = T)

vec1 = c()
vec2 = c()
for(i in 1:  nrow(df)){
    if(grepl(df$V1[i], pattern = "^[1-9]")){
        x = as.numeric(df$V1[i]) +1
        vec1 = c(vec1, as.character(x))
        y = as.numeric(df$V2[i] +1)
        vec2 = c(vec2, as.character(y))
    }else{
        vec1 = c(vec1, df$V1[i])
        vec2 = c(vec2, df$V2[i])
    }
}
vec2[is.na(vec2)] <- ""

df$V1 <- vec1
df$V2 <- vec2

write.table(df, file = "~/working/project/sc/Microtendipes/out/basic/upload/feature_table2.tbl", sep = "\t", quote = F, row.names = F, col.names = F)
