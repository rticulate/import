
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


## into()

test_that("Imports from libraries work with into()", {
  expect_error ( normal_print("OK") )
  expect_silent( import::into("custom_env", normal_print, .from=knitr) )
  expect_output( normal_print("OK"), "OK" )
  cleanup_environment("custom_env")
})

test_that("Imports from libraries work with .into as a symbol", {
  expect_error ( normal_print("OK") )
  symbol_env <- "custom_env"
  expect_silent( import::into(symbol_env, normal_print, .from=knitr) )
  expect_output( normal_print("OK"), "OK" )
  expect_true  ("normal_print" %in% ls(name = symbol_env) )
  cleanup_environment("custom_env")
})

test_that("Imports from modules work with into()", {
  expect_error ( fun1() )
  expect_silent( import::into("custom_env", fun1, .from=module_base.R) )
  expect_equal ( fun1(), "fun1" )
  cleanup_environment("custom_env")
})


test_that("The .all parmeter with into() is smart about whether .except is being used", {
  expect_error ( fun1() )
  expect_silent( import::into("custom_env", .from=module_base.R, .except=c("fun1","fun4")) )
  expect_error ( fun1()         )
  expect_equal ( fun2(), "fun2" )
  expect_equal ( fun3(), "fun3" )
  expect_error ( fun4()         )
  expect_equal ( fun5(), "fun5" )
  expect_equal ( fun6(), "fun6" )
  cleanup_environment("custom_env")
})

## here()

test_that("Imports from libraries  work with here()", {
  expect_error ( normal_print("OK") )
  expect_silent( import::here(normal_print, .from=knitr) )
  expect_output( normal_print("OK"), "OK" )
  cleanup_environment(cleanup_here=TRUE)
})

test_that("Imports from modules work with here()", {
  expect_error ( fun1() )
  expect_silent( import::here(fun1, .from=module_base.R) )
  expect_equal ( fun1(), "fun1" )
  cleanup_environment(cleanup_here=TRUE)
})

test_that("Importing modules with here() by absolute path works", {
  abs_module <- file.path(tempdir(),"module_base.R")
  file.copy("module_base.R",abs_module)
  expect_error ( fun1() )
  expect_silent( import::here(abs_module, "fun1", .character_only=TRUE) )
  expect_equal ( fun1(), "fun1" )
  cleanup_environment(cleanup_here=TRUE)
})



## Tests end

## IMPORTANT:
## The following line must be printed exactly as is,
## it is used by the custom harness to check if the tests worked:
print("Import tests completed successfully ...")

