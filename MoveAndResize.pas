{*******************************************************************************
 * TMoveAndResize
 * Component of WinEssential project (http://php4php.free.fr/winessential/
 *
 * This program is free software; you can redistribute it and/or modify it under
 * the terms of the GNU General Public License as published by the Free Software
 * Foundation; either version 2 of the License, or (at your option) any later
 * version.
 *
 * This program is distributed in the hope that it will be useful, but WITHOUT
 * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
 * FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License along with
 * this program; if not, write to the Free Software Foundation, Inc., 59 Temple
 * Place, Suite 330, Boston, MA 02111-1307 USA
 *
 *******************************************************************************
 * Version 1.0 by MARTINEAU Emeric (php4php.free.fr) - 05/09/2007
 *
 * TODO
 *  dblClick stop move and resize
 *
 * CHANGE
 *  FOriginalOnMouseDown :=  TButton(FControl).OnMouseDown ;
 *  TButton(FControl).OnMouseDown := MyMouseDown ;
 ******************************************************************************}
unit MoveAndResize;

interface

uses
  Windows, Messages, SysUtils, Classes, ExtCtrls, Controls, Graphics, StdCtrls,
  Forms;

type
  TMoveAndResize = class(TWinControl)
  private
    { Déclarations privées }
    FControl : TWinControl ;
    FPanelCoinHautGauche : TPanel ;
    FPanelCoinHautDroit : TPanel ;
    FPanelCoinBasGauche : TPanel ;
    FPanelCoinBasDroit : TPanel ;
    FPanelGauche : TPanel ;
    FPanelDroit : TPanel ;
    FPanelHaut : TPanel ;
    FPanelBas : TPanel ;
    FMovable : boolean ;
    FResizeable : boolean ;
    FCursorHeight : Integer ;
    FCursorWidth : Integer ;
    FColor : TColor ;
    FCursorBevelInner : TBevelCut ;
    FCursorBevelOuter : TBevelCut ;
    FMinHeight : Integer ;
    FMinWidth : Integer ;
    FName : String ;
    // Pos of mouse on control when click. Use to keep pos mouse on control
    PosX : Integer ;
    PosY : Integer ;
    // Old cursor
    OldCursor : TCursor ;
    FOriginalOnMouseDown : procedure (Sender: TObject; Button: TMouseButton;
                                      Shift: TShiftState; X, Y: Integer) of object;
    FOriginalOnMouseMove : procedure (Sender: TObject; Shift: TShiftState; X,
                                      Y: Integer) of object;
    FOnResize : TNotifyEvent;
  protected
    { Déclarations protégées }
    procedure SetMovable(value:boolean) ;
    procedure SetControl(control:TWinControl) ;
    procedure SetCursorHeight(value:integer) ;
    procedure SetCursorWidth(value:integer) ;
    procedure SetColor(color:TColor) ;
    procedure SetCursorBevelInner(bevel:TBevelCut) ;
    procedure SetCursorBevelOuter(bevel:TBevelCut) ;
    procedure ShowCursor ;
    procedure CreateCursor ;
    procedure SetupCursor ;
    procedure SetResizable(value:boolean) ;
    procedure SetCursorCursor ;
    procedure MyMouseDown(Sender : TObject; Button: TMouseButton;
                          Shift: TShiftState; X, Y: Integer);
    procedure MyMouseMove(Sender: TObject; Shift: TShiftState; X,
                          Y: Integer);
    procedure CoinHautGaucheMouseMove(Sender: TObject; Shift: TShiftState; X,
                                      Y: Integer);
    procedure HautMouseMove(Sender: TObject; Shift: TShiftState; X,
                                                 Y: Integer);
    procedure ResizeMouseDown(Sender: TObject; Button: TMouseButton;
                                      Shift: TShiftState; X, Y: Integer);
    procedure GaucheMouseMove(Sender: TObject; Shift: TShiftState; X,
                                                  Y: Integer);
    procedure CoinHautDroitMouseMove(Sender: TObject; Shift: TShiftState; X,
                                                 Y: Integer);
    procedure DroitMouseMove(Sender: TObject; Shift: TShiftState; X,
                                                 Y: Integer);
    procedure BasMouseMove(Sender: TObject; Shift: TShiftState; X,
                                                 Y: Integer);
    procedure PanelCoinBasGaucheMouseMove(Sender: TObject; Shift: TShiftState; X,
                                                 Y: Integer);
    procedure PanelCoinBasDroitMouseMove(Sender: TObject; Shift: TShiftState; X,
                                                 Y: Integer);
  public
    { Déclarations publiques }
    constructor Create(Owner:TComponent); override;
    destructor Destroy; override;
  published
    { Déclarations publiées }
    property Name : String read FName write FName ;
    property Control : TWinControl read FControl write SetControl ;
    property Movable : boolean read FMovable write SetMovable ;
    property Resizeable : boolean read FResizeable write SetResizable ;
    property CursorHeight : integer read FCursorHeight write SetCursorHeight ;
    property CursorWidth : integer read FCursorWidth write SetCursorWidth ;
    property Color : TColor read FColor write SetColor ;
    property CursorBevelInner : TBevelCut read FCursorBevelInner write SetCursorBevelInner ;
    property CursorBevelOuter : TBevelCut read FCursorBevelOuter write SetCursorBevelOuter ;
    property MinHeight : Integer read FMinHeight write FMinHeight ;
    property MinWidth : Integer read FMinWidth write FMinWidth ;
    property OnResize: TNotifyEvent read FOnResize write FOnResize;
  end;

procedure Register;

implementation

constructor TMoveAndResize.Create(Owner:TComponent);
begin
    inherited ;

    CreateCursor ;

    FCursorHeight := 5 ;
    FCursorwidth := 5 ;

    CursorBevelInner := bvNone ;
    CursorBevelOuter := bvNone ;

    FColor := clBlack ;

    SetUpCursor ;

    FOriginalOnMouseMove := nil ;
    FOriginalOnMouseDown := nil ;

    FMinHeight := 0 ;
    FMinWidth := 0 ;
    
    // Disabled cursor
    OldCursor := -32768  ;

    Movable := False ;
    Resizeable := False ;
end ;

destructor TMoveAndResize.Destroy;
begin
    FPanelCoinHautGauche.Free ;
    FPanelCoinHautDroit.Free ;
    FPanelCoinBasGauche.Free ;
    FPanelCoinBasDroit.Free ;
    FPanelGauche.Free ;
    FPanelDroit.Free ;
    FPanelHaut.Free ;
    FPanelBas.Free ;

    inherited ;    
end ;

procedure TMoveAndResize.ShowCursor ;
begin
    FPanelCoinHautGauche.Top := FControl.Top - (FPanelCoinHautGauche.Height div 2);
    FPanelCoinHautGauche.Left := FControl.Left - (FPanelCoinHautGauche.Width div 2);
    FPanelCoinHautGauche.Visible := True ;

    FPanelCoinHautDroit.Top := FControl.Top - (FPanelCoinHautDroit.Height div 2);
    FPanelCoinHautDroit.Left := FControl.Left + FControl.Width - (FPanelCoinHautDroit.Width div 2) ;
    FPanelCoinHautDroit.Visible := True;

    FPanelCoinBasGauche.Top := FControl.Top + FControl.Height - (FPanelCoinBasGauche.Height div 2) ;
    FPanelCoinBasGauche.Left := FControl.Left - (FPanelCoinBasGauche.Width div 2);
    FPanelCoinBasGauche.Visible := True;

    FPanelCoinBasDroit.Top := FControl.Top + FControl.Height - (FPanelCoinBasDroit.Height div 2) ;
    FPanelCoinBasDroit.Left := FControl.Left + FControl.Width - (FPanelCoinBasDroit.Width div 2) ;
    FPanelCoinBasDroit.Visible := True;

    FPanelGauche.Top := FControl.Top + (FControl.Height div 2) - (FPanelGauche.Height div 2);
    FPanelGauche.Left := FControl.Left - (FPanelGauche.Width div 2);
    FPanelGauche.Visible := True;

    FPanelDroit.Top := FControl.Top + (FControl.Height div 2) - (FPanelDroit.Height div 2);
    FPanelDroit.Left := FControl.Left + FControl.Width - (FPanelDroit.Width div 2) ;
    FPanelDroit.Visible := True;

    FPanelHaut.Top := FControl.Top - (FPanelHaut.Height div 2) ;
    FPanelHaut.Left := FControl.Left + (FControl.Width div 2) - (FPanelHaut.Width div 2) ;
    FPanelHaut.Visible := True;

    FPanelBas.Top := FControl.Top + FControl.Height - (FPanelBas.Height div 2) ;
    FPanelBas.Left := FControl.Left + (FControl.Width div 2) - (FPanelBas.Width div 2) ;
    FPanelBas.Visible := True;
end ;

procedure TMoveAndResize.SetControl(control:TWinControl) ;
begin
    FControl := Control ;

    if Assigned(Control)
    then begin
        FPanelCoinHautGauche.Parent := FControl.Parent;
        FPanelCoinHautDroit.Parent := FControl.Parent;
        FPanelCoinBasGauche.Parent := FControl.Parent;
        FPanelCoinBasDroit.Parent := FControl.Parent;
        FPanelGauche.Parent := FControl.Parent;
        FPanelDroit.Parent := FControl.Parent;
        FPanelHaut.Parent := FControl.Parent;
        FPanelBas.Parent := FControl.Parent;
    end ;
end ;

procedure TMoveAndResize.SetCursorHeight(value:integer) ;
begin
    FPanelCoinHautGauche.Height := value ;
    FPanelCoinHautDroit.Height := value ;
    FPanelCoinBasGauche.Height := value ;
    FPanelCoinBasDroit.Height := value ;
    FPanelGauche.Height := value ;
    FPanelDroit.Height := value ;
    FPanelHaut.Height := value ;
    FPanelBas.Height := value ;
end ;

procedure TMoveAndResize.SetCursorWidth(value:integer) ;
begin
    FPanelCoinHautGauche.Width := value ;
    FPanelCoinHautDroit.Width := value ;
    FPanelCoinBasGauche.Width := value ;
    FPanelCoinBasDroit.Width := value ;
    FPanelGauche.Width := value ;
    FPanelDroit.Width := value ;
    FPanelHaut.Width := value ;
    FPanelBas.Width := value ;
end ;

procedure TMoveAndResize.SetColor(color:TColor) ;
begin
    FPanelCoinHautGauche.Color := color ;
    FPanelCoinHautDroit.Color := color ;
    FPanelCoinBasGauche.Color := color ;
    FPanelCoinBasDroit.Color := color ;
    FPanelGauche.Color := color ;
    FPanelDroit.Color := color ;
    FPanelHaut.Color := color ;
    FPanelBas.Color := color ;
end ;


procedure TMoveAndResize.SetCursorBevelInner(bevel:TBevelCut) ;
begin
    FPanelCoinHautGauche.BevelInner := bevel ;
    FPanelCoinHautDroit.BevelInner := bevel ;
    FPanelCoinBasGauche.BevelInner := bevel ;
    FPanelCoinBasDroit.BevelInner := bevel ;
    FPanelGauche.BevelInner := bevel ;
    FPanelDroit.BevelInner := bevel ;
    FPanelHaut.BevelInner := bevel ;
    FPanelBas.BevelInner := bevel ;
end ;


procedure TMoveAndResize.SetCursorBevelOuter(bevel:TBevelCut) ;
begin
    FPanelCoinHautGauche.BevelOuter := bevel ;
    FPanelCoinHautDroit.BevelOuter := bevel ;
    FPanelCoinBasGauche.BevelOuter := bevel ;
    FPanelCoinBasDroit.BevelOuter := bevel ;
    FPanelGauche.BevelOuter := bevel ;
    FPanelDroit.BevelOuter := bevel ;
    FPanelHaut.BevelOuter := bevel ;
    FPanelBas.BevelOuter := bevel ;
end ;


procedure TMoveAndResize.MyMouseDown(Sender : TObject; Button: TMouseButton;
                    Shift: TShiftState; X, Y: Integer);
Var P : TPoint ;
begin
    // Work but control fore ground
    //ReleaseCapture;
    //FControl.Perform(WM_SYSCOMMAND, SC_MOVE+2, 0);
    //ShowCursor ;
    GetCursorPos(P) ;

    PosY := P.Y - TWinControl(Sender).ClientOrigin.Y ;
    PosX := P.X - TWinControl(Sender).ClientOrigin.X ;
end ;

procedure TMoveAndResize.MyMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
Var P : TPoint ;
begin
    GetCursorPos(P) ;

    if ssLeft in Shift
    then begin
        TWinControl(Sender).Top := TWinControl(Sender).Top + (P.Y - TWinControl(Sender).ClientOrigin.Y) - PosY ;
        TWinControl(Sender).Left := TWinControl(Sender).Left + (P.X - TWinControl(Sender).ClientOrigin.X) - PosX ;
        ShowCursor ;
    end ;
end;

procedure TMoveAndResize.SetMovable(value:boolean) ;
begin
    if not (csDesigning in ComponentState)
    then begin
        FMovable := value ;

        if FMovable
        then begin
            if Assigned(FControl)
            then begin
                // Charge les curseurs
                ShowCursor ;
                // Met notre gestionnaire de souris
                FOriginalOnMouseDown :=  TButton(FControl).OnMouseDown ;
                FOriginalOnMouseMove :=  TButton(FControl).OnMouseMove ;
                TButton(FControl).OnMouseDown := MyMouseDown ;
                TButton(FControl).OnMouseMove := MyMouseMove ;
                OldCursor := FControl.Cursor ;
                FControl.Cursor := crSizeAll ;
            end ;
        end
        else begin
            if Assigned(FOriginalOnMouseDown)
            then
                TButton(FControl).OnMouseDown := FOriginalOnMouseDown ;

            if Assigned(FOriginalOnMouseMove)
            then
                TButton(FControl).OnMouseMove := FOriginalOnMouseMove ;

            FOriginalOnMouseMove := nil ;
            FOriginalOnMouseDown := nil ;

            if OldCursor <> -32768
            then
                FControl.Cursor := OldCursor ;
        end ;
    end ;
end ;

procedure TMoveAndResize.CreateCursor ;
begin
    FPanelCoinHautGauche := TPanel.Create(Self) ;
    FPanelCoinHautGauche.Caption := '' ;
    FPanelCoinHautGauche.Visible := False ;

    FPanelCoinHautDroit := TPanel.Create(Self) ;
    FPanelCoinHautDroit.Caption := '' ;
    FPanelCoinHautDroit.Visible := False ;

    FPanelCoinBasGauche := TPanel.Create(Self) ;
    FPanelCoinBasGauche.Caption := '' ;
    FPanelCoinBasGauche.Visible := False ;

    FPanelCoinBasDroit := TPanel.Create(Self) ;
    FPanelCoinBasDroit.Caption := '' ;
    FPanelCoinBasDroit.Visible := false ;

    FPanelGauche := TPanel.Create(Self) ;
    FPanelGauche.Caption := '' ;
    FPanelGauche.Visible := False ;

    FPanelDroit := TPanel.Create(Self) ;
    FPanelDroit.Caption := '' ;
    FPanelDroit.Visible := False ;

    FPanelHaut := TPanel.Create(Self) ;
    FPanelHaut.Caption := '' ;
    FPanelHaut.Visible := false ;

    FPanelBas := TPanel.Create(Self) ;
    FPanelBas.Caption := '' ;
    FPanelBas.Visible := false ;
end ;

procedure TMoveAndResize.SetupCursor ;
begin
    SetCursorHeight(FCursorHeight) ;
    SetCursorWidth(FCursorWidth) ;

    SetColor(FColor) ;

    SetCursorBevelInner(CursorBevelInner) ;
    SetCursorBevelOuter(CursorBevelInner) ;
end ;

procedure TMoveAndResize.SetCursorCursor ;
begin
    FPanelCoinHautGauche.Cursor := crSizeNWSE ;
    FPanelCoinHautDroit.Cursor := crSizeNESW ;
    FPanelCoinBasGauche.Cursor := crSizeNESW ;
    FPanelCoinBasDroit.Cursor := crSizeNWSE ;
    FPanelGauche.Cursor := crSizeWE ;
    FPanelDroit.Cursor := crSizeWE ;
    FPanelHaut.Cursor := crSizeNS ;
    FPanelBas.Cursor := crSizeNS ;
end ;

procedure TMoveAndResize.SetResizable(value:boolean) ;
begin
    if not (csDesigning in ComponentState)
    then begin
        FMovable := value ;

        if FMovable
        then begin
            if Assigned(FControl)
            then begin
                // Charge les curseurs
                ShowCursor ;
                // Affiche les curseurs de redimensionement
                SetCursorCursor ;
                // Met les gestionnaire de redimenssionnement
                FPanelCoinHautGauche.OnMouseMove := CoinHautGaucheMouseMove ;
                FPanelCoinHautGauche.OnMouseDown := ResizeMouseDown ;
                FPanelHaut.OnMouseMove := HautMouseMove ;
                FPanelHaut.OnMouseDown := ResizeMouseDown ;
                FPanelGauche.OnMouseMove := GaucheMouseMove ;
                FPanelGauche.OnMouseDown := ResizeMouseDown ;
                FPanelCoinHautDroit.OnMouseMove := CoinHautDroitMouseMove ;
                FPanelCoinHautDroit.OnMouseDown := ResizeMouseDown ;
                FPanelDroit.OnMouseMove := DroitMouseMove ;
                FPanelDroit.OnMouseDown := ResizeMouseDown ;
                FPanelBas.OnMouseMove := BasMouseMove ;
                FPanelBas.OnMouseDown := ResizeMouseDown ;
                FPanelCoinBasGauche.OnMouseMove := PanelCoinBasGaucheMouseMove ;
                FPanelCoinBasGauche.OnMouseDown := ResizeMouseDown ;
                FPanelCoinBasDroit.OnMouseMove := PanelCoinBasdroitMouseMove ;
                FPanelCoinBasDroit.OnMouseDown := ResizeMouseDown ;
            end ;
        end ;
    end ;
end ;

procedure TMoveAndResize.ResizeMouseDown(Sender: TObject; Button: TMouseButton;
                                                 Shift: TShiftState; X, Y: Integer);
Var P : TPoint ;
begin
    GetCursorPos(P) ;

    PosY := P.Y - TWincontrol(Sender).ClientOrigin.Y ;
    PosX := P.X - TWincontrol(Sender).ClientOrigin.X ;
end ;

procedure TMoveAndResize.CoinHautGaucheMouseMove(Sender: TObject; Shift: TShiftState; X,
                                                 Y: Integer);
Var P : TPoint ;
    NewTop, NewLeft : Integer ;
begin
    GetCursorPos(P) ;

    if ssLeft     in  Shift
    then begin
        { Le nouvelle position c'est la position actuel + (la diférence entre le
          control et la position de la souris) + décalage entre le coin du
          control et la position de la souris (pour garder la souris où il est
          sur le control) }
        {NewTop = TopOfCursor + (PosOfMouseCursor - PosOfControl) - OldPosOfMouse }
        NewTop := TWincontrol(Sender).Top + (P.Y - TWincontrol(Sender).ClientOrigin.Y) - PosY ;
        {NewLeft = LeftOfCursor + (PosOfMouseCursor - PosOfControl) - OldPosOfMouse }
        NewLeft := TWincontrol(Sender).Left + (P.X - TWincontrol(Sender).ClientOrigin.X) - PosX ;

        if ((NewTop + FMinHeight) < (TWincontrol(FControl).Top + TWincontrol(FControl).Height)) and
           (NewTop >= -(TWincontrol(Sender).Height div 2)) 
        then begin
            { On monte }
            TWincontrol(Sender).Top := NewTop ;
            FPanelCoinHautDroit.Top := NewTop ;
            FPanelHaut.Top := NewTop ;
            FControl.Top := NewTop + (TWincontrol(Sender).Height div 2) ;
            FControl.Height := FPanelBas.Top - TWincontrol(Sender).Top ;  //(FPanelBas.Top + (FPanelBas.Height div 2)) - FControl.Top ;
        end ;

        if ((NewLeft + FMinWidth) < (TWinControl(FControl).Left + TWinControl(FControl).Width)) and
           (NewLeft >= -(TWincontrol(Sender).Width div 2))
        then begin
            TWinControl(Sender).Left := NewLeft ;
            FPanelGauche.Left := NewLeft ;
            FPanelCoinBasGauche.Left := NewLeft ;
            FControl.Left := NewLeft + (TWincontrol(Sender).Width div 2) ;
            FControl.Width := FPanelDroit.Left - TWinControl(Sender).Left ; //(FPanelDroit.Left - (FPanelDroit.Width div 2)) - FControl.Top ;
        end ;

        if Assigned(FOnResize) then
             FOnResize(Self);
        
        FControl.RePaint ;
        ShowCursor ;
    end ;
