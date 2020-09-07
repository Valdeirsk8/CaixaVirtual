unit Caixa.Controllers.Categoria;

interface

Uses
  System.Json, System.Classes, System.SysUtils,

  Horse,

  Ragna,

  Caixa.Services.Categoria, Caixa.Providers.Authorization;

type
  TControllerCategoria = Class
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
//    .Group
//    .Use(TProviderAuthorization.Authorization)
      .Get   ('/categoria/'              , TProviderAuthorization.Authorization, TControllerCategoria.Get)
      .Get   ('/categoria/:id_categoria/', TProviderAuthorization.Authorization, TControllerCategoria.GetByID)
      .Post  ('/categoria/'              , TProviderAuthorization.Authorization, TControllerCategoria.Post)
      .put   ('/categoria/:id_categoria/', TProviderAuthorization.Authorization, TControllerCategoria.Put)
      .Delete('/categoria/:id_categoria/', TProviderAuthorization.Authorization, TControllerCategoria.Delete);
end;

{ TControllerCategoria }
class procedure TControllerCategoria.Get(aReq: THorseRequest; aRes: THorseResponse; aNext: TProc);
Var
  lServiceCategoria:TServiceCategoria;
  lLoggedUser:TLoggedUser;
begin
  lServiceCategoria := TServiceCategoria.Create(nil);
  try
    lLoggedUser := TProviderAuthorization.GetLoggedUser(aReq);
    aRes
      .Send(lServiceCategoria.Get(lLoggedUser.ID).ToJSONArray)
      .Status(THTTPStatus.OK);
  finally
    FreeAndNil(lServiceCategoria);
  end;
end;

class procedure TControllerCategoria.GetByID(aReq: THorseRequest; aRes: THorseResponse; aNext: TProc);
Var
  lServiceCategoria:TServiceCategoria;
  lID_Categoria:Integer;
  lLoggedUser:TLoggedUser;
begin
  lServiceCategoria := TServiceCategoria.Create(nil);
  try
    lID_Categoria := aReq.Params.Items['id_categoria'].ToInteger;
    lLoggedUser   := TProviderAuthorization.GetLoggedUser(aReq);

    aRes
      .Send(lServiceCategoria.GetByID(lLoggedUser.ID, lID_Categoria).ToJSONObject)
      .Status(THTTPStatus.OK);

  finally
    FreeAndNil(lServiceCategoria);
  end;

end;

class procedure TControllerCategoria.Delete(aReq: THorseRequest; aRes: THorseResponse; aNext: TProc);
Var
  lServiceCategoria:TServiceCategoria;
  lID_Categoria:Integer;
  lLoggedUser:TLoggedUser;
begin
  lServiceCategoria := TServiceCategoria.Create(nil);
  try
    lID_Categoria := aReq.Params.Items['id_categoria'].ToInteger;
    lLoggedUser   := TProviderAuthorization.GetLoggedUser(aReq);

    aRes
      .Send(lServiceCategoria.Delete(lLoggedUser.ID, lID_Categoria))
      .Status(THTTPStatus.OK)
  finally
    FreeAndNil(lServiceCategoria);
  end;

end;

class procedure TControllerCategoria.Post(aReq: THorseRequest; aRes: THorseResponse; aNext: TProc);
var
  lServiceCategoria:TServiceCategoria;
  lLoggedUser:TLoggedUser;
begin
  lServiceCategoria := TServiceCategoria.Create(nil);
  try
    lLoggedUser := TProviderAuthorization.GetLoggedUser(aReq);

    aRes
      .Send<TJsonObject>(lServiceCategoria.Post(lLoggedUser.ID, aReq.Body<TJsonObject>).ToJsonObject())
      .Status(THTTPStatus.Created);

  finally
    lServiceCategoria.Free;
  end;
end;

class procedure TControllerCategoria.Put(aReq: THorseRequest; aRes: THorseResponse; aNext: TProc);
var
  lServiceCategoria:TServiceCategoria;
  lID_Categoria:Integer;
  lLoggedUser:TLoggedUser;
begin
  lServiceCategoria := TServiceCategoria.Create(nil);
  try
    lID_Categoria := aReq.Params.Items['id_categoria'].ToInteger;
    lLoggedUser := TProviderAuthorization.GetLoggedUser(aReq);

    aRes
      .Send(lServiceCategoria.Put(lLoggedUser.ID, lID_Categoria, aReq.Body<TJsonObject>).ToJsonObject)
      .Status(THTTPStatus.OK);
  finally
    FreeAndNil(lServiceCategoria);
  end;

end;

end.
