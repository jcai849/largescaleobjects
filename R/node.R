node <- function(x, ...) {
	UseMethod("node", x)
}

node.numeric <- function(x, ...) {
	replicate(x, node(HOST))
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