end ;

procedure TMoveAndResize.HautMouseMove(Sender: TObject; Shift: TShiftState; X,
                                                 Y: Integer);
Var P : TPoint ;
    NewTop : Integer ;
begin
    GetCursorPos(P) ;

    if ssLeft     in  Shift
    then begin
        { Le nouvelle position c'est la position actuel + (la diférence entre le
          control et la position de la souris) + décalage entre le coin du
          control et la position de la souris (pour garder la souris où il est
          sur le control) }
        {NewTop = TopOfCursor + (PosOfMouseCursor - PosOfControl) - OldPosOfMouse }
        NewTop := TWincontrol(Sender).Top + (P.Y - TWincontrol(Sender).ClientOrigin.Y) - PosY ;

        if ((NewTop + FMinHeight) < (TWincontrol(FControl).Top + TWincontrol(FControl).Height)) and
           (NewTop >= -(TWincontrol(Sender).Height div 2))
        then begin
            { On monte }
            TWincontrol(Sender).Top := NewTop ;
            FControl.Top := NewTop + (TWincontrol(Sender).Height div 2) ;
            FControl.Height := FPanelBas.Top - TWincontrol(Sender).Top ;  //(FPanelBas.Top + (FPanelBas.Height div 2)) - FControl.Top ;
        end ;

        if Assigned(FOnResize) then
             FOnResize(Self);
        
        FControl.RePaint ;
        ShowCursor ;
    end ;
