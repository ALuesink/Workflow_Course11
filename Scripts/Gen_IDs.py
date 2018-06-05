import sys
from Bio import Entrez

def main():
    file_input = sys.argv[1]
    file_output1 = sys.argv[2]
    file_output2 = sys.argv[3]
    list_PMIDs = openfile(file_input)
    gen_IDs(list_PMIDs, file_output1, file_output2)

def openfile(file):
    list_PMIDs = []

    with open(file, "r") as f:
        for line in f:
            regel = line.split("\t")
            lp = regel[0]
            id = regel[1].rstrip()
            list_PMIDs.append([lp,id])
    return list_PMIDs

def gen_IDs(list_PMIDs,file1, file2):
    Entrez.email = "mail@email.com"

    with open(file1, "w+") as outfile:
        with open(file2, "w+") as GO_outfile:
            outfile.write("Locus_tag \t Databases: IDs \n")
            for PMID in list_PMIDs:
                db_id = {}
                id = PMID[1]
                locus_tag = PMID[0]

                handle = Entrez.efetch(db="gene", id=id, retmode="xml")
                record = Entrez.read(handle)

                gen_ids = record[0]['Entrezgene_locus'][0]['Gene-commentary_products'][0]['Gene-commentary_source']
                gen_pmids = record[0]['Entrezgene_locus'][0]['Gene-commentary_products'][0]['Gene-commentary_refs']

                for ref in gen_ids:
                    db = ref['Other-source_src']['Dbtag']['Dbtag_db']
                    id = ref['Other-source_src']['Dbtag']['Dbtag_tag']['Object-id']['Object-id_str']
                    if db not in db_id:
                        db_id[db] = [id]
                    else:
                        list_ids = db_id[db]
                        list_ids.append(id)
                        db_id[db] = list_ids

                outfile.write(locus_tag+"\t"+str(db_id)+"\n")
                if 'GOA' in db_id:
                    GO_outfile.write(locus_tag+"\t"+db_id['GOA'][0]+"\n")


main()
