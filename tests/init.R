library(distObj)

chunk1 			<- structure(new.env(), class = "chunkRef")
chunk2 			<- structure(new.env(), class = "chunkRef")
chunk3 			<- structure(new.env(), class = "chunkRef")
chunkA 			<- structure(new.env(), class = "chunkRef")
chunkB 			<- structure(new.env(), class = "chunkRef")
chunkC 			<- structure(new.env(), class = "chunkRef")
chunkD 			<- structure(new.env(), class = "chunkRef")
chunkE 			<- structure(new.env(), class = "chunkRef")
chunkF 			<- structure(new.env(), class = "chunkRef")
chunkG 			<- structure(new.env(), class = "chunkRef")
chunkH 			<- structure(new.env(), class = "chunkRef")

chunkID(chunk1) 	<- structure("chunk1", class="chunkID")
chunkID(chunk2) 	<- structure("chunk2", class="chunkID")
chunkID(chunk3) 	<- structure("chunk3", class="chunkID")
chunkID(chunkA) 	<- structure("chunkA", class="chunkID")
chunkID(chunkB) 	<- structure("chunkB", class="chunkID")
chunkID(chunkC) 	<- structure("chunkC", class="chunkID")
chunkID(chunkD) 	<- structure("chunkD", class="chunkID")
chunkID(chunkE) 	<- structure("chunkE", class="chunkID")
chunkID(chunkF) 	<- structure("chunkF", class="chunkID")
chunkID(chunkG) 	<- structure("chunkG", class="chunkID")
chunkID(chunkH) 	<- structure("chunkH", class="chunkID")

preview(chunk1) 	<- 1:5
preview(chunk2) 	<- 6:10
preview(chunk3) 	<- 11:15
preview(chunkA) 	<- 1:3
preview(chunkB) 	<- 1:5
preview(chunkC) 	<- 9:12
preview(chunkD) 	<- 13:18
preview(chunkE) 	<- 17:19
preview(chunkF) 	<- 3:18
preview(chunkG) 	<- 8:18
preview(chunkH) 	<- 1:38

from(chunk1) 		<- 1L
from(chunk2) 		<- 6L
from(chunk3) 		<- 11L
from(chunkA) 		<- 1L
from(chunkB) 		<- 1L
from(chunkC) 		<- 9L
from(chunkD) 		<- 13L
from(chunkE) 		<- 17L
from(chunkF) 		<- 3L
from(chunkG) 		<- 8L
from(chunkH) 		<- 1L

to(chunk1) 		<- 5L
to(chunk2) 		<- 10L
to(chunk3) 		<- 15L
to(chunkA) 		<- 3L
to(chunkB) 		<- 5L
to(chunkC) 		<- 12L
to(chunkD) 		<- 18L
to(chunkE) 		<- 19L
to(chunkF) 		<- 18L
to(chunkG) 		<- 18L
to(chunkH) 		<- 38L

size(chunk1) 		<- 5L
size(chunk2) 		<- 5L
size(chunk3) 		<- 5L
size(chunkA) 		<- 3L
size(chunkB) 		<- 5L
size(chunkC) 		<- 4L
size(chunkD) 		<- 6L
size(chunkE) 		<- 3L
size(chunkF) 		<- 16L
size(chunkG) 		<- 11L
size(chunkH) 		<- 38L

resolution(chunk1) 	<- "RESOLVED"
resolution(chunk2) 	<- "RESOLVED"
resolution(chunk3) 	<- "RESOLVED"
resolution(chunkA) 	<- "RESOLVED"
resolution(chunkB) 	<- "RESOLVED"
resolution(chunkC) 	<- "RESOLVED"
resolution(chunkD) 	<- "RESOLVED"
resolution(chunkE) 	<- "RESOLVED"
resolution(chunkF) 	<- "RESOLVED"
resolution(chunkG) 	<- "RESOLVED"
resolution(chunkH) 	<- "RESOLVED"

addChunk("chunk1", 1:5)
addChunk("chunk2", 6:10)
addChunk("chunk3", 11:15)
addChunk("chunkA", 1:3)
addChunk("chunkB", 1:5)
addChunk("chunkC", 9:12)
addChunk("chunkD", 13:18)
addChunk("chunkE", 17:19)
addChunk("chunkF", 3:18)
addChunk("chunkG", 8:18)
addChunk("chunkH", 1:38)

distObj1 		<- structure(new.env(), class = "distObjRef")
distObj2 		<- structure(new.env(), class = "distObjRef")

chunk(distObj1) 	<- list(chunk1, chunk2, chunk3)
chunk(distObj2) 	<- list(chunkH)
