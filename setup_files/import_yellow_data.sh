#!/bin/bash

year_month_regex="tripdata_([0-9]{4})-([0-9]{2})"

yellow_schema_pre_2015="(vendor_id,tpep_pickup_datetime,tpep_dropoff_datetime,passenger_count,trip_distance,pickup_longitude,pickup_latitude,rate_code_id,store_and_fwd_flag,dropoff_longitude,dropoff_latitude,payment_type,fare_amount,extra,mta_tax,tip_amount,tolls_amount,total_amount)"

yellow_schema_2015_2016_h1="(vendor_id,tpep_pickup_datetime,tpep_dropoff_datetime,passenger_count,trip_distance,pickup_longitude,pickup_latitude,rate_code_id,store_and_fwd_flag,dropoff_longitude,dropoff_latitude,payment_type,fare_amount,extra,mta_tax,tip_amount,tolls_amount,improvement_surcharge,total_amount)"

yellow_schema_2016_h2="(vendor_id,tpep_pickup_datetime,tpep_dropoff_datetime,passenger_count,trip_distance,rate_code_id,store_and_fwd_flag,pickup_location_id,dropoff_location_id,payment_type,fare_amount,extra,mta_tax,tip_amount,tolls_amount,improvement_surcharge,total_amount,junk1,junk2)"

yellow_schema_2017_h1="(vendor_id,tpep_pickup_datetime,tpep_dropoff_datetime,passenger_count,trip_distance,rate_code_id,store_and_fwd_flag,pickup_location_id,dropoff_location_id,payment_type,fare_amount,extra,mta_tax,tip_amount,tolls_amount,improvement_surcharge,total_amount)"

# if 2010-02 and 2010-03 yellow files give errors about extra columns, remove offending rows:
./setup_files/remove_bad_rows.sh

for filename in data/yellow_tripdata*.csv; do
  [[ $filename =~ $year_month_regex ]]
  year=${BASH_REMATCH[1]}
  month=$((10#${BASH_REMATCH[2]}))

  if [ $year -lt 2015 ]; then
    schema=$yellow_schema_pre_2015
  elif [ $year -eq 2015 ] || ([ $year -eq 2016 ] && [ $month -lt 7 ]); then
    schema=$yellow_schema_2015_2016_h1
  elif [ $year -eq 2016 ] && [ $month -gt 6 ]; then
    schema=$yellow_schema_2016_h2
  else
    schema=$yellow_schema_2017_h1
  fi

  echo "`date`: beginning load for ${filename}"
  sed $'s/\r$//' $filename | sed '/^$/d' | psql nyc-taxi-data -c "COPY yellow_tripdata_staging ${schema} FROM stdin CSV HEADER;"
  echo "`date`: finished raw load for ${filename}"
  psql nyc-taxi-data -f setup_files/populate_yellow_trips.sql
  echo "`date`: loaded trips for ${filename}"

  rm ${filename}
done;

psql nyc-taxi-data -c "CREATE INDEX ON trips USING BRIN (pickup_datetime) WITH (pages_per_range = 32);"
