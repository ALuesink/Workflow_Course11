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
