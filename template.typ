#if "directory_name" not in sys.inputs.keys() {
  panic("DIRECTORY NAME NOT SPECIFIED")
}
#let directory_name = sys.inputs.at("directory_name")

#include "/style.typ"

// import info from directory
#let info = toml(directory_name + "/info.toml")

// show e.g. the name of the course as title
= #info.at("title")

// showing the info from info.toml
#let cells = ()
#for (k, v) in info {
  cells.push(
    table.cell(x: 0, str(k))
  )
  cells.push(
    table.cell(x: 1, str(v))
  )
}
#table(
  columns: 2,
  ..cells
)
#pagebreak()

// show table of contents
#outline()

#include directory_name + "/.export.typ"
