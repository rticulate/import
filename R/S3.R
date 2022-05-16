#' Register S3 method
#'
#' Detected if `x` is an S3 method and if so, register it in an environment.
#'
#' Given the ambiguity in class and method names, here we detect only
#' the canonical form `generic.class` methods (or `generic.class.name` to
#' allow for `data.frame` methods). This ambiguity cannot be sufficiently
#' resolved given that both class and generic can contain dots in their names.
#' Take for an example `t.data.frame` and `t.test.matrix` and a hypothetical
#' (but valid) `t` generics for class `test.data.frame`.
#' Users should resolve possible ambiguity by registering the S3 manually.
#'
#' @param x a potential S3 method
#' @param env an environemnt in which `x` will be registered if `x` is an S3
#'   method.
#' @return information whether the object `x` is S3 class and name of itself
#'   derived generic and class names.
#'
#' @noRd
register_s3_method <- function(x, env){
  method <- base::get(x, envir=env)

  if(!is.function(method) || !utils::isS3method(x, envir=env))
    return(c(x, FALSE, NA, NA))

  parts <- unlist(strsplit(x, split=".", fixed=TRUE))
  generic <- parts[1]
  class <- paste(parts[-1], sep=".")

  registerS3method(generic, class, method, env)

  c(x, TRUE, generic, class)
}

#' Register S3 methods
#'
#' Find S3 methods in `x` and register them in an environment `env`.
#'
#' @param x a vector objects that might contain S3 methods
#' @param env an environment in which detected S3 methods from `x`
#'   will be registered
#' @return a data.frame containing information whether the objects in `x` are
#'   S3 methods and if so, the detected class and generics.
#'
#' @noRd
register_s3_methods <- function(x, env){
  methods <- lapply(x, register_s3_method, env=env)
  methods <- data.frame(do.call(rbind, methods))
  names(methods) <- c("function", "isS3", "generic", "class")
  methods
}
