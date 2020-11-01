source("init.R")

o5		<- 1:15 %% 2 == 0
distObj5	<- distObj1 %% 2 == 0

# Ops
stopifnot(
	  identical(1:3 + 1:15,			# Arithmetic
		    emerge(1:3 + distObj1)),
	  identical(-{1:15}, 			# Unary Arith
		    emerge(-distObj1)),
	  identical(o5,				# Comparison
		    emerge(distObj5)),
	  identical(o5 | TRUE,		 	# Logical
		    emerge(distObj5 | TRUE)),
	  identical(!o5,			# Unary Logic
		    emerge(!distObj5))
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
	  identical(all(o5),
		    all(distObj5)),
	  identical(any(o5),
		    any(distObj5)),
	  identical(sum(1:15),
		    sum(distObj1)),
	  identical(max(1:15),
		    max(distObj1)),
	  identical(range(1:15),
		    range(distObj1))
)

clear()
