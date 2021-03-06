rule all:
	input: "report.html"

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

rule visualise:
	input:
		"Data/Oefen_Seq_GC.txt"
	output:
		"Data/out.png"
	shell:
		"Rscript Scripts/visualise.R {input} {output}"

rule report:
	input:
		"Data/Oefen_RNA-Seq-IDs.txt",
		"Data/Oefen_PMIDs.txt",
		"Data/Oefen_Gen_info.txt",
		"Data/Oefen_Seq_GC.txt",
		"Data/Oefen_Gen_IDs.txt",
		"Data/Oefen_Uniprot_info.txt",
		"Data/Oefen_Uniprot_IDs.txt",
		"Data/out.png"

	output:
		"report.html"
	run:
		from snakemake.utils import report

		def main():
			# Alle bestanden die zijn gemaakt bij het runnen van de rules.
			# Deze zijn vervolgens gelezen met de functie read_files

			RNA_Seq_IDs_raw = input[0]
			PMIDs_raw = input[1]
			Gen_Info_raw = input[2]
			Seq_GC_raw = input[3]
			Gen_IDs_file_raw = input[4]
			Uniprot_info_raw = input[5]
			Uniprot_IDs_raw = input[6]
			visualise_gc = input[7]

			# In de functie read_files worden *zeven* bestanden gelezen en in lijsten
			# gezet zodat vervolgens alle belangrijke informatie er eenvoudig uitgehaald kan worden
			RNA_Seq_IDs, PMIDs, Gen_Info, Seq_GC, Gen_IDs_file, Uniprot_info, Uniprot_IDs = read_files(RNA_Seq_IDs_raw, PMIDs_raw, Gen_Info_raw, Seq_GC_raw, Gen_IDs_file_raw, Uniprot_info_raw, Uniprot_IDs_raw)

			# Alle benodigde informatie over de genen wordt opgehaald en in
			# lijsten gezet met de onderstaande functies
			ids_RNA_Seq = get_RNA_Seq_IDs(RNA_Seq_IDs)
			ids_pm = get_PMIDs(PMIDs)
			gene_name = get_Gene_Name(Gen_Info)
			GCper, seq = get_GC_Seq(Seq_GC)
			uniprot_ids = get_uniprot_ids(Uniprot_IDs)

			# Hieronder wordt een variabele aangemaakt die de inhoud van het
			# report bevat. Met de functie make_report wordt het report bestand vervolgens gemaakt
			report_data = get_report_data(ids_RNA_Seq, ids_pm, uniprot_ids, gene_name, GCper, seq, visualise_gc)
		 	make_report(report_data, visualise_gc)


		def read_files(RNA_Seq_IDs_raw, PMIDs_raw, Gen_Info_raw, Seq_GC_raw, Gen_IDs_file_raw, Uniprot_info_raw, Uniprot_IDs_raw):
			PMIDs = []
			with open(PMIDs_raw, "rb") as f:
				contents = f.readlines()
			for line in contents:
				regel = str(line.strip(),"utf-8")
				regel = regel.split("\t")
				PMIDs.append(regel)
			f.close()

			Seq_GC = []
			with open(Seq_GC_raw, "rb") as f:
				contents = f.readlines()
			for line in contents:
				regel = str(line.strip(),"utf-8")
				regel = regel.split("\t")
				Seq_GC.append(regel)
			f.close()

			Gen_Info = []
			with open(Gen_Info_raw, "rb") as f:
				contents = f.readlines()
			for line in contents:
				regel = str(line.strip(),"utf-8")
				regel = regel.split("\t")
				Gen_Info.append(regel)
			f.close()

			RNA_Seq_IDs = []
			with open(RNA_Seq_IDs_raw, "rb") as f:
				contents = f.readlines()
			for line in contents:
				regel = str(line.strip(),"utf-8")
				regel = regel.split("\t")
				RNA_Seq_IDs.append(regel)
			f.close()

			Gen_IDs_file = []
			with open(Gen_IDs_file_raw, "rb") as f:
				contents = f.readlines()
			for line in contents:
				regel = str(line.strip(),"utf-8")
				regel = regel.split("\t")
				Gen_IDs_file.append(regel)
			f.close()

			Uniprot_info = []
			with open(Uniprot_info_raw, "rb") as f:
				contents = f.readlines()
			for line in contents:
				regel = str(line.strip(),"utf-8")
				regel = regel.split("\t")
				Uniprot_info.append(regel)
			f.close()

			Uniprot_IDs = []
			with open(Uniprot_IDs_raw, "rb") as f:
				contents = f.readlines()
			for line in contents:
				regel = str(line.strip(),"utf-8")
				regel = regel.split("\t")
				Uniprot_IDs.append(regel)
			f.close()

			return RNA_Seq_IDs, PMIDs, Gen_Info, Seq_GC, Gen_IDs_file, Uniprot_info, Uniprot_IDs

		def get_RNA_Seq_IDs(RNA_Seq_IDs):
			ids_RNA_Seq = []
			for i in RNA_Seq_IDs:
				count = 1
				for item in i:
					count += 1
					if count == 2:
						ids_RNA_Seq.append(item)
			return ids_RNA_Seq

		def get_PMIDs(PMIDs):
			ids_pm = []
			for i in PMIDs:
				count = 1
				for item in i:
					count += 1
					if count % 2:
						ids_pm.append(item)
			return ids_pm


		def get_Gene_Name(Gen_Info):
			gene_name = []
			gene_info = iter(Gen_Info)
			next(gene_info)
			for i in gene_info:
				gene_name.append(i[1])
			return gene_name


		def get_GC_Seq(Seq_GC):
			seq = []
			GCper = []
			seq_info = iter(Seq_GC)
			next(seq_info)
			for i in seq_info:
				y = re.sub("(.{64})", "\\1\n", i[3], 0)
				seq.append(y+"\n"+"\n"+"------------------------------------------------------")
				GCper.append(i[1])
			return GCper, seq


		def get_uniprot_ids(Uniprot_IDs):
			uniprot_ids = []
			for i in Uniprot_IDs:
				uniprot_ids.append(i[1])
				# print(i[1])
			return uniprot_ids


		# Het creëren van de data die in het report komt te staan.
		def get_report_data(ids_RNA_Seq, ids_pm, uniprot_ids, gene_name, GCper, seq, image):
			report_data = []
			for i in range(len(uniprot_ids)):
				report_line =  "\n" + "**Gene Name:**" + "\t\t" + ids_RNA_Seq[i] + "\n" + "\n" + "**Pubmed ID:**" + "\t\t" + ids_pm[i] + "\n"+ "\n" + "**Uniprot ID:**" + "\t\t" + uniprot_ids[i] + "\n"+ "\n" + "**Gene Description:**" + "\t\t" + gene_name[i] + "\n"+ "\n" + "**GC percentage:**" + "\t" + GCper[i] + "\n"+ "\n" + "**Sequence:**" + "\n" + "\n" + seq[i] + "\n"
				report_data.append(report_line)
			return report_data



		# Het maken van het report.html bestand. Hierin is alle significante
		# informatie over de genen te vinden
		def make_report(report_data, visualise_gc):
			
			report(
			"""
			===================
			RNA-seq gene report
			===================
			lactobacillus plantarum
			---------------------------------------
			.. image:: {visualise_gc}
			{report_data}
		    	""", output[0], metadata = "Made by Michelle Stegeman, Anne Luesink and Sanne Geraets")

		main()
