#!/bin/bash

. config.sh

# load 2014 Uber data into `fhv_trips` table
for filename in $TMP_DATA/uber-raw-data*14.csv; do
  echo "`date`: beginning load for $filename"
  cat $filename | psql nyc-taxi-data -c "SET datestyle = 'ISO, MDY'; COPY uber_trips_2014 (pickup_datetime, pickup_latitude, pickup_longitude, base_code) FROM stdin CSV HEADER;"
  echo "`date`: finished raw load for $filename"
  rm ${filename}
done;

psql nyc-taxi-data -f setup_files/populate_2014_uber_trips.sql
