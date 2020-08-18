(******************************************************************************
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

******************************************************************************)

program Example02;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  JetLua.SDK;

var
  Lua: IJetLua;
  val: TJetLuaValue;
begin
  // Report any memory leaks
  ReportMemoryLeaksOnShutdown := True;

  // Create JetLua interface
  JetLua_Interface(Lua, iaCreate);

  // Define Lua variable from host side
  Lua.SetVariable('var_string', '"My Name"');
  Lua.SetVariable('var_integer', 4321);
  Lua.SetVariable('var_number', 12.34);
  Lua.SetVariable('var_boolean', true);

  // Load and run Lua source file
  Lua.LoadFile('Example02.lua');

  // Display script assigned variables created on host side
  writeln;
  writeln('Script assigned:');
  val := Lua.GetVariable('var_string', vtString);
  writeln('var_string: ', val.AsString, ', a string value');

  val := Lua.GetVariable('var_integer', vtInteger);
  writeln('var_integer: ', val.AsInteger, ', a integer value');

  val := Lua.GetVariable('var_number', vtDouble);
  writeln('var_number: ', val.AsNumber:3:2, ', a number value');

  val := Lua.GetVariable('var_boolean', vtBoolean);
  writeln('var_boolean: ', val.AsBoolean, ', a boolean value');

  // Display script defined variables assigned on script side
  writeln;
  writeln('Script defined:');
  val := Lua.GetVariable('var_string2', vtString);
  writeln('var_string2: ', val.AsString, ', a string value');

  val := Lua.GetVariable('var_integer2', vtInteger);
  writeln('var_integer2: ',  val.AsInteger, ', a integer value');

  val := Lua.GetVariable('var_number2', vtDouble);
  writeln('var_number2: ', val.AsNumber:3:2, ', a number value');

  val := Lua.GetVariable('var_boolean2', vtBoolean);
  writeln('var_boolean2: ', val.AsBoolean, ', a boolean value');

  // Display script defined variables assigned on host side
  Lua.SetVariable('test', 'Easy! Fast! Fun!');
  Lua.LoadString('print("\ntest: " .. test)');

  // Destroy JetLua interface
  JetLua_Interface(Lua, iaDestroy);

  WriteLn;
  Write('Press ENTER to continue...');
  Readln;
end.
