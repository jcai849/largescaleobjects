# Class structure
#
#	   Node
#          / \
# commServer compute
#

node <- function(host="localhost", commPort=6379L, commPass=NULL,
		 nodeName=name(type="node")) {
	n <- structure(new.env(args), class = "node")
	host(n) <- host
	commPort(n) <- commPort
	commPass(n) <- commPass
	name(n) <- nodeName
	n
}

commServer <- function(host="localhost", commPort=6379L, commPass=NULL,
		       nodeName=name(type="node")) {
	n <- node(host=host, commPort=commPort, commPass=commPass,
		  nodeName=nodeName)
	class(n) <- c("commServer", class(n))
	n
}

computeNode <- function(host="localhost",
			user=NULL, password=NULL,
			objectPort=9012L, commPort=6379L, commPass=NULL,
			nodeName=name(type="node")) {
	n <- node(host=host, commPort=commPort, commPass=commPass,
		  nodeName=nodeName)
	objectPort(n) <- objectPort
	class(n) <- c("computeNode", class(n))
	n
}

startQueues <- function() {
	q <- rediscc::redis.get(conn(), "START_QUEUES", list=TRUE)
	lapply(q, as.queue)
}

is.node <- isA("node")
is.commServer <- isA("commServer")

init.node <- function(x, ...) # copy stuff from demo, see doRedis as well

print.node <- function(x, ...)
	cat("Node at host ", format(host(x)), 
	    " and port ", format(port(node)), 
	    " with nodename ", name(node),
	    "\n")

`host<-.node`		<- envSet("HOST")
`commPort<-.node`	<- envSet("COMM_PORT")
`commPass<-.node`	<- envSet("COMM_PASS")
`name<-.node`		<- envSet("NAME")

host.node		<- envGet("HOST")
commPort.node		<- envGet("COMM_PORT")
commPass.node		<- envGet("COMM_PASS")
name.node		<- envGet("NAME")

`objectPort<-.computeNode`<- envSet("OBJECT_PORT")
objectPort.computNode	<- envGet("OBJECT_PORT")

`user<-.computeNode`	<- envSet("USER")
`password<-.computeNode`<- envSet("PASSWORD")

user.computeNode	<- envGet("USER")
password.computeNode	<- envGet("PASSWORD")

as.queue <- function(x) {
	class(x) <- "queue"
	name(x) <- x
	x
}
`name<-.queue` <- function(x, value) {
	attr(x, "name") <- value
	x
}
name.queue <- function(x) attr(x, "name", exact=TRUE)
