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
fun.msg <- function(x) x$FUN
args.msg <- function(x) x$ARGS
target.msg <- function(x) x$TARGET
desc.msg <- function(x) x$DESC
