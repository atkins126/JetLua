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

 Example: Using the IJetLua.LoadXXX routines
 Author : Jarrod Davis

******************************************************************************)

program Example01;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  System.Classes,
  JetLua.SDK;

var
  Lua: IJetLua;
  //buffer: string = 'print("Lun running from a buffer!")';
  Buffer: TStringStream;
begin
  ReportMemoryLeaksOnShutdown := True;

  // create JetLua interface
  JetLua_Interface(Lua, iaCreate);

  // LoadString, AutoRun = True
  Writeln('LoadString, AutoRun = True');
  Writeln('---------------------------');
  Lua.LoadString('print("Hello World! (AutoRun)")');

  // LoadString, AutoRun = False
  WriteLn;
  Writeln('LoadString, AutoRun = False');
  Writeln('---------------------------');
  Lua.LoadString('print("Hello World! (No AutoRun)")', False);
  Lua.Run; // Call Run to execution current function at top of Lua stack

  // LoadFile, AutoRun = True
  Writeln;
  Writeln('LoadFile, AutoRun = True');
  Writeln('---------------------------');
  Lua.LoadFile('Example01.lua');

  // LoadFile, AutoRun = False
  Writeln;
  Writeln('LoadFile, AutoRun = False');
  Writeln('---------------------------');
  Lua.LoadFile('Example01.lua', False);
  Lua.Run; // Call Run to execution current function at top of Lua stack


  // create a memory buffer
  Buffer := TStringStream.Create('print("Lun running from a buffer!")');

  // LoadBuffer, AutoRun = True
  Writeln;
  Writeln('LoadBuffer, AutoRun = True');
  Writeln('---------------------------');
  Lua.LoadBuffer(Buffer.Memory, Buffer.Size);

  // LoadBuffer, AutoRun = False
  Writeln;
  Writeln('LoadBuffer, AutoRun = False');
  Writeln('---------------------------');
  Lua.LoadBuffer(Buffer.Memory, Buffer.Size);
  Lua.Run;

  // destroy memory buffer
  FreeAndNil(Buffer);

  // Destroy JetLua interface
  JetLua_Interface(Lua, iaDestroy);

  WriteLn;
  Write('Press ENTER to continue...');
  Readln;
end.
