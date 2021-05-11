library(largeScaleR)
start(paste0("10.3.1.7", c(2, 3, 5, 7, 8, 9, 15, 17)))

lx <- rnorm(1E6)
dx <- distribute(lx)
print(dx)
preview(dx)
