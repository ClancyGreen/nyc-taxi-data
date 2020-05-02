. config.sh


for type in "${TYPES[@]}"; do
  for (( year=$START; year<=$END; year++ )); do 
    cat setup_files/raw_data_urls.txt | \
        grep $type | \
        grep $year | \
        xargs -n 1 -P 6 wget -c -P $TMP_DATA/
  done
done
