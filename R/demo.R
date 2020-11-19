beginNZSA2020Demo <- function() {
	require(distObj)

	distInit(osrvPort=9012L,
		 verbose=F,
		 nodeName="N0/Init")

	pid <<- parallel::mclapply(c(1:4, 7:32), function(n) {
		       system(paste("ssh", paste0("hadoop", ((n-1) %/% 4) + 1),
			    shQuote(paste('nohup R -q -e',
					  '"distObj::NZSA2020DemoNode(', n, ')"',
					  paste0('>DOLOG', n), '2>&1 </dev/null &',
					  'echo $!'))),
			      intern = TRUE)
		 })

	rediscc::redis.rm(conn(), c(paste0("fileNameChunk", 1:32),
				    paste0("C", 1:1000), paste0("J", 1:1000)))

	chunks <- lapply(1:32, function(n) 
			 makeTestChunk(name	= paste0("fileNameChunk", n),
				       contents	= paste0("~/flights-chunk-", sprintf("%02d", n), ".csv"),
				       host	= paste0("hadoop", ((n-1) %/% 4) + 1),
				       port	= 9012L+((n-1L)%%4L),
				       from	= n,
				       to	= n
				       ))

	fileNames <<- makeDistObj(chunks)
	
	cols <<- c("Year"="integer","Month"="integer","DayofMonth"="integer",
		   "DayOfWeek"="integer","DepTime"="integer","CRSDepTime"="integer",
		   "ArrTime"="integer","CRSArrTime"="integer",
		   "UniqueCarrier"="character","FlightNum"="integer","TailNum"="character",
		   "ActualElapsedTime"="integer","CRSElapsedTime"="integer",
		   "AirTime"="integer","ArrDelay"="integer", "DepDelay"="integer",
		   "Origin"="character","Dest"="character","Distance"="integer",
		   "TaxiIn"="integer","TaxiOut"="integer", "Cancelled"="integer",
		   "CancellationCode"="character","Diverted"="integer",
		   "CarrierDelay"="integer","WeatherDelay"="integer","NASDelay"="integer",
		   "SecurityDelay"="integer","LateAircraftDelay"="integer")

	NULL
}

NZSA2020DemoNode <- function(n) {
	require(distObj)

	options(error = quote(dump.frames(dumpto = paste0("DO",
						  Sys.getpid(),
						  format(Sys.time(),
							 "-%F-%H-%M-%S")),
					  to.file = TRUE, 
					  include.GlobalEnv = FALSE)))

	distInit(redisHost="hdp",
		 osrvPort=9012L+((n-1L)%%4L),
		 verbose=if (n==5) T else F, 
		 nodeName=paste0("N", n))

	addChunk(paste0("fileNameChunk", n),
		 paste0("~/flights-chunk-", sprintf("%02d", n), ".csv"))

	server()
}
