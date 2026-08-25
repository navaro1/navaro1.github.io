const fs = require("fs");
const pkg = require("./package.json");
const filename = "assets/js/main.min.js";
const script = fs.readFileSync(filename);
const padStart = str => ("0" + str).slice(-2);
const dateObj = new Date();
const date = `${dateObj.getFullYear()}-${padStart(
  dateObj.getMonth() + 1
)}-${padStart(dateObj.getDate())}`;
const banner = `/*!
 * Minimal Mistakes Jekyll Theme ${pkg.version} by ${pkg.author}
 * Includes jQuery 3.7.1
 * Copyright 2013-${dateObj.getFullYear()} Michael Rose - mademistakes.com | @mmistakes
 * Copyright 2024-${dateObj.getFullYear()} iBug - ibugone.com | @iBug
 * Free for personal and commercial use under the ${pkg.license} license
 * https://github.com/mmistakes/minimal-mistakes/blob/master/LICENSE
 */
`;

if (script.slice(0, 3) != "/**") {
  fs.writeFileSync(filename, banner + script);
}
