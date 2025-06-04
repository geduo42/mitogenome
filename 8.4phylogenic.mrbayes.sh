#! /usr/bin/bash

workdir=~/project/sc/Microtendipes
alter='java -jar /home/soft/soft/ALTER/alter-lib/target/ALTER-1.3.4-jar-with-dependencies.jar'

mitos_dir=$workdir/out/annotation/mitos
mitoseq_dir=$workdir/out/basic/mitoseq
out_dir=$workdir/out/phylogenic8
seq_dir=$out_dir/seqs
align_dir=$out_dir/msa
trim_dir=$out_dir/trim
model_dir=$out_dir/model
tree_dir=$out_dir/tree.mrbayes

specimens=(BSZ01 BSZ71 BSZ95 BSZ99 WYS168 WYS209 WYS260 WYS265 WYS273 ON838257 ON943041 OP950228 MZ747091 ON975027 OP950216 OP950220 OP950218 OP950223 ON838255 MW373526 PQ014458 PQ014456 PQ014461 PQ014460 ON099430 MZ150770 MZ261913 MZ981735 MW677959)
genes=(pcg pcgc12 allgene allgenec12)


mkdir -p $out_dir $seq_dir $align_dir $model_dir $tree_dir $aligroove_dir



######## contruct the tree

#for gene in allgene  ## for a test run
for gene in pcg pcgc12 pcgR pcgc12R
do
    mkdir -p $tree_dir/$gene
     # transformat fasta to nexus, perform once only!!!!!!
     # Perfrom once only !!!!
#    $alter -i  $trim_dir/${gene}.ape.fasta -if FASTA -io Linux -ip MAFFT -o $tree_dir/$gene/${gene}.mafft.nexus -of NEXUS -oo Linux -op MrBayes

done



# edit the nexus file, and construct a starting tree using MrBayes

for gene in pcg pcgc12 pcgR pcgc12R
do
    cd $tree_dir/$gene
    mpirun -np 24 mb ${gene}.mafft.nexus

    # modiry the tree
#    Rscript $workdir/scripts/tree_modify.R $tree_dir $gene ${gene}.mafft.nexus.con.tre


done



