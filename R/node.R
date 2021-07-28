node <- function(x, ...) {
	if (missing(x)) {
		return(ncget("self", start))
	} else UseMethod("node", x)
}

node.numeric <- function(x, ...) {
	replicate(x, node(HOST, port()))
}

node.character <- function(x, p=port()) {
	command <- c("R", "-e",
                     paste0("largeScaleR::worker(",
                            "host=", deparse(x),
                            ",port=", deparse(p),
			    ",msghost=", deparse(host(msg())),
			    ",msgport=", deparse(port(msg())),
                            ",loghost=", deparse(host(log())),
                            ",logport=", deparse(port(log())),
			    ")", collapse=""))
	system2("ssh", c(x, shQuote(shQuote(command))),
		stdout=FALSE, stderr=FALSE, wait=FALSE)
}
