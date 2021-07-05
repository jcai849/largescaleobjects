start <- function(workers, loginName, user="127.0.0.1", comms=user, log=user) {
	logProcess(log)
	commsProcess(comms)
	userProcess(user)
	if (is.numeric(workers)) {
		replicate(workers, workerProcess())
	} else lapply(workers, workerProcess, user=loginName)
	init()
}

init <- function(x) {
	if (missing(x)) {
	# order: 1. log 2. comms 3. user 4. worker
	invisible(lapply(mget(ls(unregisteredProcesses()),
			      envir=unregisteredProcesses()), register))
	} else UseMethod("init")
}

init.character <- function(x) {
	source(x, echo=FALSE)
	init()
}

register <- function(...) {
	if (length(list(...)) == 1) {
		UseMethod("register") 
	} else lapply(list(...), register)
}

process <- function(host="127.0.0.1", port=largeScaleR::port(), 
		    user=NULL, pass=NULL, execute=NULL) {
	x <- list()
	class(x) <- "process"
	host(x)		<- if (missing(host)) NULL else host
	port(x)		<- if (missing(port)) NULL else port
	user(x)		<- if (missing(user)) NULL else user
	pass(x)		<- if (missing(pass)) NULL else pass
	execute(x)	<- if (missing(execute)) NULL else execute
	x
}

logProcess <- function(host="127.0.0.1", port=5140L, execute=FALSE) {
	x <- process(host, port, execute=execute)
	class(x) <- c("logProcess", class(x))

	assign("01.logProcess", x, envir=unregisteredProcesses())
}

register.logProcess <- function(x, ...) {
	if (execute(x)) {
		system2("ssh",  c(host(x), "ulogd", "-u", port(x)),
			      stdout=FALSE, stderr=FALSE,  wait=FALSE)
	}
	init(x)
	rm("01.logProcess", envir=unregisteredProcesses())
	assign("logProcess", x, envir=.largeScaleRProcesses)
}

commsProcess <- function(host="127.0.0.1", port=6379L, user=NULL,
			 pass=NULL, dbpass=NULL, execute=FALSE) {
	x <- process(host, port, user, pass, execute)
	class(x) <- c("commsProcess", class(x))
	desc(x) <- "comms"
	dbpass(x) <- dbpass

	assign("02.commsProcess", x, envir=unregisteredProcesses())
}

register.commsProcess <- function(x, ...) {
	if (execute(x)) {
		system2("ssh", c(host(x), "redis-server"),
			stdout=FALSE, stderr=FALSE,  wait=FALSE)
	}
	rsc <- rediscc::redis.connect(host(x), port(x),
				      reconnect = TRUE, 
				      password=dbpass(x))
	assign("commsConn", rsc, envir=.largeScaleRConn)

	rm("02.commsProcess", envir=unregisteredProcesses())
	assign("commsProcess", x, envir=.largeScaleRProcesses)
}

userProcess <- function(host="127.0.0.1", port=largeScaleR::port()) {
	x <- process(host=host, port=port)
	class(x) <- c("userProcess", class(x))

	assign("03.userProcess", x, envir=unregisteredProcesses())
}

register.userProcess <- function(x, ...) {
	desc(x) <- desc("process")
	while (!tryCatch(osrv::start(port=port(x)), 
			 error = function(e) FALSE)){}
	assign(paste0("/process/", as.character(largeScaleR::desc(x))),
	       NULL, envir=.largeScaleRKeys)
	assign(paste0("/host/", host(x)),
	       NULL, envir=.largeScaleRKeys)

	rm("03.userProcess", envir=unregisteredProcesses())
	assign("userProcess", x, envir=.largeScaleRProcesses)
	stateLog(paste("CON", desc(getUserProcess()))) # CON X - New worker connected
}

counterMaker <- function(initial, step)
	local({
		count <- initial
		function() {count <<- count + step; count}
	})

workerCounter <- counterMaker(3, 1)

workerProcess <- function(host="127.0.0.1",
			  port=NULL, user=NULL, pass=NULL, execute=TRUE) {
	x <- process(host, port, user, pass, execute)
	class(x) <- c("workerProcess", class(x))

	attr(x, "count") <- workerCounter()
	assign(paste0(attr(x, "count", exact=TRUE), ".workerProcess"), x,
	       envir=unregisteredProcesses())
}

register.workerProcess <- function(x, ...) {
	if (!execute(x)) return()
	count <- attr(x, "count", exact = TRUE)
	attr(x, "count") <- NULL
	rm(list=paste0(count, ".workerProcess"), envir=unregisteredProcesses())

	command <- c("R", "-e",
		     paste0("largeScaleR::worker(comms=",
			    paste0(deparse(getCommsProcess()), collapse=""), 
			    ",log=", paste0(deparse(getLogProcess()), collapse=""), 
			    ",host=", paste0(deparse(host(x)), collapse=""),
			    if (is.null(port(x))) NULL else paste0(",port=",
						   paste0(deparse(port(x))), collapse=""),
			    ")", collapse=""))
	system2("ssh", c(if (is.null(user(x))) NULL else paste("-l", user(x)), 
			     host(x), shQuote(shQuote(command))),
		stdout=FALSE, stderr=FALSE,  wait=FALSE)
}

print.process <- function(x, ...) {
	print(paste("largeScaleR process at host",
		    host(x), "and port", port(x), "under descriptor", desc(x)))
	if (!is.null(user(x)))
		 print(paste("At user", user(x)))
}

format.process <- function(x) {
	paste("largeScaleR process at host",
		    host(x), "and port", format(port(x)), "under descriptor", desc(x), 
	if (!is.null(user(x)))
		 paste("At user", user(x)) else NULL)
}

desc.process <- function(x, ...) x$desc
host.process <- function(x, ...) x$host
pass.process <- function(x, ...) x$pass
port.process <- function(x, ...) x$port
execute.process <- function(x, ...) x$execute
user.process <- function(x, ...) x$user
dbpass.commsProcess <- function(x, ...) x$dbpass

`desc<-.process` <- function(x, value) { x$desc <- value; x}
`host<-.process` <- function(x, value) { x$host <- value; x }
`pass<-.process` <- function(x, value) { x$pass <- value; x }
`port<-.process` <- function(x, value) { x$port <- value; x}
`execute<-.process` <- function(x, value) { x$execute <- value; x}
`user<-.process` <- function(x, value) { x$user <- value; x }
`dbpass<-.commsProcess` <- function(x, value) { x$dbpass <- value; x}
