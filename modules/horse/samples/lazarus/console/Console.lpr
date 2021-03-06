program Console;

{$MODE DELPHI}{$H+}

uses
  Horse, SysUtils;

procedure GetPing(Req: THorseRequest; Res: THorseResponse; Next: TNextProc);
begin
  Res.Send('pong');
end;

procedure OnListen(Horse: THorse);
begin
  Writeln(Format('Server is runing on %s:%d', [Horse.Host, Horse.Port]));
end;

begin

  THorse.Get('/ping', GetPing);

  THorse.Listen(9000, OnListen);

end.
