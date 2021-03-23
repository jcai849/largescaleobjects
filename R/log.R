init.logProcess <- function(x) ulog::ulog.init(paste0("udp://", host(x), ":", port(x)))

stateLog <- function(action) {
	ulog::ulog(action)
}
