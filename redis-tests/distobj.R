source("init.R")

o4		<- 1:15 %% 2 == 0
distObj4	<- distObj1 %% 2 == 0

# Ops
stopifnot(
	  identical(1:3 + 1:15,			# Arithmetic
		    emerge(1:3 + distObj1)),
	  identical(-{1:15}, 			# Unary Arith
		    emerge(-distObj1)),
	  identical(o4,				# Comparison
		    emerge(distObj4)),
	  identical(o4 | TRUE,		 	# Logical
		    emerge(distObj4 | TRUE)),
	  identical(!o4,			# Unary Logic
		    emerge(!distObj4)),
)

# Math
stopifnot(
	  identical(sqrt(1:15),			# Grp. 1
		    emerge(sqrt(distObj1))),
	  identical(exp(1:15),			# Grp. 2
		    emerge(exp(distObj1))),
	  identical(lgamma(1:15),		# Grp. 3
		    emerge(lgamma(distObj1)))
)

# Summary
stopifnot(
	  identical(all(o4),
		    emerge(all(distObj1))),
	  identical(any(o4),
		    emerge(any(distObj1))),
	  identical(sum(1:15),
		    emerge(sum(distObj1))),
	  identical(max(1:15),
		    emerge(max(distObj1))),
	  identical(range(1:15),
		    emerge(range(distObj1)))
)

clear()
