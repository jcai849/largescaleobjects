library(distObj)

distInit(verbose=T)
chunk1 <- seq(10)
addChunk("chunk1", chunk1)

server()
