unit Caixa.Controllers.Categoria;

interface

Uses
  System.Json, System.Classes, System.SysUtils,

  Horse,

  Ragna,

  Caixa.Services.Categoria;

type
  TControllerCategoria = Class
    class procedure Get    (aReq: THorseRequest; aRes: THorseResponse; aNext: TProc);
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
    .Get   ('/categoria/'              , TControllerCategoria.Get)
    .Get   ('/categoria/:id_categoria/', TControllerCategoria.GetByID)
    .Post  ('/categoria/'              , TControllerCategoria.Post)
    .put   ('/categoria/:id_categoria/', TControllerCategoria.Put)
    .Delete('/categoria/:id_categoria/', TControllerCategoria.Delete);
end;

{ TControllerCategoria }
class procedure TControllerCategoria.Get(aReq: THorseRequest; aRes: THorseResponse; aNext: TProc);
Var
  lServiceCategoria:TServiceCategoria;
begin
  lServiceCategoria := TServiceCategoria.Create(nil);
  try
    aRes
      .Send(lServiceCategoria.Get.ToJSONArray)
      .Status(THTTPStatus.OK);
  finally
    FreeAndNil(lServiceCategoria);
  end;
end;

class procedure TControllerCategoria.GetByID(aReq: THorseRequest; aRes: THorseResponse; aNext: TProc);
Var
  lServiceCategoria:TServiceCategoria;
  lID_Categoria:Integer;
begin
  lServiceCategoria := TServiceCategoria.Create(nil);
  try
    lID_Categoria := aReq.Params.Items['id_categoria'].ToInteger;

    aRes
      .Send(lServiceCategoria.GetByID(lID_Categoria).ToJSONObject)
      .Status(THTTPStatus.OK);

  finally
    FreeAndNil(lServiceCategoria);
  end;

end;

class procedure TControllerCategoria.Delete(aReq: THorseRequest; aRes: THorseResponse; aNext: TProc);
Var
  lServiceCategoria:TServiceCategoria;
  lID_Categoria:Integer;
begin
  lServiceCategoria := TServiceCategoria.Create(nil);
  try
    lID_Categoria := aReq.Params.Items['id_categoria'].ToInteger;

    aRes
      .Send(lServiceCategoria.Delete(lID_Categoria).ToJsonArray)
      .Status(THTTPStatus.OK)
  finally
    FreeAndNil(lServiceCategoria);
  end;

end;

class procedure TControllerCategoria.Post(aReq: THorseRequest; aRes: THorseResponse; aNext: TProc);
var
  lServiceCategoria:TServiceCategoria;
begin
  lServiceCategoria := TServiceCategoria.Create(nil);
  try

    aRes
      .Send(lServiceCategoria.Post(aReq.Body<TJsonObject>).ToJsonObject)
      .Status(THTTPStatus.Created);

  finally
    FreeAndNil(lServiceCategoria);
  end;
end;

class procedure TControllerCategoria.Put(aReq: THorseRequest; aRes: THorseResponse; aNext: TProc);
var
  lServiceCategoria:TServiceCategoria;
  lBody:TJsonObject;
  lID_Categoria:Integer;
begin
  lServiceCategoria := TServiceCategoria.Create(nil);
  try
    lID_Categoria := aReq.Params.Items['id_categoria'].ToInteger;
    lBody := aReq.Body<TJsonObject>;
    lBody.AddPair(lServiceCategoria.categoriaID.FieldName, TJsonNumber.Create(lID_Categoria));

    aRes
      .Send(lServiceCategoria.Put(lBody).ToJsonObject)
      .Status(THTTPStatus.OK);
  finally
    FreeAndNil(lServiceCategoria);
  end;

end;

end.
