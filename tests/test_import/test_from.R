
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


test_that("Imports from libraries work", {
  expect_error ( normal_print("OK") )
  expect_silent( import::from(knitr, normal_print) )
  expect_output( normal_print("OK"), "OK" )
  cleanup_environment()
})

test_that("Imports from libraries NOT defined in .libPaths work", {
  tmp_install_dir = tempdir()
  system("R CMD build packageToTest")
  install.packages('packageToTest_0.1.0.tar.gz', lib = tmp_install_dir, repos = NULL, type = 'source')
  expect_true( 'packageToTest' %in% list.files(tmp_install_dir) )
  expect_silent( import::from(.from = packageToTest, .library = tmp_install_dir, hello) )
  expect_equal(hello(), "Hello, world!")
})

test_that("Imports from modules work", {
  expect_error ( fun1() )
  expect_silent( import::from(module_base.R, fun1) )
  expect_equal ( fun1(), "fun1" )
  cleanup_environment()
})

test_that("Passing values as characters works", {
  char_package   <- "knitr"
  char_functions <- c("normal_print","knit_print")
  expect_error ( normal_print("OK") )
  expect_silent( import::from(char_package, char_functions, .character_only=TRUE) )
  expect_output( normal_print("OK"), "OK" )
  expect_output( knit_print("OK"),   "OK" )
  cleanup_environment()
})

test_that("Importing modules by absolute path works", {
  abs_module <- file.path(tempdir(),"module_base.R")
  file.copy("module_base.R",abs_module)
  expect_error ( fun1() )
  expect_silent( import::from(abs_module, "fun1", .character_only=TRUE) )
  expect_equal ( fun1(), "fun1" )
  cleanup_environment()
})

test_that("The .all parameter works", {
  expect_error ( fun1() )
  expect_silent( import::from(module_base.R, .all=TRUE) )
  expect_equal ( fun1(), "fun1" )
  expect_equal ( fun2(), "fun2" )
  cleanup_environment()
})

# The .all parameter should work with individual objects for renaming
# Renamed functions should not be found under their original names
test_that("The .all parameter works with renamings", {
  expect_error ( fun1() )
  expect_silent( import::from(module_base.R, hansolo=fun1, luke=fun6, .all=TRUE) )
  expect_equal ( hansolo(), "fun1" )
  expect_equal ( fun2(),    "fun2" )
  expect_equal ( luke(),    "fun6" )
  expect_error ( fun1()            )
  expect_error ( fun6()            )
  cleanup_environment()
})

test_that("The .all and .except parameters work together", {
  expect_error ( fun1() )
  expect_silent( import::from(module_base.R, .all=TRUE, .except=c("fun2","fun3")) )
  expect_equal ( fun1(), "fun1" )
  expect_error ( fun2()         )
  expect_error ( fun3()         )
  expect_equal ( fun4(), "fun4" )
  cleanup_environment()
})

test_that("The .all parmeter is smart about whether .except is being used", {
  expect_error ( fun1() )
  expect_silent( import::from(module_base.R, .except=c("fun1","fun4")) )
  expect_error ( fun1()         )
  expect_equal ( fun2(), "fun2" )
  expect_equal ( fun3(), "fun3" )
  expect_error ( fun4()         )
  expect_equal ( fun5(), "fun5" )
  expect_equal ( fun6(), "fun6" )
  cleanup_environment()
})

test_that("Using .all or .except with import::: should throw an error", {
  expect_error( import:::from(module_base.R, .all=TRUE) )
  expect_error( import:::from(module_base.R, .except=c("fun1","fun4")) )
  expect_error( import:::from(module_base.R, .all=TRUE, .except=c("fun2","fun3")) )
  cleanup_environment()
})

test_that("The .into paremeter is honored", {
  expect_error ( normal_print("OK") )
  expect_silent( import::from(knitr, normal_print, .into="custom_env") )
  expect_output( normal_print("OK"), "OK" )
  cleanup_environment("custom_env")
})

test_that("Importing .into={....} (curly brackets) works", {
  expect_error ( normal_print("OK") )
  expect_false ( "normal_print" %in% ls() )
  expect_silent( import::from(knitr, normal_print, .into={environment()}) )
  expect_output( normal_print("OK"), "OK" )
  expect_true  ("normal_print" %in% ls() )
  cleanup_environment(cleanup_here=TRUE)
})


test_that("Importing .into=\"\" (empty string) works", {
  expect_error ( normal_print("OK") )
  expect_false ( "normal_print" %in% ls() )
  expect_silent( import::from(knitr, normal_print, .into="") )
  expect_output( normal_print("OK"), "OK" )
  expect_true  ("normal_print" %in% ls() )
  cleanup_environment(cleanup_here=TRUE)
})



test_that("Imports from specific version work",{

  # Base case, no version
  expect_silent( import::from(magrittr, "%>%") )# no version, quotes are unnecessary.

  # Variable spacing before parenthesis or around comparator operator
  expect_silent( import::from("magrittr (>=1.5)", "%>%")      )
  expect_silent( import::from("magrittr(>= 1.5)", "%>%")      )
  expect_silent( import::from("magrittr( >=1.5)", "%>%")      )
  expect_silent( import::from("magrittr  (  >=1.5  )", "%>%")      )

  # Variable specificity
  expect_silent( import::from("magrittr(>=1)", "%>%")   )
  expect_silent( import::from("magrittr(>=1.5)", "%>%")      )
  expect_silent( import::from("magrittr(>=1.5.0)", "%>%")      )

  # Maximum version
  expect_silent( import::from("magrittr(<= 100.0.1)", "%>%") )

  # Non-equality
  expect_silent( import::from("magrittr(!= 1.0.1)", "%>%")    )
  expect_silent( import::from("magrittr(!= 1.0.1)", "%>%")   )

  # Cleanup before testing failures
  cleanup_environment()

  # If the version is not available, the import should fail with erro
  # Variable spacing before parenthesis or around comparator operator
  expect_error( import::from("magrittr (>=100.5)", "%>%")      )
  expect_error( import::from("magrittr(>= 100.5)", "%>%")      )
  expect_error( import::from("magrittr( >=100.5)", "%>%")      )
  expect_error( import::from("magrittr  (  >=100.5  )", "%>%")      )

  # Variable specificity
  expect_error( import::from("magrittr(>=100)", "%>%")   )
  expect_error( import::from("magrittr(>=100.5)", "%>%")      )
  expect_error( import::from("magrittr(>=100.5.0)", "%>%")      )

  # Maximum version
  expect_error( import::from("magrittr(<= 0.0.1)", "%>%") )


  # Test equality/non-equality with the version currently installed
  # (1.5.0 at time of writing. The test could be updated to choose an
  # available version automatically, but we'll put that on the backburner
  # for now. So we skip these tests when running automatically.)
  skip("It is too fragile to test specific versions")

  # Non-equality
  expect_error( import::from("magrittr(!= 1.5)", "%>%")    )
  expect_error( import::from("magrittr(!= 1.5.0)", "%>%")   )

  # Equality
  expect_silent( import::from("magrittr(== 1.5)", "%>%") )
  expect_silent( import::from("magrittr(== 1.5.0)", "%>%") )
  expect_silent( import::from("magrittr(1.5)", "%>%")    )  # same as (==1.5)
  expect_silent( import::from("magrittr(1.5.0)", "%>%")    )
})

## .chdir parameter is tested in a separate file (test_param_chdir.R)


## Tests end


## IMPORTANT:
## The following line must be printed exactly as is,
## it is used by the custom harness to check if the tests worked:
print("Import tests completed successfully ...")
