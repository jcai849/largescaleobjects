library(largeScaleR)
debug(start)
start(workers=paste0("10.3.1.", c(17, 2, 5, 3, 15, 8, 7, 9)), 
      user="10.3.1.1")

lx <- rnorm(1E3)
dx <- distribute(lx, 8)
print(dx)
preview(dx)
