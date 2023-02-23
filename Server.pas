unit Server;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ScktComp, Client, Buttons;

type
  TForm1 = class(TForm)
    ServerSocket1: TServerSocket;
    btnStart: TButton;
    Memo1: TMemo;
    btnSendMessage: TButton;
    Edit1: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    BitBtn1: TBitBtn;
    procedure btnStartClick(Sender: TObject);
    procedure btnSendMessageClick(Sender: TObject);
    procedure ServerSocket1ClientConnect(Sender: TObject;
      Socket: TCustomWinSocket);
    procedure ServerSocket1ClientDisconnect(Sender: TObject;
      Socket: TCustomWinSocket);
    procedure ServerSocket1ClientRead(Sender: TObject;
      Socket: TCustomWinSocket);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure BitBtn1Click(Sender: TObject);
  private
    MessageText: string;
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  Client: TForm2;

implementation

{$R *.dfm}

procedure TForm1.btnStartClick(Sender: TObject);
begin
  if not ServerSocket1.Active then
  begin
    ServerSocket1.Active := True;
    Memo1.Text := Memo1.Text + 'Server Started' + #13#10;
    btnStart.Caption := 'Stop';
  end
  else
  begin
    ServerSocket1.Active := False;
    Memo1.Text := Memo1.Text + 'Server Stopped' + #13#10;
    btnStart.Caption := 'Start';
    btnSendMessage.Enabled := False;
    Edit1.Enabled := False;
  end;
end;

procedure TForm1.btnSendMessageClick(Sender: TObject);
var
  I: Integer;
begin
  MessageText := Edit1.Text;
  Memo1.Text := Memo1.Text + 'Me: ' + MessageText + #13#10;
  Edit1.Text := '';
  for i := 0 to ServerSocket1.Socket.ActiveConnections - 1 do
    ServerSocket1.Socket.Connections[I].SendText(MessageText);
end;

procedure TForm1.ServerSocket1ClientConnect(Sender: TObject;
  Socket: TCustomWinSocket);
begin
  Socket.SendText('Connected');
  btnSendMessage.Enabled := True;
  Edit1.Enabled := True;
end;

procedure TForm1.ServerSocket1ClientDisconnect(Sender: TObject;
  Socket: TCustomWinSocket);
begin
  if ServerSocket1.Socket.ActiveConnections-1 = 0 then
  begin
    btnSendMessage.Enabled := False;
    Edit1.Enabled := False;
  end;
end;

procedure TForm1.ServerSocket1ClientRead(Sender: TObject;
  Socket: TCustomWinSocket);
begin
  Memo1.Text := Memo1.Text + 'Client(' + IntToStr(Socket.SocketHandle) +
    '): ' + Socket.ReceiveText + #13#10;
end;

procedure TForm1.FormShow(Sender: TObject);
begin
  Client := TForm2.Create(Application);
  Client.Show;
end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Client.Free;
end;

procedure TForm1.BitBtn1Click(Sender: TObject);
begin
  Memo1.Clear;
end;

end.
 