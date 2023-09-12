split-window R --interactive; send-keys 'chunknet::locator_node("localhost", 8999L, verbose=T)' Enter

new-window   R --interactive; send-keys 'chunknet::worker_node("localhost", 9001L, "localhost", 8999L, verbose=T)' Enter
select-layout tiled
split-window R --interactive; send-keys 'chunknet::worker_node("localhost", 9002L, "localhost", 8999L, verbose=T)' Enter
select-layout tiled
split-window R --interactive; send-keys 'chunknet::worker_node("localhost", 9003L, "localhost", 8999L, verbose=T)' Enter
select-layout tiled
split-window R --interactive; send-keys 'chunknet::worker_node("localhost", 9004L, "localhost", 8999L, verbose=T)' Enter
select-layout tiled
split-window R --interactive; send-keys 'chunknet::worker_node("localhost", 9005L, "localhost", 8999L, verbose=T)' Enter
select-layout tiled
split-window R --interactive; send-keys 'chunknet::worker_node("localhost", 9006L, "localhost", 8999L, verbose=T)' Enter
select-layout tiled
split-window R --interactive; send-keys 'chunknet::worker_node("localhost", 9007L, "localhost", 8999L, verbose=T)' Enter
select-layout tiled
split-window R --interactive; send-keys 'chunknet::worker_node("localhost", 9008L, "localhost", 8999L, verbose=T)' Enter
select-layout tiled
split-window R --interactive; send-keys 'chunknet::worker_node("localhost", 9009L, "localhost", 8999L, verbose=T)' Enter
select-layout tiled

new-window   R --interactive; send-keys 'chunknet::worker_node("localhost", 9011L, "localhost", 8999L, verbose=T)' Enter
select-layout tiled
split-window R --interactive; send-keys 'chunknet::worker_node("localhost", 9012L, "localhost", 8999L, verbose=T)' Enter
select-layout tiled
split-window R --interactive; send-keys 'chunknet::worker_node("localhost", 9013L, "localhost", 8999L, verbose=T)' Enter
select-layout tiled
split-window R --interactive; send-keys 'chunknet::worker_node("localhost", 9014L, "localhost", 8999L, verbose=T)' Enter
select-layout tiled
split-window R --interactive; send-keys 'chunknet::worker_node("localhost", 9015L, "localhost", 8999L, verbose=T)' Enter
select-layout tiled
split-window R --interactive; send-keys 'chunknet::worker_node("localhost", 9016L, "localhost", 8999L, verbose=T)' Enter
select-layout tiled
split-window R --interactive; send-keys 'chunknet::worker_node("localhost", 9017L, "localhost", 8999L, verbose=T)' Enter
select-layout tiled
split-window R --interactive; send-keys 'chunknet::worker_node("localhost", 9018L, "localhost", 8999L, verbose=T)' Enter
select-layout tiled
split-window R --interactive; send-keys 'chunknet::worker_node("localhost", 9019L, "localhost", 8999L, verbose=T)' Enter
select-layout tiled

select-window -t0; select-pane -t0; send-keys 'R && tmux kill-session' Enter 'source("airline.R", echo=TRUE)' Enter
