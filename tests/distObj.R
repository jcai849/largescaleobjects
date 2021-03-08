library(largeScaleR)
init("config")

x <- resolve(stub(1:30, 3))

# AsIs local
stopifnot(identical(unstub(x+I(1:3)), 
		    rep(1:3, length.out=10)+1:30))

# Equal size local
stopifnot(identical(unstub(x+1:30), 
		    1:30+1:30))

# Smaller sized local
stopifnot(identical(unstub(x+1:3),
		    1:30+1:3))

# larger sized local
stopifnot(identical(unstub(x+1:300), 1:30+1:300))

# equal sized distObj

# smaller sized distObj

# larger sized distObj

# unresolved distObj

# unresolved : unresolved distObj
