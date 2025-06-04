#! /usr/bin
workdir=/home/wwj/working/project/sc/Microtendipes

alter=/home/wwj/soft/ALTER/alter-lib/target/ALTER-1.3.4-jar-with-dependencies.jar

assemble_dir=$workdir/out/assemble
msa_dir=$assemble_dir/msa
spades_dir=$assemble_dir/spades
kmergenie_dir=$assemble_dir/kmergenie
out_dir=$assemble_dir/result
mkdir -p $assemble_dir $msa_dir $spades_dir $kmergenie_dir  $out_dir
#BSZ71 BSZ95 BSZ99 WYS168 WYS209 WYS265


for sample in  BSZ71 BSZ95 BSZ99 WYS168 WYS209 WYS265
do

data_dir=$workdir/data/$sample
fq1=$data_dir/${sample}.trimmed_1P.fq
fq2=$data_dir/${sample}.trimmed_2P.fq
fq3=$data_dir/${sample}.trimmed_1U.fq.gz
fq4=$data_dir/${sample}.trimmed_2U.fq.gz

contigs_dir=$
mkdir -p $kmergenie_dir/$sample $spades_dir/$sample

# estimate genome
echo $fq1 >$kmergenie_dir/$sample/${sample}.list.txt
echo $fq2 >>$kmergenie_dir/$sample/${sample}.list.txt

#kmergenie $kmergenie_dir/$sample/${sample}.list.txt -k 121 -l 31 -s 10 -t 4 -o $kmergenie_dir/$sample/${sample} >$kmergenie_dir/$sample/${sample}.kmergenie.log

# assemble
#zcat $fq3 $fq4 >$data_dir/${sample}.trimmed.single.fq
#gzip -f $data_dir/${sample}.trimmed.single.fq

novoplasty_res=$out_dir/${sample}.novoplasty.fasta
mitoz_res=$out_dir/${sample}.mitoz.fasta
idba_res=$out_dir/${sample}.idba.fasta
spades_res=$out_dir/${sample}.spades.fasta

cat $novoplasty_res $mitoz_res $idba_res >$spades_dir/$sample/${sample}.untrusted.contigs.fasta
spades.py --pe-1 1 $fq1 --pe-2 1 $fq2 --pe-s 1 $data_dir/${sample}.trimmed.single.fq.gz -t 4 -k auto -m 40 --careful --phred-offset 64 -o $spades_dir/$sample  --untrusted-contigs $spades_dir/$sample/${sample}.untrusted.contigs.fasta

# mv results
seqkit faidx $spades_dir/$sample/contigs.fasta NODE_1 --id-regexp "^(\w+_1)_length\S+" >$out_dir/${sample}.spades.fasta.temp
seqkit replace $out_dir/${sample}.spades.fasta.temp -p "^\S+" -r ${sample}_spades >$out_dir/${sample}.spades.fasta


# multi sequence alignment of result of mitoz, novoplasty and spades

cat $novoplasty_res $mitoz_res $spades_res >$msa_dir/${sample}.assemble.fasta
# adjust direction of sequences if reverse complementary exist
mafft-sparsecore.rb -i $msa_dir/${sample}.assemble.fasta -D '--adjustdirection' >$msa_dir/${sample}.assemble.ad.fasta

# mafft High accuracy
mafft --maxiterate 1000 --globalpair --thread 4 $msa_dir/${sample}.assemble.ad.fasta > $msa_dir/${sample}.mafft.fasta

java -jar $alter -i $msa_dir/${sample}.mafft.fasta -if fasta -io Linux -ip MAFFT -o $msa_dir/${sample}.mafft.aln -of ALN -oo Windows -op MEGA

done

rm $out_dir/*spades.fasta.temp


#--pe1-1、--pe1-2:pair-end测序得到的两个文件名，这里我用的是经过trim后的数据。
#-t:线程数(对于CPU密集型的程序，应该使用少一点的线程，对于IO密集型任务，应该使用多一点的线程)。
#-k:kmer选择的值，一般不需要设置，默认的话21,33,55,77，但是对于我的data(水稻)组装结果明显不好，所以我决定以前面kmergenie预测出来的结果为参考设置k值。
#-m:内存。---跑不下去加到跑的下去，不能超。单位为Gb，注:free -m可以查看最大的内存。
#--careful:运行BayesHammer(read纠错)、SPAdes、MismatchCorrector。
#--phred-offset:碱基质量体系，33或64。
#-o:输出文件目录。
#note:spades还有一个优势，如果你有其他组装工具产生的contigs的话可以，可以使用--trusted-contigs或 --untrusted-contigs选项。前者是当获得高质量组装中使用的，这些contigs将用于graph的构建、间隙填补、处理重复序列。第二个选项用于相对不太可靠的contigs，这些contigs用于间隙填补、处理重复序列。
