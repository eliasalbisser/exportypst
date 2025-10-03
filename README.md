# exportypst

Use typst to write your notes and export them to a single pdf. No need to worry about organizing.

Prerequisites:
- typst
- bash
- rsync

> 🚧 This is a **Work in Progress** Use at your own discretion! 🚧
>
> It is being tested out for real-world application at the moment and may change at any time.

## Usage

```
Usage: exportypst.sh [-h | --help] [ARGUMENT]... 

-h, --help        Display this help

export example    export pdf for the folder 'example'
export_all        export pdfs for all folders in project root

push exports      upload exported pdf to the remote

push files        upload relevant files to the remote
pull files        download relevant files from the remote
```

## What is this?

A script that takes `.typ` files from a folder and compiles them into a single `.pdf`

## Who is this for

Anyone looking to write notes on a subject and have it in one pdf.
While making this I was thinking of lecture notes you would take in a university course,
that is however but one simple use case.

## How can I use it?

```bash
./exportypst.sh export example
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

### `info.toml`

required fields are:
- title

And you write your notes e.g. `nvim my_course/notes/01-lecture.typ`
> Note that the files will be imported in the order of their file-names, so you should use a naming convention.
> I personally like to use the date e.g. `2025.08.10-lecture.typ`

Over the semester, you will likely end up with different files in your folder.

For that reason I chose to organise the notes into a subdirectory, and not directly in the course root.
This will help you to keep your files clean.

By running

```bash
./exportypst.sh export my_course
```

you will find the file in `./export/my_course.pdf`

*Alternatively* you can export all files at once by running

```bash
./exportypst.sh export_all
```

## Upload exported files

To make your life easier, helper functionality is implemented.

```
./exportypst.sh push exports
```

To use it take the following steps:
- `cp .env.examples .env`
- edit your `.env` to your liking
- edit your `exportypst.sh` to your liking 
    (you may need to establish a connection and close it, you can find it at the *top of the script*)
- `./upload.sh` to upload your files to your remote server

You can even exclude folders you do not need by appending them to the array in the `export_all.sh` script

## Upload the whole project

Instead of using git to commit all of your files, including attachments or books you need for your studies, upload them onto a remote server.

Use `./exportypst.sh push files` to do that.

> Follow the same steps as you did to upload exported files

*If you use multiple computers to take notes*, download from the remote with
Use `./exportypst.sh pull files` to do that.

### I use windows, what now?

You could try using [WSL](https://learn.microsoft.com/en-us/windows/wsl/install)

Run the script like this:

```
wsl -e ./exportypst.sh export my_course
```

> This has not been tested as I do not have access to a machine running windows
