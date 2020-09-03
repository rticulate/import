# Import utility function or package using import::from() is not recommended usage
import::from(knitr, normal_print)
import::from(module_recursive_inner.R, to_title)

print_title_text = function(text){
  normal_print(to_title(text))
}
