/***
function: to_s
description: Converts objecto to string
arguments:
  str: (*) Object
example: >
        to_s(1); // "1"
returns: (String) Object to string
***/

function to_s(str){
  return str.toString();
}


/***
function: trim
description: Remove whitespaces from both ends
returns: (String) String withouth trailing white spaces
dependencies: 
  - to_s
arguments:
  str: (String) Text
example: >
        trim(" Trime me! "); // "Trim me!"
***/

function trim(str){
  return str.replace(/^\s+|\s+$/g,'');
}

var StringUtils = {
  /***
  function: to_s
  description: Converts objecto to string
  namespace: StringUtils
  arguments:
    str: (*) Object
  example: >
          to_s(1); // "1"
  ***/
  to_s: to_s

  /***
  function: trim
  description: Remove whitespaces from both ends
  namespace: StringUtils
  dependencies: 
    - StringUtils.to_s
  arguments:
    str: (String) Text
  example: >
          trim(" Trime me! "); // "Trim me!"
  ***/
  trim: trim
};

/*** 
  class: SuperObject
  description: Extended Object class
  arguments:
    obj: (Object) Object
***/

function SuperObject(obj){

}


/*** 
  class: SuperString
  namespace: StringUtils
  dependencies:
    - StringUtils.SuperObject
  description: Extended string class
  arguments:
    type: string
    description: Regular String
    required: true
***/

StringUtils.SuperString = function(string){

}

/*** 
  class: SuperObject
  namespace: StringUtils
  description: Extended Object class
  arguments:
    obj: (Object) Object
***/

StringUtils.SuperObject = function(obj){

}

/*** 
  method: to_json
  description: Returns object as JSON
***/

StringUtils.SuperObject.prototype.to_json = function(){
  return JSON.stringify(this);
}


/*** 
  class: SuperString
  extends: SuperObject
  dependencies:
    - SuperObject
  description: Extended string class
  arguments:
    string: "(String)(default: \"Hello World!\") Regular String"
***/


function SuperString(string){

}

/*** 
  method: trim
  description: Remove whitespaces from both ends
***/

StringUtils.SuperString.prototype.trim = function(){
  
}

/*** 
  method: to_json
  description: Remove whitespaces from both ends
  arguments: 
    string: "(Boolean)(default: false)(required) Return Object (false) or string (true)"
  example: |
    var str = new SuperString("Hello")
    str.to_json(true) // "['Hello']"
    str.to_json(false) // ["Hello"]
    str.to_json() // ["Hello"]
  returns: "(Object) JSON representation of the string"
***/

StringUtils.SuperString.prototype.to_json = function(string){
  
}