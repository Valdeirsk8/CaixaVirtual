unit Caixa.Controllers.Movimentacao.Saldo;

interface

Uses
  System.Json, System.Classes, System.SysUtils,

  Horse,

  Ragna,

  Caixa.Services.Movimentacao.Saldo, Caixa.Providers.Authorization;

type
  TControllerMovimentacaoSaldo = Class
    class procedure Get(aReq: THorseRequest; aRes: THorseResponse; aNext: TProc);
  end;

procedure Registry;

implementation

procedure Registry;
begin
  THorse
    .Get('/movimentacao/saldo/', TProviderAuthorization.Authorization, TControllermovimentacaoSaldo.Get);
end;

class procedure TControllerMovimentacaoSaldo.Get(aReq: THorseRequest; aRes: THorseResponse; aNext: TProc);
Var
  lServiceMovimentacaoSaldo:TServiceMovimentacaoSaldo;
  lLoggedUser:TLoggedUser;
begin
  lServiceMovimentacaoSaldo := TServiceMovimentacaoSaldo.Create(nil);
  try
    lLoggedUser := TProviderAuthorization.GetLoggedUser(aReq);

    aRes
      .Send(lServiceMovimentacaoSaldo.Get(lLoggedUser.ID))
      .Status(THTTPStatus.OK);

  finally
    FreeAndNil(lServiceMovimentacaoSaldo);
  end;
end;

end.
