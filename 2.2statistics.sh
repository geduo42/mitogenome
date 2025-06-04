#! /usr/bin
workdir=/home/wwj/project/sc/Microtendipes

basic_dir=$workdir/out/basic
mitoseq_dir=$basic_dir/mitoseq
seq_dir=$basic_dir/seqs_stat
mitos_dir=$workdir/out/annotation/mitos
stats_dir=$basic_dir/stats
cusp_dir=$stats_dir/cusp
cai_dir=$stats_dir/cai
chips_dir=$stats_dir/chips
mkdir -p  $stats_dir $cusp_dir $cai_dir $chips_dir $seq_dir
specimens=(Punifascium BSZ01 BSZ71 BSZ95 BSZ99 WYS168 WYS209 WYS260 WYS265 WYS273 ON838257 ON943041 OP950228 MZ747091 ON975027 OP950216 OP950220 OP950218 OP950223 ON838255 MW373526)
pcg=(nad2 cox1 cox2 atp8 atp6 cox3 nad3 nad5 nad4 nad4l nad6 cob nad1)
rRNA=(rrnL rrnS)
tRNA=(trnA trnC trnD trnE trnF trnG trnG trnI trnK trnL1 trnL2 trnM trnN trnP trnQ trnR trnS1 trnS2 trnT trnV trnW trnY)

