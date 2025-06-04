from CAI import RSCU
from Bio import SeqIO
import sys

sample = sys.argv[1]
print(sample)

data_dir = '/home/wwj/project/sc/Microtendipes/out/basic/seqs'
out_dir= '/home/wwj/project/sc/Microtendipes/out/basic/stats/rscu'

# translate_table=5, invertebrate mitochondrial code
c2aa = {
    'TGT':'Cys', 'UGU':'Cys', 'TGC':'Cys', 'UGC':'Cys',
    'AAG':'Lys', 'AAA':'Lys',
    'GAT':'Asp', 'GAU':'Asp', 'GAC':'Asp',
    'TCT':'Ser', 'UCU':'Ser', 'TCG':'Ser', 'UCG':'Ser', 'TCA':'Ser', 'UCA':'Ser', 'TCC':'Ser',
                 'UCC':'Ser', 'AGC':'Ser', 'AGT':'Ser', 'AGU':'Ser', 'AGG':'Ser', 'AGA':'Ser',
    'CAA':'Gln', 'CAG':'Gln',
    'ATG':'Met', 'AUG':'Met', 'ATA':'Met', 'AUA':'Met',
    'AAC':'Asn', 'AAT':'Asn', 'AAU':'Asn',
    'CCT':'Pro', 'CCU':'Pro', 'CCG':'Pro', 'CCA':'Pro', 'CCC':'Pro',
    'ACC':'Thr', 'ACA':'Thr', 'ACG':'Thr', 'ACT':'Thr', 'ACU':'Thr',
    'TTT':'Phe', 'UUU':'Phe', 'TTC':'Phe', 'UUC':'Phe',
    'GCA':'Ala', 'GCC':'Ala', 'GCG':'Ala', 'GCT':'Ala', 'GCU':'Ala',
    'GGT':'Gly', 'GGU':'Gly', 'GGG':'Gly', 'GGA':'Gly', 'GGC':'Gly',
    'ATC':'Ile', 'AUC':'Ile', 'ATT':'Ile', 'AUU':'Ile',
    'TTA':'Leu', 'UUA':'Leu', 'TTG':'Leu', 'UUG':'Leu', 'CTC':'Leu',  'CUC':'Leu',
    'CTT':'Leu', 'CUU':'Leu', 'CTG':'Leu', 'CUG':'Leu', 'CTA':'Leu',  'CUA':'Leu',
    'CAT':'His', 'CAU':'His', 'CAC':'His',
    'CGA':'Arg', 'CGC':'Arg', 'CGG':'Arg', 'CGT':'Arg', 'CGU':'Arg',
    'TGG':'Trp', 'UGG':'Trp', 'UGA':'Trp', 'TGA':'Trp',
    'GTA':'Val', 'GUA':'Val', 'GTC':'Val', 'GUC':'Val', 'GTG':'Val', 'GUG':'Val', 
        'GTT':'Val', 'GUU':'Val',
    'GAG':'Glu', 'GAA':'Glu', 
    'TAT':'Tyr', 'UAU':'Tyr', 'TAC':'Tyr', 'UAC':'Tyr',
    }

seqs = [rec.seq for rec in SeqIO.parse(data_dir + '/' + sample + '/' + sample + '.pcg.fas', 'fasta')]
rscu = RSCU(seqs, genetic_code = 5)

fw = open(out_dir + '/' + sample + '.rscu.txt', 'w')
amino_acid = {}
for aa,bb in rscu.items():
    if c2aa[aa] not in amino_acid:
        amino_acid[c2aa[aa]] = 6
    else:
        amino_acid[c2aa[aa]] -= 0.5
    print(aa,c2aa[aa],round(bb,3),amino_acid[c2aa[aa]])
    fw.write(aa+","+c2aa[aa]+","+str(round(bb,3))+","+str(amino_acid[c2aa[aa]])+"\n")

fw.close()