end ;

procedure TMoveAndResize.GaucheMouseMove(Sender: TObject; Shift: TShiftState; X,
                                                 Y: Integer);
Var P : TPoint ;
    NewLeft : Integer ;
begin
    GetCursorPos(P) ;

    if ssLeft     in  Shift
    then begin
        { Le nouvelle position c'est la position actuel + (la diférence entre le
          control et la position de la souris) + décalage entre le coin du
          control et la position de la souris (pour garder la souris où il est
          sur le control) }
        {NewLeft = LeftOfCursor + (PosOfMouseCursor - PosOfControl) - OldPosOfMouse }
        NewLeft := TWincontrol(Sender).Left + (P.X - TWincontrol(Sender).ClientOrigin.X) - PosX ;

        if ((NewLeft + FMinWidth) < (TWinControl(FControl).Left + TWinControl(FControl).Width)) and
           (NewLeft >= -(TWincontrol(Sender).Width div 2))
        then begin
            TWinControl(Sender).Left := NewLeft ;
            FControl.Left := NewLeft + (TWincontrol(Sender).Width div 2) ;
            FControl.Width := FPanelDroit.Left - TWinControl(Sender).Left ;
        end ;

        if Assigned(FOnResize) then
             FOnResize(Self);
        
        FControl.RePaint ;
        ShowCursor ;
    end ;
