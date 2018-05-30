rule open_file:
	input:
		"Data/RNA-Seq-counts.txt"
	output:
		"Data/RNA-Seq-IDs.txt"
	shell:
		"python Scripts/Open_Bestand.py"
