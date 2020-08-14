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

 Example: Load Lua code and auto execute from a string
 Author : Jarrod Davis

******************************************************************************)

program Example01;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  JetLua.SDK;

var
  Lua: IJetLua;
begin
  JetLua_Interface(Lua, iaCreate);

  Lua.LoadString('print("Hello World!")');

  JetLua_Interface(Lua, iaDestroy);

  WriteLn;
  Write('Press ENTER to continue...');
  Readln;
end.
