split-window R --interactive
send-keys 'largescalechunks::locator_node("localhost", 8999L, verbose=T)' Enter
split-window R --interactive
send-keys 'largescalechunks::worker_node("localhost", 3434L, "localhost", 8999L, verbose=T)' Enter
split-window R --interactive
send-keys 'largescalechunks::worker_node("localhost", 4343L, "localhost", 8999L, verbose=T)' Enter
split-window R --interactive
send-keys 'largescalechunks::worker_node("localhost", 4433L, "localhost", 8999L, verbose=T)' Enter
select-layout tiled
select-pane -t0; send-keys 'R && tmux kill-session' Enter 'source("iris.R", echo=TRUE)' Enter
