#! /usr/bin
workdir=/home/wwj/working/project/sc/Microtendipes

alter=/home/wwj/soft/ALTER/alter-lib/target/ALTER-1.3.4-jar-with-dependencies.jar

assemble_dir=$workdir/out/assemble
basic_dir=$workdir/out/basic
mitoseq_dir=$basic_dir/mitoseq
out_dir=$assemble_dir/result
mkdir -p $basic_dir $mitoseq_dir
#BSZ71 BSZ95 BSZ99 WYS168 WYS209 WYS265

seqkit replace -p "^\S+" -r BSZ71 $out_dir/BSZ71.mitoz.fasta >$mitoseq_dir/BSZ71.fasta
seqkit restart -i 200 $mitoseq_dir/BSZ71.fasta >$mitoseq_dir/BSZ71.fasta.rs
seqkit seq -r -p $mitoseq_dir/BSZ71.fasta.rs >$mitoseq_dir/BSZ71.fasta

seqkit replace -p "^\S+" -r BSZ95 $out_dir/BSZ95.mitoz.fasta >$mitoseq_dir/BSZ95.fasta
seqkit seq -r -p $mitoseq_dir/BSZ95.fasta >$mitoseq_dir/BSZ95.fasta.rp
mv $mitoseq_dir/BSZ95.fasta.rp $mitoseq_dir/BSZ95.fasta

seqkit replace -p "^\S+" -r BSZ99 $out_dir/BSZ99.mitoz.fasta >$mitoseq_dir/BSZ99.fasta
seqkit restart -i 1500 $mitoseq_dir/BSZ99.fasta >$mitoseq_dir/BSZ99.fasta.rs
seqkit seq -r -p $mitoseq_dir/BSZ99.fasta.rs >$mitoseq_dir/BSZ99.fasta

seqkit replace -p "^\S+" -r WYS168 $out_dir/WYS168.mitoz.fasta >$mitoseq_dir/WYS168.fasta
seqkit restart -i 6225 $mitoseq_dir/WYS168.fasta >$mitoseq_dir/WYS168.fasta.rs
seqkit seq -r -p $mitoseq_dir/WYS168.fasta.rs >$mitoseq_dir/WYS168.fasta

seqkit replace -p "^\S+" -r WYS209 $out_dir/WYS209.mitoz.fasta >$mitoseq_dir/WYS209.fasta
seqkit restart -i 12000 $mitoseq_dir/WYS209.fasta >$mitoseq_dir/WYS209.fasta.rs
seqkit seq -r -p $mitoseq_dir/WYS209.fasta.rs >$mitoseq_dir/WYS209.fasta

seqkit replace -p "^\S+" -r WYS265 $out_dir/WYS265.mitoz.fasta >$mitoseq_dir/WYS265.fasta



