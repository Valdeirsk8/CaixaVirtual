unit Caixa.Controllers.Login;

interface

uses
  System.Classes, System.SysUtils, System.JSON, System.DateUtils,

  Horse, Horse.BasicAuthentication, JOSE.Core.JWT, JOSE.Core.Builder,

  Caixa.Providers.Authorization;

type
  TControllerLogin = class
    class procedure DoLogin(aReq: THorseRequest; aRes: THorseResponse; aNext: TProc);
  end;

procedure Registry;

implementation

procedure Registry;
begin
  THorse
    //.Group
    //.Use(TProviderAuthorization.BasicAuthorization())
      .Get('/login', TProviderAuthorization.BasicAuthorization(), TControllerLogin.DoLogin);
end;


{ TControllerLogin }

class procedure TControllerLogin.DoLogin(aReq: THorseRequest; aRes: THorseResponse; aNext: TProc);
var
  JWT: TJWT;
  Claims: TJWTClaims;
  LoggedUser:TloggedUser;
begin

  HorseBasicAuthentication(
    function(const AUsername, APassword: string): Boolean
    begin
      LoggedUser := TProviderAuthorization.GetLoggedUser(AUsername, APassword);
      Result     := True;
    end);

  Horse.BasicAuthentication.Middleware(aReq, aRes, aNext);

  JWT               := TJWT.Create;
  Claims            := JWT.Claims;
  Claims.JSON       := TJSONObject.Create;
  Claims.IssuedAt   := Now;
  Claims.Expiration := IncHour(Now, TProviderAuthorization.TJWTConsts.Expires);

  Claims.SetClaimOfType<integer>(TProviderAuthorization.TJWTConsts.userID, LoggedUser.ID);
  Claims.SetClaimOfType<String>(TProviderAuthorization.TJWTConsts.userName,LoggedUser.UserName);

  aRes.Send(TJSONObject.Create.AddPair('token', TJOSE.SHA256CompactToken(TProviderAuthorization.TJWTConsts.SecretJWT, JWT)));

end;

end.
