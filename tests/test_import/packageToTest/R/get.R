#' Function named get
#'
#' Used to test imports when a function named `get` is before the base package
#' on the search path.
#'
#' @export
get <- function(...) {
  stop("import incorrectly used function `get` exported from package: packageToTest")
}
