# N1

library(distObj)
distInit(osrvPort=9012L, verbose=T)

addChunk("chunk1", 1:5)
addChunk("chunk6", 11:15)

server()
