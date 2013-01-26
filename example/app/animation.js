/***
function: trim
description: Remove whitespaces from both ends
arguments:
  str: (String) Text
example: >
        trim(" Trime me! "); // "Trim me!"
***/

function trim(str){
  return .replace(/^\s+|\s+$/g,'');
}