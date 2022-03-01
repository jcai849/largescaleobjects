init_locator <- function(host, port) {
	LOCATOR(host, port)
	remote_sys(host, "largescaler::locator", list(host, port))
}

init_worker <- function(host, port) {
	locator_address <- LOCATOR()$address
	locator_port <- LOCATOR()$port
	if (is.null(locator_address) || is.null(locator_port))
		stop("Location service not yet initialised")
	remote_sys(host, "largescaler::worker", list(host, port, locator_address, locator_port))
}

remote_sys <- function(host, fun, args) {
	command <- c("R", "-e", paste0(fun, "(", do.call(paste, c(args, sep=", ")), ")" ))
	system2("ssh", c(host, shQuote(shQuote(command))), stdout=FALSE, stderr=FALSE, wait=FALSE)
}
