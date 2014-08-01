fs = require 'fs'
path = require 'path'

filename = path.resolve process.cwd(), process.argv[2]
console.log filename

unless filename?.match /\.sscad$/
  console.log "Usage: coffee sscad.coffee <filename.sscad>"
  process.exit 1

findNextLine = (lines, start) ->
  for line, i in lines when i > start
    return lines[i] if lines[i][1].length
  return null

indent = (d) ->
  new Array(d+1).join("  ")

compile = (content) ->
  content = content.replace /\n[\t ]*\n/g, "\n\n"
  content = content.replace /\t/g, "    "
  lines = content.split /\n/
  lines = lines.map (line) ->
    matches = line.match /^([\t  ]*)(.*)$/
    [(matches[1]?.length ? 0) / 2, matches[2]]

  depth = 0
  output = []
  for line, i in lines
    nextLine = findNextLine(lines, i)
    while depth > line[0]
      depth--
      output.push "#{indent(depth)}}"
    if line[0] > depth + 1
      throw new Error "Invalid indentation"
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
  output = compile(content)
  fs.writeFileSync(filename.replace(/\.sscad$/, ".scad"), output)

fs.watch filename, recompile
recompile()
