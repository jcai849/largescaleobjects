#! /bin/sh

tmux new-session \; source-file `Rscript -e 'cat(system.file("demo-session.tmux", package="largescaleobjects"))'`