object ProviderConnection: TProviderConnection
  OldCreateOrder = False
  Height = 269
  Width = 441
  object FDConnection: TFDConnection
    Params.Strings = (
      'User_Name=sysdba'
      'Password=masterkey'
      
        'Database=C:\Users\Plenus Sofrware\Documents\Projects\CaixaVirtua' +
        'l\DataBase\DBCAIXAVIRTUAL.FDB'
      'Protocol=TCPIP'
      'Server=127.0.0.1'
      'Port=3051'
      'CharacterSet=WIN1252'
      'DriverID=FB')
    BeforeConnect = FDConnectionBeforeConnect
    Left = 48
    Top = 24
  end
end
