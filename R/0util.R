counterMaker <- function(initial, step)
	local({
		count <- initial
		function() {count <<- count + step; count}
	})

getLocal <- function(loc) function(field) get(field, environment(loc))
envGet <- function(field) function(x) get(field, x)
envSet <- function(field) function(x, value) {
	assign(field, value, x)
	x
}
