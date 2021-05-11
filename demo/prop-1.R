library(largeScaleR)
workers <- paste0("10.3.1.", c(17, 2, 5, 3, 15, 8, 7, 9)) 

start(workers=workers, user="10.3.1.1")

lx <- rnorm(1E6)
head(lx)

dx <- distribute(lx, 8)
print(dx)
preview(dx)
