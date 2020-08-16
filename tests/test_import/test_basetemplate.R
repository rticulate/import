
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
test_that("Basic scenario works", {
  expect_error ( normal_print("OK")                )
  expect_silent( import::from(knitr, normal_print) )
  expect_output( normal_print("OK"), "OK"          )
  cleanup_environment()
})


## Tests end


## IMPORTANT:
## The following line must be printed exactly as is,
## it is used by the custom harness to check if the tests worked:
print("Import tests completed successfully ...")

