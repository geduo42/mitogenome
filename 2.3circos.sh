#! /usr/bin
workdir=/home/wwj/project/sc/Microtendipes

cgview=/home/soft/soft/cgview/v2.0.3

basic_dir=$workdir/out/basic
mitoseq_dir=$basic_dir/mitoseq
seq_dir=$basic_dir/seqs
mitos_dir=$workdir/out/annotation/mitos
circos_dir=$basic_dir/circos
annot_dir=$circos_dir/annot
mkdir -p  $circos_dir $annot_dir

specimens=(Puni BSZ01 BSZ71 BSZ95 BSZ99 WYS168 WYS209 WYS260 WYS265 WYS273)
pcg=(nad2 cox1 cox2 atp8 atp6 cox3 nad3 nad5 nad4 nad4l nad6 cob nad1)
rRNA=(rrnL rrnS)
tRNA=(trnA trnC trnD trnE trnF trnG trnG trnI trnK trnL1 trnL2 trnM trnN trnP trnQ trnR trnS1 trnS2 trnT trnV trnW trnY)


for sample in ${specimens[@]}
do
#    Rscript $workdir/scripts/0.23data4cgview.R $sample $mitos_dir $annot_dir
#    perl $cgview/cgview_xml_builder.pl -sequence $mitoseq_dir/${sample}.fasta -gc_skew T -title $sample -size small -tick_density 0.5 -output $annot_dir/${sample}.xml -genes $annot_dir/${sample}.annot.txt -gene_labels T
    java -jar $cgview/cgview.jar -A 50 -D 40 -i $annot_dir/${sample}.xml -I F -o $circos_dir/${sample}.svg -f svg
done