end ;

procedure TMoveAndResize.CoinHautDroitMouseMove(Sender: TObject; Shift: TShiftState; X,
                                                 Y: Integer);
Var P : TPoint ;
    NewTop, NewLeft : Integer ;
begin
    GetCursorPos(P) ;

    if ssLeft     in  Shift
    then begin
        { Le nouvelle position c'est la position actuel + (la diférence entre le
          control et la position de la souris) + décalage entre le coin du
          control et la position de la souris (pour garder la souris où il est
          sur le control) }
        {NewTop = TopOfCursor + (PosOfMouseCursor - PosOfControl) - OldPosOfMouse }
        NewTop := TWincontrol(Sender).Top + (P.Y - TWincontrol(Sender).ClientOrigin.Y) - PosY ;
        {NewLeft = LeftOfCursor + (PosOfMouseCursor - PosOfControl) - OldPosOfMouse }
        NewLeft := TWincontrol(Sender).Left + (P.X - TWincontrol(Sender).ClientOrigin.X) - PosX + TWincontrol(Sender).Width;

        if ((NewTop + FMinHeight) < (TWincontrol(FControl).Top + TWincontrol(FControl).Height)) and
           (NewTop >= -(TWincontrol(Sender).Height div 2))
        then begin
            { On monte }
            TWincontrol(Sender).Top := NewTop ;
            FPanelHaut.Top := NewTop ;
            FControl.Top := NewTop + (TWincontrol(Sender).Height div 2) ;
            FControl.Height := FPanelBas.Top - TWincontrol(Sender).Top ;  //(FPanelBas.Top + (FPanelBas.Height div 2)) - FControl.Top ;
        end ;

        if NewLeft > (FPanelCoinHautGauche.Left + FMinWidth)
        then begin
            TWinControl(Sender).Left := NewLeft ;
            FControl.Width := TWinControl(Sender).Left -  FControl.Left ; //(FPanelDroit.Left - (FPanelDroit.Width div 2)) - FControl.Top ;
        end ;

        if Assigned(FOnResize) then
             FOnResize(Self);
        
        FControl.RePaint ;
        ShowCursor ;
    end ;
