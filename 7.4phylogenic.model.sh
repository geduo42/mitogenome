#! /usr/bin/bash
### modified from 6.3

workdir=~/project/sc/Microtendipes
alter='java -jar /home/soft/soft/ALTER/alter-lib/target/ALTER-1.3.4-jar-with-dependencies.jar'

mitos_dir=$workdir/out/annotation/mitos
mitoseq_dir=$workdir/out/basic/mitoseq
out_dir=$workdir/out/phylogenic7
seq_dir=$out_dir/seqs
align_dir=$out_dir/msa
trim_dir=$out_dir/trim
model_dir=$out_dir/model
tree_dir=$out_dir/tree.mrbayes
aligroove_dir=$out_dir/aligroove.mrbayes

specimens=(BSZ01 BSZ71 BSZ95 BSZ99 WYS168 WYS209 WYS260 WYS265 WYS273 ON838257 ON943041 OP950228 MZ747091 ON975027 OP950216 OP950220 OP950218 OP950223 ON838255 MW373526 PQ014458 PQ014456 PQ014461 PQ014460 ON099430 MZ150770 MZ261913 MZ981735 MW677959)
genes=(pcg pcgc12 allgene allgenec12)


mkdir -p $out_dir $seq_dir $align_dir $trim_dir $model_dir $tree_dir $aligroove_dir

######## combine the msa of each gene
Rscript $workdir/scripts/0.74combine.fasta.R


######## model selection
for gene in  pcgc12R  pcgR  pcg  pcgc12 
do
    mkdir -p $model_dir/${gene}.mrbayes $model_dir/${gene}.raxml
    $alter -i $trim_dir/${gene}.ape.fasta -if FASTA -io Linux -ip MAFFT -o $model_dir/${gene}.mrbayes/${gene}.mafft.phylip -of PHYLIP -oo Linux -os -op ProtTest
    python /home/soft/soft/PartionFinder/partitionfinder-2.1.1/PartitionFinder.py $model_dir/${gene}.mrbayes --raxml --force-restart

    cp $model_dir/${gene}.mrbayes/${gene}.mafft.phylip $model_dir/${gene}.raxml/${gene}.mafft.phylip
    python /home/soft/soft/PartionFinder/partitionfinder-2.1.1/PartitionFinder.py $model_dir/${gene}.raxml --raxml
done





