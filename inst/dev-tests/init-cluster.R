library(largescaleobjects)

init_locator("hadoop1", 9000L)
Sys.sleep(2)
init_worker("hadoop2", 9001L)
init_worker("hadoop3", 9001L)
init_worker("hadoop4", 9001L)
init_worker("hadoop5", 9001L)
init_worker("hadoop6", 9001L)
init_worker("hadoop7", 9001L)
Sys.sleep(2)

x <- chunknet::push(1:100)
chunknet::pull(x)
