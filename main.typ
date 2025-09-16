#import "/template.typ": *
#include "/lib.typ"

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

// style your document here
#set page(
  paper: "a4",
  header: [
    #align(left, info.title)
  ],
  footer: context[
    #align(
      right,
      counter(page).display("1/1", both: true),
    )
  ],
)

// table of contents
#outline()

#include directory_name + "/.export.typ"
