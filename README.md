# exportypst

Use typst to write your notes and export them to a single pdf. No need to worry about organizing.

Prerequisites:
- typst
- bash

## What is this?

A script that takes `.typ` files from a folder and compiles them into a single `.pdf`

## Who is this for

Anyone looking to write notes on a subject and have it in one pdf.
While making this I was thinking of lecture notes you would take in a university course,
that is however but one simple use case.

## How can I use in?

```bash
./export.sh example
```

Will create a folder `./export` containing the file `example.pdf`

See the `./example/` directory on how you _could_ structure your notes.
Seeing as this is a template, you are free to adjust it to your needs.

I chose to display a table of contents as well as a (literal) table with the contents the `info.toml` file,
but other people may regard this as unnecessary.

## How does it work?

In the project root, you create a folder

```bash
mkdir my_course
```

You have some info on the course. e.g. its title you want to display.
That info goes into the `./my_course/info.toml` file

And you write your notes e.g. `nvim my_course/01-lecture.typ`
> Note that the files will be imported in the order of their file-names, so you should use a naming convention. I personally like to use the date e.g. `2025.08.10-lecture.typ`

You will end up with different files in your folder

By running

```bash
./export.sh my_course
```

you will find the file in `./export/my_course.pdf`

### I use windows, what now?

You could try using [WSL]()

Run the script like this:

```
wsl -e ./export.sh example
```

> This has not been tested, as I do not have access to a machine running windows
