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

 Example: Register (manual, auto)/direct call routines
 Author : Jarrod Davis

******************************************************************************)

program Example03;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  JetLua.SDK,
  uFunctions in 'uFunctions.pas';

var
  Lua: IJetLua;
  val: TJetLuaValue;
  obj: testbed2;
begin
  // Report any memory leaks
  ReportMemoryLeaksOnShutdown := True;

  // Create JetLua interface
  JetLua_Interface(Lua, iaCreate);

  // Manually register routine & direct call it
  Lua.RegisterRoutine('misc.test1', misc.test1);
  Lua.Call('misc.test1', ['this works', 777]);

  // Auto reg all class routines as global, direct call, get global variable
  Lua.RegisterRoutines(testbed1);
  val := Lua.GetVariable('variable1', vtString);
  writeln('(host) variable1: ', val.AsString);
  Lua.Call('test1', ['this works!']);

  // Auto reg all class routines into global table with same name as class name
  // retrieve global variable defined in setup
  // direct call registered method
  Lua.RegisterRoutines('', testbed3);
  val := Lua.GetVariable('variable3', vtString);
  writeln('(host) variable3: ', val.AsString);
  Lua.Call('testbed3.test2', ['this works also!']);

  // Auto register object instance as global, direct call
  obj := testbed2.Create;
  Lua.RegisterRoutines('', obj, 'myObj');
  Lua.Call('myObj.test1', [2020]);
  FreeAndNil(obj);

  // Destroy JetLua interface
  JetLua_Interface(Lua, iaDestroy);

  WriteLn;
  Write('Press ENTER to continue...');
  Readln;
end.
