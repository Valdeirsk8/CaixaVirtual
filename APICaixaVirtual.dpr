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
  Caixa.Controllers.Categoria in 'src\Controllers\Caixa.Controllers.Categoria.pas';

begin
  THorse
   .Use(HandleException)
   .Use(Compression())
   .Use(Jhonson);

  THorse.Use(HorseBasicAuthentication(
    function(const AUsername, APassword: string): Boolean
    begin
      Result := AUsername.Equals('caixa') and APassword.Equals('API');
    end));

  THorse.Get('/ping',
    procedure(Req: THorseRequest; Res: THorseResponse; Next: TProc)
    begin
      Res.Send('pong');
    end);

  Caixa.Controllers.Categoria.Registry;

  THorse.Listen(9000,
    procedure(aHorse:THorse)
    begin
      WriteLn('Running');
      readln;
    end
  );

end.
