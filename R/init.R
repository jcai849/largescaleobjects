init_locator <- function(host, port) {
	largescalechunks::LOCATOR(host, port)
	remote_sys(host, "largescalechunks::locator_node", list(host, port))
}

init_worker <- function(host, port) {
	if (is.null(largescalechunks::LOCATOR()))
		stop("Location service not yet initialised")
	remote_sys(host, "largescalechunks::worker_node",
		   list(host, port,
			largescalemessages::address(largescalechunks::LOCATOR()), largescalemessages::port(largescalechunks::LOCATOR())))
}

remote_sys <- function(host, fun, args) {
	command <- c("R", "-e", as.call(c(parse(text=fun), args)))
	system2("ssh", c(host, shQuote(shQuote(command))), stdout=FALSE, stderr=FALSE, wait=FALSE)
}
