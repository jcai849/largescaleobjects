library(largeScaleR)
init("config")

x <- resolve(stub(1:30, 4))
y <- resolve(stub(1:300, 3))

# alignment(long, shortendpiece)
# identical(alignment(distObj1, chunkF),
#           list(HEAD   = list(FROM = 3L, TO = 5L),
#                REF    = list(chunk1, chunk2, chunk3, chunk1),
#                TAIL   = list(FROM = 1L, TO = 2L)))
# alignment(short, longendpiece)