end ;

procedure TMoveAndResize.DroitMouseMove(Sender: TObject; Shift: TShiftState; X,
                                                 Y: Integer);
Var P : TPoint ;
    NewLeft : Integer ;
begin
    GetCursorPos(P) ;

    if ssLeft     in  Shift
    then begin
        { Le nouvelle position c'est la position actuel + (la diférence entre le
          control et la position de la souris) + décalage entre le coin du
          control et la position de la souris (pour garder la souris où il est
          sur le control) }
        {NewLeft = LeftOfCursor + (PosOfMouseCursor - PosOfControl) - OldPosOfMouse }
        NewLeft := TWincontrol(Sender).Left + (P.X - TWincontrol(Sender).ClientOrigin.X) - PosX + TWincontrol(Sender).Width;

        if NewLeft > (FPanelCoinHautGauche.Left + FMinWidth)
        then begin
            TWinControl(Sender).Left := NewLeft ;
            FControl.Width := TWinControl(Sender).Left -  FControl.Left ; //(FPanelDroit.Left - (FPanelDroit.Width div 2)) - FControl.Top ;
        end ;

        if Assigned(FOnResize) then
             FOnResize(Self);
        
        FControl.RePaint ;
        ShowCursor ;
    end ;
end ;

procedure TMoveAndResize.BasMouseMove(Sender: TObject; Shift: TShiftState; X,
                                                 Y: Integer);
