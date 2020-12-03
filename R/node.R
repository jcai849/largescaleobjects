# Class structure
#
#	Node
#      /    \
# Master    Worker
#
node <- function(host="localhost", objectPort=9012L, commPort=6379L,
		 commPass=NULL, nodeName=name(type="node")) {
	n <- structure(new.env(args), class = "node")
	host(n) <- host
	objectPort(n) <- objectPort
	commPort(n) <- commPort
	commPass(n) <- commPass
	name(n) <- nodeName
	n
}

master <- function(objectPort=9012L, commPort=6379L, commPass=NULL,
		   nodeName=name(type="node")) {
	n <- node(host=Sys.info()["nodename"], objectPort=objectPort,
		  commPort=commPort, commPass=commPass, nodeName=nodeName)
	class(n) <- c("master", class(n))
	store(n)
	n
}

worker <- function(host="localhost", objectPort=9012L, 
		   user=NULL, password=NULL, 
		   commPort=commPort(getMaster()),
		   commPass=commPass(getMaster()),
		   nodeName=name(type="node")) {
	n <- node(host=host, objectPort=port, commPort=commPort,
		  commPass=commPass, nodeName=nodeName)
	class(n) <- c("worker", class(n))
	user(n) <- user
	password(n) <- password
	n
}

is.node <- isA("node")
is.master <- isA("master")
is.worker <- isA("worker")

init.node <- function(x, ...) # copy stuff from demo, see doRedis as well

print.node <- function(x, ...)
	cat("Node at host ", format(host(x)), 
	    " and port ", format(port(node)), 
	    if (is.null(user(x))) " with default user" else 
		    paste0(" with username ", format(user(x))),
	    if (is.null(password(x))) " and default password" else 
		    paste(" and password ", format(password(x))),
	    " with nodename ", name(node),
	    "\n")

`host<-.node`		<- envSet("HOST")
`objectPort<-.node`	<- envSet("OBJECT_PORT")
`commPort<-.node`	<- envSet("COMM_PORT")
`commPass<-.node`	<- envSet("COMM_PASS")
`name<-.node`		<- envSet("NAME")

host.node		<- envGet("HOST")
objectPort.node		<- envGet("OBJECT_PORT")
commPort.node		<- envGet("COMM_PORT")
commPass.node		<- envGet("COMM_PASS")
name.node		<- envGet("NAME")

`user<-.worker`		<- envSet("USER")
`password<-.worker`	<- envSet("PASSWORD")
`masterHost<-.worker`	<- envSet("MASTER_HOST")

user.worker		<- envGet("USER")
password.worker		<- envGet("PASSWORD")
masterHost.worker	<- envGet("MASTER_HOST")
