#import "/template.typ": *


#show: template

#let directory_name = get_directory_name()
#let info = get_info_dict()
// show e.g. the name of the course as title
= #info.at("title")

#show_info_table()
#pagebreak()

// show table of contents
#outline()

#include directory_name + "/.export.typ"
