--[[---------------------------------------------------------------------------
      _      _   _
     | | ___| |_| |   _   _  ___ ™
  _  | |/ _ \ __| |  | | | |/ _` |
 | |_| |  __/ |_| |__| |_| | (_| |
  \___/ \___|\__|_____\__,_|\__,_|
          Delphi Lua SDK

 Copyright © tinyBigGAMES™ LLC
 All rights reserved.

 website: https://tinybiggames.com
 email  : support@tinybiggames.com
 
 See LICENSE.TXT for licensing information.
 
 -----------------------------------------------------------------------------

 Example: Set/Get/Check global variables
 Author : Jarrod Davis
 
-----------------------------------------------------------------------------]]

test = "JetLua"
print("test: " .. test)
print("")

print("Host defined:")
print("var_string : " .. var_string .. ", string value")
print("var_integer: " .. tostring(var_integer) .. ", integer value")
print("var_number : " .. tostring(var_number) .. ", number value")
print("var_boolean: " .. tostring(var_boolean) .. ", boolean value")

var_string  = '"JetLua"'
var_integer = 777
var_number  = 21.32
var_boolean = false

var_string2  = '"string2"'
var_integer2 = 888
var_number2  = 2342.3
var_boolean2 = true

