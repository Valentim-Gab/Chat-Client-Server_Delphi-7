program ChatClientServer;

uses
  Forms,
  Server in 'Server.pas' {Form1},
  Client in 'Client.pas' {Form2};

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'ChatClientServer';
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TForm2, Form2);
  Application.Run;
end.
