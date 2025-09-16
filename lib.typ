// define elements and functions that you want to re-use across your notes

#let homework(
  due_date: datetime,
  link: str,
  content
) = [
  #place(center)[
    #box(
      width: 35%,
      height:20%, 
    )[
      #grid(
        rows: (20%, 80%),
        fill: red,
      )[
        #grid.cell()[
          #place(left)[Due date: #due_date.display()]
          #place(right)[#link(link)[Link]]
        ]
        #grid.cell(content)
      ]
    ]
  ]
]
