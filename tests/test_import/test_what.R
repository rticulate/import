
# We use the testthat library to evaluate expectations.
# Tests must nevertheless be run outside the standard testthat
# test harness, because import::from changes environments that
# are protected when run inside the harness. See the contents
# of the testthat directory to examine the custom test harness
# that is used instead. These tests can also be run manually.
library(testthat)

# Printing the directory helps with fixing any problems if tests fail
print(getwd())

# Source cleanup script
# (we do not use import::from because then the script would clean itself up)
source("cleanup_environment.R")

## IMPORTANT:
## Remember to run the cleanup script after each test sequence with:
## > cleanup_environment()


## Tests begin


test_that("Listing imports from libraries works", {
  # (also verifies that nothing is actually imported)
  normal_print("OK") |> expect_error()
  import::what(knitr) |> expect_contains("normal_print")
  normal_print("OK") |> expect_error()
})

test_that("Listing imports from modules works", {
  # (also verifies that nothing is actually imported)
  fun1() |> expect_error()
  import::what(module_base.R) |> expect_contains("fun1")
  fun1() |> expect_error()
})

test_that("Listing imports from subsequent modules works", {
  import::what(module_base.R) |> expect_contains("fun1")
  import::what(module_subsequent.R) |> expect_contains("fun7")
})

test_that("Passing values as characters works", {
  char_package   <- "knitr"
  import::what(char_package, .character_only=TRUE) |>
    expect_contains("normal_print") |>
    expect_contains("knit_print")
})

test_that("Specifying modules by absolute path works", {
  abs_module <- file.path(tempdir(),"module_base.R")
  file.copy("module_base.R",abs_module)
  import::what(abs_module, .character_only=TRUE) |>
    expect_contains("fun1")
})

test_that("import:::what() throws an error", {
  # import::what() relies on `.all`, which is not implemented for private functions
  import::what(knitr) |> expect_contains("normal_print")
  import:::what(knitr) |> expect_error()
})

test_that("Specifying .into/.all/.except throws an error", {
  import::what(knitr, .into = "custom_env") |>
    expect_error("Unexpected arguments")
  import::what(knitr, .into={environment()}) |>
    expect_error("Unexpected arguments")
  import::what(knitr, .all = TRUE) |>
    expect_error("Unexpected arguments")
  import::what(knitr, .except = "normal_print") |>
    expect_error("Unexpected arguments")
})

test_that("Listing imports from libraries NOT defined in .libPaths works", {
  # This is tested in test_from.R to avoid installing the package twice,
  # since installation takes over a second
})

test_that("Script errors are caught and allow manual retry", {
  Sys.getenv("SOMECONFIG", NA) |> is.na() |> expect_true()
  import::what(module_script_error.R) |>
    expect_error("Failed to import")
  Sys.setenv("SOMECONFIG"="any")
  import::what(module_script_error.R) |>
    expect_contains("foo")
  Sys.unsetenv("SOMECONFIG")
  cleanup_environment()
})

## Tests end


## IMPORTANT:
## The following line must be printed exactly as is,
## it is used by the custom harness to check if the tests worked:
print("Import tests completed successfully ...")
