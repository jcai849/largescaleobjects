#https://www1.nyc.gov/site/tlc/about/tlc-trip-record-data.page

library(largeScaleR)
init("config")
files <- apply(expand.grid("https://s3.amazonaws.com/nyc-tlc/trip+data/yellow_tripdata_20",
			  formatC(9:20, width=2,flag=0), "-", formatC(1:12, width=2, flag=0), 
			  ".csv"),
	      1, paste0, collapse="")
cols <- c("VendorID"="integer","tpep_pickup_datetime"="POSIXct","tpep_dropoff_datetime"="POSIXct","passenger_count"="integer","trip_distance"="numeric","RateCodeID"="integer","store_and_fwd_flag"="character","PULocationID"="integer","DOLocationID"="integer","payment_type"="integer","fare_amount"="numeric","extra"="numeric","mta_tax"="numeric","tip_amount"="numeric","tolls_amount"="numeric","improvement_surcharge"="numeric","total_amount"="numeric","congestion_surcharge"="numeric")

taxi.dcsv <- distributedCSV(files[143:144], header=T, col.names=names(cols), colClasses=as.vector(cols))
taxicab <- read(taxi.dcsv)
print(taxicab)
preview(taxicab)
nrow(taxicab)
desc(taxicab)
host(taxicab)

isCMT <- taxicab$VendorID == 1L
print(isCMT)
preview(isCMT)
sum(isCMT)
CMT <- subset(taxicab, isCMT)
length(CMT)

passengerLoc <- table(CMT$passenger_count, CMT$RateCodeID)
print(passengerLoc)
