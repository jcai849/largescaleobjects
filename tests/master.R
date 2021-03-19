library(largeScaleR)
userProcess(host="localhost")
commsProcess(host="localhost", port=6379L, execute=FALSE)
logProcess(host="localhost", port=5140L, execute=FALSE)
init()

x <- stub(data.frame(a=rnorm(1E4), b=rnorm(1E4)), 1)
debug("$")
x$a
