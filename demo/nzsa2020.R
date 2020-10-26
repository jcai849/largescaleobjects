host = "localhost"
scriptloc = "tmp/script.R"
pid = system(paste("ssh", host, 
		   "'", 
			   "nohup Rscript", scriptloc, 
			   ">/dev/null 2>&1 </dev/null & echo $!", 
		   "'"), 
	     intern = TRUE)


system(paste("ssh", host, "kill", pid))
