unit TestSuperBouton;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, WinButton, ComCtrls, Menus, WinXPTheme, MoveAndResize,
  ExtCtrls;

type
  TForm1 = class(TForm)
    PopupMenu1: TPopupMenu;
    cvbc1: TMenuItem;
    xx1: TMenuItem;
    N1: TMenuItem;
    nnn1: TMenuItem;
    Button1: TButton;
    TreeView1: TTreeView;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Button1Click(Sender: TObject);
  private
    Bouton : TWinButton ;
    MAR : TMoveAndResize ;
    { Déclarations privées }
    procedure PanelResize(Sender: TObject);
  public
    { Déclarations publiques }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.FormCreate(Sender: TObject);
begin
    Bouton := TWinButton.Create(Self) ;
    Bouton.Parent := Self ;
    Bouton.Top := 40 ;
    Bouton.Width := 161 ;
    Bouton.Height := 80 ;
    Bouton.Left := 8 ;
    Bouton.Caption := 'TWinButton 0123456' ;
    Bouton.ShowCaption := True ;
    Bouton.Image.LoadFromFile('alertes-petit.bmp') ;
    Bouton.ToggleImage.LoadFromFile('disabled.bmp') ;
    Bouton.HotImage.LoadFromFile('alertes-petit-2.bmp') ;
    Bouton.DownImage.LoadFromFile('exit-petit.bmp') ;
    Bouton.HotTextColor := clAqua	;
    Bouton.TextColor := clRed	;
    Bouton.Layout := wbBitmapBottom ;
    // wbBitmapTop, wbBitmapBottom, wbBitmapLeft, wbBitmapRight
    Bouton.DropDownMenu := PopupMenu1 ;
    Bouton.ShowDropDownArrow := True ;
    Bouton.Interval := 500 ;
    Bouton.ActivateToggle := true ;

    Bouton.Enabled := true ;

    MAR := TMoveAndResize.Create(Self) ;
    MAR.Control := TreeView1 ;
    MAR.Movable := True ;
    MAR.Resizeable := True ;
    MAR.MinHeight := 10 ;
    MAR.MinWidth := 20 ;
    MAR.OnResize := PanelResize ;
end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
    Bouton.Free ;
    MAR.Free ;
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
    Bouton.Enabled := not Bouton.Enabled ;
    Bouton.ShowDropDownArrow := not Bouton.ShowDropDownArrow ;
    Bouton.Focused
end;

procedure TForm1.PanelResize(Sender: TObject);
begin
 Caption := IntToStr(TreeView1.Left) + 'x' + IntToStr(TreeView1.Top) ;
end;

end.
