// 2008-04-09
/*
Copyright (c) 2008 Cory Bennett (www.corybennett.org)

Permission is hereby granted, free of charge, to any person obtaining a copy of
this software and associated documentation files (the "Software"), to deal in
the Software without restriction, including without limitation the rights to
use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies
of the Software, and to permit persons to whom the Software is furnished to do
so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

The Software shall be used for Good, not Evil.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
*/

/* This is enhanced and modified code taken from Ian Bicking's blog post of
   2005-08-19 here:
   http://blog.ianbicking.org/jslint-command-line.html
*/



/* SpiderMonkey globals */
/*global environment, load, JSLINT, print, readline */

/*global options */
options = {};

// should pull in "options" var
if (environment.LOAD_DOT_JSLINT) {
  load(environment.HOME + '/.jslint');
}

var body = "";
var line;
var blcount = 0;
while (true) {
  line = readline();
  body = body + line + "\n";
  // HACK
  // cant figure out how to tell EOF
  // from a normal blank line so arbitrarily
  // count 100 sequential blank lines and
  // assume we have finished
  if (line.length === 0) {
    // blank line, so increment
    blcount = blcount + 1;
    if (blcount >= 100) {
      break;
    }
  }
  else {
    // not blank, so reset
    blcount = 0;
  }
}

for (var env in environment) if (environment.hasOwnProperty(env)) {
  var m = env.match(/JSLINT_(\w+)/);
  if (m && m.length) {
    /* use JSLINT_HOME internally, so just skip */
    if (m[1] === "HOME") {
      continue;
    }
    /* magic var to set the indentation in case you
       dont like the '4' Douglas uses */
    if (m[1] === "indentby") {
      options[m[1]] = parseInt(environment[m[0]], 10);
    } else {
      options[m[1]] = true;
    }
  }
}

load(environment.JSLINT_HOME + '/fulljslint.js');

var result = JSLINT(body, options);
if (result) {
  print('All good.');
} else {
  print('Problems:');
  print(JSLINT.report());
}