### For whole mito genome
mark=mito
mitoseq=()
for sample in  ${specimens[@]}
do
    mitoseq[${#mitoseq[@]}]=$mitoseq_dir/${sample}.fasta
done

cat ${mitoseq[@]} >$seq_dir/${mark}.fas

seqkit replace $seq_dir/${mark}.fas -p "^\s+.+" >$seq_dir/${mark}.fas.temp
seqkit seq  $seq_dir/${mark}.fas.temp -w 60     >$seq_dir/${mark}.fas

### For protein coding genes
mark=pcg
# split seqs by gene
for sample in  ${specimens[@]}
do
    seqs=$mitos_dir/$sample/result.fas
# rename names of tRNA
    seqkit replace $seqs -p "\(.+" > $seq_dir/temp.fas
    seqkit split $seq_dir/temp.fas --by-id --by-id-prefix ${sample}.simpleID. --id-regexp "^[^\s]+\s[^\s]+\s[^\s]+\s([^\s]+|\s)" --out-dir $seq_dir/$sample
    rm $seq_dir/temp.fas
done

pcg_seq=()
for sample in ${specimens[@]}
do
    mkdir -p $cusp_dir/$sample $cai_dir/$sample $chips_dir/$sample
    gene_seq=()
    for gene in  ${pcg[@]}
    do
    echo OK
        seqkit replace $seq_dir/$sample/${sample}.simpleID.${gene}.fas -p "^.+" -r ${sample}_${mark} >$seq_dir/$sample/temp.fas
        mv $seq_dir/$sample/temp.fas $seq_dir/$sample/${sample}.simpleID.${gene}.fas

        gene_seq[${#gene_seq[@]}]=$seq_dir/$sample/${sample}.simpleID.${gene}.fas

## get coden codon usage table
        cusp -sequence $seq_dir/$sample/${sample}.simpleID.${gene}.fas -outfile $cusp_dir/$sample/${sample}.${gene}.cusp

## compute codon adaptation index (CAI)
        cai -seqall $seq_dir/$sample/${sample}.simpleID.${gene}.fas -cfile $cusp_dir/$sample/${sample}.${gene}.cusp -outfile $cai_dir/$sample/${sample}.${gene}.cai

## compute effective number of coden (ENC)
        chips -seqall $seq_dir/$sample/${sample}.simpleID.${gene}.fas -outfile $chips_dir/$sample/${sample}.${gene}.chips

        ## For codon1 codon2  codon3 and codon12
        seqkit seq $seq_dir/$sample/${sample}.simpleID.${gene}.fas -w 3 > $seq_dir/$sample/${sample}.${gene}.w3.fas

        # For codon1
        awk  '{ if(NR > 1)  print substr($1, 1, 1)}' $seq_dir/$sample/${sample}.${gene}.w3.fas >$seq_dir/$sample/${sample}.${gene}.c1.fas
        echo ">${sample}_$gene" | cat - $seq_dir/$sample/${sample}.${gene}.c1.fas >$seq_dir/$sample/${sample}.${gene}.c1.fas.temp
        seqkit seq $seq_dir/$sample/${sample}.${gene}.c1.fas.temp -w 60 >$seq_dir/$sample/${sample}.${gene}.c1.fas
        # For codon2
        awk  '{ if(NR > 1)  print substr($1, 2, 1)}' $seq_dir/$sample/${sample}.${gene}.w3.fas >$seq_dir/$sample/${sample}.${gene}.c2.fas
        echo ">${sample}_$gene" | cat - $seq_dir/$sample/${sample}.${gene}.c2.fas >$seq_dir/$sample/${sample}.${gene}.c2.fas.temp
        seqkit seq $seq_dir/$sample/${sample}.${gene}.c2.fas.temp -w 60 >$seq_dir/$sample/${sample}.${gene}.c2.fas
        # For codon3
        awk  '{ if(NR > 1)  print substr($1, 3, 1)}' $seq_dir/$sample/${sample}.${gene}.w3.fas >$seq_dir/$sample/${sample}.${gene}.c3.fas
        echo ">${sample}_$gene" | cat - $seq_dir/$sample/${sample}.${gene}.c3.fas >$seq_dir/$sample/${sample}.${gene}.c3.fas.temp
        seqkit seq $seq_dir/$sample/${sample}.${gene}.c3.fas.temp -w 60 >$seq_dir/$sample/${sample}.${gene}.c3.fas
        # For codon12
        awk  '{ if(NR > 1)  print substr($1, 1, 2)}' $seq_dir/$sample/${sample}.${gene}.w3.fas >$seq_dir/$sample/${sample}.${gene}.c12.fas
        echo ">${sample}_$gene" | cat - $seq_dir/$sample/${sample}.${gene}.c12.fas >$seq_dir/$sample/${sample}.${gene}.c12.fas.temp
        seqkit seq $seq_dir/$sample/${sample}.${gene}.c12.fas.temp -w 60 >$seq_dir/$sample/${sample}.${gene}.c12.fas

    done
    seqkit concat ${gene_seq[@]} > $seq_dir/$sample/${sample}.${mark}.fas
    pcg_seq+=($seq_dir/$sample/${sample}.${mark}.fas)
done

cat ${pcg_seq[@]} >$seq_dir/${mark}.fas

cat $seq_dir/*/*.c1.fas >$seq_dir/c1.fas
cat $seq_dir/*/*.c2.fas >$seq_dir/c2.fas
cat $seq_dir/*/*.c3.fas >$seq_dir/c3.fas
cat $seq_dir/*/*.c12.fas >$seq_dir/c12.fas

### For rRNA gene
mark=rRNA

rename.ul rrnL_0 rrnL $seq_dir/*/*.rrnL_0.fas

rRNA_seq=()
for sample in ${specimens[@]}
do
    gene_seq=()
    for gene in  rrnL rrnS
    do
        seqkit replace $seq_dir/$sample/${sample}.simpleID.${gene}.fas -p "^.+" -r ${sample}_${mark} >$seq_dir/$sample/temp.fas
        mv $seq_dir/$sample/temp.fas $seq_dir/$sample/${sample}.simpleID.${gene}.fas

        gene_seq[${#gene_seq[@]}]=$seq_dir/$sample/${sample}.simpleID.${gene}.fas
    done
    seqkit concat ${gene_seq[@]} > $seq_dir/$sample/${sample}.${mark}.fas
    rRNA_seq+=($seq_dir/$sample/${sample}.${mark}.fas)
done

cat ${rRNA_seq[@]} >$seq_dir/${mark}.fas



### For tRNA gene
mark=tRNA
tRNA_seq=()
for sample in ${specimens[@]}
do
    gene_seq=()
    for gene in  ${tRNA[@]}
    do
        seqkit replace $seq_dir/$sample/${sample}.simpleID.${gene}.fas -p "^.+" -r ${sample}_${mark} >$seq_dir/$sample/temp.fas
        mv $seq_dir/$sample/temp.fas $seq_dir/$sample/${sample}.simpleID.${gene}.fas

        gene_seq[${#gene_seq[@]}]=$seq_dir/$sample/${sample}.simpleID.${gene}.fas
    done
    seqkit concat ${gene_seq[@]} > $seq_dir/$sample/${sample}.${mark}.fas
    tRNA_seq+=($seq_dir/$sample/${sample}.${mark}.fas)
done

cat ${tRNA_seq[@]} >$seq_dir/${mark}.fas


### For control region
mark=CR
CR_seq=()
for sample in ${specimens[@]}
do
    start=(`awk /D-loop/ $mitos_dir/$sample/result.seq | cut -f 1`)
    stop=(`awk /D-loop/ $mitos_dir/$sample/result.seq | cut -f 2`)
    for((i=0;i<${#start[@]};i++))
    do
        seqkit subseq $mitoseq_dir/${sample}.fasta -r ${start[i]}:${stop[i]} > $seq_dir/${sample}/${mark}${i}.fas
    done

    seqkit concat $seq_dir/${sample}/${mark}*.fas > $seq_dir/$sample/${sample}.${mark}.fas
    CR_seq+=($seq_dir/$sample/${sample}.${mark}.fas)
done

cat ${CR_seq[@]} >$seq_dir/${mark}.fas


### For each gene
for gene in ${pcg[@]}
do
    cat $seq_dir/*/*.simpleID.${gene}.fas >$seq_dir/${gene}.fas
done


### statistics
for mark in mito pcg rRNA tRNA CR c1 c2 c3 c12 nad2 cox1 cox2 atp8 atp6 cox3 nad3 nad5 nad4 nad4l nad6 cob nad1
do
    seqkit fx2tab $seq_dir/${mark}.fas --name --only-id --length -g -G -B A -B T -B AT --header-line >$stats_dir/${mark}.stats.txt

   sed 's/\#//' $stats_dir/${mark}.stats.txt > $stats_dir/${mark}.stats.txt.temp

    Rscript $workdir/scripts/0.22AT-skew.R -d $stats_dir -m $mark
    Rscript $workdir/scripts/0.22skew.scatterplot.R -d $stats_dir --gene $mark
done
rm  $stats_dir/*.stats.txt.temp

## plot
#for mark in c1 c2 c3 c12 
#do
#    Rscript $workdir/scripts/0.22codon.heatmap.R -d $stats_dir -m $mark
#done

#Rscript $workdir/scripts/0.22cai.scatterplot.R
#Rscript $workdir/scripts/0.22chips.scatterplot.R


