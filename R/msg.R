msg <- function(..., to) {
	if (missing(...)) {
		return(nget("msg", redis.connect, reconnect=TRUE))
	} else if (missing(to)) {
		return(structure(list(...), class="msg"))
	} else {
		redis.push(msgconn(), to,
			   rawToChar(serialize(msg(...), NULL, T)))
	}
}

msgconn <- function() msg()$conn

print.msg <- function(x, ...) {
	cat("Message with components:\n")
	for (n in names(x)) {
		cat("\t", n, ":\n")
		print(x[[n]])
	}
}

args.msg	<- function(x, target, ...) 
	rapply(getMsg("args")(x, ...),  emerge,
	       classes = c("AsIs", "chunkRef", "distObjRef"),
	       deflt = NULL, how="replace", target=target)
desc.msg	<- function(x) x$desc
from.msg	<- function(x) x$from
fun.msg		<- function(x, ...) as.function(x$fun)
host.msg	<- function(x) x$host
insert.msg	<- function(x) x$insert
port.msg	<- function(x) x$port
preview.msg	<- function(x) x$preview
size.msg	<- function(x) x$size
store.msg	<- function(x) x$store
target.msg	<- function(x) x$target
to.msg		<- function(x) x$to

as.function.character <- function(x, ...) {
                funsplit <- strsplit(x, "::", fixed=TRUE)[[1]]
                if (length(funsplit) == 2L) {
                        getFromNamespace(funsplit[2], funsplit[1])
                } else get(x)
}