Var P : TPoint ;
    NewTop : Integer ;
begin
    GetCursorPos(P) ;

    if ssLeft     in  Shift
    then begin
        { Le nouvelle position c'est la position actuel + (la diférence entre le
          control et la position de la souris) + décalage entre le coin du
          control et la position de la souris (pour garder la souris où il est
          sur le control) }
        {NewTop = TopOfCursor + (PosOfMouseCursor - PosOfControl) - OldPosOfMouse }
        NewTop := TWincontrol(Sender).Top + (P.Y - TWincontrol(Sender).ClientOrigin.Y) - PosY ;

        if (NewTop < FControl.Parent.ClientHeight) and ((NewTop - FPanelHaut.Top) > FMinHeight)
        then begin
            { On monte }
            TWincontrol(Sender).Top := NewTop ;
            FControl.Height := TWincontrol(Sender).Top - FPanelHaut.Top;
        end ;

        if Assigned(FOnResize) then
             FOnResize(Self);
        
        FControl.RePaint ;
        ShowCursor ;
    end ;
end ;

procedure TMoveAndResize.PanelCoinBasGaucheMouseMove(Sender: TObject; Shift: TShiftState; X,
                                                 Y: Integer);
Var P : TPoint ;
    NewTop, NewLeft : Integer ;
