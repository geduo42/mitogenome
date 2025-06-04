#! /usr/bin
workdir=/home/wwj/working/project/sc/Microtendipes
novoplast=~/soft/NOVOPlasty/v_pre4.3.1/NOVOPlasty4.3.1.pl

assemble_dir=$workdir/out/assemble
out_dir=$assemble_dir/result
mkdir -p $assemble_dir $out_dir


cd $workdir/scripts
#BSZ71 BSZ95 BSZ99 WYS168 WYS209 WYS265


for sample in BSZ20 BSZ71 BSZ95 BSZ99 WYS168 WYS209 WYS265
do
data_dir=$workdir/data/$sample
fq1=${sample}_1.fq.gz
fq2=${sample}_2.fq.gz

mkdir -p $assemble_dir/novoplasty/$sample

#perl $novoplast -c ./novoplasty_config/novoplasty_config_${sample}.txt

cp $assemble_dir/novoplasty/$sample/${sample}*.fasta $out_dir/${sample}.novoplasty.fasta.temp
seqkit replace $out_dir/${sample}.novoplasty.fasta.temp -p "\S+" -r "${sample}_novoplasty" >$out_dir/${sample}.novoplasty.fasta

done

rm $out_dir/*.fasta.temp
