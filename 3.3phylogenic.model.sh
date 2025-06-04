#! /usr/bin/bash

workdir=~/project/sc/Microtendipes
alter='java -jar /home/soft/soft/ALTER/alter-lib/target/ALTER-1.3.4-jar-with-dependencies.jar'

mitos_dir=$workdir/out/annotation/mitos
mitoseq_dir=$workdir/out/basic/mitoseq
out_dir=$workdir/out/phylogenic30
seq_dir=$out_dir/seqs
align_dir=$out_dir/msa
trim_dir=$out_dir/trim
model_dir=$out_dir/model
tree_dir=$out_dir/tree.mrbayes
aligroove_dir=$out_dir/aligroove.mrbayes

specimens=(BSZ01 BSZ71 BSZ95 BSZ99 WYS168 WYS209 WYS260 WYS265 WYS273 ON838257 ON943041 OP950228 MZ747091 ON975027 OP950216 OP950220 OP950218 OP950223 ON838255 MW373526 PQ014458 PQ014456 PQ014461 PQ014460 ON099430 MZ150770 MZ261913 MZ981735 MW677959 OL753645)
genes=(pcg pcgc12 allgene allgenec12)


mkdir -p $out_dir $seq_dir $align_dir $trim_dir $model_dir $tree_dir $aligroove_dir



######## trim some gaps using trimAl
## transformat fasta to phylip for easier watching
for gene in nad2 cox1 cox2 atp8 atp6 cox3 nad3 nad5 nad4 nad4l nad6 cob nad1 rrnL  rrnS
do
 #   $alter -i $align_dir/${gene}.mafft.fasta -if FASTA -io Linux -ip MAFFT -o $align_dir/${gene}.phylip -of PHYLIP -oo Linux -op RAxML
    cp $align_dir/${gene}.mafft.fasta $trim_dir/${gene}.mafft.fasta
done

for gene in nad2 cox1 cox2 atp8 atp6 cox3 nad3 nad5 nad4 nad4l nad6 cob nad1
do
 #   $alter -i $align_dir/${gene}.c12.mafft.fasta -if FASTA -io Linux -ip MAFFT -o $align_dir/${gene}.c12.phylip -of PHYLIP -oo Linux -op RAxML
    cp $align_dir/${gene}.c12.mafft.fasta $trim_dir/${gene}.c12.mafft.fasta
done
    # remove any space in seq names
#    seqkit replace $align_dir/${gene}.mafft.trimmed.fasta -p "\s.+" >$align_dir/temp.fa
#    mv $align_dir/temp.fa $align_dir/${gene}.mafft.trimmed.fasta


## trim
trimal -in $trim_dir/atp8.mafft.fasta -out $trim_dir/atp8.trim.fasta -selectcols { 0-56 }
trimal -in $trim_dir/cox1.mafft.fasta -out $trim_dir/cox1.trim.fasta -selectcols { 0-8 }
trimal -in $trim_dir/nad1.mafft.fasta -out $trim_dir/nad1.trim.fasta -selectcols { 0-8 }
trimal -in $trim_dir/nad2.mafft.fasta -out $trim_dir/nad2.trim.fasta -selectcols { 0-56 }
trimal -in $trim_dir/nad6.mafft.fasta -out $trim_dir/nad6.trim.fasta -selectcols { 0-2 }
trimal -in $trim_dir/rrnL.mafft.fasta -out $trim_dir/rrnL.trim.fasta -selectcols { 0-722 }

trimal -in $trim_dir/atp8.c12.mafft.fasta -out $trim_dir/atp8.c12.trim.fasta -selectcols { 0-40 }
trimal -in $trim_dir/cox1.c12.mafft.fasta -out $trim_dir/cox1.c12.trim.fasta -selectcols { 0-5 }
trimal -in $trim_dir/nad1.c12.mafft.fasta -out $trim_dir/nad1.c12.trim.fasta -selectcols { 0-5 }
trimal -in $trim_dir/nad2.c12.mafft.fasta -out $trim_dir/nad2.c12.trim.fasta -selectcols { 0-37 }
trimal -in $trim_dir/nad6.c12.mafft.fasta -out $trim_dir/nad6.c12.trim.fasta -selectcols { 0-1 }

rename.ul trim.fasta mafft.fasta $trim_dir/*.trim.fasta

######## combine the msa of each gene
#Rscript $workdir/scripts/0.33combine.fasta.R


######## model selection
for gene in  pcgc12R  pcgR  #pcg  pcgc12 pcgR pcgc12R
do
    mkdir -p $model_dir/${gene}.mrbayes $model_dir/${gene}.raxml
    $alter -i $trim_dir/${gene}.ape.fasta -if FASTA -io Linux -ip MAFFT -o $model_dir/${gene}.mrbayes/${gene}.mafft.phylip -of PHYLIP -oo Linux -os -op ProtTest
    python /home/soft/soft/PartionFinder/partitionfinder-2.1.1/PartitionFinder.py $model_dir/${gene}.mrbayes --raxml --force-restart

    cp $model_dir/${gene}.mrbayes/${gene}.mafft.phylip $model_dir/${gene}.raxml/${gene}.mafft.phylip
#    python /home/soft/soft/PartionFinder/partitionfinder-2.1.1/PartitionFinder.py $model_dir/${gene}.raxml --raxml
done





