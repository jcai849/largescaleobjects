library(largeScaleR)

init("config")

x <- 1:30

# movement

distX <- stub(x, 3)
distIris <- stub(iris, 10)
stopifnot(identical(unstub(distX), x))
stopifnot(identical(unstub(distIris), iris))

# Ops & Interactions

stopifnot(identical(unstub(-distX), -x))

## DistX prior
### AsIs local
stopifnot(identical(unstub(distX + I(1:3)), 
		    x + rep(1:3, length.out=10)))
### Equal size local
stopifnot(identical(unstub(distX + 1:30), 
		    x + 1:30))
### Smaller sized local
stopifnot(identical(unstub(distX + 1:3),
		    x + 1:3))
### larger sized local
stopifnot(identical(unstub(distX + 1:300),
		    x + 1:300))
### equal sized distObj
stopifnot(identical(unstub(distX + stub(1:30, 4)),
		    x + 1:30))
### smaller sized distObj
stopifnot(identical(unstub(distX + stub(1:3, 2)),
		    x + 1:3))
### larger sized distObj
stopifnot(identical(unstub(distX + stub(1:300, 10)),
		    x + 1:300))

## DistX posterior
### AsIs local
stopifnot(identical(unstub(I(1:3) + distX), 
		    rep(1:3, length.out=10) + x))
### Equal size local
stopifnot(identical(unstub(1:30 + distX), 
		    1:30 + x))
### Smaller sized local
stopifnot(identical(unstub(1:3 + distX),
		    1:3 + x))
### larger sized local
stopifnot(identical(unstub(1:300 + distX),
		    1:300 + x))
### equal sized distObj
stopifnot(identical(unstub(stub(1:30, 4) + distX),
		    1:30 + x))
### smaller sized distObj
stopifnot(identical(unstub(stub(1:3, 2) + distX),
		    1:3 + x))
### larger sized distObj
stopifnot(identical(unstub(stub(1:300, 10) + distX),
		    1:300 + x))

# Summary
stopifnot(identical(sum(distX), sum(1:30)))
# Math
stopifnot(identical(unstub(abs(distX)), abs(x)))
#Complex
stopifnot(identical(unstub(Re(distX)), Re(x)))
# Print
print(distX)

# custom methods

## table
table(distIris$Sepal.Length)
## length
stopifnot(identical(length(distX), length(x)))
## dim
stopifnot(identical(dim(distIris), dim(iris)))
## nrow
stopifnot(identical(nrow(distIris), nrow(iris)))
## ncol
stopifnot(identical(ncol(distIris), ncol(iris)))
## colnames
stopifnot(identical(colnames(distIris), colnames(iris)))
## cbind
stopifnot(identical(unstub(cbind(distIris, distIris)),
		    cbind(iris, iris)))

## rbind FIX differences in rownames
rbind(distIris, distIris)
## c
c(distX, distX)

final(1)
