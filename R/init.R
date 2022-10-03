init_locator <- function(host, port) {
	chunknet::LOCATOR(host, port)
	remote_sys(host, "chunknet::locator_node", list(host, port))
}

init_worker <- function(host, port) {
	if (is.null(chunknet::LOCATOR()))
		stop("Location service not yet initialised")
	remote_sys(host, "chunknet::worker_node",
		   list(host, port,
			orcv::address(chunknet::LOCATOR()), orcv::port(chunknet::LOCATOR())))
}

remote_sys <- function(host, fun, args) {
	command <- c("R", "-e", as.call(c(parse(text=fun), args)))
	system2("ssh", c(host, shQuote(shQuote(command))), stdout=FALSE, stderr=FALSE, wait=FALSE)
}
