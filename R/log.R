init.logProcess <- function(x) ulog::ulog.init(paste0("udp://", host(x), ":", port(x)))

stateLog <- function(action) {
	ulog::ulog(action)
}

# States
# CON X - New worker connected
# RCV X Y - Receiving at worker X, chunk Y
# SVD X Y - Saving at worker X, chunk Y
# WRK X Y - Working at worker X on chunk Y
# WTQ X - Waiting on queues at worker X#
