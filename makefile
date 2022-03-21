.PHONY: tags install test
all: install test
install: /usr/local/lib/R/library/largescaler/
/usr/local/lib/R/library/largescaler/: R/* NAMESPACE DESCRIPTION
	R CMD INSTALL .
tags:
	uctags -R 
test:
	cd tests && ./test
