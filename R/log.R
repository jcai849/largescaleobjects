init.logProcess <- function(x) ulog::ulog.init(paste0("udp://", host(x), ":", port(x)))

log <- function(x) ulog::ulog(paste(logCounter(), ". ", paste(x, sep=";"), collapse=". "))

logCounter <- counterMaker(0, 1)
