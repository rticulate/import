#' This package is not intended for use with `library`. It is named to make
#' calls like `import::from(pkg, fun1, fun2)` expressive. Using the `import`
#' functions complements the standard use of `library(pkg)`(when most objects
#' are needed, and context is clear) and `obj <- pkg::obj` (when only a single
#' object is needed).
#'
#' @docType package
#' @name import
#' @title An Import Mechanism for R
#' @author Stefan Milton Bache
#' @description This is an alternative mechanism for importing objects from
#'   packages. The syntax allows for importing multiple objects from a package
#'   with a single command in an expressive way. The `import` package bridges
#'   some of the gap between using `library` (or `require`) and direct
#'   (single-object) imports. Furthermore the imported objects are not placed in
#'   the current environment (although possible), but in a named entry in the
#'   search path.
#' @seealso For usage instructions and examples, see [`from`], [`into`], or
#'   [`here`].
#'
#'   Helpful links:
#'   * [https://rticulate.github.io/import](https://rticulate.github.io/import)
#'   * [https://github.com/rticulate/import](https://github.com/rticulate/import)
#'   * [https://github.com/rticulate/import/issues](https://github.com/rticulate/import/issues)
#'
#' @md
"_PACKAGE"
