init <- function(file, ...) {
	source(file, echo=TRUE)
	# order: 1. log 2. comms 3. user 4. worker
	lapply(mget(ls(unregisteredProcesses()),
		    envir=unregisteredProcesses()), register)
}

register <- function(...) {
	if (length(list(...)) == 1) {
		UseMethod("register") 
	} else lapply(list(...), register)
}

process <- function(host=Sys.info()["nodename"], port=port(), 
		    user=NULL, pass=NULL, execute=NULL) {
	x <- list()
	class(x) <- "process"
	host(x) <- host
	port(x) <- port
	user(x) <- user
	pass(x) <- pass
	execute(x) <- execute
	x
}

logProcess <- function(host=Sys.info()["nodename"], port=514L, execute=FALSE) {
	x <- process(host, port, execute=execute)
	class(x) <- c("logProcess", class(x))

	assign("1.logProcess", x, envir=unregisteredProcesses())
}

register.logProcess <- function(x, ...) {
	if (execute(x)) system2("ssh",  c(host(x), "ulogd", "-u", port(x)),
			      stdout=FALSE, stderr=FALSE,  wait=FALSE)
	ulog::ulog.init(path=paste0("udp://", host(x), ":", port(x)))

	rm("1.logProcess", envir=unregisteredProcesses())
	assign("logProcess", x, envir=.largeScaleRProcesses)
}

commsProcess <- function(host=Sys.info()["nodename"], port=6379L, user=NULL,
			 pass=NULL, dbpass=NULL, execute=FALSE) {
	x <- process(host, port, user, pass, execute)
	class(x) <- c("commsProcess", class(x))
	desc(x) <- "comms"
	dbpass(x) <- dbpass

	assign("2.commsProcess", x, envir=unregisteredProcesses())
}

register.commsProcess <- function(x, ...) {
	if (execute(x))
		system2("ssh", c(host(x), "redis-server"),
			stdout=FALSE, stderr=FALSE,  wait=FALSE)
	rsc <- rediscc::redis.connect(host(x), port(x),
				      reconnect = TRUE, 
				      password=dbpass(x))
	assign("commsConn", rsc, envir=.largeScaleRConn)

	rm("2.commsProcess", envir=unregisteredProcesses())
	assign("commsProcess", x, envir=.largeScaleRProcesses)
}

userProcess <- function(host=Sys.info()["nodename"], port=largeScaleR::port()) {

	x <- process(host=host, port=port)
	class(x) <- c("userProcess", class(x))

	assign("3.userProcess", x, envir=unregisteredProcesses())
}

register.userProcess <- function(x, ...) {
	desc(x) <- desc("process")
	osrv::execute(port=port)
	assign(paste0("/process/", as.character(largeScaleR::desc(x))),
	       NULL, envir=.largeScaleRKeys)
	assign(paste0("/host/", host(x)),
	       NULL, envir=.largeScaleRKeys)

	rm("3.userProcess", envir=unregisteredProcesses())
	assign("userProcess", x, envir=.largeScaleRProcesses)
}

workerCounter <- local({
	count <- 3
	function() {count <<- count+1; count}
})

workerProcess <- function(host=Sys.info()["nodename"],
			  port=largeScaleR::port(), user=NULL, pass=NULL, execute=TRUE) {
	x <- process(host, port, user, pass, execute)
	class(x) <- c("workerProcess", class(x))

	attr(x, "count") <- workerCounter()
	assign(paste0(attr(x, "count", exact=TRUE), ".workerProcess"), x,
	       envir=unregisteredProcesses())
}

register.workerProcess <- function(x, ...) {
	rm(paste0(count, ".workerProcess"), envir=unregisteredProcesses())
	if (!execute(x)) return()
	count <- attr(x, "count", exact = TRUE)
	attr(x, "count") <- NULL

	loc <- paste0(if (!is.null(user(x))) paste0(user(x), '@') else  NULL, host(x))
	command <- c("R", "-e", 
		     paste0("largeScaleR::worker(comms=",
			    deparse1(getCommsProcess()), 
			    ",log=",deparse1(getLogProcess()), 
			    ",host=", deparse1(host(x)),
			    ",port=", deparse1(port(x)),
			    ")"))
	system2("ssh", c(loc, shQuote(shQuote(command))), 
		stdout=FALSE, stderr=FALSE,  wait=FALSE)
}

print.process <- function(x) {
	print(paste("largeScaleR communications process at host",
		    host(x), "and port", port(x), "under descriptor", desc(x)))
	if (!is.null(user(x)))
		 print(paste("At user", user(x)))
}

desc.process <- function(x) x$desc
host.process <- function(x) x$host
pass.process <- function(x) x$pass
port.process <- function(x) x$port
execute.process <- function(x) x$execute
user.process <- function(x) x$user
dbpass.commsProcess <- function(x) x$dbpass

`desc<-.process` <- function(x, value) { x$desc <- value; x}
`host<-.process` <- function(x, value) { x$host <- value; x }
`pass<-.process` <- function(x, value) { x$pass <- value; x }
`port<-.process` <- function(x, value) { x$port <- value; x}
`execute<-.process` <- function(x, value) { x$execute <- value; x}
`user<-.process` <- function(x, value) { x$user <- value; x }
`dbpass<-.commsProcess` <- function(x, value) { x$dbpass <- value; x}
