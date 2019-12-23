cat setup_files/raw_data_urls.txt | grep yellow | xargs -n 1 -P 6 wget -c -P data/
