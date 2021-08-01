loc <- function(host, port, conn) {
	l <- cache(mutable=TRUE)
	class(l) <- c("loc", class(l))
	if (!missing(host))
		host(l) <- host
	if (!missing(port))
		host(l) <- port
	if (!missing(conn))
		host(l) <- conn
	l
}

host.loc <- function(x) x[["host"]]
port.loc <- function(x) x[["port"]]
conn.loc <- function(x) x[["conn"]]
