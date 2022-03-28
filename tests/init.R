library(largescaler)

init_locator("localhost", 9000L)
Sys.sleep(2)
init_worker("localhost", 9001L)
init_worker("localhost", 9002L)
init_worker("localhost", 9003L)
Sys.sleep(2)

x <- largerscale::push(1:100)
pull(x)
