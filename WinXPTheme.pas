{*******************************************************************************
 * TXPTheme
 * Component of WinEssential project (http://php4php.free.fr/winessential/
 *
 *******************************************************************************}
unit WinXPTheme;

interface

uses Classes ;

type
    TWinXPTheme = class(TComponent)
    end ;
procedure Register;

implementation

{$R WinXPTheme.res}

uses
  CommCtrl;

procedure Register;
begin
     RegisterComponents('WinEssential', [TWinXPTheme]);
end;

initialization
  { Note: This call is required! SetupLdr won't start without it. }
  InitCommonControls;
end.
