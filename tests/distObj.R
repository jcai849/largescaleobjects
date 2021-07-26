library(largeScaleR)

#trace(largeScaleR:::requestField.chunkRef, quote(print(paste("requesting", field, "from", desc(x)))), exit=quote(print("request returned")))
#trace(largeScaleR:::delete.chunkRef, quote(print(paste("deleting", desc(x)))))
#trace(largeScaleR:::osrvGet, quote(print(paste("getting", desc(x)))))

init("config")

x <- 1:30

# movement

distX <- distribute(x, 3)
distIris <- distribute(iris, 10)

stopifnot(
	  identical(emerge(distX), x),
	  identical(emerge(distIris), iris),

	  # Ops & Interactions
	  identical(emerge(-distX), -x),

	  ## DistX prior
	  ### AsIs local
	  identical(emerge(distX + I(1:3)), x + rep(1:3, length.out=10)),
	  ### Equal size local
	  identical(emerge(distX + 1:30), x + 1:30),
	  ### Smaller sized local
	  identical(emerge(distX + 1:3), x + 1:3),
	  ### larger sized local
	  identical(emerge(distX + 1:300), x + 1:300),
	  ### equal sized distObj
	  identical(emerge(distX + distribute(1:30, 4)), x + 1:30),
	  ### smaller sized distObj
	  identical(emerge(distX + distribute(1:3, 2)), x + 1:3),
	  ### larger sized distObj
	  identical(emerge(distX + distribute(1:300, 10)), x + 1:300),

	  ## DistX posterior
	  ### AsIs local
	  identical(emerge(I(1:3) + distX), rep(1:3, length.out=10) + x),
	  ### Equal size local
	  identical(emerge(1:30 + distX), 1:30 + x),
	  ### Smaller sized local
	  identical(emerge(1:3 + distX), 1:3 + x),
	  ### larger sized local
	  identical(emerge(1:300 + distX), 1:300 + x),
	  ### equal sized distObj
	  identical(emerge(distribute(1:30, 4) + distX), 1:30 + x),
	  ### smaller sized distObj
	  identical(emerge(distribute(1:3, 2) + distX), 1:3 + x),
	  ### larger sized distObj
	  identical(emerge(distribute(1:300, 10) + distX), 1:300 + x),

	  # Summary
	  identical(sum(distX), sum(1:30)),
	  # Math
	  identical(emerge(abs(distX)), abs(x)),
	  #Complex
	  identical(emerge(Re(distX)), Re(x)),
	  ## length
	  identical(length(distX), length(x)),
	  ## dim
	  identical(dim(distIris), dim(iris)),
	  ## nrow
	  identical(nrow(distIris), nrow(iris)),
	  ## ncol
	  identical(ncol(distIris), ncol(iris)),
	  ## colnames
	  identical(colnames(distIris), colnames(iris))
)

## Print
print(distX)
## table
table(distIris$Sepal.Length)
## rbind FIX differences in rownames
rbind(distIris, distIris)
## c
c(distX, distX)

final(1)
