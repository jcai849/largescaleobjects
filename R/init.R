init_locator <- function(host, port) {
	largerscale::LOCATOR(host, port)
	remote_sys(host, "largerscale::locator", list(host, port))
}

init_worker <- function(host, port) {
	locator_address <- largerscale::LOCATOR()$address
	locator_port <- largerscale::LOCATOR()$port
	if (is.null(locator_address) || is.null(locator_port))
		stop("Location service not yet initialised")
	remote_sys(host, "largerscale::worker", list(host, port, locator_address, locator_port))
}

remote_sys <- function(host, fun, args) {
	command <- c("R", "-e", as.call(c(parse(text=fun), args)))
	system2("ssh", c(host, shQuote(shQuote(command))), stdout=FALSE, stderr=FALSE, wait=FALSE)
}
