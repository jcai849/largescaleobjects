library(largeScaleR)

# ensure redis-server running on localhost:6379
commsProcess('localhost')
userProcess()
#workerProcess('localhost')
#workerProcess('localhost')
#workerProcess('localhost')

x <- stub(mtcars, 4)

#fileLoc <- tempfile(fileext=".csv")
#data <- data.frame(a=rnorm(1E6), b=rnorm(1E6), c=rnorm(1E6))
#write.csv(data, fileLoc, row.names=FALSE)
#
#x <- read(localCSV(fileLoc), col_types = sapply(data, class), 
#	  max.size=3000074)
#print(x)
#print(x$a + x$b)

# old - to be converted

# chunk1 	<- distObj:::addTestChunk("chunk1", 1:5)
# chunk2 	<- distObj:::addTestChunk("chunk2", 6:10)
# chunk3 	<- distObj:::addTestChunk("chunk3", 11:15)
# chunkA 	<- distObj:::addTestChunk("chunkA", 1:3)
# chunkB 	<- distObj:::addTestChunk("chunkB", 1:5)
# chunkC 	<- distObj:::addTestChunk("chunkC", 9:12)
# chunkD 	<- distObj:::addTestChunk("chunkD", 13:18)
# chunkE 	<- distObj:::addTestChunk("chunkE", 17:19)
# chunkF 	<- distObj:::addTestChunk("chunkF", 3:18)
# chunkG 	<- distObj:::addTestChunk("chunkG", 8:18)
# chunkH 	<- distObj:::addTestChunk("chunkH", 1:38)
# chunkI 	<- distObj:::addTestChunk("chunkI", 2:16)
# chunkJ 	<- distObj:::addTestChunk("chunkJ", 2:15)
# chunkK 	<- distObj:::addTestChunk("chunkK", 1:16)
# chunkL 	<- distObj:::addTestChunk("chunkL", 4:25)
# chunkM 	<- distObj:::addTestChunk("chunkL", 1L)
# chunkN 	<- distObj:::addTestChunk("chunkL", 4L)
# chunkO 	<- distObj:::addTestChunk("chunkO", 3754443:7489749)
# 
# distObj1<- distObj:::makeDistObj(list(chunk1, chunk2, chunk3))
# distObj2<- distObj:::makeDistObj(list(chunkH))
# distObj3<- distObj:::makeDistObj(list(chunkA))
# distObj4<- distObj:::makeDistObj(list(chunkM))
