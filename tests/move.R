source("init.R")

# findTarget
stopifnot(
	  identical(findTarget(list(distObj1, distObj2)), distObj1),
	  identical(findTarget(list(distObj1, 1, 2, distObj2)), distObj1),
	  identical(findTarget(list(1, 2, distObj1, 1, 2, distObj2)), distObj1),
	  identical(findTarget(list(distObj2, distObj1)), distObj1),
	  identical(findTarget(list(distObj2)), distObj2)
)
  
# alignment: arg x w/ targets a-g at from/to/size
#  a 1/3/3     ---
#  b 1/5/5     -----
#  c 9/12/4             -- -- 
#  d 13/18/6                 --- ---
#  e 17/19/3                      ---
#  f 3/18/16     --- ----- ----- ---
#  g 8/18/11           --- ----- ---
#  h 1/38/38   ----- ----- ----- ----- ----- ----- ----- ---
#              _____ _____ _____     
#  x 1/15/15  |__C1_|__C2_|__C3_|       

stopifnot(
	  identical(alignment(distObj1, chunkA),
		    list(HEAD = list(FROM = 1L, TO = 3L),
			 REF = list(chunk1),
			 TAIL = list(FROM = 1L, TO = 3L))),
	  identical(alignment(distObj1, chunkB),
		    list(HEAD = list(FROM = 1L, TO = 5L),
			 REF = list(chunk1),
			 TAIL = list(FROM = 1L, TO = 5L))),
	  )
