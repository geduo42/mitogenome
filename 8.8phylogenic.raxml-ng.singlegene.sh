#! /usr/bin/bash

# modified from 6.5

workdir=~/project/sc/Microtendipes
alter='java -jar /home/soft/soft/ALTER/alter-lib/target/ALTER-1.3.4-jar-with-dependencies.jar'

mitos_dir=$workdir/out/annotation/mitos
mitoseq_dir=$workdir/out/basic/mitoseq
out_dir=$workdir/out/phylogenic8
seq_dir=$out_dir/seqs
align_dir=$out_dir/msa
trim_dir=$out_dir/trim
model_dir=$out_dir/model
tree_dir=$out_dir/tree.singlegene

specimens=(BSZ01 BSZ71 BSZ95 BSZ99 WYS168 WYS209 WYS260 WYS265 WYS273 ON838257 ON943041 OP950228 MZ747091 ON975027 OP950216 OP950220 OP950218 OP950223 ON838255 MW373526 PQ014458 PQ014456 PQ014461 PQ014460 ON099430 MZ150770 MZ261913 MZ981735 MW677959 OL753645)
genes=(atp6 atp8 cob cox1 cox2 cox3 nad1 nad2 nad3 nad4 nad4l nad5 nad6)

mkdir -p $out_dir $seq_dir $align_dir $model_dir $tree_dir 

for gene in ${genes[@]}
do
#    $alter -i  $trim_dir/${gene}.fas -if FASTA -io Linux -ip MAFFT -o $model_dir/${gene}.mafft.nexus -of NEXUS -oo Linux -op MrBayes
     # get mrmodel.scores by PAUP in manual
     # get model by mrmodeltest2
#    mrmodeltest2 < $model_dir/mrmodeltest2/mrmodel.scores.${gene} >$model_dir/mrmodeltest2/mrmodeltest2.${gene}

# model select has done, just copy

#    cp $workdir/out/phylogenic6/model/mrmodeltest2/mrmodeltest2.${gene} $model_dir


    mkdir -p $tree_dir/$gene
    cd $tree_dir/$gene


#  check the MSA
#    raxml-ng --check --msa $trim_dir/${gene}.fas  --model GTR+I+G --prefix check

    # construct the tree using RAxML-ng
    raxml-ng --all --msa $trim_dir/${gene}.fas --model GTR+I+G --tree pars{25},rand{25} --bs-trees 1000 --bs-metric fbp,tbe --prefix gtrIG
    raxml-ng --bsconverge --bs-trees gtrIG.raxml.bootstraps --prefix gtrIG.bs --bs-cutoff 0.01
    # modiry the tree
    Rscript $workdir/scripts/tree_modify.R $tree_dir ${gene}.gtrIG  gtrIG.raxml.bestTree

done

for gene in atp6 nad4l
do
    cd $tree_dir/$gene
    raxml-ng --all --msa $trim_dir/${gene}.fas --model GTR+G --tree pars{25},rand{25} --bs-trees 1000 --bs-metric fbp,tbe --prefix gtrG
    raxml-ng --bsconverge --bs-trees gtrG.raxml.bootstraps --prefix gtrG.bs --bs-cutoff 0.01
    Rscript $workdir/scripts/tree_modify.R $tree_dir ${gene}.gtrG  gtrG.raxml.bestTree
done


for gene in atp8
do
    cd $tree_dir/$gene
    raxml-ng --all --msa $trim_dir/${gene}.fas --model HKY+G --tree pars{25},rand{25} --bs-trees 1000 --bs-metric fbp,tbe --prefix hkyG
    raxml-ng --bsconverge --bs-trees hkyG.raxml.bootstraps --prefix hkyG.bs --bs-cutoff 0.01
    Rscript $workdir/scripts/tree_modify.R $tree_dir ${gene}.hkyG  hkyG.raxml.bestTree
done
