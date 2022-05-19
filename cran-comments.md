## General

This is an update with the following features and fixes:

* import::from/into now support importing `.into` `symbol`s
* import::from/here/into can now support importing generics
* import::from/here/into now support importing hidden objects
* Fix where function `base::get` could be masked internally
* Several documentation improvements


## Test environments

* local Mac OS X (R 4.2.0)
* r-hub 
  * (Windows Server 2022, R-devel, 64 bit)
  * (Ubuntu Linux 20.04.1 LTS, R-release, GCC)
  * (Fedora Linux, R-devel, clang, gfortran)
* win-builder (devel R R-4.1.0 and release R-4.0.2)
* GitHub CE (macos, linux and windows)


## R CMD check results

There were no ERRORs or WARNINGs.

On r-hub.io Linux platforms and winbuilder, there were no NOTEs:

On r-hub.io, Windows Server 2022, R-devel, 64 bit platform, there was one note relating to MiKTeX:

    +---
    | * checking for detritus in the temp directory ... NOTE
    | Found the following files/directories:
    |   'lastMiKTeXException'
    +---

This note is not reproducible locally or on other platforms, and seems not to affect the output, because the check reports no errors related to the PDF version of the manual:

    #> * checking PDF version of manual ... OK


## Downstream dependencies - revdepcheck results

We checked 11 reverse dependencies (10 from CRAN + 1 from Bioconductor), comparing R CMD check results across CRAN and dev versions of this package.

 * We saw 0 new problems
 * We failed to check 0 packages


## Other Notes (unchanged since last release):

The package's functionality may alter the search path, but this is intended and should be clear for the user, as the main functionality is an alternative to using `library`. For example the call:

`import::from(parallel, makeCluster, parLapply)`

will make an "imports" entry in the search path and place the imported there.


