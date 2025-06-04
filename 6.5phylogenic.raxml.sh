#! /usr/bin/bash

workdir=~/project/sc/Microtendipes
alter='java -jar /home/soft/soft/ALTER/alter-lib/target/ALTER-1.3.4-jar-with-dependencies.jar'

mitos_dir=$workdir/out/annotation/mitos
mitoseq_dir=$workdir/out/basic/mitoseq
out_dir=$workdir/out/phylogenic6
seq_dir=$out_dir/seqs
align_dir=$out_dir/msa
trim_dir=$out_dir/trim
model_dir=$out_dir/model
tree_dir=$out_dir/tree.raxml
aligroove_dir=$out_dir/aligroove.mrbayes

specimens=(BSZ01 BSZ71 BSZ95 BSZ99 WYS168 WYS209 WYS260 WYS265 WYS273 ON838257 ON943041 OP950228 MZ747091 ON975027 OP950216 OP950220 OP950218 OP950223 ON838255 MW373526 PQ014458 PQ014456 PQ014461 PQ014460 ON099430 MZ150770 MZ261913 MZ981735 MW677959 OL753645)
genes=(pcg pcgc12 allgene allgenec12)


mkdir -p $out_dir $seq_dir $align_dir $model_dir $tree_dir $aligroove_dir


for gene in pcg pcgc12 pcgR pcgc12R
do
    # construct a starting tree using RAxML
    mkdir -p $tree_dir/$gene
    cd $tree_dir/$gene
#    raxmlHPC-PTHREADS-SSE3 -f a -x 123456 -p 123456  -s $trim_dir/${gene}.ape.fasta -m GTRGAMMA -N 1000 -n ${gene}.ex -k -T 12 -o MW373526
#    raxmlHPC-PTHREADS-SSE3 -f a -x 123456 -p 123456  -s $trim_dir/${gene}.ape.fasta -m GTRGAMMA -N 1000 -n ${gene}.part.ex -k -T 12 -o MW373526 -q ${gene}.partition

    # construct a final tree
    mkdir -p $tree_dir/$gene
    cd $tree_dir/$gene
#    raxmlHPC-PTHREADS-SSE3 -f B -t RAxML_bipartitionsBranchLabels.${gene}.ex -b 12345 -N 1000 -p 12345 -s $trim_dir/${gene}.ape.fasta -m GTRGAMMA -n ${gene}.final.t.ex -k -T 12 -o MW373526


    # modiry the tree
    Rscript $workdir/scripts/tree_modify.R $tree_dir $gene RAxML_bipartitionsBranchLabels.${gene}.ex
    Rscript $workdir/scripts/tree_modify.R $tree_dir ${gene}.part RAxML_bipartitionsBranchLabels.${gene}.part.ex
#    Rscript $workdir/scripts/tree_modify.R $tree_dir ${gene}.f RAxML_bestTree.${gene}.final.t.ex

    # AliGROOVE
    mkdir -p $aligroove_dir/$gene
    cd $aligroove_dir/$gene
    cp $trim_dir/${gene}.ape.fasta ./
    cp $tree_dir/$gene/RAxML_bestTree.${gene}.ex ./
    cp /home/soft/soft/AliGROOCE/v1.08/AliGROOVE_v.1.08.pl ./aligroove.pl
    cp /home/soft/soft/AliGROOCE/v1.08/AliGROOVE_module.pm ./
    cp /home/soft/soft/AliGROOCE/v1.08/SVG.pm ./
    cp /home/soft/soft/AliGROOCE/v1.08/Bio ./ -r
#    ./aligroove.pl -i ${gene}.ape.fasta -z RAxML_bestTree.${gene}.final.t.ex

done


