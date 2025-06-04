from Bio import SeqIO
from Bio.Data import CodonTable
import pandas as pd
import codonw
import sys

#sample="BSZ01"
#gene = "atp6"
 
data_dir = '/home/wwj/project/sc/Microtendipes/out/phylogenic6/seqs'
out_dir= '/home/wwj/project/sc/Microtendipes/out/basic/stats/codons'


# translate_table=5, invertebrate mitochondrial code
codes = pd.Series({'UGU':'C', 'UGC':'C', 'GAU':'D', 'GAC':'D', 'UCU':'S', 'UCG':'S', 'UCA':'S', 'UCC':'S', 'AGC':'S', 'AGU':'S', 'CAA':'Q', 'CAG':'Q', 'AUG':'M', 'AAC':'N', 'AAU':'N', 'CCU':'P', 'CCG':'P', 'CCA':'P', 'CCC':'P', 'AAG':'K', 'AAA':'K', 'ACC':'T', 'ACA':'T', 'ACG':'T', 'ACU':'T', 'UUU':'F', 'UUC':'F', 'GCA':'A', 'GCC':'A', 'GCG':'A', 'GCU':'A', 'GGU':'G', 'GGG':'G', 'GGA':'G', 'GGC':'G', 'AUC':'I', 'AUA':'M', 'AUU':'I', 'UUA':'L', 'UUG':'L', 'CUC':'L', 'CUU':'L', 'CUG':'L', 'CUA':'L', 'CAU':'H', 'CAC':'H', 'CGA':'R', 'CGC':'R', 'CGG':'R', 'CGU':'R', 'AGG':'S', 'AGA':'S', 'UGG':'W', 'GUA':'V', 'GUC':'V', 'GUG':'V', 'GUU':'V', 'GAG':'E', 'GAA':'E', 'UAU':'Y', 'UAC':'Y', 'UGA':'W', 'BAD':'X', 'UAA':'*', 'UAG':'*'})

samples = ['BSZ01', 'BSZ71', 'BSZ95', 'BSZ99', 'WYS168', 'WYS209', 'WYS260', 'WYS265', 'WYS273', 'ON838257', 'ON943041', 'OP950228', 'MZ747091', 'ON975027', 'OP950216', 'OP950220', 'OP950218', 'OP950223', 'ON838255', 'MW373526', 'PQ014458', 'PQ014456', 'PQ014461', 'PQ014460', 'ON099430', 'MZ150770', 'MZ261913', 'MZ981735', 'MW677959', 'OL753645']
genes = ['atp6', 'atp8', 'cob', 'cox1', 'cox2', 'cox3', 'nad1', 'nad2', 'nad3', 'nad4', 'nad4l', 'nad5', 'nad6']

df_cai = pd.DataFrame({'sample' : samples})
df_fop = pd.DataFrame({'sample' : samples})
df_cbi = pd.DataFrame({'sample' : samples})
df_enc = pd.DataFrame({'sample' : samples})
df_hyd = pd.DataFrame({'sample' : samples})
df_aro = pd.DataFrame({'sample' : samples})

for gene in genes:
    cai = []
    fop = []
    cbi = []
    enc = []
    hyd = []
    aro = []
    for sample in samples:
        seq = SeqIO.read(data_dir + '/' + sample + '/' + sample + '.simpleID.' + gene +'.fas', 'fasta')
        seqcodon = codonw.CodonSeq(str(seq.seq), genetic_code = 4)
#        seqcodon.genetic_code = codes
        cai.append(seqcodon.cai())
        fop.append(seqcodon.fop())
        cbi.append(seqcodon.cbi())
        enc.append(seqcodon.enc())
        hyd.append(seqcodon.hydropathy())
        aro.append(seqcodon.aromaticity())
    df_cai[gene] = cai
    df_fop[gene] = fop
    df_cbi[gene] = cbi
    df_enc[gene] = enc
    df_hyd[gene] = hyd
    df_aro[gene] = aro 

codon_usage = seqcodon.codon_usage()
aa_usage = seqcodon.aa_usage()
rscu = seqcodon.rscu()
raau = seqcodon.raau()
base_composition = seqcodon.bases2()

df_cai.to_csv(path_or_buf = out_dir + '/' + 'cai.txt', sep = '\t', float_format = '%.2f')
df_fop.to_csv(path_or_buf = out_dir + '/' + 'fop.txt', sep = '\t', float_format = '%.2f')
df_cbi.to_csv(path_or_buf = out_dir + '/' + 'cbi.txt', sep = '\t', float_format = '%.2f')
df_enc.to_csv(path_or_buf = out_dir + '/' + 'enc.txt', sep = '\t', float_format = '%.2f')
df_hyd.to_csv(path_or_buf = out_dir + '/' + 'hydropathy.txt', sep = '\t', float_format = '%.2f')
df_aro.to_csv(path_or_buf = out_dir + '/' + 'aromaticity.txt', sep = '\t', float_format = '%.2f')


data_dir = '/home/wwj/project/sc/Microtendipes/out/phylogenic30/seqs'

df_silent_base_composition = pd.DataFrame(index = ['G3s', 'C3s', 'A3s', 'T3s'])
df_codon_usage = pd.DataFrame(index = codon_usage.index)
df_aa_usage = pd.DataFrame(index = aa_usage.index)
df_rscu = pd.DataFrame(index = rscu.index)
df_raau = pd.DataFrame(index = raau.index)
df_base_composition = pd.DataFrame(index = base_composition.index)

for sample in samples:
    seq = SeqIO.read(data_dir + '/' + sample + '.mito.pcg.fas', 'fasta')
    seqcodon = codonw.CodonSeq(str(seq.seq), genetic_code = 4)
#    seqcodon.genetic_code = codes
    df_silent_base_composition[sample] = seqcodon.silent_base_usage()
    df_codon_usage[sample] = list(seqcodon.codon_usage()['UUU'])
    df_aa_usage[sample] = list(seqcodon.aa_usage()['X'])
    df_rscu[sample] = seqcodon.rscu()
    df_raau[sample] = seqcodon.raau()
    base_composition_by_codon_position = seqcodon.bases()
    base_composition_by_codon_position.to_csv(path_or_buf = out_dir + '/' + sample + '.base_composition_by_codon_position.txt', sep = '\t')
    df_base_composition[sample] = seqcodon.bases2()
    dinucleotide_count = seqcodon.dinuc()
    dinucleotide_count.to_csv(path_or_buf = out_dir + '/' + sample + '.dinucleotide_count.txt', sep = '\t', float_format = '%.2f')


df_silent_base_composition.to_csv(path_or_buf = out_dir + '/' + 'base_composition.txt', sep = '\t', float_format = '%.2f')
df_codon_usage.to_csv(path_or_buf = out_dir + '/' + 'codon_usage.txt', sep = '\t')
df_aa_usage.to_csv(path_or_buf = out_dir + '/' + 'aa_usage.txt', sep = '\t')
df_rscu.to_csv(path_or_buf = out_dir + '/' + 'rscu.txt', sep = '\t', float_format = '%.2f')
df_raau.to_csv(path_or_buf = out_dir + '/' + 'raau.txt', sep = '\t', float_format = '%.3f')
df_base_composition.to_csv(path_or_buf = out_dir + '/' + 'base_composition.txt', sep = '\t', float_format = '%.2f')

