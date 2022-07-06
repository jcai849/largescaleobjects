init_locator <- function(host, port) {
	largerscale::LOCATOR(host, port)
	remote_sys(host, "largerscale::locator", list(host, port))
}

init_worker <- function(host, port) {
	if (is.null(largerscale::LOCATOR()))
		stop("Location service not yet initialised")
	remote_sys(host, "largerscale::worker",
		   list(host, port,
			orcv::address(largerscale::LOCATOR()), orcv::port(largerscale::LOCATOR())))
}

remote_sys <- function(host, fun, args) {
	command <- c("R", "-e", as.call(c(parse(text=fun), args)))
	system2("ssh", c(host, shQuote(shQuote(command))), stdout=FALSE, stderr=FALSE, wait=FALSE)
}
