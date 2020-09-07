unit Caixa.Services.Movimentacao;

interface

uses
  System.SysUtils, System.Classes, System.Json, System.Json.writers,

  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf,
  FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async,
  FireDAC.Phys, FireDAC.Phys.FB, FireDAC.Phys.FBDef, FireDAC.ConsoleUI.Wait,
  FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client,

  Data.DB,

  Horse, Ragna, DataSet.Serialize, DataSet.Serialize.Config,

  Caixa.Providers.Connection, Caixa.Services.Categoria;

type
  TServiceMovimentacao = class(TProviderConnection)
    movimentacao: TFDQuery;
    movimentacaoID: TIntegerField;
    movimentacaoDATA: TDateField;
    movimentacaoTIPO: TStringField;
    movimentacaoVALOR: TBCDField;
    movimentacaoDESCRICAO: TStringField;
    movimentacaoCATEGORIAID: TIntegerField;
    movimentacaoUSERID: TIntegerField;
  private
    function GetJsonCategoria(aID_Usuario, aID_Categoria:Integer): TJsonValue;
    function GetJsonMovimentacao():TJsonObject;
  public
    function GetByID(aID_Usuario, aID_Movimentacao: Integer): TJsonObject;
    function Post(aID_Usuario:Integer; aMovimentacao: TJSONObject): TJsonObject;
    function Put(aID_Usuario, aID_Movimentacao:Integer;  aMovimentacao: TJSONObject): TJsonObject;
    function Delete(aID_Usuario, aID_Movimentacao:Integer): TJsonObject;
  end;

var
  ServiceMovimentacao: TServiceMovimentacao;

implementation

{%CLASSGROUP 'System.Classes.TPersistent'}

{$R *.dfm}

ResourceString
  __NotFoundMov = 'Movimentação não encontrada';

function TServiceMovimentacao.GetByID(aID_Usuario, aID_Movimentacao: Integer): TJsonObject;
begin
  movimentacao
    .Where(movimentacaoID).Equals(aID_Movimentacao)
    .&And(movimentacaoUSERID).Equals(aID_Usuario)
  .OpenUp;

  if movimentacao.IsEmpty then
    raise EHorseException.Create(THTTPStatus.NotFound, __NotFoundMov);

  Result := GetJsonMovimentacao();
end;

function TServiceMovimentacao.Delete(aID_Usuario, aID_Movimentacao: Integer): TJsonObject;
begin
  movimentacao
    .Where(movimentacaoID).Equals(aID_Movimentacao)
    .&And(movimentacaoUSERID).Equals(aID_Usuario)
  .OpenUp;

  if movimentacao.IsEmpty then
    raise EHorseException.Create(THTTPStatus.NotFound, __NotFoundMov);

  Result := GetJsonMovimentacao();

  movimentacao.Delete;
end;

function TServiceMovimentacao.Post(aID_Usuario: Integer; aMovimentacao: TJSONObject): TJsonObject;
begin

  aMovimentacao.AddPair(movimentacaoUSERID.FieldName.ToLower, TJSONNumber.Create(aID_Usuario));
  aMovimentacao.AddPair(movimentacaoCATEGORIAID.FieldName.ToLower, TJSONNumber.Create(aMovimentacao.GetValue<TJsonObject>('categoria').GetValue<integer>('id')));
  aMovimentacao.RemovePair('categoria');

  movimentacao
    .New(aMovimentacao)
  .OpenUp;

  Result := GetJsonMovimentacao();
end;

function TServiceMovimentacao.Put(aID_Usuario, aID_Movimentacao: Integer; aMovimentacao: TJSONObject): TJsonObject;
begin
  aMovimentacao.AddPair(movimentacaoCATEGORIAID.FieldName.ToLower, TJSONNumber.Create(aMovimentacao.GetValue<TJsonObject>('categoria').GetValue<integer>('id')));
  aMovimentacao.RemovePair('categoria');

  movimentacao
    .Where(movimentacaoID).Equals(aID_Movimentacao)
    .&And(movimentacaoUSERID).Equals(aID_Usuario)
  .OpenUp;

  if movimentacao.IsEmpty then
    raise EHorseException.Create(THTTPStatus.NotFound, __NotFoundMov);

  movimentacao.MergeFromJSONObject(aMovimentacao, False);

  Result := GetJsonMovimentacao();
end;

function TServiceMovimentacao.GetJsonCategoria(aID_Usuario, aID_Categoria:Integer): TJsonValue;
Var
  lServiceCategoria:TServiceCategoria;
begin
  lServiceCategoria := TServiceCategoria.Create(nil);
  try
    Result := lServiceCategoria.GetByID(aID_Usuario, aID_Categoria).ToJSONObject
  finally
    FreeAndNil(lServiceCategoria);
  end;

end;

function TServiceMovimentacao.GetJsonMovimentacao(): TJsonObject;
begin

  movimentacaoUSERID.Visible      := False;
  movimentacaoCATEGORIAID.Visible := False;

  Result := movimentacao.ToJSONObject;
  Result.AddPair('categoria', GetJsonCategoria(movimentacaoUSERID.AsInteger, movimentacaoCATEGORIAID.AsInteger));
end;

end.
