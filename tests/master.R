library(largeScaleR)
userProcess(host="localhost")
logProcess(host="localhost", port=5140L, execute=FALSE)
init()

x <- stub(1:30, 3)
y <- stub(1:20, 2)
z = x + y
