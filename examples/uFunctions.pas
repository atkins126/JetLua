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

 Example: JetLua class/object functions
 Author : Jarrod Davis

******************************************************************************)

unit uFunctions;

interface

uses
  JetLua.SDK;

type

  TVector = record
    x: Double;
    y: Double;
    z: Double;
  end;

  { testbed1 }
  testbed1 = class
    class procedure AutoSetup(aLua: IJetLua);
    class procedure test1(aContext: IJetLuaContext);
  end;

  { testbed2 }
  testbed2 = class
  public
    procedure AutoSetup(aLua: IJetLua);
    procedure test1(aContext: IJetLuaContext);
  end;

  { testbed3 }
  testbed3 = class
    class procedure AutoSetup(aLua: IJetLua);
    class procedure vector(aContext: IJetLuaContext);
    class procedure test2(aContext: IJetLuaContext);
  end;

  { misc }
  misc = class
    class procedure test1(aContext: IJetLuaContext);
  end;

implementation

{ --- testbed1 -------------------------------------------------------------- }
class procedure testbed1.AutoSetup(aLua: IJetLua);
begin
  writeln;
  writeln('testbed1.AutoSetup');
  aLua.SetVariable('variable1', 'this is variable1');
end;

class procedure testbed1.test1(aContext: IJetLuaContext);
var
  s: string;
begin
  s := aContext.GetValue(vtString, 1);
  writeln('running "testbed1.test1": ', s);
end;

{ --- testbed2 -------------------------------------------------------------- }
procedure testbed2.AutoSetup(aLua: IJetLua);
begin
  writeln;
  writeln('testbed2.AutoSetup');
  aLua.SetVariable('variable2', 'this is variable2');
end;

procedure testbed2.test1(aContext: IJetLuaContext);
var
  i: Integer;
begin
  i := aContext.GetValue(vtInteger, 1);
  writeln('int arg 1: ', i);
end;

{ --- testbed3 -------------------------------------------------------------- }
class procedure testbed3.AutoSetup(aLua: IJetLua);
begin
  writeln;
  writeln('testbed3.AutoSetup');
  aLua.SetVariable('variable3', 'this is variable3');
end;

class procedure testbed3.vector(aContext: IJetLuaContext);
var
  v: TVector;
begin
  v.x := 0;
  v.y := 0;
  v.z := 0;

  if aContext.ArgCount = 3 then
  begin
    v.x := aContext.GetValue(vtDouble, 1);
    v.y := aContext.GetValue(vtDouble, 2);
    v.z := aContext.GetValue(vtDouble, 3);
  end;

  aContext.PushValue(LuaTable);
  aContext.SetTableFieldValue('x', v.x, 1);
  aContext.SetTableFieldValue('y', v.y, 1);
  aContext.SetTableFieldValue('z', v.z, 1);
end;

class procedure testbed3.test2(aContext: IJetLuaContext);
var
  s: string;
begin
  s := aContext.GetValue(vtString, 1);
  writeln('running "testbed3.test2": ', s);
end;


{ --- misc ------------------------------------------------------------------ }
class procedure misc.test1(aContext: IJetLuaContext);
var
  s: string;
  i: Integer;
begin
  if aContext.ArgCount = 2 then
    begin
      s := aContext.GetValue(vtString, 1);
      i := aContext.GetValue(vtInteger, 2);
      writeln('(host) misc.test1 - param1: "', s, '", param2: ', i);
    end
  else
    begin
      writeln('(host) misc.test1');
    end;
end;

end.
