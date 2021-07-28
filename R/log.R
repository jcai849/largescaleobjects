log <- function(...) {
	if (missing(...)) {
		return(nget(self, function(host, port)
		     { ulog.init(paste0("udp://", host, ":", port)) }))
	} else {
		ulog(paste0(...))
	}
}
