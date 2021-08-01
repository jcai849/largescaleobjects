log <- function(...) {
	if (missing(...)) {
		return(lstore("log", function(host, port)
		     { ulog.init(paste0("udp://", host, ":", port)) }))
	} else {
		ulog(paste0(...))
	}
}
