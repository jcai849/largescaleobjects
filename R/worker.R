worker <- function(host, port, msghost, msgport, loghost, logport, prepop) {
	options(autolsr=FALSE)
	library(PKGNAME)
	host(node()) <- host
	port(node()) <- port
	node()
	host(msg()) <- msghost
	port(msg()) <- msgport
	msg()
	host(log()) <- loghost
	port(log()) <- logport
	log()
	lapply(names(prepop), function(x) chunk(x) <- prepop[[x]])
	serve()
}

serve <- function() {
	repeat {
		log("WTQ")
		keys <- ls(chunk())
		while (is.null(smsg <- redis.pop(msgconn(), keys, timeout=10))) {}
		request <- unserialize(charToRaw(smsg))
		rd <- desc(request)
		log("WRK", desc(request))
		result <- tryCatch(do.call(insert(fun(request), insert(request)),
                                            args(request, target(request))),
                                   error =  identity)
                if (store(request)) chunk(rd) <- result
	}
}

insert.function <- function(fun, insert) {
        if (is.null(insert)) return(fun)
        environment(fun) <- new.env(parent = environment(fun))
        for (m in names(insert))
                assign(m, insert[[m]], environment(fun))
        fun
}
