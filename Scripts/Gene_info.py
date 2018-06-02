import sys
from Bio import Entrez

def main():
    file_input = sys.argv[1]
    file_output = sys.argv[2]
    list_PMIDs = openfile(file_input)
    PMID_connection(list_PMIDs, file_output)

def openfile(file):
    list_PMIDs = []

    with open(file, "r") as f:
        for line in f:
            regel = line.split("\t")
            lp = regel[0]
            id = regel[1].rstrip()
            list_PMIDs.append([lp,id])

    return list_PMIDs

def PMID_connection(list_PMIDs, file):
    Entrez.email = "mail@email.com"

    with open(file, "w+") as outfile:
        outfile.write("Locus_tag \t Gen_naam \t Gen_accessie \t Genoom \t Gen_start \t Gen_stop \t Lijst_PMIDs \n")
        for PMID in list_PMIDs:
            id = PMID[1]
            locus_tag = PMID[0]

            handle = Entrez.efetch(db="gene", id=id, retmode="xml")
            record = Entrez.read(handle)

            genoom = record[0]['Entrezgene_gene-source']['Gene-source']['Gene-source_src-str1']
            gen_naam = record[0]['Entrezgene_locus'][0]['Gene-commentary_products'][0]['Gene-commentary_label']
            gen_accessie = record[0]['Entrezgene_locus'][0]['Gene-commentary_products'][0]['Gene-commentary_accession']
            gen_start = record[0]['Entrezgene_locus'][0]['Gene-commentary_seqs'][0]['Seq-loc_int']['Seq-interval']['Seq-interval_from']
            gen_stop = record[0]['Entrezgene_locus'][0]['Gene-commentary_seqs'][0]['Seq-loc_int']['Seq-interval']['Seq-interval_to']
            gen_refs = record[0]['Entrezgene_locus'][0]['Gene-commentary_products'][0]['Gene-commentary_refs']
            pubmed_refs = []
            for ref in gen_refs:
                ref = ref['Pub_pmid']['PubMedId']
                pubmed_refs.append(ref)

            outfile.write(locus_tag+"\t"+gen_naam+"\t"+gen_accessie+"\t"+genoom+"\t"+gen_start+"\t"+gen_stop+"\t"+str(pubmed_refs)+"\n")






main()
