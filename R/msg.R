msg <- function(...) {
	m <- list(...)
	class(m) <- "msg"
	m
}

print.msg <- function(x) {
	cat("Message with components:\n")
	for (n in names(x)) {
		cat("\t", n, ":\n")
		print(x[[n]])
	}
}

format.msg <- function(x) {
	paste("Message with components:" sapply(names(x), format), sep="\n")
}

fun.msg		<- function(x) x$fun
args.msg	<- function(x) x$args
target.msg	<- function(x) x$target
desc.msg	<- function(x) x$desc
