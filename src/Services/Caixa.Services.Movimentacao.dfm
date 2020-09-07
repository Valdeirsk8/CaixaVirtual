inherited ServiceMovimentacao: TServiceMovimentacao
  OldCreateOrder = True
  inherited FDConnection: TFDConnection
    Connected = True
  end
  object movimentacao: TFDQuery
    Connection = FDConnection
    UpdateOptions.AssignedValues = [uvGeneratorName]
    UpdateOptions.GeneratorName = 'GEN_MOVIMENTACOES_ID'
    UpdateOptions.AutoIncFields = 'ID'
    SQL.Strings = (
      'select'
      '  movimentacoes.id,'
      '  movimentacoes.data,'
      '  movimentacoes.tipo,'
      '  movimentacoes.valor,'
      '  movimentacoes.descricao,'
      '  movimentacoes.categoriaid,'
      '  movimentacoes.userid'
      'from movimentacoes')
    Left = 144
    Top = 24
    object movimentacaoID: TIntegerField
      AutoGenerateValue = arAutoInc
      FieldName = 'ID'
      Origin = 'ID'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
    end
    object movimentacaoDATA: TDateField
      FieldName = 'DATA'
      Origin = '"DATA"'
      DisplayFormat = 'dd/mm/yyyy hh:mm:ss'
    end
    object movimentacaoTIPO: TStringField
      FieldName = 'TIPO'
      Origin = 'TIPO'
      Size = 10
    end
    object movimentacaoVALOR: TBCDField
      FieldName = 'VALOR'
      Origin = 'VALOR'
      Precision = 18
      Size = 2
    end
    object movimentacaoDESCRICAO: TStringField
      FieldName = 'DESCRICAO'
      Origin = 'DESCRICAO'
      Size = 80
    end
    object movimentacaoCATEGORIAID: TIntegerField
      FieldName = 'CATEGORIAID'
      Origin = 'CATEGORIAID'
    end
    object movimentacaoUSERID: TIntegerField
      FieldName = 'USERID'
      Origin = 'USERID'
    end
  end
end
