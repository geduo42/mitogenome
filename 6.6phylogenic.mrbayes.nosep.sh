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
tree_dir=$out_dir/tree.mrbayes.nosep
aligroove_dir=$out_dir/aligroove.mrbayes.nosep

specimens=(BSZ01 BSZ71 BSZ95 BSZ99 WYS168 WYS209 WYS260 WYS265 WYS273 ON838257 ON943041 OP950228 MZ747091 ON975027 OP950216 OP950220 OP950218 OP950223 ON838255 MW373526 PQ014458 PQ014456 PQ014461 PQ014460 ON099430 MZ150770 MZ261913 MZ981735 MW677959 OL753645)
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
#    cp $tree_dir/$gene/${gene}.mafft.nexus $model_dir
     # get mrmodel.scores by PAUP in manual
     # get model by mrmodeltest2
#    mrmodeltest2 < $model_dir/mrmodel.scores.${gene} >$model_dir/mrmodeltest2.${gene}
done



# edit the nexus file, and construct a starting tree using MrBayes

for gene in pcg pcgc12 pcgR pcgc12R
do
    cd $tree_dir/$gene
#    mpirun -np 24 mb ${gene}.mafft.nexus

    # modiry the tree
#    Rscript $workdir/scripts/tree_modify.R $tree_dir $gene ${gene}.mafft.nexus.con.tre

    # AliGROOVE
    mkdir -p $aligroove_dir/$gene
    cd $aligroove_dir/$gene

#    cp $trim_dir/${gene}.ape.fasta ./
    cp /home/soft/soft/AliGROOCE/v1.08/AliGROOVE_v.1.08.pl ./aligroove.pl
    cp /home/soft/soft/AliGROOCE/v1.08/AliGROOVE_module.pm ./
    cp /home/soft/soft/AliGROOCE/v1.08/SVG.pm ./
    cp /home/soft/soft/AliGROOCE/v1.08/Bio ./ -r
   
    bioconvert nexus2newick $tree_dir/$gene/${gene}.mafft.nexus.con.tre ./${gene}.mafft.nexus.con.tre.newick
    ./aligroove.pl -i ${gene}.ape.fasta -z ${gene}.mafft.nexus.con.tre.newick


done



