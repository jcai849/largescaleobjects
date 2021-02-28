userProcess(host=	"localhost",
	    port=	port())

logProcess(host=	"localhost",
	   port=	514L,
	   execute=	FALSE)

commsProcess(host=	"localhost",
	     port=	6379L,
	     execute=	FALSE)

workerProcess(host=	"localhost",
	      port=	port(),
	      execute=	TRUE)

workerProcess(host=	"localhost",
	      port=	port(),
	      execute=	TRUE)

workerProcess(host=	"localhost",
	      port=	port(),
	      execute=	TRUE)
