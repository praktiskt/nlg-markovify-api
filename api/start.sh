#!/bin/bash
R -e 'r <- plumber::plumb("routes.R"); if(Sys.getenv("PORT") == "") Sys.setenv(PORT = 8000); r$run(host = "0.0.0.0", port=as.numeric(Sys.getenv("PORT")), swagger = T)'
