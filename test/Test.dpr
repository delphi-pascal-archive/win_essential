program Test;

uses
  Forms,
  TestSuperBouton in 'TestSuperBouton.pas' {Form1},
  WinButton in '..\WinButton.pas',
  WinXPTheme in '\..\WinXPTheme.pas' ;

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
