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

  Ragna;

type
  TServiceCategoria = class(TProviderConnection)
    categoria: TFDQuery;
    categoriaID: TIntegerField;
    categoriaName: TStringField;
  private

  public
    function Post(aCategoria: TJSONObject): TFDQuery;
    function Get: TFDQuery;
    function GetByID(aID_Categoria:Integer): TFDQuery;
    function Put(aCategoria: TJSONObject): TFDQuery;
    function Delete(aID_Categoria:Integer): TFDQuery;


  end;

var
  ServiceCategoria: TServiceCategoria;

implementation

{%CLASSGROUP 'System.Classes.TPersistent'}

{$R *.dfm}

{ TProviderConnection1 }

function TServiceCategoria.Delete(aID_Categoria:Integer): TFDQuery;
begin
  Result := Categoria
              .Remove(categoriaID, aID_Categoria)
            .OpenUp;
end;

function TServiceCategoria.Get: TFDQuery;
begin
  Result := Categoria.OpenUp;
end;

function TServiceCategoria.GetByID(aID_Categoria: Integer): TFDQuery;
begin
  Result := Categoria
              .Where(CategoriaID)
              .Equals(aID_Categoria)
            .OpenUp();
end;

function TServiceCategoria.Post(aCategoria: TJSONObject): TFDQuery;
begin
  Categoria.New(aCategoria).OpenUp;
  Result := Categoria;
end;

function TServiceCategoria.Put(aCategoria: TJSONObject): TFDQuery;
begin
  Result := Categoria
              .UpdateById(CategoriaID, aCategoria.GetValue<Integer>('id'), aCategoria)
            .OpenUp
end;

end.
