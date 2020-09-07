unit DataSet.Serialize;

interface

uses System.JSON, Data.DB, DataSet.Serialize.Language;

type
  TDataSetSerializeHelper = class Helper for TDataSet
  public
    /// <summary>
    ///   Creates a JSON object with the data from the current record of DataSet.
    /// </summary>
    /// <param name="AOnlyUpdatedRecords">
    ///   Exports only inserted, modified and deleted data from childs dataset.
    /// </param>
    /// <param name="AChildRecords">
    ///   Exports only childs records from child datasets.
    /// </param>
    /// <returns>
    ///   Returns a JSON object containing the record data.
    /// </returns>
    /// <remarks>
    ///   Invisible fields will not be generated.
    /// </remarks>
    function ToJSONObject(const AOnlyUpdatedRecords: Boolean = False; const AChildRecords: Boolean = True): TJSONObject;
    /// <summary>
    ///   Creates an array of JSON objects with all DataSet records.
    /// </summary>
    /// <param name="AOnlyUpdatedRecords">
    ///   Exports only inserted, modified and deleted data from childs dataset.
    /// </param>
    /// <param name="AChildRecords">
    ///   Exports only childs records from child datasets.
    /// </param>
    /// <returns>
    ///   Returns a JSONArray with all records from the DataSet.
    /// </returns>
    /// <remarks>
    ///   Invisible fields will not be generated.
    /// </remarks>
    function ToJSONArray(const AOnlyUpdatedRecords: Boolean = False; const AChildRecords: Boolean = True): TJSONArray;
    /// <summary>
    ///   Responsible for exporting the structure of a DataSet in JSON Array format.
    /// </summary>
    /// <returns>
    ///   Returns a JSON array with all fields of the DataSet.
    /// </returns>
    /// <remarks>
    ///   Invisible fields will not be generated.
    /// </remarks>
    function SaveStructure: TJSONArray;
    /// <summary>
    ///   Loads fields from a DataSet based on a JSONArray.
    /// </summary>
    /// <param name="AJSONArray">
    ///   Refers to JSON with field specifications.
    /// </param>
    /// <param name="AOwns">
    ///   Destroy JSON in the end.
    /// </param>
    procedure LoadStructure(const AJSONArray: TJSONArray; const AOwns: Boolean = True); overload;
    /// <summary>
    ///   Loads fields from a DataSet based on a JSON (string format).
    /// </summary>
    /// <param name="AJSONString">
    ///   Refers to JSON with field specifications.
    /// </param>
    procedure LoadStructure(const AJSONString: string); overload;
    /// <summary>
    ///   Loads the DataSet with data from a JSON object.
    /// </summary>
    /// <param name="AJSONObject">
    ///   Refers to JSON that you want to load.
    /// </param>
    /// <param name="AOwns">
    ///   Destroy JSON in the end.
    /// </param>
    /// <remarks>
    ///   Only the keys that make up the DataSet field list will be loaded. The JSON keys must have the same name as the
    ///   DataSet fields. It's not case-sensitive.
    /// </remarks>
    procedure LoadFromJSON(const AJSONObject: TJSONObject; const AOwns: Boolean = True); overload;
    /// <summary>
    ///   Loads the DataSet with data from a JSON array.
    /// </summary>
    /// <param name="AJSONArray">
    ///   Refers to JSON that you want to load.
    /// </param>
    /// <param name="AOwns">
    ///   Destroy JSON in the end.
    /// </param>
    /// <remarks>
    ///   Only the keys that make up the DataSet field list will be loaded. The JSON keys must have the same name as the
    ///   DataSet fields. It's not case-sensitive.
    /// </remarks>
    procedure LoadFromJSON(const AJSONArray: TJSONArray; const AOwns: Boolean = True); overload;
    /// <summary>
    ///   Loads the DataSet with data from a JSON (string format).
    /// </summary>
    /// <param name="AJSONString">
    ///   Refers to JSON that you want to load.
    /// </param>
    /// <remarks>
    ///   Only the keys that make up the DataSet field list will be loaded. The JSON keys must have the same name as the
    ///   DataSet fields. It's not case-sensitive.
    /// </remarks>
    procedure LoadFromJSON(const AJSONString: string); overload;
    /// <summary>
    ///   Updates the DataSet data with JSON object data.
    /// </summary>
    /// <param name="AJSONObject">
    ///   Refers to JSON that you want to merge.
    /// </param>
    /// <param name="AOwns">
    ///   Destroy JSON in the end.
    /// </param>
    procedure MergeFromJSONObject(const AJSONObject: TJSONObject; const AOwns: Boolean = True); overload;
    /// <summary>
    ///   Updates the DataSet data with JSON object data (string format).
    /// </summary>
    /// <param name="AJSONString">
    ///   Refers to JSON that you want to merge.
    /// </param>
    procedure MergeFromJSONObject(const AJSONString: string); overload;
    /// <summary>
    ///   Responsible for validating whether JSON has all the necessary information for a particular DataSet.
    /// </summary>
    /// <param name="AJSONObject">
    ///   Refers to JSON that must be validated.
    /// </param>
    /// <param name="ALang">
    ///   Language used to mount messages.
    /// </param>
    /// <param name="AOwns">
    ///   Destroy JSON in the end.
    /// </param>
    /// <returns>
    ///   Returns a JSONArray with the fields that were not informed.
    /// </returns>
    /// <remarks>
    ///   Walk the DataSet fields by checking the required property.
    ///   Uses the DisplayLabel property to mount the message.
    /// </remarks>
    function ValidateJSON(const AJSONObject: TJSONObject; const ALang: TLanguageType = enUS; const AOwns: Boolean = True): TJSONArray; overload;
    /// <summary>
    ///   Responsible for validating whether JSON has all the necessary information for a particular DataSet.
    /// </summary>
    /// <param name="AJSONString">
    ///   Refers to JSON that must be validated.
    /// </param>
    /// <param name="ALang">
    ///   Language used to mount messages.
    /// </param>
    /// <returns>
    ///   Returns a JSONArray with the fields that were not informed.
    /// </returns>
    /// <remarks>
    ///   Walk the DataSet fields by checking the required property.
    ///   Uses the DisplayLabel property to mount the message.
    /// </remarks>
    function ValidateJSON(const AJSONString: string; const ALang: TLanguageType = enUS): TJSONArray; overload;
  end;

