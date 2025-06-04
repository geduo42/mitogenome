#! /usr/bin
workdir=/home/wwj/working/project/sc/Microtendipes

basic_dir=$workdir/out/basic
mitoseq_dir=$basic_dir/mitoseq
seq_dir=$basic_dir/seqs
mitos_dir=$workdir/out/annotation/mitos
upload_dir=$basic_dir/upload
mkdir -p  $upload_dir 

specimens=(BSZ71 BSZ95 BSZ99 WYS168 WYS209 WYS260 WYS265 WYS273)

for sample in  ${specimens[@]}
do
    # convert gff to gbk
    seqret -sequence $mitoseq_dir/${sample}.fasta -feature  -fformat gff -fopenfile $mitos_dir/$sample/result.gff -osformat genbank -osname_outseq $sample -ofdirectory_outseq gbk_file -auto -outseq $upload_dir/${sample}.gbf

    # convert gbk to tbl
    cd $upload_dir
    perl ~/soft/tools/gbf2tbl.pl ${sample}.gbf
done

# combine to 1 file
cat *.tbl >uplad.tbl

# remove "gene" feature line and the next line
#sed '/gene$/,+1d' uplad.tbl >uplad.nogene.tbl


## another way, using MITOS result

touch $upload_dir/feature_table.tbl
for sample in  ${specimens[@]}
do
    cat $mitos_dir/$sample/result.seq >> $upload_dir/feature_table.tbl
done
