unit Caixa.Providers.Connection;

interface

uses
  System.SysUtils, System.Classes, System.IniFiles, System.IoUtils,


  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf,
  FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async,
  FireDAC.Phys, FireDAC.Phys.FB, FireDAC.Phys.FBDef, FireDAC.ConsoleUI.Wait,
  FireDAC.Comp.UI, FireDAC.Phys.IBBase, FireDAC.Comp.Client,

  Data.DB;

type
  TProviderConnection = class(TDataModule)
    FDConnection: TFDConnection;
    procedure FDConnectionBeforeConnect(Sender: TObject);
  private

  public

  end;

var
  ProviderConnection: TProviderConnection;

implementation

{%CLASSGROUP 'System.Classes.TPersistent'}

{$R *.dfm}

procedure TProviderConnection.FDConnectionBeforeConnect(Sender: TObject);
Var
  lIni:TIniFile;
begin
  lIni := TIniFile.Create(TPath.Combine(ExtractFilePath(ParamStr(0)), 'Config.ini'));
  try
    FDConnection.Params.Values['Database'] := lIni.ReadString('BANCO', 'DATABASE', '');
    FDConnection.Params.Values['Server']   := lIni.ReadString('BANCO', 'SERVER'  , '');;
    FDConnection.Params.Values['Port']     := lIni.ReadString('BANCO', 'PORT'    , '');;
  finally
    FreeAndNil(lIni);
  end;
end;

end.
