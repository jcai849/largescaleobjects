CLUSTER_TABLE <- new.env()
assign('nodeTable', data.frame(), envir = CLUSTER_TABLE)
assign('chunkTable', data.frame(), envir = CLUSTER_TABLE)
assign('nodeIDCounter', 0L, envir = CLUSTER_TABLE)
assign('chunkIDCounter', 0L, envir = CLUSTER_TABLE)

closeAllConnections <- function(CLUSTER_TABLE) {
	connections <- CLUSTER_TABLE$nodeTable$connection
	if (length(connections) < 1L)
		return()
	lapply(connections, RSclient::RS.close)
}
reg.finalizer(CLUSTER_TABLE, closeAllConnections)

newConnection <- function(hostName) {
	startRServe(hostName)
	connection <- sapply(hostName, RSclient::RS.connect)
	nodeID <- replicate(length(hostName), newNodeID())
	nodeTable <- data.frame(nodeID = nodeID, links = 0L, 
				host = hostName, connection = connection)
	CLUSTER_TABLE$nodeTable <- rbind(CLUSTER_TABLE$nodeTable, nodeTable)
}

newID <- function(type) function() {
	assign(type, get(type, envir = CLUSTER_TABLE) + 1, envir = CLUSTER_TABLE)
	get(type, envir = CLUSTER_TABLE)
}

newNodeID <- newID("nodeIDCounter")
newChunkID <- newID("chunkIDCounter")

getCluster <- function(...) {
	"pass"
}
