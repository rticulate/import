
<img src="https://import.rticulate.org/articles/import.png" align="right" alt="" width="120" />

<!-- badges: start -->

[![CRAN
status](https://www.r-pkg.org/badges/version/import)](https://CRAN.R-project.org/package=import)
[![CRAN status
shields](https://img.shields.io/badge/Git-1.3.0.9003-success)](https://github.com/rticulate/import)
[![R build
status](https://github.com/rticulate/import/workflows/R-CMD-check/badge.svg)](https://github.com/rticulate/import/actions)
<!-- badges: end -->

# An Import Mechanism For R

The import package is intended to simplify the way in which functions
from external packages or modules are made available for use in R
scripts. Learn more on the [package
website](https://import.rticulate.org/), by reading
[`vignette("import")`](https://import.rticulate.org/articles/import.html),
or using the help (`?import::from`).

## Introduction

The typical way of using functionality exposed by a package in R scripts
is to load (and attach) the entire package with `library()` (or
`require()`). This can have the **undesirable effect of masking
objects** in the user’s search path and can also make it difficult and
**confusing to identify** what functionality comes from which package
when using several `library` statements.

The `import` package provides a simple alternative, allowing the user
specify in a concise way exactly which objects. For example, the `Hmisc`
package exposes over four hundred functions. Instead of exposing all of
those functions, someone who only needs access to, say the `impute()`
and the `nomiss()` functions, can import those functions only:

``` r
import::from(Hmisc, impute, nomiss)
```

For more on the motivation behind the package, see
[vignette(“import”)](https://import.rticulate.org/articles/import.html)

## Installation

To install `import` from CRAN:

``` r
install.packages("import")
```

You can also install the development version of `import` from GitHub
using `devtools`:

``` r
devtools::install_github("rticulate/import")
```

## Usage

### Importing functions from R packages

The most basic use case is to import a few functions from package (here
the `psych` package):

``` r
import::from(psych, geometric.mean, harmonic.mean)
geometric.mean(trees$Volume)
```

If one of the function names conflicts with an existing function (such
as `filter` from the `dplyr` package) it is simple to rename it:

``` r
import::from(dplyr, select, arrange, keep_when = filter)
keep_when(mtcars, hp>250)
```

Use `.all=TRUE` to import all functions from a package. If you want to
rename one of them, you can still do that:

``` r
import::from(dplyr, keep_when = filter, .all=TRUE)
```

To omit a function from the import, use `.except` (which takes a
character vector):

``` r
import::from(dplyr, .except=c("filter", "lag"))
```

Note that `import` tries to be smart about this and assumes that if you
are using the `.except` parameter, you probably want to import
everything you are *not* explicitly omitting, and sets the `.all`
parameter to `TRUE`. You can still override this in exceptional cases,
but you seldom need to.

These and other examples are discussed in more detail in the [Importing
from Packages](articles/import.html#importing-from-packages) section of
the package vignette.

### Importing Functions from “Module” Scripts

The `import` package allows R files to be used as “modules” from which
functions are loaded. For example, the file
[sequence_module.R](https://raw.githubusercontent.com/rticulate/import/master/man/examples/sequence_module.R)
contains several functions calculating terms of mathematical sequences.
It is possible to import from such files, just as one imports from
packages:

``` r
import::from(sequence_module.R, fibonacci, square, triangular)
```

Renaming, as well as the `.all` and `.except` parameters, work in the
same way as for packages:

``` r
import::from(sequence_module.R, fib=fibonacci, .except="square")
```

These and other examples are discussed in more detail in the [Importing
from
Modules](articles/import.html#importing-functions-from-module-scripts)
section of the package vignette.

### Choosing where import looks for packages or modules

The `import` package will by default use the current set of library
paths, i.e. the result of `.libPaths()`. It is, however, possible to
specify a different set of library paths using the `.library` argument
in any of the `import` functions, for example to import packages
installed in a custom location, or to remove any ambiguity as to where
imports come from.

Note that in versions up to and including `1.3.0` this defaulted to use
only the *first* entry in the library paths,
i.e. `.library=.libPaths()[1L]`. We believe the new default is
applicable in a broader set of circumstances, but if this change causes
any issues, we would very much appreciate hearing about it.

When importing from a module (.R file), the directory where `import`
looks for the module script can be specified with the with `.directory`
parameter. The default is `.` (the current working directory).

### Choosing where the imported functions are placed

By default, imported objects are placed in a separate entity in the
search path called “imports”. One can also specify which names to use in
the search path and use several to group imports:

``` r
import::from(magrittr, "%>%", "%$%", .into = "operators") 
import::from(dplyr, arrange, .into = "datatools")
```

If using custom search path entities actively, one might prefer the
alternative syntax (which does the same but reverses the argument
order):

``` r
import::into("operators", "%>%", "%$%", .from = magrittr)
import::into("datatools", arrange, .from = dplyr)
```

If it is desired to place imported objects in the current environment,
use `import::here()`:

### More advanced usage

The `import` package is designed to be simple to use for basic cases, so
it uses symbolic evaluation to allow the names of packages, modules and
functions to be entered without quotes (except for operators, such as
`"%>%"` which must be quoted). However, this means that it calling a
variable containing the name of a module, or a vector of functions to
import, will not work. For this use case, you can use the
`.character_only` parameter:

``` r
module_name <- "../utils/my_module.R"

# Will not work (import will look for a package called "module_name")
import::from(module_name, foo, bar)

# This will correctly import the foo() and bar() functions from "../utils/my_module.R"
import::from(module_name, foo, bar, .character_only=TRUE)
```

The `.character_only` parameter is covered in more detail in the
[Advanced Usage](articles/import.html#advanced-usage) section of the
package vignette, which also describes how you can import from module
scripts stored online with the help of the `pins` package, or achieve
python-like imports with the help of `{}` notation for environments in
the `.into` parameter.

# Contributing

Contributions to this project are welcome. Please start by opening an
issue or discussion thread. New features are added conservatively based
on supply (is anyone willing to contribute an implementation of the
feature?), demand (how many people seem to need a new feature?), and
last, but not least, by whether a feature can be implemented without
breaking backwards compatibility.

-   Created and authored by [@smbache](https://github.com/smbache)
-   Currently maintained by [@torfason](https://github.com/torfason)
-   Code contributions by [@awong234](https://github.com/awong234),
    [@brshallo](https://github.com/brshallo),
    [@flying-sheep](https://github.com/flying-sheep),
    [@hutch3232](https://github.com/hutch3232),
    [@J-Moravec](https://github.com/J-Moravec),
    [@klmr](https://github.com/klmr),
    [@mschilli87](https://github.com/mschilli87)

*(Did we forget to add you? If so, please let us know!)*

# See also:

-   Some of the use cases for `import` can now be handled directly in
    base R using the new `exclude` and `include.only` arguments of
    `library()` and `require()`
-   For an interesting but slightly different idea of Python-like
    modules for R, see the [modules](https://github.com/klmr/modules)
    package by [@klmr](https://github.com/klmr).
-   Another approach, focused on treating the use of functions with
    naming conflicts as explicit errors is the
    [conflicted](https://github.com/r-lib/conflicted) package by
    [@hadley](https://github.com/hadley).
