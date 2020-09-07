unit DataSet.Serialize.Utils;

interface

uses System.DateUtils, System.JSON, Data.DB, DataSet.Serialize.BooleanField, System.SysUtils, System.Classes, System.Character;

type
  /// <summary>
  ///   API error class (default).
  /// </summary>
  EDataSetSerializeException = class(Exception);

  /// <summary>
  ///   Type to get key values of an dataset.
  /// </summary>
  TKeyValues = array of Variant;

  /// <summary>
  ///   Record representing the structure of a dataset field.
  /// </summary>
  TFieldStructure = record
    Alignment: TAlignment;
    FieldType: TFieldType;
    Size: Integer;
    Precision: Integer;
    FieldName: string;
    Origin: string;
    DisplayLabel: string;
    Key: Boolean;
    Required: Boolean;
    Visible: Boolean;
    ReadOnly: Boolean;
    AutoGenerateValue: TAutoRefreshFlag;
  end;

  TDataSetSerializeUtils = class
  public
    /// <summary>
    ///   Transform name in lower camel case pattern.
    /// </summary>
    /// <param name="AFieldName">
    ///   Field name to format.
    /// </param>
    /// <returns>
    ///   Field name in lower camel case format.
    /// </returns>
    class function NameToLowerCamelCase(const AFieldName: string): string;
    /// <summary>
    ///   Creates a new field in the DataSet.
    /// </summary>
    /// <param name="AFieldStructure">
    ///   Field structure to create a new field to dataset.
    /// </param>
    /// <param name="ADataSet">
    ///   DataSet that the field will be created.
    /// </param>
    /// <returns>
    ///   Return a new field.
    /// </returns>
    class function NewDataSetField(const ADataSet: TDataSet; const AFieldStructure: TFieldStructure): TField;
    /// <summary>
    ///   Converts a boolean to a TBooleanFieldType.
    /// </summary>
    /// <param name="ABooleanField">
    ///   Boolean field type.
    /// </param>
    /// <returns>
    ///   Returns a valid boolean field type.
    /// </returns>
    class function BooleanFieldToType(const ABooleanField: TBooleanField): TBooleanFieldType;
    /// <summary>
    ///   Creates a valid name for the field added to the DataSet.
    /// </summary>
    /// <param name="AName">
    ///   Field name.
    /// </param>
    /// <returns>
    ///   Returns a valid name.
    /// </returns>
    class function CreateValidIdentifier(const AName: string): string;
    /// <summary>
    ///   Converts a Boolean value to a JSONValue.
    /// </summary>
    /// <param name="AValue">
    ///   Refers to the Boolean value (True or False).
    /// </param>
    /// <returns>
    ///   Returns a JSONValue.
    /// </returns>
    class function BooleanToJSON(const AValue: Boolean): TJSONValue;
    /// <summary>
    ///   Remove the prefix "mt" or "qry" of an child dataset.
    /// </summary>
    class function FormatDataSetName(const ADataSetName: string): string;
  end;

implementation

uses DataSet.Serialize.Consts, DataSet.Serialize.Config;

{ TDataSetSerializeUtils }

class function TDataSetSerializeUtils.BooleanFieldToType(const ABooleanField: TBooleanField): TBooleanFieldType;
var
  I: Integer;
begin
  Result := bfUnknown;
  for I := Ord(low(TBooleanFieldType)) to Ord(high(TBooleanFieldType)) do
    if LowerCase(TBooleanFieldType(I).ToString).Equals(LowerCase(ABooleanField.Origin.Trim)) then
      Exit(TBooleanFieldType(I));
end;

class function TDataSetSerializeUtils.CreateValidIdentifier(const AName: string): string;
var
  I: Integer;
  LCharacter: Char;
begin
  I := 0;
  SetLength(Result, Length(AName));
  for LCharacter in AName do
  begin
    if CharInSet(LCharacter, ['A' .. 'Z', 'a' .. 'z', '0' .. '9', '_']) then
    begin
      Inc(I);
      Result[I] := LCharacter;
    end;
  end;
  SetLength(Result, I);
  if I = 0 then
    Result := '_'
  else if CharInSet(Result[1], ['0' .. '9']) then
    Result := '_' + Result;
