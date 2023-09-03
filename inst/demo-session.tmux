split-window R --interactive
send-keys 'library(largescaleobjects); largescalechunks::locator_node("localhost", 9000L, verbose=T)' Enter
split-window R --interactive
send-keys 'library(largescaleobjects); largescalechunks::worker_node("localhost", 9001L, "localhost", 9000L, verbose=T)' Enter
split-window R --interactive
send-keys 'library(largescaleobjects); largescalechunks::worker_node("localhost", 9002L, "localhost", 9000L, verbose=T)' Enter
split-window R --interactive
send-keys 'library(largescaleobjects); largescalechunks::worker_node("localhost", 9003L, "localhost", 9000L, verbose=T)' Enter
select-layout tiled
run-shell 'sleep 2'
select-pane -t0; send-keys 'R; tmux kill-session' Enter