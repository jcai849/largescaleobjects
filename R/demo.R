beginNZSA2020Demo <- function() {
	require(distObj)

	distInit(osrvPort=9012L,
		 verbose=T,
		 nodeName="N0/Init")

	pid <<- lapply(1:32, function(n) {
		       system(paste("ssh", paste0("hadoop", ((n-1) %/% 4) + 1),
				    shQuote(paste('nohup R -q -e',
						  '"distObj::NZSA2020DemoNode(', n, ')"',
						  '>.DOLOG 2>&1 </dev/null &',
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
	NULL
}

endNZSA2020Demo <- function(pid) {
	lapply(1:32, function(n) {
		       system(paste("ssh", paste0("hadoop", ((n-1) %/% 4) + 1),
				    "kill", pid[[n]]))
		 })

	rediscc::redis.rm(conn(), c(paste0("fileNameChunk", 1:32),
				    paste0("C", 1:1000), paste0("J", 1:1000)))
	NULL
}

NZSA2020DemoNode <- function(n) {
	require(distObj)

	distInit(redisHost="hdp",
		 osrvPort=9012L+((n-1L)%%4L),
		 verbose=T, 
		 nodeName=paste0("N", n))

	addChunk(paste0("fileNameChunk", n),
		 paste0("~/flights-chunk-", sprintf("%02d", n), ".csv"))

	server()
}
