#! /usr/bin
workdir=/home/wwj/working/project/sc/Microtendipes

data_dir=$workdir/data
basic_dir=$workdir/out/basic
mitoseq_dir=$basic_dir/mitoseq
seq_dir=$basic_dir/seqs
cox1_dir=$seq_dir/cox1
blast_dir=$cox1_dir/blast
mkdir -p  $cox1_dir

specimens=(BSZ01 BSZ71 BSZ95 BSZ99 WYS168 WYS209 WYS260 WYS265 WYS273)

for sample in ${specimens[@]}
do
cp $seq_dir/${sample}/${sample}.simpleID.cox1.fas $cox1_dir/${sample}.cox1.fas

seqkit subseq $cox1_dir/${sample}.cox1.fas -r 42:699 >$cox1_dir/${sample}.cox1.partial.fas
done
seqkit subseq $cox1_dir/WYS209.cox1.fas -r 45:702 >$cox1_dir/WYS209.cox1.partial.fas

cat $cox1_dir/*.cox1.fas > $cox1_dir/cox1.fas

#makeblastdb -in $seq_dir/mito.fas -dbtype nucl -out $blast_dir/mito -parse_seqids

#blastn -db $blast_dir/mito -query $data_dir/WZWC33.fas -out $blast_dir/cox1.nsn -evalue 1e-2 -outfmt 7



