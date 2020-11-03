source("init.R")

# findTarget
stopifnot(
	  identical(findTarget(list(distObj1, distObj2)), distObj1),
	  identical(findTarget(list(distObj1, 1, 2, distObj2)), distObj1),
	  identical(findTarget(list(1, 2, distObj1, 1, 2, distObj2)), distObj1),
	  identical(findTarget(list(distObj2, distObj1)), distObj1),
	  identical(findTarget(list(distObj2)), distObj2)
)

# alignment: arg X w/ targets A-G at from/to/size
#              _____ _____ _____
#  X 1/15/15  |__C1_|__C2_|__C3_|
#
#  A 1/3/3     ---
#  B 1/5/5     -----
#  C 9/12/4             -- --
#  D 13/18/6                 --- ---
#  E 17/19/3                      ---
#  F 3/18/16     --- ----- ----- ---
#  G 8/18/11           --- ----- ---
#  H 1/38/38   ----- ----- ----- ----- ----- ----- ----- ---
#  I 2/16/15    ---- ----- ----- -
#  J 2/15/14    ---- ----- -----
#  K 1/16/16   ----- ----- ----- -
#  L 4/25/22      -- ----- ----- ----- -----
#  M 1/1/1     -
#  N 4/4/1        -

stopifnot(
	  identical(alignment(distObj1, chunkA),
		    list(HEAD	= list(FROM = 1L, TO = 3L),
			 REF	= list(chunk1),
			 TAIL	= list(FROM = 1L, TO = 3L))),
	  identical(alignment(distObj1, chunkB),
		    list(HEAD	= list(FROM = 1L, TO = 5L),
			 REF	= list(chunk1),
			 TAIL	= list(FROM = 1L, TO = 5L))),
	  identical(alignment(distObj1, chunkC),
		    list(HEAD	= list(FROM = 4L, TO = 5L),
			 REF	= list(chunk2, chunk3),
			 TAIL	= list(FROM = 1L, TO = 2L))),
	  identical(alignment(distObj1, chunkD),
		    list(HEAD	= list(FROM = 3L, TO = 5L),
			 REF	= list(chunk3, chunk1),
			 TAIL	= list(FROM = 1L, TO = 3L))),
	  identical(alignment(distObj1, chunkE),
		    list(HEAD	= list(FROM = 2L, TO = 4L),
			 REF	= list(chunk1),
			 TAIL	= list(FROM = 1L, TO = 4L))),
	  identical(alignment(distObj1, chunkF),
		    list(HEAD	= list(FROM = 3L, TO = 5L),
			 REF	= list(chunk1, chunk2, chunk3, chunk1),
			 TAIL	= list(FROM = 1L, TO = 2L))),
	  identical(alignment(distObj1, chunkG),
		    list(HEAD	= list(FROM = 3L, TO = 5L),
			 REF	= list(chunk2, chunk3, chunk1),
			 TAIL	= list(FROM = 1L, TO = 3L))),
	  identical(alignment(distObj1, chunkH),
		    list(HEAD	= list(FROM = 1L, TO = 5L),
			 REF	= list(chunk1, chunk2, chunk3),
			 TAIL	= list(FROM = 1L, TO = 5L))),
	  identical(alignment(distObj1, chunkI),
		    list(HEAD	= list(FROM = 2L, TO = 5L),
			 REF	= list(chunk1, chunk2, chunk3, chunk1),
			 TAIL	= list(FROM = 1L, TO = 1L))),
	  identical(alignment(distObj1, chunkJ),
		    list(HEAD	= list(FROM = 2L, TO = 5L),
			 REF	= list(chunk1, chunk2, chunk3),
			 TAIL	= list(FROM = 1L, TO = 5L))),
	  identical(alignment(distObj1, chunkK),
		    list(HEAD	= list(FROM = 1L, TO = 5L),
			 REF	= list(chunk1, chunk2, chunk3),
			 TAIL	= list(FROM = 1L, TO = 5L))),
	  identical(alignment(distObj1, chunkL),
		    list(HEAD	= list(FROM = 4L, TO = 5L),
			 REF	= list(chunk1, chunk2, chunk3, chunk1),
			 TAIL	= list(FROM = 1L, TO = 3L))),
	  identical(alignment(distObj1, chunkM),
		    list(HEAD	= list(FROM = 1L, TO = 1L),
			 REF	= list(chunk1),
			 TAIL	= list(FROM = 1L, TO = 1L))),
	  identical(alignment(distObj1, chunkN),
		    list(HEAD	= list(FROM = 4L, TO = 4L),
			 REF	= list(chunk1),
			 TAIL	= list(FROM = 1L, TO = 4L)))
	  )

# alignment: arg Y w/ target B at from/to/size
#              ___ 
#  Y 1/3/3    |_CA|
#  A 1/3/3     ---
#  B 1/5/5     -----
#  C 9/12/4             -- -- 
#  E 17/19/3                      ---
#  M 1/1/1     -
#  N 4/4/1        -

stopifnot(
	  identical(alignment(distObj3, chunkA),
		    list(HEAD	= list(FROM = 1L, TO = 3L),
			 REF	= list(chunkA),
			 TAIL	= list(FROM = 1L, TO = 3L))),
	  identical(alignment(distObj3, chunkB),
		    list(HEAD	= list(FROM = 1L, TO = 3L),
			 REF	= list(chunkA),
			 TAIL	= list(FROM = 1L, TO = 3L))),
	  identical(alignment(distObj3, chunkC),
		    list(HEAD	= list(FROM = 3L, TO = 3L),
			 REF	= list(chunkA, chunkA),
			 TAIL	= list(FROM = 1L, TO = 2L))),
	  identical(alignment(distObj3, chunkE),
		    list(HEAD	= list(FROM = 2L, TO = 3L),
			 REF	= list(chunkA, chunkA),
			 TAIL	= list(FROM = 1L, TO = 1L))),
	  identical(alignment(distObj3, chunkM),
		    list(HEAD	= list(FROM = 1L, TO = 1L),
			 REF	= list(chunkA),
			 TAIL	= list(FROM = 1L, TO = 1L))),
	  identical(alignment(distObj3, chunkN),
		    list(HEAD	= list(FROM = 1L, TO = 1L),
			 REF	= list(chunkA),
			 TAIL	= list(FROM = 1L, TO = 1L)))
	  )

stopifnot(
	  identical(refToRec(distObj1, chunkA),
		    1:3),
	  identical(refToRec(distObj1, chunkC),
		    9:12),
	  identical(refToRec(distObj1, chunkH),
		    1:15),
	  identical(refToRec(distObj1, chunkL),
		    c(4:15, 1:3))
	 )
