library(largeScaleR)
#init("config-single")
cols <- c("VendorID"="integer","tpep_pickup_datetime"="POSIXct","tpep_dropoff_datetime"="POSIXct","passenger_count"="integer","trip_distance"="numeric","RatecodeID"="integer","store_and_fwd_flag"="character","PULocationID"="integer","DOLocationID"="integer","payment_type"="integer","fare_amount"="numeric","extra"="numeric","mta_tax"="numeric","tip_amount"="numeric","tolls_amount"="numeric","improvement_surcharge"="numeric","total_amount"="numeric","congestion_surcharge"="numeric")
files <- "https://s3.amazonaws.com/nyc-tlc/trip+data/yellow_tripdata_2020-01.csv"
dcsv <- distributedCSV(files, header=T, col.names=names(cols), colClasses=cols)
#x <- read.csv(files, header=TRUE, col.names=names(cols), colClasses=cols)
#https://www1.nyc.gov/site/tlc/about/tlc-trip-record-data.page
