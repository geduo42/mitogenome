#! /usr/bin/bash

workdir=~/project/sc/Microtendipes
alter='java -jar /home/soft/soft/ALTER/alter-lib/target/ALTER-1.3.4-jar-with-dependencies.jar'

mitos_dir=$workdir/out/annotation/mitos
mitoseq_dir=$workdir/out/basic/mitoseq
out_dir=$workdir/out/phylogenic30
seq_dir=$out_dir/seqs
align_dir=$out_dir/msa
trim_dir=$out_dir/trim
tree_dir=$out_dir/tree.iqtree
aligroove_dir=$out_dir/aligroove.iqtree

mkdir -p $out_dir $seq_dir $align_dir $tree_dir $aligroove_dir

specimens=(BSZ01 BSZ71 BSZ95 BSZ99 WYS168 WYS209 WYS260 WYS265 WYS273 ON838257 ON943041 OP950228 MZ747091 ON975027 OP950216 OP950220 OP950218 OP950223 ON838255 MW373526 PQ014458 PQ014456 PQ014461 PQ014460 ON099430 MZ150770 MZ261913 MZ981735 MW677959 OL753645)
genes=(pcg pcgc12 allgene allgenec12)


######## contruct the tree

#for gene in allgene  ## for a test run
for gene in pcg pcgc12 pcgR pcgc12R
do
    mkdir -p $tree_dir/$gene
     # transformat fasta to nexus, perform once only!!!!!!
     # Perfrom once only !!!!
   # $alter -i  $trim_dir/${gene}.ape.fasta -if FASTA -io Linux -ip MAFFT -o $tree_dir/$gene/${gene}.mafft.nexus -of NEXUS -oo Linux -op MrBayes

done

######## contruct the tree
for gene in pcg pcgc12 pcgR pcgc12R
do
    cd $tree_dir/$gene
    cp $trim_dir/${gene}.ape.fasta ./
    iqtree2 -s ${gene}.ape.fasta -m MFP  -bb 100000 --prefix $gene  -T 6 -o MW373526

    # modiry the tree
    Rscript $workdir/scripts/tree_modify.R $tree_dir $gene $gene.treefile

    # AliGROOVE
    mkdir -p $aligroove_dir/$gene
    cd $aligroove_dir/$gene
    cp $align_dir/${gene}.mafft.fasta ./
    cp $tree_dir/$gene/$gene.treefile ./
    cp /home/soft/soft/AliGROOCE/v1.08/AliGROOVE_v.1.08.pl ./aligroove.pl
    cp /home/soft/soft/AliGROOCE/v1.08/AliGROOVE_module.pm ./
    cp /home/soft/soft/AliGROOCE/v1.08/SVG.pm ./
    cp /home/soft/soft/AliGROOCE/v1.08/Bio ./ -r
    ./aligroove.pl -i ${gene}.mafft.fasta -z $gene.treefile
    
done



