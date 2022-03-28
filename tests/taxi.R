library(largescaler)

init_locator("hadoop1", 9000L)
Sys.sleep(2)
init_worker("hadoop2", 9001L)
init_worker("hadoop3", 9001L)
init_worker("hadoop4", 9001L)
init_worker("hadoop5", 9001L)
init_worker("hadoop6", 9001L)
init_worker("hadoop7", 9001L)
init_worker("hadoop8", 9001L)
Sys.sleep(2)

hosts <- rep(paste0("hadoop", 2:8), each=4)
paths <- paste0("taxicab-", sprintf("%02d", 4:31), ".csv")
cols <- c("VendorID"="integer", "tpep_pickup_datetime"="POSIXct",
	  "tpep_dropoff_datetime"="POSIXct", "passenger_count"="integer",
	  "trip_distance"="numeric", "RateCodeID"="integer",
	  "store_and_fwd_flag"="character", "PULocationID"="integer",
	  "DOLocationID"="integer", "payment_type"="integer",
	  "fare_amount"="numeric", "extra"="numeric", "mta_tax"="numeric",
	  "tip_amount"="numeric", "tolls_amount"="numeric",
	  "improvement_surcharge"="numeric", "total_amount"="numeric",
	  "congestion_surcharge"="numeric")
taxicab <- read.dcsv(hosts, paths, col.names=names(cols), colClasses=as.vector(cols))

isCMT <- taxicab$VendorID == 1L
sum(isCMT)

sum(taxicab$tip_amount)

passengerRateCode <- table(CMT$passenger_count, CMT$RateCodeID)
print(passengerRateCode)
