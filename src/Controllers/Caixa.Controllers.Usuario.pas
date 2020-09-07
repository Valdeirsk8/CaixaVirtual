unit Caixa.Controllers.Usuario;

interface

Uses
  System.Json, System.Classes, System.SysUtils,

  Horse,

  Ragna,

  Caixa.Services.Usuario, Caixa.Providers.Authorization;

type
  TControllerUsuario = Class
    class procedure Get    (aReq: THorseRequest; aRes: THorseResponse; aNext: TProc);
    class procedure GetByID(aReq: THorseRequest; aRes: THorseResponse; aNext: TProc);
    class procedure Post   (aReq: THorseRequest; aRes: THorseResponse; aNext: TProc);
    class procedure Put    (aReq: THorseRequest; aRes: THorseResponse; aNext: TProc);
    class procedure Delete (aReq: THorseRequest; aRes: THorseResponse; aNext: TProc);
  end;


procedure Registry;

implementation

procedure Registry;
begin

  THorse
    .Get   ('/usuario/'            , TProviderAuthorization.Authorization, TControllerUsuario.Get)
    .Get   ('/usuario/:id_usuario/', TProviderAuthorization.Authorization, TControllerUsuario.GetByID)
    .Post  ('/usuario/'            , TProviderAuthorization.Authorization, TControllerUsuario.Post)
    .put   ('/usuario/:id_usuario/', TProviderAuthorization.Authorization, TControllerUsuario.Put)
    .Delete('/usuario/:id_usuario/', TProviderAuthorization.Authorization, TControllerUsuario.Delete);
end;

{ TControllerUsuario }
class procedure TControllerUsuario.Get(aReq: THorseRequest; aRes: THorseResponse; aNext: TProc);
Var
  lServiveUsuario:TServiceUsuario;
  ID:Integer;
  lLoggedUser:TloggedUser;
begin
  lServiveUsuario := TServiceUsuario.Create(nil);
  try
    lLoggedUser := TProviderAuthorization.GetLoggedUser(aReq);

    aRes
      .Send(lServiveUsuario.Get.ToJSONArray)
      .Status(THTTPStatus.OK);
  finally
    FreeAndNil(lServiveUsuario);
  end;
end;

class procedure TControllerUsuario.GetByID(aReq: THorseRequest; aRes: THorseResponse; aNext: TProc);
Var
  lServiveUsuario:TServiceUsuario;
  lID_Usuario:Integer;
begin
  lServiveUsuario := TServiceUsuario.Create(nil);
  try
    lID_Usuario := aReq.Params.Items['id_usuario'].ToInteger;

    aRes
      .Send(lServiveUsuario.GetByID(lID_Usuario).ToJSONObject)
      .Status(THTTPStatus.OK);

  finally
    FreeAndNil(lServiveUsuario);
  end;

end;

class procedure TControllerUsuario.Delete(aReq: THorseRequest; aRes: THorseResponse; aNext: TProc);
Var
  lServiveUsuario:TServiceUsuario;
  lID_Usuario:Integer;
begin
  lServiveUsuario := TServiceUsuario.Create(nil);
  try
    lID_Usuario := aReq.Params.Items['id_usuario'].ToInteger;

    aRes
      .Send(lServiveUsuario.Delete(lID_Usuario))
      .Status(THTTPStatus.OK)
  finally
    FreeAndNil(lServiveUsuario);
  end;

end;

class procedure TControllerUsuario.Post(aReq: THorseRequest; aRes: THorseResponse; aNext: TProc);
var
  lServiveUsuario:TServiceUsuario;
begin
  lServiveUsuario := TServiceUsuario.Create(nil);
  try

    aRes
      .Send(lServiveUsuario.Post(aReq.Body<TJsonObject>).ToJsonObject())
      .Status(THTTPStatus.Created);

  finally
    lServiveUsuario.Free;
  end;
end;

class procedure TControllerUsuario.Put(aReq: THorseRequest; aRes: THorseResponse; aNext: TProc);
var
  lServiveUsuario:TServiceUsuario;
  lID_Usuario:Integer;
begin
  lServiveUsuario := TServiceUsuario.Create(nil);
  try
    lID_Usuario := aReq.Params.Items['id_usuario'].ToInteger;

    aRes
      .Send(lServiveUsuario.Put(lID_Usuario, aReq.Body<TJsonObject>).ToJsonObject)
      .Status(THTTPStatus.OK);
  finally
    FreeAndNil(lServiveUsuario);
  end;

end;

end.
