## General
This is an update with the following features:

* There is a distinction between using double- and triple colon syntax;
  analalogue to using :: and ::: operators.
* If the package is attached (e.g. via library) there is a startup message
  informing the user that the package is not meant to be attached.
* It is only possible to use the functions with the `import::` / `import:::`
  syntax.

## Test environments
* local Windows installation (R 3.1.2)
* local Mac OS X (R 3.1.2)
* win-builder (devel and release)

## R CMD check results
There were no ERRORs or WARNINGs.

There was one NOTE:
  Components with restrictions and base license permitting such:
  MIT + file LICENSE
  File 'LICENSE':
    YEAR: 2015
    COPYRIGHT HOLDER: Stefan Milton Bache

## Downstream dependencies
There are no downstream dependencies.

## Other Notes:
The package's functionality may alter the search path, but this
is intended and should be clear for the user, as the main functionality 
is an alternative to using `library`. For example the call 

`import::from(parallel, makeCluster, parLapply)`

will make an "imports" entry in the search path and place the
imported there.


