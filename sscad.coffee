fs = require 'fs'
path = require 'path'

INDENTATION_AMOUNT = 2

argv = process.argv[..]
if argv[2] is "-w"
  watch = true
  argv.splice(2, 1)

filename = path.resolve process.cwd(), argv[2]

unless filename?.match /\.sscad$/
  console.log "Usage: coffee sscad.coffee [-w] <filename.sscad>"
  process.exit 1

findNextLine = (lines, start) ->
  for line, i in lines when i > start
    return lines[i] if lines[i][1].length
  return null

indent = (d) ->
  new Array(d+1).join("  ")

compile = (content) ->
  content = content.replace /\n[\t ]*\n/g, "\n\n"
  content = content.replace /\t/g, new Array(INDENTATION_AMOUNT + 1).join(" ")
  lines = content.split /\n/
  lines = lines.map (line) ->
    matches = line.match /^([\t  ]*)(.*)$/
    [(matches[1]?.length ? 0) / INDENTATION_AMOUNT, matches[2]]

  firstLine = findNextLine(lines, -1)
  unless firstLine[0] is 0
    throw new Error "Invalid initial indentation in #{filename}: first line must not be indented"

  depth = 0
  output = []
  for line, i in lines
    nextLine = findNextLine(lines, i)
    while depth > line[0]
      depth--
      output.push "#{indent(depth)}}"
    if line[0] > depth + 1
      throw new Error "Invalid indentation increase (#{(line[0] - depth) * INDENTATION_AMOUNT} spaces) on line #{i+1} of #{filename}: must indent by exactly two spaces at each level"
    depth = line[0]

    suffix =
      if nextLine?[0] > depth
        " {"
      else
        ";"
    if line[1].length
      output.push "#{indent(depth)}#{line[1]}#{suffix}"
    else
      output.push ""
  while depth > 0
    depth--
    output.push "#{indent(depth)}}"

  return output.join("\n")


recompile = ->
  content = fs.readFileSync(filename, 'utf8')
  try
    output = compile(content)
    fs.writeFileSync(filename.replace(/\.sscad$/, ".scad"), output)
  catch e
    console.log e.message

recompile()
if watch
  fs.watch filename, recompile
