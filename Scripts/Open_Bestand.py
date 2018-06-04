def main():
    openfile()

def openfile():
    lines = []
    ids = []
    with open("Data/Oefen_RNA-Seq-counts.txt", "rb") as f:
        contents = f.readlines()[2:]
    for line in contents:
        regel = str(line.strip(),"utf-8")
        regel = regel.split("\t")
        id = regel[0]
        lines.append(regel)
        ids.append(id)

    with open("Data/Oefen_RNA-Seq-IDs.txt", "w+") as file:
        for id in ids:
            file.write(id + '\n')


main()
