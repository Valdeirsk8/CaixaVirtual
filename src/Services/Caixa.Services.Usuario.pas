unit Caixa.Services.Usuario;

interface

uses
  System.SysUtils, System.Classes, System.Json,

  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf,
  FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async,
  FireDAC.Phys, FireDAC.Phys.FB, FireDAC.Phys.FBDef, FireDAC.ConsoleUI.Wait,
  FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client,

  Data.DB,

  Horse, Ragna, DataSet.Serialize,

  Caixa.Providers.Connection, Caixa.Providers.Encrypt;

type
  TServiceUsuario = class(TProviderConnection)
    usuario: TFDQuery;
    usuarioID: TIntegerField;
    usuarioUSERNAME: TStringField;
    usuarioPASSWORD: TStringField;
    usuarioNAME: TStringField;
  private
    function GetUsurioWithEncryptedPassword(aUsuario:TJsonObject):TJsonObject;
  public
    function IsAValidUser(aUserName, aPassword:String):Boolean;
    function GetLoggedUser(aUserName, aPassword: String): TServiceUsuario;

    function Get: TFDQuery;
    function GetByID(aID_Usuario:Integer): TFDQuery;
    function Post(aUsuario: TJSONObject): TFDQuery;
    function Put(aID_Ususrio:Integer; aUsuario: TJSONObject): TFDQuery;
    function Delete(aID_Usuario:Integer): TJsonObject;
  end;

//var
//  ProviderConnection1: TProviderConnection1;


implementation

{%CLASSGROUP 'System.Classes.TPersistent'}

{$R *.dfm}

resourcestring
  __UserNotFound = 'Usuário não encontrado';

function TServiceUsuario.Get: TFDQuery;
begin
  usuarioPASSWORD.Visible := False;

  Result := Usuario.OpenUp;
end;

function TServiceUsuario.GetByID(aID_Usuario:Integer): TFDQuery;
begin
  usuarioPASSWORD.Visible := False;

  Result := Usuario
              .where(usuarioID)
              .Equals(aID_Usuario)
            .OpenUp;
end;

function TServiceUsuario.GetLoggedUser(aUserName, aPassword: String): TServiceUsuario;
begin
  usuario
    .Where(usuarioUSERNAME).Equals(aUserName)
    .&and(usuarioPASSWORD).equals(TProviderEncrypt.Encrypt(aPassword))
    .OpenUp;

  Result := Self;
end;

function TServiceUsuario.Post(aUsuario: TJSONObject): TFDQuery;
begin
  aUsuario := GetUsurioWithEncryptedPassword(aUsuario);

  Result := Usuario
              .New(aUsuario)
            .OpenUp;

   usuarioPASSWORD.Visible := False;
end;

function TServiceUsuario.Put(aID_Ususrio:Integer; aUsuario: TJSONObject): TFDQuery;
begin
  usuarioPASSWORD.Visible := False;
  aUsuario := GetUsurioWithEncryptedPassword(aUsuario);

  usuario
    .FindById(usuarioID, aID_Ususrio)
  .OpenUp;

  if usuario.IsEmpty then
    raise EHorseException.Create(ThttpStatus.NotFound, __UserNotFound);

  usuario.MergeFromJSONObject(aUsuario, False);

  Result := usuario;
end;

function TServiceUsuario.Delete(aID_Usuario:Integer): TJsonObject;
begin
  usuario
    .FindById(usuarioID, aID_Usuario)
  .OpenUp;

  usuarioPASSWORD.Visible := False;

  if usuario.IsEmpty then
    raise EHorseException.Create(THTTPStatus.NotFound, __UserNotFound);

  Result := usuario.ToJSONObject;

  usuario.delete;
end;

function TServiceUsuario.GetUsurioWithEncryptedPassword(aUsuario: TJsonObject): TJsonObject;
var
  Password: string;
begin
  Password := TProviderEncrypt.Encrypt(aUsuario.GetValue<string>(usuarioPASSWORD.FieldName.ToLower));
  aUsuario.RemovePair(usuarioPASSWORD.FieldName.ToLower);
  aUsuario.AddPair(usuarioPASSWORD.FieldName.ToLower, Password);

  Result := aUsuario;
end;

function TServiceUsuario.IsAValidUser(aUserName, aPassword: String): Boolean;
begin
  Result := not usuario
                 .Where(usuarioUSERNAME).Equals(aUserName)
                 .&and(usuarioPASSWORD).equals(TProviderEncrypt.Encrypt(aPassword))
                 .OpenUp
               .IsEmpty;

end;

end.
