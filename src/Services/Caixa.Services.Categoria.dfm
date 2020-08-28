inherited ServiceCategoria: TServiceCategoria
  OldCreateOrder = True
  Height = 277
  inherited FDConnection: TFDConnection
    Connected = True
    LoginPrompt = False
    Top = 40
  end
  object categoria: TFDQuery
    Connection = FDConnection
    SQL.Strings = (
      'select'
      '  categoria.id, categoria.name'
      'from categoria')
    Left = 216
    Top = 48
    object categoriaID: TIntegerField
      FieldName = 'ID'
      Origin = 'ID'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
      Required = True
    end
    object categoriaName: TStringField
      FieldName = 'NAME'
      Origin = 'NAME'
      Size = 80
    end
  end
end
