init.logProcess <- function(x) ulog::ulog.init(paste0("udp://127.0.0.1:", port(x)))
# change to host(x)

log <- function(x) ulog::ulog(paste(logCounter(), paste(x, sep=";"), collapse=". "))

logCounter <- counterMaker(0, 1)
