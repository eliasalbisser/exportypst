// any styles go into here
#let template = doc => {
  set heading(
    numbering: "1.",
  )

  doc
}

#let get_directory_name() = {
  if "directory_name" not in sys.inputs.keys() {
    panic("Please specify 'directory_name' with '--input=directory_name=example'")
  }
  sys.inputs.at("directory_name")
}

#let get_info_dict(
  directory_name: get_directory_name(),
  info_filename: "/info.toml"
) = {
  // import info from directory
  let info = toml(directory_name + info_filename)
  info
}

#let show_info_table(
  info_dict: get_info_dict()
) = {
  // showing the info from info.toml
  let cells = ()
  for (k, v) in info_dict {
    cells.push(
      table.cell(x: 0, str(k))
    )
    cells.push(
      table.cell(x: 1, str(v))
    )
  }
  table(
    columns: 2,
    ..cells
  )
}
