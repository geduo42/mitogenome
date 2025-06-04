#! /usr/bin
workdir=/home/wwj/working/project/sc/Microtendipes

fq2fa=~/soft/idba-ud/idba-1.1.3/bin/fq2fa
trimmomatic=~/soft/Trimmomatic/v0.39/trimmomatic-0.39.jar
trimadp=~/soft/Trimmomatic/v0.39/adapters
alter=/home/wwj/soft/ALTER/alter-lib/target/ALTER-1.3.4-jar-with-dependencies.jar

assemble_dir=$workdir/out/assemble
fastqc_dir=$assemble_dir/fastqc
multiqc_dir=$assemble_dir/multiqc
idba_dir=$assemble_dir/idba
msa_dir=$assemble_dir/msa
out_dir=$assemble_dir/result
mkdir -p $assemble_dir $fastqc_dir $multiqc_dir $idba_dir $msa_dir $out_dir
#BSZ71 BSZ95 BSZ99 WYS168 WYS209 WYS265

cd $workdir

for sample in BSZ71 BSZ95 WYS168 WYS209 WYS265 BSZ99
do

data_dir=$workdir/data/$sample
fq1=$data_dir/${sample}_1.fq.gz
fq2=$data_dir/${sample}_2.fq.gz

idba_out=$idba_dir/$sample
novoplasty_out=$assemble_dir/$sample
blast_dir=$idba_out/blast
mito_dir=$idba_out/mito
mkdir -p $idba_dir $blast_dir $mito_dir 

##Trim for QC
#java -jar $trimmomatic  PE -threads 4 -phred33 $fq1 $fq2 -baseout $data_dir/${sample}.trimmed.fq.gz ILLUMINACLIP::2:30:10:1:true LEADING:5 TRAILING:5 SLIDINGWINDOW:4:15 MINLEN:36

##fastqc data
#fastqc -o ${fastqc_dir}  -t 4 $fq1 $fq2
#fastqc -o ${fastqc_dir}  -t 4 $data_dir/${sample}.trimmed_1P.fq.gz $data_dir/${sample}.trimmed_2P.fq.gz


##fastq to fasta
#gunzip -c $data_dir/${sample}.trimmed_1P.fq.gz >$data_dir/${sample}.trimmed_1P.fq
#gunzip -c $data_dir/${sample}.trimmed_2P.fq.gz >$data_dir/${sample}.trimmed_2P.fq
#$fq2fa --merge --filter $data_dir/${sample}.trimmed_1P.fq $data_dir/${sample}.trimmed_2P.fq $data_dir/${sample}.trimmed.fasta

## assemble
#idba_hybrid --long_read $data_dir/${sample}.trimmed.fasta --mink 30 --maxk 120 --num_threads 4 --out $idba_out

## get mito
# align with novoplasty's and mitoz's result using blast
#makeblastdb -in $assemble_dir/contig.fa -dbtype nucl -out $blast_dir/db -parse_seqids
novoplasty_res=$out_dir/${sample}.novoplasty.fasta
mitoz_res=$out_dir/${sample}.mitoz.fasta

#blastn -db $blast_dir/db -query $novoplasty_res -out $blast_dir/${sample}.novoplasty.nsn -evalue 1e-2 -outfmt 7

# get mito contigs
Rscript scripts/get_aligned_sequence.R $sample $blast_dir/${sample}.novoplasty.nsn $blast_dir/${sample}.mitoz.nsn $mito_dir

seqkit faidx $idba_out/contig.fa -l $mito_dir/mito.id.txt > $mito_dir/mito.fa

# move mito seqs
seqkit replace $mito_dir/mito.fa -p "^\S+" -r ${sample}_idba >$out_dir/${sample}.idba.fasta.temp
seqkit rename $out_dir/${sample}.idba.fasta.temp >$out_dir/${sample}.idba.fasta
done

rm $out_dir/*temp
#multiqc --outdir $multiqc_dir $fastqc_dir 


