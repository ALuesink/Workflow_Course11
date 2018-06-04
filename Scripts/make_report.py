from snakemake.utils import report
RNA_Seq_IDs = open(input[0])
PMIDs = open(input[1])
Gen_Info = open(input[2])
Seq_GC = open(input[3])
ids = input[0]

report("""
    RNA-seq gene report
    -------------------------------------------------------------------

    {ids}
    
    -------------------------------------------------------------------
    """,output[0])