end;

class function TDataSetSerializeUtils.NameToLowerCamelCase(const AFieldName: string): string;
var
  I: Integer;
  LUnderline: Boolean;
begin
  Result := EmptyStr;
  if not TDataSetSerializeConfig.GetInstance.LowerCamelCase then
    Exit(AFieldName.ToLower);
  LUnderline := False;
  for I := 1 to AFieldName.Length do
  begin
    if AFieldName[I] = '_' then
    begin
      LUnderline := True;
      Continue;
    end;
    if LUnderline then
    begin
      LUnderline := False;
      Result := Result + UpperCase(AFieldName[I]);
      Continue;
    end;
    if CharInSet(AFieldName[Pred(I)], ['a' .. 'z']) and CharInSet(AFieldName[I], ['A' .. 'Z']) then
      Result := Result + AFieldName[I]
    else
      Result := Result + LowerCase(AFieldName[I]);
  end;
  if Result.IsEmpty then
    Result := AFieldName;
end;

class function TDataSetSerializeUtils.FormatDataSetName(const ADataSetName: string): string;
var
  LPrefix: string;
begin
  Result := ADataSetName;
  for LPrefix in TDataSetSerializeConfig.GetInstance.DataSetPrefix do
    if ADataSetName.StartsWith(LPrefix) then
    begin
      Result := Copy(ADataSetName, Succ(LPrefix.Length), ADataSetName.Length - LPrefix.Length);
      Break;
    end;
  Result := Self.NameToLowerCamelCase(Result);
end;

class function TDataSetSerializeUtils.NewDataSetField(const ADataSet: TDataSet; const AFieldStructure: TFieldStructure): TField;
begin
  Result := DefaultFieldClasses[AFieldStructure.FieldType].Create(ADataSet);
  Result.Alignment := AFieldStructure.Alignment;
  Result.FieldName := AFieldStructure.FieldName;
  if Result.FieldName.Trim.IsEmpty then
    Result.FieldName := 'Field' + IntToStr(ADataSet.FieldCount + 1);
  Result.FieldKind := fkData;
  Result.DataSet := ADataSet;
  Result.Name := CreateValidIdentifier(ADataSet.Name + Result.FieldName);
  Result.Size := AFieldStructure.Size;

  case Result.DataType of
    ftBCD: 
      TBCDField(Result).Precision := AFieldStructure.Precision;
    ftFloat: 
      TFloatField(Result).Precision := AFieldStructure.Precision;
    ftSingle: 
      TSingleField(Result).Precision := AFieldStructure.Precision;
    ftExtended: 
      TExtendedField(Result).Precision := AFieldStructure.Precision;
    ftCurrency: 
      TCurrencyField(Result).Precision := AFieldStructure.Precision;
    ftFMTBcd: 
      TFMTBCDField(Result).Precision := AFieldStructure.Precision;
  end;

  Result.Visible := AFieldStructure.Visible;
  Result.ReadOnly := AFieldStructure.ReadOnly;
  Result.Required := AFieldStructure.Required;
  Result.Origin := AFieldStructure.Origin;
  Result.DisplayLabel := AFieldStructure.DisplayLabel;
  Result.AutoGenerateValue := AFieldStructure.AutoGenerateValue;
  if AFieldStructure.Key then
    Result.ProviderFlags := [pfInKey];
  if (AFieldStructure.FieldType in [ftString, ftWideString]) and (AFieldStructure.Size <= 0) then
    raise EDataSetSerializeException.CreateFmt(SIZE_NOT_DEFINED_FOR_FIELD, [AFieldStructure.FieldName]);
end;

class function TDataSetSerializeUtils.BooleanToJSON(const AValue: Boolean): TJSONValue;
begin
  if AValue then
    Result := TJSONTrue.Create
  else
    Result := TJSONFalse.Create;
end;

end.