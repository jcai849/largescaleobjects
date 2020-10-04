# N2

library(distObj)
distInit(osrvPort=9013L, verbose=T, nodeName="N2")

addChunk("chunk2", 6:10)
addChunk("chunk4", 1:5)
addChunk("chunk7", 1:3)

server()
