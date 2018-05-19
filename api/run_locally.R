library(plumber)
p = plumb("routes.R")
p$run(host = "0.0.0.0", port = 8000, swagger = T)
