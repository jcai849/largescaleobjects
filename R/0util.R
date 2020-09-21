getLocal <- function(loc) function(field) get(field, environment(loc))
envGet <- function(field) function(x) get(field, x)
envSet <- function(field) function(x, value) {
	assign(field, value, x)
	x
}
isA <- function(class) function(x) inherits(x, class)

info <- function(...) {
	op <- options(digits.secs = 6)
	if (verbose()) do.call(cat, c(format(Sys.time(), "%H:%M:%OS6"), "\t",
				      "[36m", list(...), "[0m\n"))
	options(op)
}

combine.default 	<- c
combine.data.frame 	<- rbind
size.default 		<- length
size.data.frame 	<- nrow