begin
    GetCursorPos(P) ;

    if ssLeft     in  Shift
    then begin
        { Le nouvelle position c'est la position actuel + (la diférence entre le
          control et la position de la souris) + décalage entre le coin du
          control et la position de la souris (pour garder la souris où il est
          sur le control) }
        {NewTop = TopOfCursor + (PosOfMouseCursor - PosOfControl) - OldPosOfMouse }
        NewTop := TWincontrol(Sender).Top + (P.Y - TWincontrol(Sender).ClientOrigin.Y) - PosY ;
        {NewLeft = LeftOfCursor + (PosOfMouseCursor - PosOfControl) - OldPosOfMouse }
        NewLeft := TWincontrol(Sender).Left + (P.X - TWincontrol(Sender).ClientOrigin.X) - PosX + TWincontrol(Sender).Width;

        if (NewTop < FControl.Parent.ClientHeight) and ((NewTop - FPanelHaut.Top) > FMinHeight)
        then begin
            { On monte }
            TWincontrol(Sender).Top := NewTop ;
            FControl.Height := TWincontrol(Sender).Top - FPanelHaut.Top;
        end ;

        if ((NewLeft + FMinWidth) < (TWinControl(FControl).Left + TWinControl(FControl).Width)) and
           (NewLeft >= -(TWincontrol(Sender).Width div 2))
        then begin
            TWinControl(Sender).Left := NewLeft ;
            FControl.Left := NewLeft + (TWincontrol(Sender).Width div 2) ;
            FControl.Width := FPanelDroit.Left - TWinControl(Sender).Left ;
        end ;

        if Assigned(FOnResize) then
             FOnResize(Self);

        FControl.RePaint ;
        ShowCursor ;
    end ;
