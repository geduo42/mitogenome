#! /usr/bin/bash
workdir=~/project/sc/Microtendipes

mitos_dir=$workdir/out/annotation/mitos
mitoseq_dir=$workdir/out/basic/mitoseq

reference_dir=/home/soft/reference/mitos
specimens=(ON838257 ON943041 OP950228 MZ747091 ON975027 OP950216 OP950220 OP950218 OP950223 ON838255 MW373526)
specimens=(PQ014458 PQ014456 PQ014461 PQ014460 ON099430 MZ150770 MZ261913 MZ981735 MW677959 OL753645)
export PATH=/home/soft/miniconda3/envs/mitos/bin:$PATH
######## Prepare seqs
#### For whold mito
gene=mito
mitoseq=()
for sample in  ${specimens[@]}
do
    mkdir -p $mitos_dir/$sample
    runmitos.py --input $mitoseq_dir/${sample}.fasta --outdir $mitos_dir/$sample --code 5 --refseqver refseq81m --refdir $reference_dir
    
done

# --code: 2 for vertebrate mitochondrial, 3 for yeast mitochondrial, 4 for Mold, Protozoan and Coelenterate Mitochondrial, 5 for invertebrate Mitochondrial, for details see https://www.ncbi.nlm.nih.gov/Taxonomy/Utils/wprintgc.cgi
# --refseqver: refseq81f, and refseq81m, or refseq81o. The last letter f for Fungi, m for Metazoa, and o for Opistbokonta.



