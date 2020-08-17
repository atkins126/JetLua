![](/images/logo.png)
# Welcome to JetLua&trade;
An SDK to allow easy, fast & fun integration of [Lua](https://www.lua.org/) scripting inside your [Delphi](https://www.embarcadero.com/products/delphi) applications
## Features
* Made with/supports latest Delphi version
* Only two minimal interfaces to access feature set (IJetLua & IJetLuaContext)
* You can auto register class/object JetLua routines
* If you have created an AutoSetup class function, it's automatically called during registration where you can do global setup operations
* You can declare tables in "table.table.table" format
* You can declare global/table variables and access them
* You can check the exists of global/table variables and routines
* You can call global/table functions with a variable number of parameters
* You can pull and push data from and to the Lua stack via the IJetLuaContext interface
* You can load source code from a file, string and buffer
* You can import Lua modules
* Source is [JIT](https://en.wikipedia.org/wiki/Just-in-time_compilation) compiled using [moonjit](https://github.com/moonjit/moonjit)
* You can compile Lua sources (including imported modules) and bind to an EXE for stand-alone distribution
* You can add version information, an icon, enable runtime-themes and high DPI aware support to EXEs
* See this [blog post](https://tinybiggames.com/news/introducing-jetlua-easy-fast-and-fun-lua-sdk-for-delphi-r3/) for more details
## A Tour of JetLua
### JetLua Interfaces
You can access all functionality from these two minimal interfaces
```pascal
{ IJetLuaContext }
  IJetLuaContext = interface
    ['{6AEC306C-45BC-4C65-A0E1-044739DED1EB}']

    function  PushCount: Integer;
    procedure ClearStack;
    procedure PopStack(aCount: Integer);
    function  GetStackType(aIndex: Integer): TLuaType;

    function  GetValue(aType: TJetLuaValueType; aIndex: Integer): TJetLuaValue;
    procedure PushValue(aValue: TJetLuaValue);

    procedure SetTableFieldValue(aName: PChar; aValue: TJetLuaValue; aIndex: Integer);
    function  GetTableFieldValue(aName: PChar; aType: TJetLuaValueType; aIndex: Integer): TJetLuaValue;
  end;
  
  { IJetLua }
  IJetLua = interface
    ['{671FAB20-00F2-4C81-96A6-6F675A37D00B}']

    procedure Reset;

    procedure LoadFile(aFilename: PChar; aAutoRun: Boolean = True);
    procedure LoadString(aData: PChar; aAutoRun: Boolean = True);
    procedure LoadBuffer(aData: Pointer; aSize: NativeUInt; aAutoRun: Boolean = True);

    procedure Run;

    function  RoutineExist(aName: PChar): Boolean;
    function  Call(aName: PChar; const aParams: array of TJetLuaValue): TJetLuaValue;

    function  VariableExist(aName: PChar): Boolean;

    procedure SetVariable(aName: PChar; aValue: TJetLuaValue);
    function  GetVariable(aName: PChar; aType: TJetLuaValueType): TJetLuaValue;

    procedure RegisterRoutine(aName: PChar; aData: Pointer; aCode: Pointer); overload;
    procedure RegisterRoutine(aName: PChar; aRoutine: TJetLuaFunction); overload;

    procedure RegisterRoutines(aClass: TClass); overload;
    procedure RegisterRoutines(aObject: TObject); overload;
    procedure RegisterRoutines(aTables: PChar; aClass: TClass; aTableName: PChar=nil); overload;
    procedure RegisterRoutines(aTables: PChar; aObject: TObject; aTableName: PChar=nil); overload;

    procedure AddVerInfo(aValue: Boolean);
    procedure SetNoConsole(aValue: Boolean);
    procedure SetVerInfo(aCompanyName: PChar; aFileVersion: PChar;
      aFileDescription: PChar; aInternalName: PChar; aLegalCopyright: PChar;
      aLegalTrademarks: PChar; aOriginalFilename: PChar; aProductName: PChar;
      aProductVersion: PChar; aComments: PChar);
    procedure SetExeFilename(aFilename: PChar);
    procedure SetIconFilename(aFilename: PChar);
    procedure EnableRuntimeThemes(aValue: Boolean);
    procedure EnableHighDPIAware(aValue: Boolean);

    procedure Compile(aSourceFilename: PChar; aPayloadFilename: PChar);

    function  HasPayload: Boolean;
    procedure RunPayload;
  end;
```
### Hello World
The simplest example of usage.
```Pascal
program HelloWorld;
{$APPTYPE CONSOLE}
uses
  System.SysUtils, 
  JetLua.SDK;
var
  Lua: IJetLua;
begin
  // Create and return a IJetLua interface
  JetLua_Interface(Lua, iaCreate);
  
  // Execute lua statements inside string
  Lua.LoadString('print("Hello World!")');
  
  // Destroy the IJetLua interface
  JetLua_Interface(Lua, iaDestroy);

  // Wait for ENTER key, then quit
  Write('Press ENTER to quit');
  Readln;
end.
```
### Register Lua Functions
This is how you auto register Lua functions in JetLua. **Note** if you define a class function named `AutoSetup(aLua: IJetLua)`, it will automatically be called during the registration. This can be used to define globals and establish other initial conditions needed by these routines.
```Pascal
program AutoRegister;
{$APPTYPE CONSOLE}
uses
  System.SysUtils, 
  JetLua.SDK;
  
type
  
  { myfunc }
  myfunc = class
  public
    class procedure AutoSetup(aLua: IJetLua);
    class procedure test1(aContext: IJetLuaContext);
    class procedure vec(aContext: IJetLuaContext);
  end;
  
{ myfunc }
class procedure testbed.AutoSetup(aLua: IJetLua);
begin
  aLua.SetVariable('mytable.info.id1', 1);
  aLua.SetVariable('mytable.info.id2', 2);
  aLua.SetVariable('mytable.info.id3', 3);
  aLua.SetVariable('mytable.info.id4', 4);
  aLua.SetVariable('my_name', 'My Name');
  aLua.SetVariable('tbg', 777);
end;

class procedure myfunc.test1(aContext: IJetLuaContext);
var
  s: string;
begin
  s := aContext.GetValue(vtString, 1);
  writeln('myfunc.test1: ', s);
end;

class procedure testbed.vec(aContext: IJetLuaContext);
begin
  aContext.PushValue(LuaTable);
  aContext.SetTableFieldValue('x', 1, 1);
  aContext.SetTableFieldValue('y', 2, 1);
  aContext.SetTableFieldValue('z', 3, 1);
  aContext.SetTableFieldValue('info.name', 'JetLua table example', 1);
end;

var
  Lua: IJetLua;
begin
  // Create and return a IJetLua interface
  JetLua_Interface(Lua, iaCreate);
  
  // Auto register all IJetLuaContext routines in myfunc class
  Lua.RegisterRoutines(myfunc);
  
  // Load and execute Lua source on disk
  Lua.LoadFile('main.lua');
  
  // Destroy the IJetLua interface
  JetLua_Interface(Lua, iaDestroy);

  // Wait for ENTER key, then quit
  Write('Press ENTER to quit');
  Readln;
end.
```
You can now access the routines and variables from Lua
```Lua
print("mytable.info.id1" .. tostring(mytable.info.id1))
print("my_name: " .. my_name)

local v = myfunc.vec()
print("v.x: " .. tostring(v.x))
print("v.info.name: " .. v.info.name)
myfunc.test1("this is a test")
```

