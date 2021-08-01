PKGNAME	<- "largeScaleR"
HOST	<- "127.0.0.1"
PORT	<- 5140
MSGPORT	<- 6160
LOGPORT	<- 1234

.onAttach <- function(libname, pkgname) {
	options <- sapply(c("autolsr", "autolsrself",
			    "autolsrmsg", "autolsrlog"),
			  getOption, default=TRUE)
	if (options["autolsrself"] && options["autolsr"]) {
		host(chunk()) <- HOST; port(chunk()) <- PORT
		tryCatch(chunk(), error=function(e)
		 packageStartupMessage("Please specify node host and port."))
	} if (options["autolsrmsg"] && options["autolsr"]) {
		host(msg()) <- HOST; port(msg()) <- MSGPORT
		tryCatch(msg(), error=function(e)
		 packageStartupMessage("Please specify msg host and port."))
	} if (options["autolsrlog"] && options["autolsr"]) {
		host(log()) <- HOST; port(log()) <- LOGPORT
		tryCatch(log(), error=function(e)
		 packageStartupMessage("Please specify log host and port."))
	}
}
