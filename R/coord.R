attainNodes <- function(hostNames) {
	hostCount <- table(hostNames)
	hostNames <- names(hostCount)
	currHosts <- getCluster("host", "nodeID")$host
	relevantHosts <- c(currHosts[currHosts %in% hostNames], 
			   hostNames[!hostNames %in% currHosts])
	insufficientConns <- hostCount < table(relevantHosts)
	if (any(insufficientConns)) newConnection(hostNames[insufficientConns])
	finalHosts <- getCluster("host", "nodeID")
	as.vector(sapply(hostNames, function(hostName) 
			 finalHosts[finalHosts$host %in% hostName, "node"][
				     seq(hostCount[hostNames %in% hostName])]))
}
