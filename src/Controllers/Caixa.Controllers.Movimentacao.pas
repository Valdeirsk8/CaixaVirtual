unit Caixa.Controllers.Movimentacao;

interface

Uses
  System.Json, System.Classes, System.SysUtils,

  Horse,

  Ragna,

  Caixa.Services.Movimentacao, Caixa.Providers.Authorization;

type
  TControllerMovimentacao = Class
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
    .Get   ('/movimentacao/:id_movimentacao/', TProviderAuthorization.Authorization, TControllermovimentacao.GetByID)
    .Post  ('/movimentacao/'                 , TProviderAuthorization.Authorization, TControllermovimentacao.Post)
    .put   ('/movimentacao/:id_movimentacao/', TProviderAuthorization.Authorization, TControllermovimentacao.Put)
    .Delete('/movimentacao/:id_movimentacao/', TProviderAuthorization.Authorization, TControllermovimentacao.Delete);
end;


class procedure TControllerMovimentacao.GetByID(aReq: THorseRequest; aRes: THorseResponse; aNext: TProc);
Var
  lServiceMovimentacao:TServiceMovimentacao;
  lID_Movimentacao:Integer;
  lLoggedUser:TLoggedUser;
begin
  lServiceMovimentacao := TServiceMovimentacao.Create(nil);
  try
    lID_Movimentacao := aReq.Params.Items['id_movimentacao'].ToInteger;
    lLoggedUser   := TProviderAuthorization.GetLoggedUser(aReq);

    aRes
      .Send(lServiceMovimentacao.GetByID(lLoggedUser.ID, lID_Movimentacao))
      .Status(THTTPStatus.OK);

  finally
    FreeAndNil(lServiceMovimentacao);
  end;


end;

class procedure TControllerMovimentacao.Post(aReq: THorseRequest; aRes: THorseResponse; aNext: TProc);
var
  lServiceMovimentacao:TServiceMovimentacao;
  lLoggedUser:TLoggedUser;
begin
  lServiceMovimentacao := TServiceMovimentacao.Create(nil);
  try
    lLoggedUser := TProviderAuthorization.GetLoggedUser(aReq);

    aRes
      .Send<TJsonObject>(lServiceMovimentacao.Post(lLoggedUser.ID, aReq.Body<TJsonObject>))
      .Status(THTTPStatus.Created);

  finally
    lServiceMovimentacao.Free;
  end;
end;

class procedure TControllerMovimentacao.Put(aReq: THorseRequest; aRes: THorseResponse; aNext: TProc);
var
  lServiceMovimentacao:TServiceMovimentacao;
  lID_Movimentacao:Integer;
  lLoggedUser:TLoggedUser;
begin
  lServiceMovimentacao := TServiceMovimentacao.Create(nil);
  try
    lID_Movimentacao := aReq.Params.Items['id_movimentacao'].ToInteger;
    lLoggedUser := TProviderAuthorization.GetLoggedUser(aReq);

    aRes
      .Send(lServiceMovimentacao.Put(lLoggedUser.ID, lID_Movimentacao, aReq.Body<TJsonObject>))
      .Status(THTTPStatus.OK);
  finally
    FreeAndNil(lServiceMovimentacao);
  end;

end;

class procedure TControllerMovimentacao.Delete(aReq: THorseRequest;aRes: THorseResponse; aNext: TProc);
Var
  lServiceMovimentacao:TServiceMovimentacao;
  lID_Movimentacao:Integer;
  lLoggedUser:TLoggedUser;
begin
  lServiceMovimentacao := TServiceMovimentacao.Create(nil);
  try
    lID_Movimentacao := aReq.Params.Items['id_movimentacao'].ToInteger;
    lLoggedUser   := TProviderAuthorization.GetLoggedUser(aReq);

    aRes
      .Send(lServiceMovimentacao.Delete(lLoggedUser.ID, lID_Movimentacao))
      .Status(THTTPStatus.OK)
  finally
    FreeAndNil(lServiceMovimentacao);
  end;
end;


end.
