unit Caixa.Services.Categoria;

interface

uses
  System.SysUtils, System.Classes, System.Json,

  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf,
  FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async,
  FireDAC.Phys, FireDAC.Phys.FB, FireDAC.Phys.FBDef, FireDAC.ConsoleUI.Wait,
  FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client,

  Data.DB,

  Caixa.Providers.Connection,

  Ragna, DataSet.Serialize,

  Horse;

type
  TServiceCategoria = class(TProviderConnection)
    categoria: TFDQuery;
    categoriaID: TIntegerField;
    categoriaName: TStringField;
    categoriaIdUser: TIntegerField;
  private

  public
    function Get(aID_Usuario:Integer): TFDQuery;
    function GetByID(aID_Usuario, aID_Categoria: Integer): TFDQuery;
    function Post(aID_Usuario:Integer; aCategoria: TJSONObject): TFDQuery;
    function Put(aID_Usuario, aID_Categoria:Integer;  aCategoria: TJSONObject): TFDQuery;
    function Delete(aID_Usuario, aID_Categoria:Integer): TJsonObject;
  end;

//var
//  ServiceCategoria: TServiceCategoria;

implementation

{%CLASSGROUP 'System.Classes.TPersistent'}

{$R *.dfm}

{ TProviderConnection1 }

function TServiceCategoria.Delete(aID_Usuario, aID_Categoria:Integer): TJsonObject;
begin
  categoriaIdUser.Visible := False;

  Categoria
    .Where(categoriaID).Equals(aID_Categoria)
    .&And(categoriaIdUser).Equals(aID_Usuario)
  .OpenUp;

  if Categoria.IsEmpty then
    raise EHorseException.Create(THTTPStatus.NotFound, 'Categoria não encontrada.');

  Result := Categoria.toJsonObject;

  Categoria.Delete;
end;

function TServiceCategoria.Get(aID_Usuario:Integer): TFDQuery;
begin
  categoriaIdUser.Visible := false;

  Result := Categoria
              .where(categoriaIdUser).Equals(aID_Usuario)
            .OpenUp;
end;

function TServiceCategoria.GetByID(aID_Usuario, aID_Categoria: Integer): TFDQuery;
begin
  categoriaIdUser.Visible := false;
  Result := Categoria
              .Where(CategoriaID).Equals(aID_Categoria)
              .&And(categoriaIdUser).Equals(aID_Usuario)
            .OpenUp();
end;

function TServiceCategoria.Post(aID_Usuario:Integer; aCategoria: TJSONObject): TFDQuery;
begin
  aCategoria.AddPair(categoriaIdUser.FieldName.ToLower, TJSONNumber.Create(aID_Usuario) );
  Categoria.New(aCategoria).OpenUp;
  Result := Categoria;

  categoriaIdUser.Visible := False;
end;

function TServiceCategoria.Put(aID_Usuario, aID_Categoria:Integer;  aCategoria: TJSONObject): TFDQuery;
begin
  categoriaIdUser.Visible := false;

  Result := Categoria
              .where(CategoriaID).Equals(aID_Categoria)
              .&And(categoriaIdUser).equals(aID_Usuario)
            .OpenUp;

  if Categoria.IsEmpty then
    raise EHorseException.Create(ThttpStatus.NotFound, 'Categoria não encontrada');

  Categoria.MergeFromJSONObject(aCategoria, false);

//  Categoria.Edit;
//  categoriaName.AsString := aCategoria.GetValue<String>(categoriaName.FieldName.ToLower);
//  Categoria.Post;

end;

end.
