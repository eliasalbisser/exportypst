// when wanting to use any function from lib.typ, import it as follows
#import "/lib.typ": *

= Second Lecture

$ A or B $

#figure(
  // IMPORTANT: move one directory upwards
  image("../attachments/golden_ratio.svg", width: 40%),
  caption: [Graphic Describing the Golden Ratio],
)

// function from lib.typ
#homework("2025-01-03", "https://en.wikipedia.org/wiki/Logic")[
  Write notes on Formal Logic
]