implementation

uses System.SysUtils, DataSet.Serialize.Export, DataSet.Serialize.Import;

function TDataSetSerializeHelper.ToJSONArray(const AOnlyUpdatedRecords: Boolean = False; const AChildRecords: Boolean = True): TJSONArray;
var
  LDataSetSerialize: TDataSetSerialize;
begin
  LDataSetSerialize := TDataSetSerialize.Create(Self, AOnlyUpdatedRecords, AChildRecords);
  try
    Result := LDataSetSerialize.ToJSONArray;
  finally
    LDataSetSerialize.Free;
  end;
end;

function TDataSetSerializeHelper.ToJSONObject(const AOnlyUpdatedRecords: Boolean = False; const AChildRecords: Boolean = True): TJSONObject;
var
  LDataSetSerialize: TDataSetSerialize;
begin
  LDataSetSerialize := TDataSetSerialize.Create(Self, AOnlyUpdatedRecords, AChildRecords);
  try
    Result := LDataSetSerialize.ToJSONObject;
  finally
    LDataSetSerialize.Free;
  end;
end;

function TDataSetSerializeHelper.SaveStructure: TJSONArray;
var
  LDataSetSerialize: TDataSetSerialize;
begin
  LDataSetSerialize := TDataSetSerialize.Create(Self);
  try
    Result := LDataSetSerialize.SaveStructure;
  finally
    LDataSetSerialize.Free;
  end;
end;

function TDataSetSerializeHelper.ValidateJSON(const AJSONObject: TJSONObject; const ALang: TLanguageType = enUS; const AOwns: Boolean = True): TJSONArray;
var
  LJSONSerialize: TJSONSerialize;
begin
  LJSONSerialize := TJSONSerialize.Create(AJSONObject, AOwns);
  try
    Result := LJSONSerialize.Validate(Self, ALang);
  finally
    LJSONSerialize.Free;
  end;
end;

procedure TDataSetSerializeHelper.LoadFromJSON(const AJSONArray: TJSONArray; const AOwns: Boolean = True);
var
  LJSONSerialize: TJSONSerialize;
begin
  LJSONSerialize := TJSONSerialize.Create(AJSONArray, AOwns);
  try
    LJSONSerialize.ToDataSet(Self);
  finally
    LJSONSerialize.Free;
  end;
end;

procedure TDataSetSerializeHelper.LoadFromJSON(const AJSONObject: TJSONObject; const AOwns: Boolean = True);
var
  LJSONSerialize: TJSONSerialize;
begin
  LJSONSerialize := TJSONSerialize.Create(AJSONObject, AOwns);
  try
    LJSONSerialize.ToDataSet(Self);
  finally
    LJSONSerialize.Free;
  end;
end;

procedure TDataSetSerializeHelper.LoadStructure(const AJSONArray: TJSONArray; const AOwns: Boolean = True);
var
  LJSONSerialize: TJSONSerialize;
begin
  LJSONSerialize := TJSONSerialize.Create(AJSONArray, AOwns);
  try
    LJSONSerialize.LoadStructure(Self);
  finally
    LJSONSerialize.Free;
  end;
end;

procedure TDataSetSerializeHelper.MergeFromJSONObject(const AJSONObject: TJSONObject; const AOwns: Boolean = True);
var
  LJSONSerialize: TJSONSerialize;
begin
  LJSONSerialize := TJSONSerialize.Create(AJSONObject, AOwns);
  try
    LJSONSerialize.Merge(Self);
  finally
    LJSONSerialize.Free;
  end;
end;

function TDataSetSerializeHelper.ValidateJSON(const AJSONString: string; const ALang: TLanguageType): TJSONArray;
begin
  if Trim(AJSONString).StartsWith('{') then
    Result := ValidateJSON(TJSONObject.ParseJSONValue(TEncoding.UTF8.GetBytes(AJSONString), 0) as TJSONObject, ALang)
  else
    Result := TJSONArray.Create();
end;

procedure TDataSetSerializeHelper.LoadFromJSON(const AJSONString: string);
begin
  if Trim(AJSONString).StartsWith('{') then
    LoadFromJSON(TJSONObject.ParseJSONValue(TEncoding.UTF8.GetBytes(AJSONString), 0) as TJSONObject)
  else if Trim(AJSONString).StartsWith('[') then
    LoadFromJSON(TJSONObject.ParseJSONValue(TEncoding.UTF8.GetBytes(AJSONString), 0) as TJSONArray);
end;

procedure TDataSetSerializeHelper.LoadStructure(const AJSONString: string);
begin
  if Trim(AJSONString).StartsWith('[') then
    LoadStructure(TJSONObject.ParseJSONValue(TEncoding.UTF8.GetBytes(AJSONString), 0) as TJSONArray);
end;

procedure TDataSetSerializeHelper.MergeFromJSONObject(const AJSONString: string);
begin
  if Trim(AJSONString).StartsWith('{') then
    MergeFromJSONObject(TJSONObject.ParseJSONValue(TEncoding.UTF8.GetBytes(AJSONString), 0) as TJSONObject)
end;

end.
