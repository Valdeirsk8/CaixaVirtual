inherited ServiceMovimentacaoSaldo: TServiceMovimentacaoSaldo
  OldCreateOrder = True
  inherited FDConnection: TFDConnection
    Connected = True
  end
  object movimentacoes: TFDQuery
    CachedUpdates = True
    AggregatesActive = True
    Connection = FDConnection
    SQL.Strings = (
      'select'
      '  movimentacoes.id,'
      '  movimentacoes.data,'
      '  movimentacoes.tipo,'
      '  movimentacoes.valor,'
      '  movimentacoes.descricao,'
      '  movimentacoes.categoriaid,'
      '  movimentacoes.userid,'
      
        '  (case when movimentacoes.tipo = '#39'Entrada'#39' then movimentacoes.v' +
        'alor else movimentacoes.valor * -1 end) valorSoma'
      ''
      ''
      'from movimentacoes')
    Left = 184
    Top = 40
    object movimentacoesID: TIntegerField
      FieldName = 'ID'
      Origin = 'ID'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
    end
    object movimentacoesDATA: TDateField
      FieldName = 'DATA'
      Origin = '"DATA"'
      Required = True
    end
    object movimentacoesTIPO: TStringField
      FieldName = 'TIPO'
      Origin = 'TIPO'
      Required = True
      Size = 10
    end
    object movimentacoesVALOR: TBCDField
      FieldName = 'VALOR'
      Origin = 'VALOR'
      Required = True
      Precision = 18
      Size = 2
    end
    object movimentacoesDESCRICAO: TStringField
      FieldName = 'DESCRICAO'
      Origin = 'DESCRICAO'
      Required = True
      Size = 80
    end
    object movimentacoesCATEGORIAID: TIntegerField
      FieldName = 'CATEGORIAID'
      Origin = 'CATEGORIAID'
      Visible = False
    end
    object movimentacoesUSERID: TIntegerField
      FieldName = 'USERID'
      Origin = 'USERID'
      Visible = False
    end
    object movimentacoesVALORSOMA: TBCDField
      AutoGenerateValue = arDefault
      FieldName = 'VALORSOMA'
      Origin = 'VALORSOMA'
      ProviderFlags = []
      ReadOnly = True
      Visible = False
      Precision = 18
      Size = 2
    end
    object movimentacoessaldoTotal: TAggregateField
      FieldName = 'saldoTotal'
      Active = True
      DisplayName = ''
      Expression = 'SUM(VALORSOMA)'
    end
  end
  object categoria: TFDQuery
    CachedUpdates = True
    IndexFieldNames = 'CATEGORIAID'
    AggregatesActive = True
    MasterSource = dsMovimentacoes
    MasterFields = 'CATEGORIAID'
    DetailFields = 'CATEGORIAID'
    Connection = FDConnection
    SQL.Strings = (
      'SELECT'
      '  CATEGORIA.ID,'
      '  CATEGORIA.ID CATEGORIAID,'
      '  CATEGORIA.NAME,'
      '  CATEGORIA.IDUSER'
      'FROM CATEGORIA WHERE ID = :CATEGORIAID')
    Left = 280
    Top = 40
    ParamData = <
      item
        Name = 'CATEGORIAID'
        DataType = ftInteger
        ParamType = ptInput
        Value = 22
      end>
    object categoriaID: TIntegerField
      FieldName = 'ID'
      Origin = 'ID'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
    end
    object categoriaNAME: TStringField
      FieldName = 'NAME'
      Origin = 'NAME'
      Size = 80
    end
    object categoriaIDUSER: TIntegerField
      FieldName = 'IDUSER'
      Origin = 'IDUSER'
      Visible = False
    end
    object categoriaCATEGORIAID: TIntegerField
      FieldName = 'CATEGORIAID'
      Origin = 'ID'
      ProviderFlags = []
      Visible = False
    end
  end
  object dsMovimentacoes: TDataSource
    DataSet = movimentacoes
    Left = 184
    Top = 88
  end
end
