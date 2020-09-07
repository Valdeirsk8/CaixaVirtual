inherited ServiceUsuario: TServiceUsuario
  OldCreateOrder = True
  inherited FDConnection: TFDConnection
    Connected = True
  end
  object usuario: TFDQuery
    Connection = FDConnection
    UpdateOptions.AssignedValues = [uvGeneratorName]
    UpdateOptions.GeneratorName = 'GEN_USUARIO_ID'
    UpdateOptions.AutoIncFields = 'ID'
    SQL.Strings = (
      'SELECT'
      '  USUARIO.ID,'
      '  USUARIO.USERNAME,'
      '  USUARIO."PASSWORD",'
      '  USUARIO.NAME'
      'FROM USUARIO')
    Left = 224
    Top = 24
    object usuarioID: TIntegerField
      AutoGenerateValue = arAutoInc
      FieldName = 'ID'
      Origin = 'ID'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
    end
    object usuarioUSERNAME: TStringField
      FieldName = 'USERNAME'
      Origin = 'USERNAME'
      Size = 80
    end
    object usuarioPASSWORD: TStringField
      FieldName = 'PASSWORD'
      Origin = '"PASSWORD"'
      Size = 80
    end
    object usuarioNAME: TStringField
      FieldName = 'NAME'
      Origin = 'NAME'
      Size = 80
    end
  end
end
