
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


# Test every combination of into parameters
# Demonstrates that .character_only has no effect on .into processing
test_that(".into all combinations", {

  # Abbreviations
  ce <- cleanup_environment
  ee <- expect_error
  es <- expect_silent
  eo <- expect_output

  aaa <- "my_named_env"

  ne1 <- new.env(); ne2 <- new.env()
  ee(normal_print("OK"));      es(import::from( knitr ,  normal_print , .into="a",   .character_only=FALSE));  eo(normal_print("OK"));     ce("a")
  ee(normal_print("OK"));      es(import::from( knitr ,  normal_print , .into=aaa,   .character_only=FALSE));  eo(normal_print("OK"));     ce(aaa)
  ee(ne1$normal_print("OK"));  es(import::from( knitr ,  normal_print , .into={ne1}, .character_only=FALSE));  eo(ne1$normal_print("OK")); rm(ne1)
  ee(ne2$normal_print("OK"));  es(import::from( knitr ,  normal_print , .into=ne2,   .character_only=FALSE));  eo(ne2$normal_print("OK")); rm(ne2)

  ne1 <- new.env(); ne2 <- new.env()
  ee(normal_print("OK"));      es(import::from("knitr", "normal_print", .into="a",   .character_only=TRUE));   eo(normal_print("OK"));     ce("a")
  ee(normal_print("OK"));      es(import::from("knitr", "normal_print", .into=aaa,   .character_only=TRUE));   eo(normal_print("OK"));     ce(aaa)
  ee(ne1$normal_print("OK"));  es(import::from("knitr", "normal_print", .into={ne1}, .character_only=TRUE));   eo(ne1$normal_print("OK")); rm(ne1)
  ee(ne2$normal_print("OK"));  es(import::from("knitr", "normal_print", .into=ne2,   .character_only=TRUE));   eo(ne2$normal_print("OK")); rm(ne2)

})

test_that("Import .into works well with .character_only", {

  expect_error ( normal_print("OK")                )

  # With
  expect_error( import::from(knitr, normal_print, .into=test_pkg) )
  expect_silent( import::from(knitr, normal_print, .into="test_pkg") )

  # Importing to named environment without quotes fails, even without .character_only
  expect_error(import::from(module_base.R, fun1, .into=test_pkg))

  # It succeeds if quoted
  expect_silent(import::from(module_base.R, fun1, .into="test_pkg"))

  # With import-symbols fix, it also succeeds with pasted strings
  expect_silent(import::from(module_base.R, fun2, .into=paste0("test_pkg")))

  # And regardless of whether one uses .character_only=TRUE/FALSE
  expect_silent(import::from(paste0("module_base.R"), paste0("fun3"),
                             .into=paste0("test_pkg"), .character_only=TRUE))


  expect_output( normal_print("OK"), "OK"          )
  cleanup_environment("test_pkg")
  cleanup_environment()
})

test_that("Const-character named environments work", {
  expect_error ( normal_print("OK")                )
  expect_silent( import::from(knitr, normal_print, .into="custom_named") )
  expect_output( normal_print("OK"), "OK"          )
  cleanup_environment("custom_named")
})

test_that("Symbol-character environments work", {
  expect_error ( normal_print("OK")                )
  expect_silent( import::from(knitr, normal_print, .into=paste0("custom_named", "_dynamic") ))
  expect_output( normal_print("OK"), "OK"          )
  cleanup_environment("custom_named_dynamic")
})

test_that("Unnamed environments work with curlies", {
  my_env <- new.env()
  expect_error ( my_env$normal_print("OK")                )
  expect_silent( import::from(knitr, normal_print, .into={my_env}))
  expect_output( my_env$normal_print("OK"), "OK"          )
  rm(my_env)
})

# After making .into a regular parameter, unnamed environments DO work with curlies
test_that("Unnamed environments DO work without curlies", {
  my_env <- new.env()
  expect_error ( my_env$normal_print("OK")                )
  expect_silent( import::from(knitr, normal_print, .into=my_env))
  expect_output( my_env$normal_print("OK"), "OK"          )
  rm(my_env)
})


## Tests end


## IMPORTANT:
## The following line must be printed exactly as is,
## it is used by the custom harness to check if the tests worked:
print("Import tests completed successfully ...")

