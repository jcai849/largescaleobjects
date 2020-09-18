library(distObj)
distInit(verbose=T)

addChunk("chunk1", 1:5)
addChunk("chunk2", 6:10)
addChunk("chunk3", 11:15)

server()
