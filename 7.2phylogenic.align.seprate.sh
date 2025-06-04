#! /usr/bin/bash

# modified from 3.2

workdir=~/project/sc/Microtendipes
alter='java -jar /home/soft/soft/ALTER/alter-lib/target/ALTER-1.3.4-jar-with-dependencies.jar'

mitos_dir=$workdir/out/annotation/mitos
mitoseq_dir=$workdir/out/basic/mitoseq
out_dir=$workdir/out/phylogenic7
seq_dir=$out_dir/seqs
align_dir=$out_dir/msa
tree_dir=$out_dir/tree

mkdir -p $out_dir $seq_dir $align_dir $tree_dir
specimens=(BSZ01 BSZ71 BSZ95 BSZ99 WYS168 WYS209 WYS260 WYS265 WYS273 ON838257 ON943041 OP950228 MZ747091 ON975027 OP950216 OP950220 OP950218 OP950223 ON838255 MW373526 PQ014458 PQ014456 PQ014461 PQ014460 ON099430 MZ150770 MZ261913 MZ981735 MW677959)
genes=(nad2 cox1 cox2 atp8 atp6 cox3 nad3 nad5 nad4 nad4l nad6 cob nad1)

######## Prepare seqs
### For each gene
# split seqs by gene
for sample in  ${specimens[@]}
do
    seqs=$mitos_dir/$sample/result.fas
    seqkit split $seqs --by-id --by-id-prefix ${sample}.simpleID. --id-regexp "^[^\s]+\s[^\s]+\s[^\s]+\s([^\s]+|\s)" --out-dir $seq_dir/$sample
done

rename.ul rrnL_0 rrnL $seq_dir/*/*.rrnL_0.fas
rename.ul nad5_0 nad5 $seq_dir/*/*.nad5_0.fas
rename.ul nad6_0 nad6 $seq_dir/*/*.nad6_0.fas

for gene in nad2 cox1 cox2 atp8 atp6 cox3 nad3 nad5 nad4 nad4l nad6 cob nad1 rrnL rrnS
do
    gene_seq=()
    for sample in  ${specimens[@]}
    do
        seqkit replace $seq_dir/$sample/${sample}.simpleID.${gene}.fas -p ";.+" >$seq_dir/$sample/temp.fas
        seqkit replace $seq_dir/$sample/temp.fas -p "\.1" >$seq_dir/$sample/${sample}.simpleID.${gene}.fas

        gene_seq[${#gene_seq[@]}]=$seq_dir/$sample/${sample}.simpleID.${gene}.fas
    done
    cat ${gene_seq[@]} > $seq_dir/${gene}.fas
done


### For coden1 and coden2 of PCG
for ge in nad2 cox1 cox2 atp8 atp6 cox3 nad3 nad5 nad4 nad4l nad6 cob nad1
do
    c12_seq=()
    for sample in ${specimens[@]}
    do
	seqkit seq $seq_dir/$sample/${sample}.simpleID.${ge}.fas -w 3 > $seq_dir/$sample/${sample}.${ge}.w3.fas
	awk  '{ if(NR > 1)  print substr($1, 1, 2)}' $seq_dir/$sample/${sample}.${ge}.w3.fas >$seq_dir/$sample/${sample}.${ge}.c12.fas
        echo ">${sample}" | cat - $seq_dir/$sample/${sample}.${ge}.c12.fas >$seq_dir/$sample/${sample}.${ge}.c12.fas.temp
        seqkit seq $seq_dir/$sample/${sample}.${ge}.c12.fas.temp -w 60 >$seq_dir/$sample/${sample}.${ge}.c12.fas
        
	c12_seq[${#c12_seq[@]}]=$seq_dir/$sample/${sample}.${ge}.c12.fas
    done
    
    cat ${c12_seq[@]} > $seq_dir/${ge}.c12.fas
    
done


###### Align

for gene in nad2 cox1 cox2 atp8 atp6 cox3 nad3 nad5 nad4 nad4l nad6 cob nad1 rrnL rrnS 
do
    # multiple sequence alignment using mafft High accuracy
    mafft --maxiterate 1000 --globalpair --thread 4 $seq_dir/${gene}.fas > $align_dir/${gene}.mafft.fasta
    $alter -i $align_dir/${gene}.mafft.fasta -if FASTA -io Linux -ip MAFFT -o $align_dir/${gene}.phy -of PHYLIP -oo Linux -os -op ProtTest
done

for gene in nad2 cox1 cox2 atp8 atp6 cox3 nad3 nad5 nad4 nad4l nad6 cob nad1
do
    # multiple sequence alignment using mafft High accuracy
    mafft --maxiterate 1000 --globalpair --thread 4 $seq_dir/${gene}.c12.fas > $align_dir/${gene}.c12.mafft.fasta
    $alter -i $align_dir/${gene}.c12.mafft.fasta -if FASTA -io Linux -ip MAFFT -o $align_dir/${gene}.c12.phy -of PHYLIP -oo Linux -os -op ProtTest

done




