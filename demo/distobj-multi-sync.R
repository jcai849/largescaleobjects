################################### Layout #####################################
##	                                                                      ##
##	distObj1: C1[N1] C2[N2] C3[N3]                                        ##
##	distObj2: C4[N2] C5[N3] C6[N1]                                        ##
##	distObj3: C7[N2]                                                      ##
##	                                                                      ##
##	 [ N1:9012 ]            [ N2:9013 ]        [ N3:9014 ]                ##
##	+--------------------+ +----------------+ +--------------------+      ##
##	| C1: 1 2 3 4 5      | | C2: 6 7 8 9 10 | | C3: 11 12 13 14 15 |      ##
##	| C6: 11 12 13 14 15 | | C4: 1 2 3 4 5  | | C5: 6 7 8 9 10     |      ##
##	+--------------------+ | C7: 1 2 3      | +--------------------+      ##
##	                       +----------------+                             ##
##	                                                                      ##
############################### Fork other nodes ###############################

# N1
invisible(parallel::mcparallel({
	library(distObj)
	distInit(osrvPort=9012L, verbose=T, nodeName="N1")

	addChunk("chunk1", 1:5)
	addChunk("chunk6", 11:15)

	server()
}))

# N2
invisible(parallel::mcparallel({
	library(distObj)
	distInit(osrvPort=9013L, verbose=T, nodeName="N2")

	addChunk("chunk2", 6:10)
	addChunk("chunk4", 1:5)
	addChunk("chunk7", 1:3)

	server()
}))

#N3
invisible(parallel::mcparallel({
	library(distObj)
	distInit(osrvPort=9014L, verbose=T, nodeName="N3")

	addChunk("chunk3", 11:15)
	addChunk("chunk5", 6:10)

	server()
}))

############################### Initialisation #################################
library(distObj)
distInit(verbose=T, osrvPort=9011L, nodeName="N0")
# Clear any previous examples
rediscc::redis.rm(conn(), c(paste0("chunk", 1:20), 
			    paste0("C", 1:100), paste0("J", 1:100),
			    "JOB_ID", "CHUNK_ID"))

# Create new example object
chunk1 <- distObj:::makeTestChunk("chunk1", 1:5, port=9012L)
jobID(chunk1) <- jobID()
chunk2 <- distObj:::makeTestChunk("chunk2", 6:10, port=9013L)
jobID(chunk2) <- jobID()
chunk3 <- distObj:::makeTestChunk("chunk3", 11:15, port=9014L)
jobID(chunk3) <- jobID()
chunk4 <- distObj:::makeTestChunk("chunk4", 1:5, port=9013L)
jobID(chunk4) <- jobID()
chunk5 <- distObj:::makeTestChunk("chunk5", 6:10, port=9014L)
jobID(chunk5) <- jobID()
chunk6 <- distObj:::makeTestChunk("chunk6", 11:15, port=9012L)
jobID(chunk6) <- jobID()
chunk7 <- distObj:::makeTestChunk("chunk7", 1:3, port=9013L)
jobID(chunk7) <- jobID()

distObj1 <- structure(new.env(), class = "distObjRef")
chunk(distObj1) <- list(chunk1, chunk2, chunk3)
distObj2 <- structure(new.env(), class = "distObjRef")
chunk(distObj2) <- list(chunk4, chunk5, chunk6)
distObj3 <- structure(new.env(), class = "distObjRef")
chunk(distObj3) <- list(chunk7)

################################################################################

### univariate function over multiple nodes ###

x <- do.call.distObjRef("expm1", list(distObj1))
resolve(x)
chunk(x)

### multivariate function on aligned objects over multiple nodes ###

y <- do.call.distObjRef("%%", list(x, distObj2))
resolve(y)
chunk(y)

### multivariate function on non-aligned objects over multiple nodes ###

z <- do.call.distObjRef("+", list(y, distObj3))
resolve(z)
chunk(z)
