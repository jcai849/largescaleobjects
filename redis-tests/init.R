################################### Layout #####################################
##	                                                                      ##
##	distObj1: C1[N1] C2[N2] C3[N3]                                        ##
##	distObj2: C4[N2] C5[N3] C6[N1]                                        ##
##	distObj3: C7[N2]                                                      ##
##      distObj4: C8[N1] C9[N2] C10[N3]                                       ##
##	                                                                      ##
##	 [ N1:9012 ]            [ N2:9013 ]        [ N3:9014 ]                ##
##	+--------------------+ +----------------+ +--------------------+      ##
##	| C1: 1 2 3 4 5      | | C2: 6 7 8 9 10 | | C3: 11 12 13 14 15 |      ##
##	| C6: 11 12 13 14 15 | | C4: 1 2 3 4 5  | | C5: 6 7 8 9 10     |      ##
##	|                    | | C7: 1 2 3      | |                    |      ##
##	| C8: mtcars[1:10,]  | | C9: m[11:20,]  | | C10: m[21:32,]     |      ##
##	+--------------------+ +----------------+ +--------------------+      ##
############################### Fork other nodes ###############################

# N1
invisible(parallel::mcparallel({
	library(distObj)
	distInit(osrvPort=9012L, verbose=T, nodeName="N1")

	addChunk("chunk1", 1:5)
	addChunk("chunk6", 11:15)
	addChunk("chunk8", mtcars[1:10,])

	server()
}))

# N2
invisible(parallel::mcparallel({
	library(distObj)
	distInit(osrvPort=9013L, verbose=T, nodeName="N2")

	addChunk("chunk2", 6:10)
	addChunk("chunk4", 1:5)
	addChunk("chunk7", 1:3)
	addChunk("chunk9", mtcars[11:20,])

	server()
}))

# N3
invisible(parallel::mcparallel({
	library(distObj)
	distInit(osrvPort=9014L, verbose=T, nodeName="N3")

	addChunk("chunk3", 11:15)
	addChunk("chunk5", 6:10)
	addChunk("chunk10", mtcars[21:32,])

	server()
}))

############################### Initialisation #################################
library(distObj)
distInit(verbose=T, osrvPort=9011L, nodeName="N0")
distObj::clear()

# Create new example object
chunk1	<- distObj:::makeTestChunk("chunk1", 1:5, port=9012L)
chunk2	<- distObj:::makeTestChunk("chunk2", 6:10, port=9013L)
chunk3	<- distObj:::makeTestChunk("chunk3", 11:15, port=9014L)
chunk4	<- distObj:::makeTestChunk("chunk4", 1:5, port=9013L)
chunk5	<- distObj:::makeTestChunk("chunk5", 6:10, port=9014L)
chunk6	<- distObj:::makeTestChunk("chunk6", 11:15, port=9012L)
chunk7	<- distObj:::makeTestChunk("chunk7", 1:3, port=9013L)
chunk8	<- distObj:::makeTestChunk("chunk8", mtcars[1:10,],
				  port=9012L, from=1L, to=10L)
chunk9	<- distObj:::makeTestChunk("chunk9", mtcars[11:20,],
				  port=9013L, from=11L, to=20L)
chunk10	<- distObj:::makeTestChunk("chunk10", mtcars[21:32,],
				  port=9014L, from=21L, to=32L)

distObj1 <- distObj:::makeDistObj(list(chunk1, chunk2, chunk3))
distObj2 <- distObj:::makeDistObj(list(chunk4, chunk5, chunk6))
distObj3 <- distObj:::makeDistObj(list(chunk7))
distObj4 <- distObj:::makeDistObj(list(chunk8, chunk9, chunk10))
