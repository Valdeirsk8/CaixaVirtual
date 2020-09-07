program APICaixaVirtual;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,

  Horse,
  Horse.HandleException,
  Horse.Jhonson,
  Horse.BasicAuthentication,
  Horse.Compression,

  Caixa.Providers.Connection in 'src\Providers\Caixa.Providers.Connection.pas' {ProviderConnection: TDataModule},
  Caixa.Services.Categoria in 'src\Services\Caixa.Services.Categoria.pas' {ServiceCategoria: TDataModule},
  Caixa.Controllers.Categoria in 'src\Controllers\Caixa.Controllers.Categoria.pas',
  Caixa.Services.Usuario in 'src\Services\Caixa.Services.Usuario.pas' {ServiceUsuario: TDataModule},
  Caixa.Providers.Encrypt in 'src\Providers\Caixa.Providers.Encrypt.pas',
  Caixa.Controllers.Usuario in 'src\Controllers\Caixa.Controllers.Usuario.pas',
  Caixa.Providers.Authorization in 'src\Providers\Caixa.Providers.Authorization.pas',
  Caixa.Controllers.Login in 'src\Controllers\Caixa.Controllers.Login.pas',
  Caixa.Services.Movimentacao in 'src\Services\Caixa.Services.Movimentacao.pas' {ServiceMovimentacao: TDataModule},
  Caixa.Controllers.Movimentacao in 'src\Controllers\Caixa.Controllers.Movimentacao.pas',
  Caixa.Services.Movimentacao.Saldo in 'src\Services\Caixa.Services.Movimentacao.Saldo.pas' {ServiceMovimentacaoSaldo: TDataModule},
  Caixa.Controllers.Movimentacao.Saldo in 'src\Controllers\Caixa.Controllers.Movimentacao.Saldo.pas',
  Horse.HTTP in 'modules\horse\src\Horse.HTTP.pas';

begin
  ReportMemoryLeaksOnShutdown := True;

  THorse
   .Use(Compression())
   .Use(Jhonson)
   .Use(HandleException);

  Caixa.Controllers.Login.Registry;
  Caixa.Controllers.Usuario.Registry;
  Caixa.Controllers.Categoria.Registry;
  Caixa.Controllers.Movimentacao.Registry;
  Caixa.Controllers.Movimentacao.Saldo.Registry;

  THorse.Listen(9000,
    procedure(aHorse:THorse)
    begin
      WriteLn('Running');
      readln;
    end
  );

end.
