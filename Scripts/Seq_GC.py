import sys
from Bio import Entrez
from Bio.SeqUtils import GC

def main():
    file_input = sys.argv[1]
    file_output = sys.argv[2]
    list_genes = openfile(file_input)
    seq_gc(list_genes,file_output)

def openfile(file):
    list_genes = []

    with open(file, "r") as f:
        for line in f:
            if line.startswith("Locus_tag"):
                next
            else:
                line.strip()
                line_split = line.split("\t")
                locus_tag = line_split[0]
                genome = line_split[3]
                start = line_split[4]
                stop = line_split[5]

                list_genes.append([locus_tag,genome,start,stop])
    return list_genes

def seq_gc(list_genes,file):
    Entrez.email = "mail@email.com"
    with open(file, "w+") as outfile:
        outfile.write("Locus_tag \t GC-percentage \t Length \t Sequence \n")
        for gen in list_genes:
            locus_tag = gen[0]
            genome = gen[1]
            start = gen[2]
            stop = gen[3]
            handle = Entrez.efetch(db="nucleotide", id=genome, rettype="fasta", seq_start=start, seq_stop=stop, retmode="xml")
            record = Entrez.read(handle)

            sequence = record[0]['TSeq_sequence']
            gc_perc = GC(sequence)
            gc_perc = format(round(gc_perc,2))

            outfile.write(locus_tag+"\t"+gc_perc+"\t"+str(len(sequence))+"\t"+sequence+"\n")

main()
