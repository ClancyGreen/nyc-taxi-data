#!/usr/bin/env bash


## init db
#./initialize_database.sh


## get small files
#./setup_files/download_raw_2014_uber_data.sh
#./setup_files/download_raw_fhv.sh
#./setup_files/download_raw_green.sh


#./setup_files/import_2014_uber_trip_data.sh
#./setup_files/import_fhv_trip_data.sh
#./setup_files/import_green_data.sh


## get yellow files
./setup_files/download_raw_yellow.sh
./setup_files/import_yellow_data.sh
