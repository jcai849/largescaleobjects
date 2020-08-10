startRServe <- function(hostName) {
	RSconnected <- hostName %in% getCluster("hosts")
	if (all(RSconnected)) return()
	RSrunning <- lapply(paste("ssh", hostName[!RSconnected], 
				  "ps -a | grep RServe"),
			    system)
	if (all(RSrunning)) return()
	lapply(paste("ssh", hostName[!RSconnected][RSrunning],
		     "RServe"),
	       system)
}
