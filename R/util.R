info <- function(...) {
	op <- options(digits.secs = 6)
	if (verbose()) do.call(cat, c(format(Sys.time(), "%H:%M:%OS6"), "\t",
				      "[36m", list(...), "[0m\n"))
	options(op)
}
