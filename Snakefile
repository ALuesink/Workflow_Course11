rule open_file:
	input:
		"Data/Oefen_RNA-Seq-counts.txt"
	output:
		"Data/Oefen_RNA-Seq-IDs.txt"
	shell:
		"python Scripts/Open_Bestand.py"

rule get_PMIDs:
	input:
		"Data/Oefen_RNA-Seq-IDs.txt"
	output:
		"Data/Oefen_PMIDs.txt"
	shell:
		"python Scripts/Get_PMIDs.py {input} {output}"

rule gene_info:
	input:
		"Data/Oefen_PMIDs.txt"
	output:
		"Data/Oefen_Gen_info.txt"
	shell:
		"python Scripts/Gene_info.py {input} {output}"

rule seq_gc:
	input:
		"Data/Oefen_Gen_info.txt"
	output:
		"Data/Oefen_Seq_GC.txt"
	shell:
		"python Scripts/Seq_GC.py {input} {output}"

rule gen_ids:
	input:
		"Data/Oefen_PMIDs.txt"
	output:
		"Data/Oefen_Gen_IDs.txt",
		"Data/Oefen_Uniprot_IDs.txt"
	shell:
		"python Scripts/Gen_IDs.py {input} {output}"

rule uniprot_info:
	input:
		"Data/Oefen_Uniprot_IDs.txt"
	output:
		"Data/Oefen_Uniprot_info.txt"
	shell:
		"bash Scripts/Uniprot_info.sh args[1] < {input} >> {output}"
