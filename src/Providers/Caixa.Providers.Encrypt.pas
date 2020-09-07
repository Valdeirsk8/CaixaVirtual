unit Caixa.Providers.Encrypt;

interface

uses
  System.Classes, System.SysUtils, System.Hash;

type
  TProviderEncrypt = class
    class function Encrypt(aValue:String):String;
  end;

implementation

Const
  Secret = 'isThisASecretKey';


{ TProvidersEncrypt }

class function TProviderEncrypt.Encrypt(aValue: String): String;
begin
  Result := THashSHA2.GetHashString(aValue + '.' + Secret);
end;

end.
