#! /usr/bin
workdir=/home/wwj/project/sc/Microtendipes

basic_dir=$workdir/out/basic
mitoseq_dir=$basic_dir/mitoseq
collinearity_dir=$basic_dir/collinearity
blast_dir=$collinearity_dir/blast
mitos_dir=$workdir/out/annotation/mitos

mkdir -p $collinearity_dir $blast_dir

specimens=(BSZ01 BSZ71 BSZ95 BSZ99 WYS168 WYS209 WYS260 WYS265 WYS273)
specimens=(Punifascium BSZ01 BSZ71 BSZ95 BSZ99 WYS168 WYS209 WYS260 WYS265 WYS273 ON838257 ON943041 OP950228 MZ747091 ON975027 OP950216 OP950220 OP950218 OP950223 ON838255 MW373526)

# align all the mito sequeces using blast
mitoseq=()
for sample in  ${specimens[@]}
do
    seqkit replace $mitoseq_dir/${sample}.fasta -p ";.+" >$mitoseq_dir/temp.fas
    seqkit replace $mitoseq_dir/temp.fas -p "\.1" >$mitoseq_dir/${sample}.fasta

    mitoseq[${#mitoseq[@]}]=$mitoseq_dir/${sample}.fasta

done

cat ${mitoseq[@]} >$collinearity_dir/collinearity.fas

seqkit seq $collinearity_dir/collinearity.fas -n -i >$collinearity_dir/collinearity.id

makeblastdb -in $collinearity_dir/collinearity.fas -dbtype nucl -out $blast_dir/all.mito -parse_seqids

blastn -db $blast_dir/all.mito -query $collinearity_dir/collinearity.fas -out $blast_dir/all.mito.nsn -evalue 1e-2 -outfmt 7 

# plot collinearity
Rscript $workdir/scripts/collinearity.R $collinearity_dir $blast_dir $mitos_dir












