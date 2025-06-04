#! /usr/bin/bash

# repeat the work, including model selection, tree inferring with RAxML-ng and mrbayes.
#  model selection has done, copy from 6.7

workdir=~/project/sc/Microtendipes
alter='java -jar /home/soft/soft/ALTER/alter-lib/target/ALTER-1.3.4-jar-with-dependencies.jar'

mitos_dir=$workdir/out/annotation/mitos
mitoseq_dir=$workdir/out/basic/mitoseq
out_dir=$workdir/out/phylogenic8
seq_dir=$out_dir/seqs
align_dir=$out_dir/msa
trim_dir=$out_dir/trim
model_dir=$out_dir/model.raxml-ng

specimens=(BSZ01 BSZ71 BSZ95 BSZ99 WYS168 WYS209 WYS260 WYS265 WYS273 ON838257 ON943041 OP950228 MZ747091 ON975027 OP950216 OP950220 OP950218 OP950223 ON838255 MW373526 PQ014458 PQ014456 PQ014461 PQ014460 ON099430 MZ150770 MZ261913 MZ981735 MW677959 OL753645)
genes=(pcg pcgc12 allgene allgenec12)


mkdir -p $out_dir $seq_dir $align_dir $trim_dir $model_dir $tree_dir $aligroove_dir


#cp -r $workdir/out/phylogenic6/trim $out_dir 
#cp -r $workdir/out/phylogenic6/model_new/* $model_dir



######## combine the msa of each gene
#Rscript $workdir/scripts/0.63combine.fasta.R


######## model selection
for gene in  pcg pcgc12R  pcgR  pcg  pcgc12 
do
    mkdir -p $model_dir/${gene}.mrbayes $model_dir/${gene}.raxml
 #   $alter -i $trim_dir/${gene}.ape.fasta -if FASTA -io Linux -ip MAFFT -o $model_dir/${gene}.mrbayes/${gene}.mafft.phylip -of PHYLIP -oo Linux -os -op ProtTest
 #   cp $out_dir/model/${gene}.mrbayes/partition_finder.cfg $model_dir/${gene}.mrbayes
 #   python /home/soft/soft/PartionFinder/partitionfinder-2.1.1/PartitionFinder.py $model_dir/${gene}.mrbayes  --force-restart

#    cp $model_dir/${gene}.mrbayes/${gene}.mafft.phylip $model_dir/${gene}.raxml/${gene}.mafft.phylip
#    cp $out_dir/model/${gene}.raxml/partition_finder.cfg $model_dir/${gene}.raxml
    python /home/soft/soft/PartionFinder/partitionfinder-2.1.1/PartitionFinder.py $model_dir/${gene}.raxml
done





