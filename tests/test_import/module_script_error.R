if(is.na(Sys.getenv("SOMECONFIG", NA))) stop("SOMECONFIG not set!")
foo <- function(){
  "foo"
}
