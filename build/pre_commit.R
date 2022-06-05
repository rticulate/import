
## Build package, documentation, and readme (before commits)
{
  devtools::build()
  devtools::document()
  devtools::spell_check()
  devtools::build_readme()
  devtools::test()
  message("Pre-commit tasks completed")
}
