library(largeScaleR)

init("config")

x <- 1:30
distX <- stub(x, 3)
distIris <- stub(iris, 10)

# movement

stopifnot(identical(unstub(distX), x))
stopifnot(identical(unstub(distIris), iris))

# interactions

## AsIs local
stopifnot(identical(unstub(distX+I(1:3)), 
		    x+rep(1:3, length.out=10)))

## Equal size local
stopifnot(identical(unstub(distX+1:30), 
		    x++1:30))

## Smaller sized local
stopifnot(identical(unstub(distX+1:3),
		    x+1:3))

## larger sized local
stopifnot(identical(unstub(distX+1:300),
		    x+1:300))

## equal sized distObj

## smaller sized distObj

## larger sized distObj

# methods

stopifnot(identical(unstub(distX), x))
stopifnot(identical(unstub(distIris), iris))
## length
stopifnot(identical(length(distX), length(x)))
## nrow
stopifnot(identical(nrow(distIris), nrow(iris)))
## ncol
stopifnot(identical(ncol(distIris), ncol(iris)))
## colnames
stopifnot(identical(colnames(distIris), colnames(iris)))
## cbind
stopifnot(identical(unstub(cbind(distIris, distIris)),
		    cbind(iris, iris)))
## rbind ## TODO testing reveals differences in rownames - fix
# stopifnot(identical(unstub(rbind(distIris, distIris)),
# 		    rbind(iris, iris)))
# ## c
# stopifnot(identical(unstub(c(distX, distX)),
# 		    c(x, x)))

final(1)
