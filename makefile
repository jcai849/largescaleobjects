.PHONY: tags install test
all: install
install: /usr/local/lib/R/library/largescaler/
/usr/local/lib/R/library/largescaler/: R/* NAMESPACE DESCRIPTION
	R CMD INSTALL .
tags:
	uctags -R 
test:
	cd tests && tmux new-session \; source-file test.tmux
cluster-test:
	cd tests && tmux new-session \; source-file cluster-test.tmux
airline-test:
	cd tests && tmux new-session \; source-file airline-test.tmux
