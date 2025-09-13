#import "/template.typ": *


#show: template

#let directory_name = get_directory_name()
#let info = get_info_dict()

// show e.g. the name of the course as title
#align(
  center,
  text(
    weight: "semibold",
    size: 2.5em,
    info.at("title"),
  )
)

#show_info_table()
// put other content you want on the first page below this comment

#pagebreak()

// table of contents
#outline()

#include directory_name + "/.export.typ"
