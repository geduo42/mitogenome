#! /usr/bin/bash

workdir=~/project/sc/Microtendipes
alter='java -jar /home/soft/soft/ALTER/alter-lib/target/ALTER-1.3.4-jar-with-dependencies.jar'

mitos_dir=$workdir/out/annotation/mitos
mitoseq_dir=$workdir/out/basic/mitoseq
out_dir=$workdir/out/phylogenic6
seq_dir=$out_dir/seqs
align_dir=$out_dir/msa
trim_dir=$out_dir/trim
model_dir=$out_dir/model/mrmodeltest2
tree_dir=$out_dir/tree.29

specimens=(BSZ01 BSZ71 BSZ95 BSZ99 WYS168 WYS209 WYS260 WYS265 WYS273 ON838257 ON943041 OP950228 MZ747091 ON975027 OP950216 OP950220 OP950218 OP950223 ON838255 MW373526 PQ014458 PQ014456 PQ014461 PQ014460 ON099430 MZ150770 MZ261913 MZ981735 MW677959)
genes=(pcg pcgc12 allgene allgenec12)


mkdir -p $out_dir $seq_dir $align_dir $model_dir $tree_dir 


#######MSA
genome=()
for spe in ${specimens[@]}
do
genome[${#genome[@]}]=$mitoseq_dir/${spe}.fasta
done
cat ${genome[@]} > $seq_dir/mito.fasta

# multiple sequence alignment using mafft High accuracy
#mafft --maxiterate 1000 --globalpair --thread 4 $seq_dir/mito.fasta > $align_dir/mito.mafft.fasta


    # remove any space in seq names
#seqkit replace $align_dir/mito.mafft.fasta -p "\s.+" >$trim_dir/mito.notrim.fasta



######## contruct the tree

     # transformat fasta to nexus, perform once only!!!!!!
     # Perfrom once only !!!!
#$alter -i  $trim_dir/mito.notrim.fasta -if FASTA -io Linux -ip MAFFT -o $tree_dir/mito.notrim.nexus -of NEXUS -oo Linux -op MrBayes
#    cp $tree_dir/mito.notrim.nexus $model_dir
     # get mrmodel.scores by PAUP in manual
     # get model by mrmodeltest2
#    mrmodeltest2 < $model_dir/mrmodel.scores.mito.notrim >$model_dir/mrmodeltest2.mito.notrim



# edit the nexus file, and construct a starting tree using MrBayes
cd $tree_dir
    mpirun -np 24 mb mito.notrim.nexus

    # modiry the tree
    Rscript $workdir/scripts/tree_modify.R $tree_dir mito.notrim mito.mafft.nexus.con.tre





