import sys
from Bio import Entrez

def main():
    file_input = sys.argv[1]
    file_output = sys.argv[2]
    list_locus_tags = getLocus_tags(file_input)
    list_PMIDs = getPbMdIDs(list_locus_tags)
    fileOut(list_PMIDs, file_output)

def getLocus_tags(file):
    list_locus_tags = []

    with open(file, "r") as f:
        for line in f:
            list_locus_tags.append(line)

    return list_locus_tags

def getPbMdIDs(list_locus_tags):
    Entrez.email = "mail@mail.com"
    list_PMIDs = []
    for locus_tag in list_locus_tags:
        data = Entrez.esearch(db="gene", term=locus_tag)
        res = Entrez.read(data)
        pmids = res["IdList"][0]
        locus_pmids = [locus_tag, pmids]
        list_PMIDs.append(locus_pmids)

    return list_PMIDs

def fileOut(list_PMIDs, file_output):
    with open(file_output, "w+") as file:
        for locus in list_PMIDs:
            file.write(locus[0].rstrip("\n")+"\t"+locus[1]+"\n")

main()
