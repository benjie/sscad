sSCAD
=====

SimpleSCAD, SexySCAD, call it what you will. This is an alternative
syntax for OpenSCAD that takes a `.sscad` file and compiles it to
`.scad`. It currently does the following:

- Makes indentation significant
- Removes the need for semicolons and curly braces

The aim of this project is "sSCAD is to SCAD as CoffeeScript is to
JavaScript" - i.e. "It's just SCAD"

Usage
-----

    coffee sscad.coffee [-w] <filename.sscad>

(Add `-w` to watch for changes and recompile as necessary.)

It's advised you combine this script with an external editor and
OpenSCAD's "Design -> Automatical Reload and Compile" option.

Example
-------

    fiddle = 0.1
    baseWidth = 50
    discAltitude = 40
    wallThickness = 2

    difference()
      cylinder(r = baseWidth, h = discAltitude, $fn = 8)
      translate([0, 0, -fiddle])
        cylinder(r = baseWidth - wallThickness, h = discAltitude + 2 * fiddle, $fn = 8)

becomes

    fiddle = 0.1;
    baseWidth = 50;
    discAltitude = 40;
    wallThickness = 2;

    difference() {
      cylinder(r = baseWidth, h = discAltitude, $fn = 8);
      translate([0, 0, -fiddle]) {
        cylinder(r = baseWidth - wallThickness, h = discAltitude + 2 * fiddle, $fn = 8);
      }
    }
