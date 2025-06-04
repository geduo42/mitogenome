#! /usr/bin
workdir=/home/wwj/working/project/sc/Microtendipes

assemble_dir=$workdir/out/assemble
out_dir=$assemble_dir/result
mkdir -p $assemble_dir $out_dir


# BSZ71 BSZ95 BSZ99 WYS168 WYS209 WYS265

for sample in BSZ71 BSZ95 BSZ99 WYS168 WYS209 WYS265 BSZ20
do
data_dir=$workdir/data/$sample
fq1=${sample}_1.fq.gz
fq2=${sample}_2.fq.gz

fq1=${sample}_FDSW210028318-1a_1.clean.fq.gz
fq2=${sample}_FDSW210028318-1a_2.clean.fq.gz

cd $data_dir
#docker run -v $PWD:$PWD -w $PWD --rm guanliangmeng/mitoz:3.4 mitoz all \
    --outprefix $sample \
    --thread_number 4 \
    --clade Arthropoda \
    --genetic_code auto \
    --fq1 $fq1 \
    --fq2 $fq2 \
    --fastq_read_length 150 \
    --data_size_for_mt_assembly 0 \
    --assembler megahit \
    --kmers_megahit 59 79 99 119 141 \
    --memory 44440 \
    --requiring_taxa Arthropoda


seqkit replace $data_dir/${sample}.result/${sample}.megahit.result/${sample}.megahit.mitogenome.fa -p "^\S+" -r ${sample}_mitoz >$out_dir/${sample}.mitoz.fasta
seqkit rename $out_dir/${sample}.mitoz.fasta >$out_dir/${sample}.mitoz.fasta.temp
seqkit faidx $out_dir/${sample}.mitoz.fasta.temp ${sample}_mitoz >$out_dir/${sample}.mitoz.fasta

done

rm $out_dir/*temp*
