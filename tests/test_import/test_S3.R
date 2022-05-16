
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


# Test a very basic scenario. The first test in a test sequence should test
# that relevant functions have not been imported before the sequence starts.
test_that("S3 methods are registered", {
  expect_error( test_fun("OK") )
  expect_silent( import::from("module_S3.R", "test_fun", .S3=TRUE) )
  expect_identical( test_fun(1), structure("numeric", class="test_class") )
  expect_identical( test_fun("1"), structure("character", class="test_class") )
  expect_output( print(test_fun(1)), "numeric" )
  expect_output( print(test_fun("OK")), "character" )
  cleanup_environment()
})

test_that("S3 methods are not registered when .S3=FALSE", {
  expect_error( test_fun("OK") )
  expect_silent( import::from("module_S3.R", "test_fun", .S3=FALSE) )
  expect_error( test_fun("OK") )
  cleanup_environment()
})


## Test import::here and import::into
test_that("S3 methods are registered when import::here is used ", {
  expect_error( test_fun(1) )
  expect_silent( import::here("module_S3.R", "test_fun", .S3=TRUE) )
  expect_identical( test_fun(1), structure("numeric", class="test_class") )
  expect_output( print(test_fun(1)), "numeric" )
  cleanup_environment(cleanup_here=TRUE)
})

test_that("S3 methods are registered when import::into is used ", {
  expect_error( test_fun(1) )
  expect_silent( import::into("custom_env", "test_fun", .from="module_S3.R", .S3=TRUE) )
  expect_identical( test_fun(1), structure("numeric", class="test_class") )
  expect_output( print(test_fun(1)), "numeric" )
  cleanup_environment("custom_env")
})

## Tests end


## IMPORTANT:
## The following line must be printed exactly as is,
## it is used by the custom harness to check if the tests worked:
print("Import tests completed successfully ...")

