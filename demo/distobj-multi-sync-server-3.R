# N3

library(distObj)
distInit(osrvPort=9014L, verbose=T)

addChunk("chunk3", 11:15)
addChunk("chunk5", 6:10)

server(TRUE)
