split-window ssh hadoop1 R --interactive; send-keys 'largerscale::locator_node("hadoop1", 9000L, verbose=T)' Enter
select-layout tiled
split-window ssh hadoop1 R --interactive; send-keys 'largerscale::worker_node("hadoop1", 9001L, "hadoop1", 9000L, verbose=T)' Enter
select-layout tiled
split-window ssh hadoop2 R --interactive; send-keys 'largerscale::worker_node("hadoop2", 9001L, "hadoop1", 9000L, verbose=T)' Enter
select-layout tiled
split-window ssh hadoop3 R --interactive; send-keys 'largerscale::worker_node("hadoop3", 9001L, "hadoop1", 9000L, verbose=T)' Enter
select-layout tiled
split-window ssh hadoop4 R --interactive; send-keys 'largerscale::worker_node("hadoop4", 9001L, "hadoop1", 9000L, verbose=T)' Enter
select-layout tiled
split-window ssh hadoop5 R --interactive; send-keys 'largerscale::worker_node("hadoop5", 9001L, "hadoop1", 9000L, verbose=T)' Enter
select-layout tiled
split-window ssh hadoop6 R --interactive; send-keys 'largerscale::worker_node("hadoop6", 9001L, "hadoop1", 9000L, verbose=T)' Enter
select-layout tiled
split-window ssh hadoop7 R --interactive; send-keys 'largerscale::worker_node("hadoop7", 9001L, "hadoop1", 9000L, verbose=T)' Enter
select-layout tiled
split-window ssh hadoop8 R --interactive; send-keys 'largerscale::worker_node("hadoop8", 9001L, "hadoop1", 9000L, verbose=T)' Enter

select-layout tiled
select-pane -t0; send-keys 'R && tmux kill-session' Enter 'source("taxi.R", echo=TRUE)' Enter
