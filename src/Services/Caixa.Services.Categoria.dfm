inherited ServiceCategoria: TServiceCategoria
  OldCreateOrder = True
  Height = 277
  inherited FDConnection: TFDConnection
    Connected = True
    Top = 40
  end
  object categoria: TFDQuery
    Connection = FDConnection
    UpdateOptions.AssignedValues = [uvGeneratorName]
    UpdateOptions.GeneratorName = 'GEN_CATEGORIA_ID'
    UpdateOptions.AutoIncFields = 'ID'
    SQL.Strings = (
      'select'
      '  categoria.id, categoria.name, categoria.iduser'
      'from categoria')
    Left = 216
    Top = 48
    object categoriaID: TIntegerField
      AutoGenerateValue = arAutoInc
      FieldName = 'ID'
      Origin = 'ID'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
    end
    object categoriaName: TStringField
      FieldName = 'NAME'
      Origin = 'NAME'
      Size = 80
    end
    object categoriaIdUser: TIntegerField
      FieldName = 'IDUSER'
      Origin = 'IDUSER'
    end
  end
end
