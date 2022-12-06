index <- function(x, i, j, ...) UseMethod("index", i)
index.numeric <- function(x, i, j, ...) {
	stopifnot(is.DistributedObject(x))
	sizes <- emerge(do.dcall(dim, list(x)))
	cumsum(sizes)
	# Actually this cumsum should be a generic that depends on the dimension and class
	# e.g.
	# > x <- array(1:9, c(3,3))
	# > apply(sapply(list(x,x,x,x), dim), 1, cumsum)
	# Question: what if arrays aren't combined end-to-end?
}
prune <- function(x)
align <- function(x, y)

#utils
dim.DistributedObject
head.DistributedObject
length.DistributedObject
nrow.DistributedObject
NROW.DistributedObject
object.size.DistributedObject
ncol.DistributedObject
colnames.DistributedObject
names.DistributedObject
