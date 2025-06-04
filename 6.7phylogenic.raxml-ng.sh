#! /usr/bin/bash

# modified from 6.5

workdir=~/project/sc/Microtendipes
alter='java -jar /home/soft/soft/ALTER/alter-lib/target/ALTER-1.3.4-jar-with-dependencies.jar'

mitos_dir=$workdir/out/annotation/mitos
mitoseq_dir=$workdir/out/basic/mitoseq
out_dir=$workdir/out/phylogenic6
seq_dir=$out_dir/seqs
align_dir=$out_dir/msa
trim_dir=$out_dir/trim
model_dir=$out_dir/model
tree_dir=$out_dir/tree.raxml-ng

specimens=(BSZ01 BSZ71 BSZ95 BSZ99 WYS168 WYS209 WYS260 WYS265 WYS273 ON838257 ON943041 OP950228 MZ747091 ON975027 OP950216 OP950220 OP950218 OP950223 ON838255 MW373526 PQ014458 PQ014456 PQ014461 PQ014460 ON099430 MZ150770 MZ261913 MZ981735 MW677959 OL753645)
genes=(pcg pcgc12 allgene allgenec12)


mkdir -p $out_dir $seq_dir $align_dir $model_dir $tree_dir $aligroove_dir


for gene in pcg pcgc12 pcgR pcgc12R
do
    mkdir -p $tree_dir/$gene
    cd $tree_dir/$gene
#    cp $out_dir/tree.raxml/${gene}/${gene}.partition ./

#   edit the partition file

#   check the MSA
#    raxml-ng --check --msa $trim_dir/${gene}.ape.fasta  --model GTR+I+G --prefix check

    # construct the tree using RAxML-ng
#    raxml-ng --all --msa $trim_dir/${gene}.ape.fasta --model GTR+I+G --tree pars{10} --bs-trees 200 --prefix nopar
#    raxml-ng --all --msa $trim_dir/${gene}.ape.fasta --model ${gene}.partition --tree pars{10} --bs-trees 200  --prefix par

    # add extra 400 bootstrap for convergence
    raxml-ng --bootstrap --msa $trim_dir/${gene}.ape.fasta --model GTR+I+G --prefix nopar400 --threads 10 --bs-trees 400
    raxml-ng --bootstrap --msa $trim_dir/${gene}.ape.fasta --model ${gene}.partition --prefix par400 --thread 10 --bs-trees 400
    # check bootstrap convergence
    cat nopar.raxml.bootstraps nopar400.raxml.bootstraps >all.nopar.raxml.bootstraps
    cat par.raxml.bootstraps par400.raxml.bootstraps >all.par.raxml.bootstraps

    raxml-ng --bsconverge --bs-trees all.nopar.raxml.bootstraps --prefix nopar.bs --bs-cutoff 0.01 --threads 10
    raxml-ng --bsconverge --bs-trees all.par.raxml.bootstraps --prefix par.bs --bs-cutoff 0.01 --threads 10 10 10 10 10 10 10 10 10 10 



    # modiry the tree
#    Rscript $workdir/scripts/tree_modify.R $tree_dir ${gene}.par par.raxml.bestTree
#    Rscript $workdir/scripts/tree_modify.R $tree_dir ${gene}.nopar nopar.raxml.bestTree
done


