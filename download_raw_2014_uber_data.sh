. config.sh
cat setup_files/raw_2014_uber_data_urls.txt | xargs -n 1 -P 6 wget -c -P $TMP_DATA/