end ;

procedure TMoveAndResize.PanelCoinBasDroitMouseMove(Sender: TObject; Shift: TShiftState; X,
                                                 Y: Integer);
Var P : TPoint ;
    NewTop, NewLeft : Integer ;
begin
    GetCursorPos(P) ;

    if ssLeft     in  Shift
    then begin
        { Le nouvelle position c'est la position actuel + (la diférence entre le
          control et la position de la souris) + décalage entre le coin du
          control et la position de la souris (pour garder la souris où il est
          sur le control) }
        {NewTop = TopOfCursor + (PosOfMouseCursor - PosOfControl) - OldPosOfMouse }
        NewTop := TWincontrol(Sender).Top + (P.Y - TWincontrol(Sender).ClientOrigin.Y) - PosY ;
        {NewLeft = LeftOfCursor + (PosOfMouseCursor - PosOfControl) - OldPosOfMouse }
        NewLeft := TWincontrol(Sender).Left + (P.X - TWincontrol(Sender).ClientOrigin.X) - PosX + TWincontrol(Sender).Width;

        if (NewTop < FControl.Parent.ClientHeight) and ((NewTop - FPanelHaut.Top) > FMinHeight)
        then begin
            { On monte }
            TWincontrol(Sender).Top := NewTop ;
            FControl.Height := TWincontrol(Sender).Top - FPanelHaut.Top;
        end ;

        if NewLeft > (FPanelCoinHautGauche.Left + FMinWidth)
        then begin
            TWinControl(Sender).Left := NewLeft ;
            FControl.Width := TWinControl(Sender).Left -  FControl.Left ; //(FPanelDroit.Left - (FPanelDroit.Width div 2)) - FControl.Top ;
        end ;

        if Assigned(FOnResize) then
             FOnResize(Self);
                
        FControl.RePaint ;
        ShowCursor ;
    end ;
end ;

procedure Register;
begin
  RegisterComponents('WinEssential', [TMoveAndResize]);
end;

end.
