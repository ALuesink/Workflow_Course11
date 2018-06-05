#!/bin/bash
while IFS=$'\t' read -r -a myArray
do
  # echo $myArray
  id=$"${myArray[1]}"
  lp=$"${myArray[0]}"
  # echo $id
  data=$(curl -s "https://www.uniprot.org/uniprot/${id}.txt")
  GO=$(egrep -o "[FCP]:[0-9a-zA-Z ]*;" <<< "$data" | tr '\n' ' ')
  echo -e "${lp} \t ${GO}"
done


# C: Cellular component, F: Molecular function, P: Biological process
