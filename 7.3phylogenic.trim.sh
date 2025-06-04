#! /usr/bin/bash

# modified from 6.2

workdir=~/project/sc/Microtendipes
alter='java -jar /home/soft/soft/ALTER/alter-lib/target/ALTER-1.3.4-jar-with-dependencies.jar'

mitos_dir=$workdir/out/annotation/mitos
mitoseq_dir=$workdir/out/basic/mitoseq
out_dir=$workdir/out/phylogenic7
seq_dir=$out_dir/seqs
align_dir=$out_dir/msa
trim_dir=$out_dir/trim
tree_dir=$out_dir/tree

mkdir -p $out_dir $seq_dir $align_dir  $trim_dir $tree_dir
specimens=(BSZ01 BSZ71 BSZ95 BSZ99 WYS168 WYS209 WYS260 WYS265 WYS273 ON838257 ON943041 OP950228 MZ747091 ON975027 OP950216 OP950220 OP950218 OP950223 ON838255 MW373526 PQ014458 PQ014456 PQ014461 PQ014460 ON099430 MZ150770 MZ261913 MZ981735 MW677959)
genes=(nad2 cox1 cox2 atp8 atp6 cox3 nad3 nad5 nad4 nad4l nad6 cob nad1 rrnL rrnS)



### trim
cp $workdir/out/phylogenic7/msa/atp6.mafft.fasta $trim_dir/atp6.fas

trimal -in $workdir/out/phylogenic7/msa/atp8.mafft.fasta -out $trim_dir/atp8.fas -selectcols { 0-8,112-117,121-123,140-154 }

cp $workdir/out/phylogenic7/msa/cob.mafft.fasta $trim_dir/cob.fas 

trimal -in $workdir/out/phylogenic7/msa/cox1.mafft.fasta -out $trim_dir/cox1.fas -selectcols { 0-8,1535-1540,1543-1545 }

cp $workdir/out/phylogenic7/msa/cox2.mafft.fasta $trim_dir/cox2.fas

cp $workdir/out/phylogenic7/msa/cox3.mafft.fasta $trim_dir/cox3.fas 

trimal -in $workdir/out/phylogenic7/msa/nad1.mafft.fasta -out $trim_dir/nad1.fas -selectcols { 0-8,938-943 }

trimal -in $workdir/out/phylogenic7/msa/nad2.mafft.fasta -out $trim_dir/nad2.fas -selectcols { 0-56,245-247,265-270,288-290,822-824,944-949,1040-1045 }

cp $workdir/out/phylogenic7/msa/nad3.mafft.fasta $trim_dir/nad3.fas

trimal -in $workdir/out/phylogenic7/msa/nad4.mafft.fasta -out $trim_dir/nad4.fas -selectcols { 82-84,102-104 }

trimal -in $workdir/out/phylogenic7/msa/nad4l.mafft.fasta -out $trim_dir/nad4l.fas -selectcols { 27-29 }

trimal -in $workdir/out/phylogenic7/msa/nad5.mafft.fasta -out $trim_dir/nad5.fas -selectcols { 3-11,1212-1214,1719-1721 }

trimal -in $workdir/out/phylogenic7/msa/nad6.mafft.fasta -out $trim_dir/nad6.fas -selectcols { 0-2,8-10,314-316,507-512 }

trimal -in $workdir/out/phylogenic7/msa/rrnL.mafft.fasta -out $trim_dir/rrnL.fas -gt 0.7 -cons 50

trimal -in $workdir/out/phylogenic7/msa/rrnS.mafft.fasta -out $trim_dir/rrnS.fas -gt 0.7 -cons 60

for gene in nad2 cox1 cox2 atp8 atp6 cox3 nad3 nad5 nad4 nad4l nad6 cob nad1 rrnL rrnS
do
$alter -i $trim_dir/${gene}.fas -if FASTA -io Linux -ip MAFFT -o $trim_dir/${gene}.phy -of PHYLIP -oo Linux -os -op ProtTest
done
