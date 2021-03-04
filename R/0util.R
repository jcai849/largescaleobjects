counterMaker <- function(initial, step)
	local({
		count <- initial
		function() {count <<- count + step; count}
	})

getLocal <- function(loc) function(field) get(field, environment(loc), inherits=FALSE)
envGet <- function(field) function(x) get(field, x, inherits=FALSE)
envSet <- function(field) function(x, value) {
	assign(field, value, x)
	x
}
