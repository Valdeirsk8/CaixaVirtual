unit Horse.HTTP;
{$IF DEFINED(FPC)}
  {$MODE DELPHI}{$H+}
{$ENDIF}
interface

uses
{$IF DEFINED(FPC)}
     SysUtils, Classes, Generics.Collections, fpHTTP, HTTPDefs,
{$ELSE}
  System.SysUtils, System.Classes, Web.HTTPApp, System.Generics.Collections,
{$ENDIF}
 Horse.Commons;

type
  THorseList = {$IF DEFINED(FPC)}TDictionary<string, string>{$ELSE} TDictionary<string, string>{$ENDIF};

  THorseRequest = class
  private
    FWebRequest: {$IF DEFINED(FPC)}TRequest{$ELSE}  TWebRequest {$ENDIF};
    FQuery: THorseList;
    FParams: THorseList;
    FCookie: THorseList;
    FBody: TObject;
    FSession: TObject;
    procedure InitializeQuery;
    procedure InitializeParams;
    procedure InitializeCookie;
    function GetHeaders(AIndex: string): string;
  public
    function Body: string; overload;
    function Body<T: class>: T; overload;
    function Session<T: class>: T;
    function Query: THorseList;
    function Params: THorseList;
    function Cookie: THorseList;
    function MethodType: TMethodType;
    property Headers[index: string]: string read GetHeaders;
    constructor Create(AWebRequest: {$IF DEFINED(FPC)}TRequest{$ELSE}  TWebRequest {$ENDIF});
    destructor Destroy; override;
  end;

  THorseHackRequest = class(THorseRequest)
  public
    function GetWebRequest: {$IF DEFINED(FPC)}TRequest{$ELSE}  TWebRequest {$ENDIF};
    function GetParams: THorseList;
    procedure SetBody(ABody: TObject);
    procedure SetSession(ASession: TObject);
  end;

  THorseResponse = class
  private
    FWebResponse: {$IF DEFINED(FPC)}TResponse{$ELSE}  TWebResponse {$ENDIF};
    FContent: TObject;
  public
    function Send(AContent: string): THorseResponse; overload;
    function Send<T: class>(AContent: T): THorseResponse; overload;
    function Status(AStatus: Integer): THorseResponse; overload;
    function Status(AStatus: THTTPStatus): THorseResponse; overload;
    function Status: Integer; overload;
    constructor Create(AWebResponse: {$IF DEFINED(FPC)}TResponse{$ELSE}  TWebResponse {$ENDIF});
    destructor Destroy; override;
  end;

  THorseHackResponse = class(THorseResponse)
  public
    function GetWebResponse: {$IF DEFINED(FPC)}TResponse{$ELSE}  TWebResponse {$ENDIF};
    function GetContent: TObject;
    procedure SetContent(AContent: TObject);
  end;

implementation

const
  KEY = 0;
  VALUE = 1;

function THorseRequest.Body: string;
begin
  Result := FWebRequest.Content;
end;

function THorseRequest.Body<T>: T;
begin
  Result := T(FBody);
end;

function THorseRequest.Cookie: THorseList;
begin
  Result := FCookie;
end;

constructor THorseRequest.Create(AWebRequest: {$IF DEFINED(FPC)}TRequest{$ELSE}  TWebRequest {$ENDIF});
begin
  FWebRequest := AWebRequest;
  InitializeQuery;
  InitializeParams;
  InitializeCookie;
end;

destructor THorseRequest.Destroy;
begin
  FQuery.Free;
  FParams.Free;
  FCookie.Free;
//  if Assigned(FBody) then
//    FBody.Free;
  inherited;
end;

function THorseRequest.GetHeaders(AIndex: string): string;
begin
  Result := FWebRequest.GetFieldByName(AIndex);
end;

procedure THorseRequest.InitializeCookie;
var
  LParam: TArray<string>;
  LItem: string;
begin
  FCookie := THorseList.Create;
  for LItem in FWebRequest.CookieFields do
  begin
    LParam := LItem.Split(['=']);
    FCookie.Add(LParam[KEY], LParam[VALUE]);
  end;
end;

procedure THorseRequest.InitializeParams;
begin
  FParams := THorseList.Create;
end;

procedure THorseRequest.InitializeQuery;
var
  LItem: string;
  LKey: string;
  LValue: string;
  LEqualFirstPos : Integer;  
begin
  FQuery := THorseList.Create;
  for LItem in FWebRequest.QueryFields do
  begin
    LEqualFirstPos := Pos('=', Litem);
    LKey := Copy(Litem, 1, LEqualFirstPos - 1);
    LValue := Copy(Litem, LEqualFirstPos + 1, Length(LItem));
    FQuery.Add(LKey, LValue);
  end;
end;

function THorseRequest.MethodType: TMethodType;
begin
  Result := {$IF DEFINED(FPC)} StringCommandToMethodType(FWebRequest.Command)  {$ELSE} FWebRequest.MethodType;  {$ENDIF}
end;

function THorseRequest.Params: THorseList;
begin
  Result := FParams;
end;

function THorseRequest.Query: THorseList;
begin
  Result := FQuery;
end;

function THorseRequest.Session<T>: T;
begin
  Result := T(FSession);
end;

{ THorseResponse }

constructor THorseResponse.Create(AWebResponse: {$IF DEFINED(FPC)}TResponse{$ELSE}  TWebResponse {$ENDIF});
begin
  FWebResponse := AWebResponse;
  {$IF DEFINED(FPC)}FWebResponse.Code{$ELSE} FWebResponse.StatusCode {$ENDIF} := THTTPStatus.Ok.ToInteger;
end;

destructor THorseResponse.Destroy;
begin
  if Assigned(FContent) then
    FContent.Free;
  inherited;
end;

function THorseResponse.Send(AContent: string): THorseResponse;
begin
  FWebResponse.Content := AContent;
  Result := Self;
end;

function THorseResponse.Send<T>(AContent: T): THorseResponse;
begin
  FContent := AContent;
  Result := Self;
end;

function THorseResponse.Status(AStatus: THTTPStatus): THorseResponse;
begin
  {$IF DEFINED(FPC)}FWebResponse.Code{$ELSE} FWebResponse.StatusCode {$ENDIF} := AStatus.ToInteger;
  Result := Self;
end;

function THorseResponse.Status: Integer;
begin
  Result := {$IF DEFINED(FPC)}FWebResponse.Code{$ELSE} FWebResponse.StatusCode {$ENDIF};
end;

function THorseResponse.Status(AStatus: Integer): THorseResponse;
begin
  {$IF DEFINED(FPC)}FWebResponse.Code{$ELSE} FWebResponse.StatusCode {$ENDIF} := AStatus;
  Result := Self;
end;

{ THorseHackRequest }

function THorseHackResponse.GetContent: TObject;
begin
  Result := FContent;
end;

function THorseHackRequest.GetParams: THorseList;
begin
  Result := FParams;
end;

function THorseHackRequest.GetWebRequest: {$IF DEFINED(FPC)}TRequest{$ELSE}  TWebRequest {$ENDIF};
begin
  Result := FWebRequest;
end;

procedure THorseHackRequest.SetBody(ABody: TObject);
begin
  FBody := ABody;
end;

procedure THorseHackRequest.SetSession(ASession: TObject);
begin
  FSession := ASession;
end;

{ THorseHackResponse }

function THorseHackResponse.GetWebResponse: {$IF DEFINED(FPC)}TResponse{$ELSE} TWebResponse {$ENDIF};
begin
  Result := FWebResponse;
end;

procedure THorseHackResponse.SetContent(AContent: TObject);
begin
  FContent := AContent;
end;

end.
