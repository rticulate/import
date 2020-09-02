# Import utility function or package using import::here() is the recommended usage
import::here(knitr, normal_print)
import::here(module_recursive_inner.R, to_title)

print_title_text = function(text){
  normal_print(to_title(text))
}
