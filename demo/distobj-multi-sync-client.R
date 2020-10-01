################################### Layout #####################################
##	                                                                      ##
##	distObj1: C1[N1] C2[N2] C3[N3]                                        ##
##	distObj2: C4[N2] C5[N3] C6[N1]                                        ##
##	distObj3: C7[N2]                                                      ##
##	                                                                      ##
##	 [ N1 ]                 [ N2 ]             [ N3 ]                     ##
##	+--------------------+ +----------------+ +--------------------+      ##
##	| C1: 1 2 3 4 5      | | C2: 6 7 8 9 10 | | C3: 11 12 13 14 15 |      ##
##	| C6: 11 12 13 14 15 | | C4: 1 2 3 4 5  | | C5: 6 7 8 9 10     |      ##
##	+--------------------+ | C7: 1 2 3      | +--------------------+      ##
##	                       +----------------+                             ##
##	                                                                      ##
############################### Initialisation #################################

library(distObj)
distInit(verbose=T)
# Clear any previous examples
rediscc::redis.rm(conn(), c(paste0("chunk", 1:3), 
			    paste0("C", 1:20), paste0("J", 1:20),
			    "JOB_ID", "CHUNK_ID"))
# Create new example object
chunk1 <- distObj:::makeTestChunk("chunk1", 1:5, port=)
jobID(chunk1) <- jobID()
chunk2 <- distObj:::makeTestChunk("chunk2", 6:10)
jobID(chunk2) <- jobID()
chunk3 <- distObj:::makeTestChunk("chunk3", 11:15)
jobID(chunk3) <- jobID()
chunk4 <- distObj:::makeTestChunk("chunk4", 1:5)
jobID(chunk4) <- jobID()
chunk5 <- distObj:::makeTestChunk("chunk5", 6:10)
jobID(chunk5) <- jobID()
chunk6 <- distObj:::makeTestChunk("chunk6", 11:15)
jobID(chunk6) <- jobID()
chunk7 <- distObj:::makeTestChunk("chunk7", 1:3)
jobID(chunk7) <- jobID()

distObj1 <- structure(new.env(), class = "distObjRef")
chunk(distObj1) <- list(chunk1, chunk2, chunk3)
distObj2 <- structure(new.env(), class = "distObjRef")
chunk(distObj1) <- list(chunk4, chunk5, chunk6)
distObj3 <- structure(new.env(), class = "distObjRef")
chunk(distObj1) <- list(chunk7)

################################################################################

### univariate function over multiple nodes ###

x <- do.call.distObjRef("expm1", list(distObj1))
resolve(x)

### multivariate function on aligned objects over multiple nodes ###

y <- do.call.distObjRef("%%", list(x, distObj2))
resolve(y)

### multivariate function on non-aligned objects over multiple nodes ###

z <- do.call.distObjRef("+", list(y, distObj3))
resolve(z)
