
# Return the nth term in the fibonacci sequence (starting with 1)
# This is not a very efficient implementation :-)
fibonacci <- function(n) {
  stopifnot(n>=1 && all.equal(n, as.integer(n)))
  ifelse(n>2, fibonacci(n-1) + fibonacci(n-2), 1)
}

# Return the nth square number
square <- function(n) {
  stopifnot(n>=1 && all.equal(n, as.integer(n)))
  n^2
}

# Return the nth triangular number
triangular <- function(n) {
  stopifnot(n>=1 && all.equal(n, as.integer(n)))
  n*(n+1)/2
}
