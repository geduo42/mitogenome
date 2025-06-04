#! /usr/bin/bash

workdir=~/project/sc/Microtendipes
alter='java -jar /home/soft/soft/ALTER/alter-lib/target/ALTER-1.3.4-jar-with-dependencies.jar'

mitos_dir=$workdir/out/annotation/mitos
mitoseq_dir=$workdir/out/basic/mitoseq
out_dir=$workdir/out/phylogenic6
seq_dir=$out_dir/seqs
align_dir=$out_dir/msa
prank_dir=$align_dir/prank
trim_dir=$out_dir/trim
tree_dir=$out_dir/tree

mkdir -p $out_dir $seq_dir $align_dir $prank_dir $trim_dir $tree_dir
specimens=(BSZ01 BSZ71 BSZ95 BSZ99 WYS168 WYS209 WYS260 WYS265 WYS273 ON838257 ON943041 OP950228 MZ747091 ON975027 OP950216 OP950220 OP950218 OP950223 ON838255 MW373526 PQ014458 PQ014456 PQ014461 PQ014460 ON099430 MZ150770 MZ261913 MZ981735 MW677959 OL753645)
genes=(nad2 cox1 cox2 atp8 atp6 cox3 nad3 nad5 nad4 nad4l nad6 cob nad1)


#for gene in nad2 cox1 cox2 atp8 atp6 cox3 nad3 nad5 nad4 nad4l nad6 cob nad1 rrnL rrnS
#do
    # msa using prank
#    prank -d=$seq_dir/${gene}.fas -o=$prank_dir/${gene}.fas -f=phylipi -F
#done


### trim
cp $workdir/out/phylogenic30/msa/atp6.mafft.fasta $trim_dir/atp6.fas
$alter -i $trim_dir/atp6.fas -if FASTA -io Linux -ip MAFFT -o $trim_dir/atp6.phy -of PHYLIP -oo Linux -os -op ProtTest

trimal -in $workdir/out/phylogenic30/msa/atp8.mafft.fasta -out $trim_dir/atp8.fas -selectcols { 0-56,160-171,188-202 }
trimal -in $workdir/out/phylogenic30/msa/atp8.phylip -out $trim_dir/atp8.phy -selectcols { 0-56,160-171,188-202 }

trimal -in $workdir/out/phylogenic30/msa/cob.mafft.fasta -out $trim_dir/cob.fas -selectcols { 925-927 }
trimal -in $workdir/out/phylogenic30/msa/cob.phylip -out $trim_dir/cob.phy -selectcols { 925-927 }

trimal -in $workdir/out/phylogenic30/msa/cox1.mafft.fasta -out $trim_dir/cox1.fas -selectcols { 0-8,1535-1540,1543-1545 }
trimal -in $workdir/out/phylogenic30/msa/cox1.phylip -out $trim_dir/cox1.phy -selectcols { 0-8,1535-1540,1543-1545 }

cp $workdir/out/phylogenic30/msa/cox2.mafft.fasta $trim_dir/cox2.fas
$alter -i $trim_dir/cox2.fas -if FASTA -io Linux -ip MAFFT -o $trim_dir/cox2.phy -of PHYLIP -oo Linux -os -op ProtTest

trimal -in $workdir/out/phylogenic30/msa/cox3.mafft.fasta -out $trim_dir/cox3.fas -selectcols { 785-787 }
trimal -in $workdir/out/phylogenic30/msa/cox3.phylip -out $trim_dir/cox3.phy -selectcols { 785-787 }

trimal -in $workdir/out/phylogenic30/msa/nad1.mafft.fasta -out $trim_dir/nad1.fas -selectcols { 0-8,758-760,941-946 }
trimal -in $workdir/out/phylogenic30/msa/nad1.phylip -out $trim_dir/nad1.phy -selectcols { 0-8,758-760,941-946 }

trimal -in $workdir/out/phylogenic30/msa/nad2.mafft.fasta -out $trim_dir/nad2.fas -selectcols { 0-56,265-270,288-290,717,823-825,945-950,1044-1046 }
trimal -in $workdir/out/phylogenic30/msa/nad2.phylip -out $trim_dir/nad2.phy -selectcols { 0-56,265-270,288-290,717,823-825,945-950,1044-1046 }

cp $workdir/out/phylogenic30/msa/nad3.mafft.fasta $trim_dir/nad3.fas
$alter -i $trim_dir/nad3.fas -if FASTA -io Linux -ip MAFFT -o $trim_dir/nad3.phy -of PHYLIP -oo Linux -os -op ProtTest

trimal -in $workdir/out/phylogenic30/msa/nad4.mafft.fasta -out $trim_dir/nad4.fas -selectcols { 51-56,88-90,108-110,500-505,534-536 }
trimal -in $workdir/out/phylogenic30/msa/nad4.phylip -out $trim_dir/nad4.phy -selectcols { 51-56,88-90,108-110,500-505,534-536 }

trimal -in $workdir/out/phylogenic30/msa/nad4l.mafft.fasta -out $trim_dir/nad4l.fas -selectcols { 27-29 }
trimal -in $workdir/out/phylogenic30/msa/nad4l.phylip -out $trim_dir/nad4l.phy -selectcols { 27-29 }

trimal -in $workdir/out/phylogenic30/msa/nad5.mafft.fasta -out $trim_dir/nad5.fas -selectcols { 3-11,1212-1214,1719-1721 }
trimal -in $workdir/out/phylogenic30/msa/nad5.phylip -out $trim_dir/nad5.phy -selectcols { 3-11,1212-1214,1719-1721 }

trimal -in $workdir/out/phylogenic30/msa/nad6.mafft.fasta -out $trim_dir/nad6.fas -selectcols { 0-2,8-10,273-280,322-325,516-521 }
trimal -in $workdir/out/phylogenic30/msa/nad6.phylip -out $trim_dir/nad6.phy -selectcols { 0-2,8-10,273-280,322-325,516-521 }

trimal -in $workdir/out/phylogenic30/msa/rrnL.mafft.fasta -out $trim_dir/rrnL.fas -gt 0.7 -cons 50
trimal -in $workdir/out/phylogenic30/msa/rrnL.phylip -out $trim_dir/rrnL.phy -gt 0.7 -cons 50

trimal -in $workdir/out/phylogenic30/msa/rrnS.mafft.fasta -out $trim_dir/rrnS.fas -gt 0.7 -cons 60
#trimal -in $workdir/out/phylogenic30/msa/rrnS.phylip -out $trim_dir/rrnS.phy -gt 0.7 -cons 60


