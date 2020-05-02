#!/bin/bash

. config.sh

mkdir -p $TMP_DATA/unaltered

for (( year=$START; year<=$END; year++ )); do
    if [ $year -eq 2010 ]; then
        mv $TMP_DATA/yellow_tripdata_2010-02.csv $TMP_DATA/yellow_tripdata_2010-03.csv $TMP_DATA/unaltered/

        sed -E '/(.*,){18,}/d' $TMP_DATA/unaltered/yellow_tripdata_2010-02.csv > $TMP_DATA/yellow_tripdata_2010-02.csv
        sed -E '/(.*,){18,}/d' $TMP_DATA/unaltered/yellow_tripdata_2010-03.csv > $TMP_DATA/yellow_tripdata_2010-03.csv
    fi
done
