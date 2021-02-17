#!/usr/local/bin/Rscript --vanilla

debug(largeScaleR::worker)
debug(largeScaleR::respond)

largeScaleR::worker(comms=structure(list(host='localhost', port=6379L, user=NULL,
					 pass=NULL, desc="comms", dbpass=NULL),
				    class=c("commsProcess", "process")), 
		    host='localhost',
		    port=largeScaleR::port(),
		    desc=largeScaleR::desc("process"),
		    stopOnError=TRUE,
		    verbose=TRUE)
