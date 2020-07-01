
# We use the testthat library to evaluate expectations.
# Tests must nevertheless be run outside the standard testthat
# test harness, because import::from changes environments that
# are protected when run inside the harness. See the contents
# of the testthat directory to examine the custom test harness
# that is used instead. These tests can also be run manually.
library(testthat)

## Tests below
##
## Note that imported objects, as well as the contents of the
## import:::scripts environment must be cleaned up after each test.

# Imports from libraries should work
expect_error(normal_print("OK"))
import::from(knitr, normal_print)
expect_output(normal_print("OK"),"OK")
rm(list=ls(pos="imports"), pos="imports")
rm(list=ls(env=import:::scripts), pos=import:::scripts)

# Imports from modules should work
expect_error(fun1())
import::from("tests/testmodules/module1.R", fun1)
expect_equal(fun1(),"fun1")
rm(list=ls(pos="imports"), pos="imports")
rm(list=ls(env=import:::scripts), pos=import:::scripts)

# Passing values as characters should work
expect_error(normal_print("OK"))
char_package <- "knitr"
char_functions <- c("normal_print","knit_print")
import::from(char_package, char_functions, .character_only=TRUE)
expect_output(normal_print("OK"),"OK")
expect_output(knit_print("OK"),"OK")
rm(list=ls(pos="imports"), pos="imports")
rm(list=ls(env=import:::scripts), pos=import:::scripts)

# The .all parameter should work
expect_error(fun1())
import::from("tests/testmodules/module1.R", .all=TRUE)
expect_equal(fun1(),"fun1")
expect_equal(fun2(),"fun2")
rm(list=ls(pos="imports"), pos="imports")
rm(list=ls(env=import:::scripts), pos=import:::scripts)

# The .all parameter should work with individual objects for renaming
expect_error(fun1())
import::from("tests/testmodules/module1.R", hansolo=fun1, luke=fun6, .all=TRUE)
expect_equal(hansolo(),"fun1")
expect_equal(fun2(),   "fun2")
expect_equal(luke(),   "fun6")
rm(list=ls(pos="imports"), pos="imports")
rm(list=ls(env=import:::scripts), pos=import:::scripts)

# The .all and .except parameter should work together
expect_error(fun1())
import::from("tests/testmodules/module1.R", .all=TRUE, .except=c("fun2","fun3"))
expect_equal(fun1(),"fun1")
expect_error(fun2())
expect_error(fun3())
expect_equal(fun4(),"fun4")
rm(list=ls(pos="imports"), pos="imports")
rm(list=ls(env=import:::scripts), pos=import:::scripts)

# The .chdir parameter should be respected, default should be true
expect_error(fun_chdir_report())
import::from("tests/testmodules/module2chdir.R", fun_chdir_report)
expect_match(fun_chdir_report(),"tests/testmodules$")
rm(list=ls(pos="imports"), pos="imports")
rm(list=ls(env=import:::scripts), pos=import:::scripts)

# The .chdir parameter should be respected, if set to false no chdir performed,
# so the report should NOT match the name of the testmodule directory
expect_error(fun_chdir_report())
import::from("tests/testmodules/module2chdir.R", fun_chdir_report, .chdir=FALSE)
expect_failure(expect_match(fun_chdir_report(),"tests/testmodules$"))
rm(list=ls(pos="imports"), pos="imports")
rm(list=ls(env=import:::scripts), pos=import:::scripts)

# The following line must be printed exactly as is,
# it is used by the custom harness to check if the tests worked
print("Manual tests completed successfully ...")
