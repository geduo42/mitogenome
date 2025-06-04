#! /usr/bin/bash

workdir=~/working/project/sc/Microtendipes

alter='java -jar /home/wwj/soft/ALTER/alter-lib/target/ALTER-1.3.4-jar-with-dependencies.jar'
align_dir=$workdir/out/phylogenic/msa

out_dir=$workdir/out/evolution
dnasp_dir=$out_dir/dnasp
kaks_dir=$out_dir/kaks

mkdir -p $out_dir $kaks_dir
specimens=(BSZ01 BSZ20 BSZ71 BSZ95 BSZ99 WYS168 WYS209 WYS260 WYS265 WYS273)
genes=(nad2 cox1 cox2 atp8 atp6 cox3 nad3 nad5 nad4 nad4l nad6 cob nad1)

# DNA polymorphism
Rscript $workdir/scripts/get_DNApolymorphism.R


# KaKs
for gene in ${genes[@]}
do
    ## transformat of align out, fasta to phylip
    $alter -i $align_dir/${gene}.mafft.fasta -if FASTA -io Linux -ip MAFFT -o $align_dir/${gene}.mafft.phylip -of PHYLIP -oo Linux -op jModelTest

    ## 
    AXTConvertor $align_dir/${gene}.mafft.phylip $kaks_dir/${gene}.mafft.axt

    ## kaks 
    KaKs -i $kaks_dir/${gene}.mafft.axt -o $kaks_dir/${gene}.kaks -m NG -c 5
done


