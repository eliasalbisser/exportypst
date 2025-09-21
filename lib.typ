// define elements and functions that you want to re-use across your notes

#let homework(
  due_date,
  link_address,
  content
) = {
    box(
      width: 35%,
      height: auto, 
      outset: 1em,
    )[
      #grid(
        rows: 3,
        columns: 2,
        fill: red,
        stroke: black,
        inset: 0.5em,
        grid.cell(x: 0, y: 0, rowspan: 2)[Homework],
        grid.cell(x: 1, y: 0)[Due: #due_date],
        grid.cell(x: 1, y: 1)[#text(fill: blue, link(link_address)[Link])],
        grid.cell(x: 0, y: 2, colspan: 2, content),

      )
    ]
}
