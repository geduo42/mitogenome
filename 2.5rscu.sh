#! /usr/bin
workdir=/home/wwj/project/sc/Microtendipes

basic_dir=$workdir/out/basic
mitoseq_dir=$basic_dir/mitoseq
seq_dir=$basic_dir/seqs_stat
mitos_dir=$workdir/out/annotation/mitos
stats_dir=$basic_dir/stats
cusp_dir=$stats_dir/cusp
cai_dir=$stats_dir/cai
chips_dir=$stats_dir/chips
mkdir -p  $stats_dir $cusp_dir $cai_dir $chips_dir $seq_dir
specimens=(BSZ01 BSZ71 BSZ95 BSZ99 WYS168 WYS209 WYS260 WYS265 WYS273)

for sample in ${specimens[@]}
do
  /home/soft/soft/python/v3.7.17/bin/python3 $workdir/scripts/rscu.py $sample
done



