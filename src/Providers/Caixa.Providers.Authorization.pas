unit Caixa.Providers.Authorization;

interface

uses
  System.Classes, System.SysUtils, System.json,

  Horse, Horse.JWT, Horse.BasicAuthentication,

  Caixa.Services.Usuario;

type
  TLoggedUser = Record
  strict private
    FID       : Integer;
    FUserName : String;
  public
    property ID       : Integer read FID       write FID;
    property UserName : String  read FUserName write FUserName;
  end;

  TProviderAuthorization = class
  public
    type
      TJWTConsts = record
      const
        SecretJWT : String  = 'JWTSecretKey';
        Expires   : Integer = 1; //Uma Hora
        userID    : String  = 'userID';
        userName  : String  = 'userName';
      end;

  private
    class function doBasicAuthentication(const aUserName, aPassword: String): Boolean;
  public
    class function BasicAuthorization: THorseCallback;
    class function Authorization: THorseCallback;
    class function GetLoggedUser(aUserName, aPassword: String): TLoggedUser; overload;
    class function GetLoggedUser(aReq: THorseRequest):TLoggedUser; overload;
  end;

implementation

{ TProviderAuthorization }

class function TProviderAuthorization.Authorization: THorseCallback;
begin
  Result := HorseJWT(TProviderAuthorization.TJWTConsts.SecretJWT);
end;

class function TProviderAuthorization.BasicAuthorization: THorseCallback;
begin
  Result := HorseBasicAuthentication(DoBasicAuthentication);
end;

class function TProviderAuthorization.doBasicAuthentication(const aUserName, aPassword: String): Boolean;
var
  lServiceUsuario: TServiceUsuario;
begin
  lServiceUsuario := TServiceUsuario.Create(nil);
  try
    Result := lServiceUsuario.IsAValidUser(aUsername, aPassword);

  finally
    lServiceUsuario.Free;
  end;

end;

class function TProviderAuthorization.GetLoggedUser(aReq: THorseRequest): TLoggedUser;
begin
  Result.id       := aReq.Session<TJsonObject>.GetValue<Integer>(TProviderAuthorization.TJWTConsts.userID);
  Result.UserName := aReq.Session<TJsonObject>.GetValue<String>(TProviderAuthorization.TJWTConsts.userName);
end;

class function TProviderAuthorization.GetLoggedUser(aUserName, aPassword: String): TLoggedUser;
var
  lServiceUsuario: TServiceUsuario;
begin
  lServiceUsuario := TServiceUsuario.Create(nil);
  try
    lServiceUsuario.GetLoggedUser(aUsername, aPassword);

    Result.ID       := lServiceUsuario.usuarioID.AsInteger;
    Result.UserName := lServiceUsuario.usuarioUSERNAME.AsString;
  finally
    lServiceUsuario.Free;
  end;
end;

end.
