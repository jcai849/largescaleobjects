\name{newConnection}
\alias{newConnection}
\title{Generate a New Connection to a Given Host}
\description{
	Given a particular host, generates a new connection, starting up a
	server on the host if none currently running. Run purely for it's side
	effect of initiating a new connection.
}
\usage{
newConnection(hostName)
}
\arguments{
  \item{hostName}{A character vector of host names}
}
\author{
	Jason Cairns
}
\seealso{
\code{\link{attainNodes}}
}
\keyword{IO}% use one of  RShowDoc("KEYWORDS")
\keyword{file}% __ONLY ONE__ keyword per line
