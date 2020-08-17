(******************************************************************************
      _      _   _
     | | ___| |_| |   _   _  ___ ™
  _  | |/ _ \ __| |  | | | |/ _` |
 | |_| |  __/ |_| |__| |_| | (_| |
  \___/ \___|\__|_____\__,_|\__,_|
      Software Development Kit

 Copyright © tinyBigGAMES™ LLC
 All rights reserved.

 website: https://tinybiggames.com
 email  : support@tinybiggames.com
  
 See LICENSE.TXT for licensing information.
******************************************************************************)

unit JetLua.SDK;

{$IFDEF FPC}
{$MODE DELPHIUNICODE}
{$ENDIF}

interface

type

  { TLuaType }
  TLuaType = (
    ltNone          = -1,
    ltNil           = 0,
    ltBoolean       = 1,
    ltLightUserData = 2,
    ltNumber        = 3,
    ltString        = 4,
    ltTable         = 5,
    ltFunction      = 6,
    ltUserData      = 7,
    ltThread        = 8
  );

  { TJetLuaTable }
  TJetLuaTable = (LuaTable);

  { TJetLuaValueType }
  TJetLuaValueType = (
    vtInteger,
    vtDouble,
    vtString,
    vtTable,
    vtPointer,
    vtBoolean
  );

  { TJetLuaValue }
  TJetLuaValue = record
    AsType: TJetLuaValueType;
    class operator Implicit(const aValue: Integer): TJetLuaValue;
    class operator Implicit(aValue: Double): TJetLuaValue;
    class operator Implicit(aValue: PChar): TJetLuaValue;
    class operator Implicit(aValue: TJetLuaTable): TJetLuaValue;
    class operator Implicit(aValue: Pointer): TJetLuaValue;
    class operator Implicit(aValue: Boolean): TJetLuaValue;

    class operator Implicit(aValue: TJetLuaValue): Integer;
    class operator Implicit(aValue: TJetLuaValue): Double;
    class operator Implicit(aValue: TJetLuaValue): PChar;
    class operator Implicit(aValue: TJetLuaValue): Pointer;
    class operator Implicit(aValue: TJetLuaValue): Boolean;

    case Integer of
      0: (AsInteger: Integer);
      1: (AsNumber : Double);
      2: (AsString : PChar);
      3: (AsTable  : TJetLuaTable);
      4: (AsPointer: Pointer);
      5: (AsBoolean: Boolean);
  end;

  { TJetLuaInterfaceAction }
  TJetLuaInterfaceAction = (
    iaCreate,
    iaDestroy
  );

  { IJetLuaContext }
  IJetLuaContext = interface
    ['{6AEC306C-45BC-4C65-A0E1-044739DED1EB}']

    function  ArgCount: Integer;
    function  PushCount: Integer;
    procedure ClearStack;
    procedure PopStack(aCount: Integer);
    function  GetStackType(aIndex: Integer): TLuaType;

    function  GetValue(aType: TJetLuaValueType; aIndex: Integer): TJetLuaValue;
    procedure PushValue(aValue: TJetLuaValue);

    procedure SetTableFieldValue(aName: PChar; aValue: TJetLuaValue; aIndex: Integer);
    function  GetTableFieldValue(aName: PChar; aType: TJetLuaValueType; aIndex: Integer): TJetLuaValue;
  end;

  { TLuaFunction }
  TJetLuaFunction = procedure(aLua: IJetLuaContext) of object;

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

{$IFNDEF JETLUA_DLL}
function  JetLua_Interface(var aJetLua: IJetLua; aAction: TJetLuaInterfaceAction): Boolean; external 'JetLua.dll';
{$ENDIF}

implementation

{ --- TJetLuaValue ---------------------------------------------------------- }
class operator TJetLuaValue.Implicit(const aValue: Integer): TJetLuaValue;
begin
  Result.AsType := vtInteger;
  Result.AsInteger := aValue;
end;

class operator TJetLuaValue.Implicit(aValue: Double): TJetLuaValue;
begin
  Result.AsType := vtDouble;
  Result.AsNumber := aValue;
end;

class operator TJetLuaValue.Implicit(aValue: PChar): TJetLuaValue;
begin
  Result.AsType := vtString;
  Result.AsString := aValue;
end;

class operator TJetLuaValue.Implicit(aValue: TJetLuaTable): TJetLuaValue;
begin
  Result.AsType := vtTable;
  Result.AsTable := aValue;
end;

class operator TJetLuaValue.Implicit(aValue: Pointer): TJetLuaValue;
begin
  Result.AsType := vtPointer;
  Result.AsPointer := aValue;
end;

class operator TJetLuaValue.Implicit(aValue: Boolean): TJetLuaValue;
begin
  Result.AsType := vtBoolean;
  Result.AsBoolean := aValue;
end;

class operator TJetLuaValue.Implicit(aValue: TJetLuaValue): Integer;
begin
  Result := aValue.AsInteger;
end;

class operator TJetLuaValue.Implicit(aValue: TJetLuaValue): Double;
begin
  Result := aValue.AsNumber;
end;

class operator TJetLuaValue.Implicit(aValue: TJetLuaValue): PChar;
const
  {$J+}
  Value: string = '';
  {$J-}
begin
  Value := aValue.AsString;
  Result := PChar(Value);
end;

class operator TJetLuaValue.Implicit(aValue: TJetLuaValue): Pointer;
begin
  Result := aValue.AsPointer
end;

class operator TJetLuaValue.Implicit(aValue: TJetLuaValue): Boolean;
begin
  Result := aValue.AsBoolean;
end;

end.
