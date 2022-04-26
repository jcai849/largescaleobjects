library(largescaler)

init_locator("hadoop1", 9000L)
locations <- expand.grid(hostnum=1L:8L, port=9001L:9004L)
hosts <- paste0("hadoop", locations$hostnum)
mapply(init_worker, hosts, locations$port)

Sys.sleep(2)

# options("largerscaleVerbose" = TRUE)

paths <- paste0("taxicab-", sprintf("%02d", 0:31), ".csv")
cols <- c("vendor_id"="character",
	  "pickup_datetime"="POSIXct",
	  "dropoff_datetime"="POSIXct",
	  "passenger_count"="integer",
	  "trip_distance"="numeric",
	  "pickup_longitude"="numeric",
	  "pickup_latitude"="numeric",
	  "rate_code"="integer",
	  "store_and_fwd_flag"="character",
	  "dropoff_longitude"="numeric",
	  "dropoff_latitude"="numeric",
	  "payment_type"="character",
	  "fare_amount"="numeric",
	  "surcharge"="numeric",
	  "mta_tax"="numeric",
	  "tip_amount"="numeric",
	  "tolls_amount"="numeric",
	  "total_amount"="numeric")
taxicab <- read.dcsv(sort(hosts), paths, col.names=names(cols), colClasses=as.vector(cols))

# sum(taxicab$mta_tax)
# passengerRateCode <- table(taxicab$passenger_count, taxicab$rate_code)
# print(passengerRateCode)
