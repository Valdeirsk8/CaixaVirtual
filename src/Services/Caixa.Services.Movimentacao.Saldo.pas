unit Caixa.Services.Movimentacao.Saldo;

interface

uses
  System.SysUtils, System.Classes, System.Json,

  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf,
  FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async,
  FireDAC.Phys, FireDAC.Phys.FB, FireDAC.Phys.FBDef, FireDAC.ConsoleUI.Wait,
  FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client,

  Data.DB,

  Horse, Ragna, DataSet.Serialize.Config,

  Caixa.Providers.Connection;

type
  TServiceMovimentacaoSaldo = class(TProviderConnection)
    movimentacoes: TFDQuery;
    categoria: TFDQuery;
    dsMovimentacoes: TDataSource;
    movimentacoesID: TIntegerField;
    movimentacoesDATA: TDateField;
    movimentacoesTIPO: TStringField;
    movimentacoesVALOR: TBCDField;
    movimentacoesDESCRICAO: TStringField;
    movimentacoesCATEGORIAID: TIntegerField;
    movimentacoesUSERID: TIntegerField;
    categoriaID: TIntegerField;
    categoriaNAME: TStringField;
    categoriaIDUSER: TIntegerField;
    categoriaCATEGORIAID: TIntegerField;
    movimentacoessaldoTotal: TAggregateField;
    movimentacoesVALORSOMA: TBCDField;
  private
    { Private declarations }
  public
    function Get(aID_Usuario: Integer):TJsonObject;
  end;

var
  ServiceMovimentacaoSaldo: TServiceMovimentacaoSaldo;

implementation

{%CLASSGROUP 'System.Classes.TPersistent'}

{$R *.dfm}

ResourceString
  __NoContent = 'Nenhuma movimentação encontrada';

function TServiceMovimentacaoSaldo.Get(aID_Usuario: Integer): TJsonObject;
begin
  TDataSetSerializeConfig.GetInstance.Export.ExportChildDataSetAsJsonObject := True;

  movimentacoes
    .Where(movimentacoesUSERID).Equals(aID_Usuario)
  .OpenUp;

  if movimentacoes.IsEmpty then
    raise EHorseException.Create(THTTPStatus.NoContent, __NoContent );

  categoria.OpenUp;

  Result := TJSONObject.Create();
  Result.AddPair('saldoTotal', TJSONNumber.Create(movimentacoesSaldoTotal.Value));
  Result.AddPair('movimentacoes', movimentacoes.ToJSONArray);

end;

end.
