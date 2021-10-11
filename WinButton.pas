{*******************************************************************************
 * TWinButton
 * Component of WinEssential project (http://php4php.free.fr/winessential/
 *
 *******************************************************************************
 * Version 1.3 by MARTINEAU Emeric (php4php.free.fr) - 03/09/2007
 *
 * Add feature :
 *  HotImage
 *  TextColor
 *  HotTextColor
 *  DropDownMenu
 *  DropDownArrow
 *  ShowDropDownArrow
 *  WordWrap
 *  ShowFocusRect
 *  ToggleImage
 *  Interval
 *  OnTimer
 *
 * Rewriting DrawDisabledBitmap
 * Correct some show bug
 *
 * Activate Layout function
 * Correct little bug of positioning text
 *******************************************************************************
 * Version 1.2 by Jose Maria Ferri (jmferri@ozu.es)
 ******************************************************************************}
unit WinButton;

{$R TWinButton.res}

interface
uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, StdCtrls,
  Menus, ExtCtrls;
type
    TWinButtonLayout = (wbBitmapTop, wbBitmapBottom, wbBitmapLeft, wbBitmapRight);

    TWinButton = class(TButton)
    private
      FBitmap:TBitmap;
      FHotBitmap:TBitmap;
      FHotTextColor:TColor ;
      FTextColor:TColor ;
      FCaption:TCaption;
      FLayout: TWinButtonLayout;
      FOnEnter, FOnExit, FOnTimer: TNotifyEvent;
      FPushed:boolean;
      FShowCaption:boolean;
      MouseIn:boolean;
      rect:TRect;
      FDropDownMenu : TPopUpMenu ;
      FDownBitmap : TBitmap ;
      FShowDropDownArrow : boolean ;
      FDropDownArrow : TBitmap ;
      FShowFocusRect: Boolean;
      MouseTimer : TTimer ;
      FWordWrap : Boolean ;
      ToggleTimer : TTimer ;
      FToggleBitmap : TBitmap ;
      isToggle : boolean ;
      procedure CMDialogChar(var Message: TCMDialogChar); message CM_DIALOGCHAR;
      procedure OnMouseTimer(Sender : TObject) ;
    protected
      procedure CMMouseEnter(var msg: TMessage); message CM_MOUSEENTER;
      procedure CMMouseLeave(var msg: TMessage); message CM_MOUSELEAVE;
      procedure WMMouseLeftDown(var message:TWMLBUTTONDOWN); message WM_LBUTTONDOWN;
      procedure BitmapChange(Sender: TObject);
      procedure SetEnabled(value: Boolean); override;
      procedure SetBitmap(value:TBitmap);
      procedure SetHotBitmap(value:TBitmap);
      procedure SetDownBitmap(value:TBitmap);      
      procedure SetLayout(value: TWinButtonLayout);
      procedure SetCaption(value:TCaption);
      procedure SetFTextColor(Color : TColor);
      procedure SetShowCaption(value:boolean);
      procedure SetShowDropDownArrow(value:boolean);
      procedure SetDropDownArrowBitmap(value:TBitmap);
      procedure SetWordWrap(value:boolean);
      procedure SetShowFocusRect(value:boolean);
      procedure SetInterval(interval:integer) ;
      function  GetInterval : Integer ;
      procedure WMLButtonUp(var msg: TWMLButtonUp); message WM_LBUTTONUP;
      procedure WMPaint(var msg: TWMPaint); message WM_PAINT;
      procedure ToggleImageCall(Sender : TOBject) ;
      function GetTimerStatus : boolean ;
      procedure SetTimerStatus(value:boolean) ;      
    public
      constructor Create(Owner:TComponent); override;
      destructor Destroy; override;
    published
      property Action;
      property Anchors;
      property BiDiMode;
      property Cancel ;
      property Constraints ;
      property Cursor ;
      property Default ;
      property DragCursor ;
      property DragKind ;
      property DragMode ;
      property Enabled ;
      property Font ;
      property Height ;
      property HelpContext ;
      property HelpKeyword ;
      property HelpType ;
      property Hint ;
      property Left ;
      property ModalResult ;
      property Name ;
      property ParentBiDiMode ;
      property ParentFont ;
      property ParentShowHint ;
      property PopupMenu ;
      property ShowHint ;
      property TabOrder ;
      property TabStop ;
      property Tag ;
      property Top ;
      property Visible ;
      property Width ;
      { New feature }
      property BitmapLayout: TWinButtonLayout read FLayout write SetLayout;
      property Image:TBitmap read FBitmap write SetBitmap;
      property Layout:TWinButtonLayout read FLayout write SetLayout;
      property HotImage:TBitmap read FHotBitmap write SetHotBitmap;
      property DownImage:TBitmap read FDownBitmap write SetDownBitmap;
      property HotTextColor:TColor read FHotTextColor write FHotTextColor ;
      property TextColor:TColor read FTextColor write SetFTextColor ;
      property Caption: TCaption read FCaption write SetCaption;
      property OnEnter: TNotifyEvent read FOnEnter write FOnEnter;
      property OnExit: TNotifyEvent read FOnExit write FOnExit;
      property OnTimer: TNotifyEvent read FOnTimer write FOnTimer;      
      property ShowCaption: boolean read FShowCaption write SetShowCaption;
      property DropDownMenu : TPopUpMenu read FDropDownMenu write FDropDownMenu ;
      property ShowDropDownArrow: boolean read FShowDropDownArrow write SetShowDropDownArrow;
      property DropDownArrow:TBitmap read FDropDownArrow write SetDropDownArrowBitmap;
      property WordWrap:Boolean read FWordWrap write SetWordWrap;
      property ShowFocusRect:Boolean read FShowFocusRect write SetShowFocusRect;
      property Interval:Integer read GetInterval write SetInterval;
      property ToggleImage:TBitmap read FToggleBitmap write FToggleBitmap ;
      property ActivateToggle:boolean read GetTimerStatus write SetTimerStatus ;
    end;

procedure Register;

implementation
uses dialogs;
const
     { Bitmap Offset }
     bmOffsetX = 6;
     bmOffsetY = 6;
     { Text offset }
     txOffsetX = 4;
     txOffsetY = 4;
     { Space between texte & Image and Arrow}
     SpaceArrow = 2 ;
     { Space for focus rect }
     FocusRectX = 3 ;
     FocusRectY = 3 ;

// DrawTransparentBitmap:
// adapted from TExplorerButton by Fabrice Deville
procedure DrawTransparentBitmap(dc:HDC; bmp: TBitmap; xStart,yStart: Integer; cTransparentColor: LongInt);
var
   bm: TBitmap;
   cColor: TColorRef;
   bmAndBack, bmAndObject, bmAndMem, bmSave, oldBmp: HBITMAP;
   bmBackOld, bmObjectOld, bmMemOld, bmSaveOld, hBmp: HBITMAP;
   hdcMem, hdcBack, hdcObject, hdcTemp, hdcSave: HDC;
   ptSize: TPoint;
   temp_bitmap: TBitmap;
begin
     temp_bitmap := TBitmap.Create;
     temp_bitmap.Assign(bmp);
     try
          hBmp := temp_bitmap.Handle;
          hdcTemp := CreateCompatibleDC(dc);
          oldBmp := SelectObject(hdcTemp, hBmp);

          GetObject(hBmp, SizeOf(bm), @bm);
          ptSize.x := bmp.Width;
          ptSize.y := bmp.Height;

          hdcBack   := CreateCompatibleDC(dc);
          hdcObject := CreateCompatibleDC(dc);
          hdcMem    := CreateCompatibleDC(dc);
          hdcSave   := CreateCompatibleDC(dc);

          bmAndBack   := CreateBitmap(ptSize.x, ptSize.y, 1, 1, nil);

          bmAndObject := CreateBitmap(ptSize.x, ptSize.y, 1, 1, nil);

          bmAndMem    := CreateCompatibleBitmap(dc, ptSize.x, ptSize.y);
          bmSave      := CreateCompatibleBitmap(dc, ptSize.x, ptSize.y);

          bmBackOld   := SelectObject(hdcBack, bmAndBack);
          bmObjectOld := SelectObject(hdcObject, bmAndObject);
          bmMemOld    := SelectObject(hdcMem, bmAndMem);
          bmSaveOld   := SelectObject(hdcSave, bmSave);

          SetMapMode(hdcTemp, GetMapMode(dc));

          BitBlt(hdcSave, 0, 0, ptSize.x, ptSize.y, hdcTemp, 0, 0, SRCCOPY);

          cColor := SetBkColor(hdcTemp, cTransparentColor);

          BitBlt(hdcObject, 0, 0, ptSize.x, ptSize.y, hdcTemp, 0, 0, SRCCOPY);

          SetBkColor(hdcTemp, cColor);

          BitBlt(hdcBack, 0, 0, ptSize.x, ptSize.y, hdcObject, 0, 0, NOTSRCCOPY);
          BitBlt(hdcMem, 0, 0, ptSize.x, ptSize.y, dc, xStart, yStart, SRCCOPY);
          BitBlt(hdcMem, 0, 0, ptSize.x, ptSize.y, hdcObject, 0, 0, SRCAND);
          BitBlt(hdcTemp, 0, 0, ptSize.x, ptSize.y, hdcBack, 0, 0, SRCAND);
          BitBlt(hdcMem, 0, 0, ptSize.x, ptSize.y, hdcTemp, 0, 0, SRCPAINT);
          BitBlt(dc, xStart, yStart, ptSize.x, ptSize.y, hdcMem, 0, 0, SRCCOPY);
          BitBlt(hdcTemp, 0, 0, ptSize.x, ptSize.y, hdcSave, 0, 0, SRCCOPY);

          DeleteObject(SelectObject(hdcBack, bmBackOld));
          DeleteObject(SelectObject(hdcObject, bmObjectOld));
          DeleteObject(SelectObject(hdcMem, bmMemOld));
          DeleteObject(SelectObject(hdcSave, bmSaveOld));

          SelectObject(hdcTemp, oldBmp);

          DeleteDC(hdcMem);
          DeleteDC(hdcBack);
          DeleteDC(hdcObject);
          DeleteDC(hdcSave);
          DeleteDC(hdcTemp);
     finally
            temp_bitmap.Free;
     end;
end;

procedure DrawDisabledBitmap(DC:HDC; xStart, yStart: Integer; bmp: TBitmap; cTransparentColor: LongInt);
var X, Y : Integer ;
    MonoBmp : TBitmap ;
    DisabledColor : LongInt ;
begin
    MonoBmp := TBitmap.Create() ;
    MonoBmp.Dormant;

    MonoBmp.Height := bmp.Height ;
    MonoBmp.Width := bmp.Width ;

    DisabledColor := GetSysColor(COLOR_GRAYTEXT) ;

    for Y := 0 to bmp.Height - 1 do
    begin
        for X := 0 to bmp.Width - 1 do
        begin

            if Bmp.Canvas.Pixels[X, Y] <> cTransparentColor
            then begin
                MonoBmp.Canvas.Pixels[X, Y] := DisabledColor
                //SetPixel(DC, X+xStart, Y+yStart, Bmp.Canvas.Pixels[X, Y]) ;
            end
            else begin
                { (Bmp.Canvas.Pixels[X-1, Y] = -1) car si c'est la primère colone }
                if (Bmp.Canvas.Pixels[X-1, Y] = cTransparentColor) or (Bmp.Canvas.Pixels[X-1, Y] = -1)
                then
                    MonoBmp.Canvas.Pixels[X, Y] := Bmp.Canvas.Pixels[X, Y]
                    //SetPixel(DC, X, Y, Bmp.Canvas.Pixels[X, Y])
                else
                    MonoBmp.Canvas.Pixels[X, Y] := clWhite ;
                    //SetPixel(DC, X, Y, clWhite) ;
            end ;
        end ;
    end ;

    if (MonoBmp.Height > 0) and (MonoBmp.Width > 0)
    then begin
        DrawTransparentBitmap(dc, MonoBmp, xStart, yStart, cTransparentColor);
        MonoBmp.Free ;        
    end ;
end ;

constructor TWinButton.Create(Owner:TComponent);
begin
     inherited Create(Owner);
     ControlStyle := [csOpaque, csDoubleClicks];

     ToggleTimer := TTimer.Create(Self) ;
     ToggleTimer.OnTimer := ToggleImageCall ;
     isToggle := False ;
     
     MouseIn := False ;

     FTextColor := clBtnText ;
     FHotTextColor := clBtnText ;

     FWordWrap := false ;

     FShowDropDownArrow := False ;

     FToggleBitmap := TBitmap.Create ;
     FHotBitmap:=TBitmap.Create;
     FDownBitmap:=TBitmap.Create;
     FDropDownArrow := TBitmap.Create ;
     FDropDownArrow.Handle := LoadBitmap(hInstance,'arrow');

     FBitmap:=TBitmap.Create;
     FBitmap.OnChange := BitmapChange;

     FShowCaption:=true;
     FLayout:=wbBitmapLeft;

     if (csDesigning in ComponentState) and not (csLoading in TControl(Owner).ComponentState) then
     begin
          FCaption := 'WinButton';
     end;

     inherited Caption:='';

     Width:=75;
     Height:=25;
     MouseIn:=false;

     MouseTimer := TTimer.Create(Self) ;
     MouseTimer.Interval := 1 ;
     MouseTimer.Enabled := false ;
     MouseTimer.OnTimer := OnMouseTimer ;
end;

destructor TWinButton.Destroy;
begin
     FBitmap.free;
     FHotBitmap.Free ;
     FDownBitmap.Free ;
     FDropDownArrow.Free ;
     FToggleBitmap.Free ;
     ToggleTimer.Free ;          
     inherited;
end;

procedure TWinButton.SetBitmap(value:TBitmap);
begin
     FBitmap.Assign(value);
     if not FBitmap.Empty then
        FBitmap.Dormant;
     Repaint;
end;

procedure TWinButton.CMMouseEnter(var msg:TMessage);
begin
     MouseIn := True;
     if Enabled then
             Repaint;
     if Assigned(FOnEnter) then
             FOnEnter(Self);
end;

procedure TWinButton.CMMouseLeave(var msg:TMessage);
begin
     MouseIn := false;
     if Enabled then
             Repaint;
     if Assigned(FOnEnter) then
             FOnEnter(Self);
end;

procedure TWinButton.WMPaint(var msg: TWMPaint);
var
   tempDibX,tempDibY:integer;
   fo:HFONT;
   dc:HDC;
   BitmapWidth, BitmapHeight : Integer ;
   ArrowX, ArrowY : integer ;
begin
     inherited;
     fo:=self.Font.Handle;
     dc:=GetDC(Handle);
     selectObject(dc,fo);
     { Transparence pour le texte }
     SetBkMode(dc,TRANSPARENT);

     tempDibX:=0;
     TempDibY:=0;
     BitmapWidth := 0 ;
     BitmapHeight := 0 ;
     ArrowX := 0 ;
     ArrowY := 0 ;

     if MouseIn
     then begin
         if FPushed
         then begin
             BitmapWidth := FDownBitmap.Width ;
             BitmapHeight := FDownBitmap.Height ;
         end
         else begin
             BitmapWidth := FHotBitmap.Width ;
             BitmapHeight := FHotBitmap.Height ;
         end ;
     end
     else begin
         if not FBitmap.Empty
         then begin
             BitmapWidth := FBitmap.Width ;
             BitmapHeight := FBitmap.Height ;
         end ;
     end ;

     if FShowCaption then
     begin
          case FLayOut of
               wbBitmapTop:
               begin
                 if FShowDropDownArrow
                 then
                     tempDibX:=(Width div 2)-(BitmapWidth div 2) - FDropDownArrow.Width - SpaceArrow
                 else
                     tempDibX:=(Width div 2)-(BitmapWidth div 2);

                 TempDibY:=bmOffsetY;
               end;
               wbBitmapLeft:
               begin
                 TempDibX:=bmOffsetX ;

                 tempDibY:=(Height div 2) - (BitmapHeight div 2);
               end;
               wbBitmapRight:
               begin
                 if FShowDropDownArrow
                 then
                     tempDibX:=Width-BitmapWidth-bmOffsetX - FDropDownArrow.Width - SpaceArrow
                 else
                     tempDibX:=Width-BitmapWidth-bmOffsetX;

                 tempDibY:=(Height div 2) - (BitmapHeight div 2);
               end;
               wbBitmapBottom:
               begin

                 if FShowDropDownArrow
                 then
                     tempDibX:=(Width div 2)-(BitmapWidth div 2) - FDropDownArrow.Width - SpaceArrow
                 else
                     tempDibX:=(Width div 2)-(BitmapWidth div 2);

                 TempDibY:=Height-BitmapHeight-bmOffsetY;
               end;
          end;
     end
     else
     begin
          TempDibX:=(width div 2)-(BitmapWidth div 2) - FDropDownArrow.Width - SpaceArrow;
          TempDibY:=(Height div 2)-(BitmapHeight div 2);
     end;

     if FShowDropDownArrow
     then begin
         // Se positionne au milieu du bouton quelque soit l'alignement
         ArrowY := ((Height - FDropDownArrow.Height) div 2) ;
         ArrowX := Width - FDropDownArrow.Width - bmOffsetX ;
     end ;

(*    // para que al pulsar actue como los viejos botones, "Hundiendose"
     if enabled and  FPushed and MouseIn then
     begin
          tempDibX:=tempDibX+1;
          tempDibY:=tempDibY+1;
          TempTextX:=1;
          TempTextY:=1;

     end;
*)

     if (FCaption <> '') and (FShowCaption) then
     begin
          fo:=self.Font.Handle;
          SelectObject(dc,fo);

          case FLayout of
               wbBitmapTop:
               begin
                    rect.Top:=BitmapHeight+txOffsetY;
                    rect.Bottom:=Height-txOffsetY;

                    if FShowDropDownArrow
                    then
                        rect.Right:=width-txOffsetX - FDropDownArrow.Width - SpaceArrow
                    else
                        rect.Right:=width-txOffsetX ;
               end;
               wbBitmapLeft:
               begin
                    rect.Left:=BitmapWidth+txOffsetX;
                    rect.Top:=txOffsetY;
                    rect.Bottom:=Height-txOffsetY;

                    if FShowDropDownArrow
                    then
                        rect.Right:=Width-txOffsetX- FDropDownArrow.Width - SpaceArrow
                    else
                        rect.Right:=Width-txOffsetX ;
               end;
               wbBitmapBottom:
               begin
                    rect.Left:=txOffsetX;
                    rect.Top:=txOffsetY;
                    rect.Bottom:=height-BitmapHeight-txOffsetY;

                    if FShowDropDownArrow
                    then
                        rect.Right:=width-txOffsetY - FDropDownArrow.Width - SpaceArrow
                    else
                        rect.Right:=width-txOffsetY ;
               end;
               wbBitmapRight:
               begin
                    rect.Left:=txOffsetX;
                    rect.Top:=txOffsetY;
                    Rect.Bottom:=Height-txOffsetY;

                    if FShowDropDownArrow
                    then
                        Rect.Right:=Width-BitmapWidth-txOffsetX - FDropDownArrow.Width - SpaceArrow
                    else
                        Rect.Right:=Width-BitmapWidth-txOffsetX ;
               end;
          end;
     end;

     if enabled then
     begin
          if MouseIn
          then begin
              if FPushed
              then begin
                  DrawTransparentBitmap(DC,FDownBitmap,TempDibX,TempDibY,ColorToRGB(FDownBitmap.Canvas.Pixels[0, 0]));
              end
              else begin
                  DrawTransparentBitmap(DC,FHotBitmap,TempDibX,TempDibY,ColorToRGB(FHotBitmap.Canvas.Pixels[0, 0]));
              end ;
          end
          else begin
              if not FBitmap.Empty
              then begin
                  if isToggle
                  then
                      DrawTransparentBitmap(DC,FToggleBitmap,TempDibX,TempDibY,ColorToRGB(FBitmap.Canvas.Pixels[0, 0]))
                  else
                      DrawTransparentBitmap(DC,FBitmap,TempDibX,TempDibY,ColorToRGB(FBitmap.Canvas.Pixels[0, 0]));
              end ;
          end ;


          if MouseIn
          then
              SetTextColor(dc,FHotTextColor)
          else
              SetTextColor(dc,FTextColor) ;
              //SetTextColor(dc,GetSysColor(COLOR_BTNTEXT))

          if FShowDropDownArrow
          then
              DrawTransparentBitmap(DC,FDropDownArrow,arrowX,arrowY,ColorToRGB(FDropDownArrow.Canvas.Pixels[0, 0]));
     end
     else
     begin
          SetTextColor(dc,GetSysColor(COLOR_GRAYTEXT));
          DrawDisabledBitmap(dc,TempDibX,TempDibY,FBitmap, ColorToRGB(FDropDownArrow.Canvas.Pixels[0, 0]));

          if FShowDropDownArrow
          then
              DrawDisabledBitmap(dc,arrowX,arrowY,FDropDownArrow, ColorToRGB(FDropDownArrow.Canvas.Pixels[0, 0]));
     end;

     if (FCaption <> '') and (FShowCaption) then
     begin
         if FWordWrap
         then
             DrawText(dc,PChar(FCaption),length(FCaption),rect,DT_CENTER or DT_VCENTER or DT_WORDBREAK)
          else
             DrawText(dc,PChar(FCaption),length(FCaption),rect,DT_CENTER or DT_VCENTER);             
     end;

    if Self.Focused
    then begin
        DrawFocusRect(dc, Classes.rect(FocusRectX, FocusRectY, Width - FocusRectX, Height - FocusRectY)) ;
    end ;

     ReleaseDC(handle,dc);
end;

procedure TWinButton.BitmapChange(Sender: TObject);
begin
     if not FBitmap.Empty then
        FBitmap.Dormant;
     Repaint;
end;

procedure TWinButton.WMLButtonUp(var msg: TWMLButtonUp);
begin
     inherited;
     if Enabled and visible then
     begin
          FPushed:=false;
          repaint;
     end;
end;

procedure TWinButton.SetLayout(value: TWinButtonLayout);
begin
     if FLayout <> value then
     begin
          FLayout:=value;
          repaint;
     end;
end;

procedure TWinButton.SetEnabled(value: Boolean);
begin
     inherited;
     repaint;
end;

procedure TWinButton.SetShowCaption(value:boolean);
begin
     if FShowCaption <> value then
     begin
          FShowCaption:=value;
          repaint;
     end;
end;

procedure TWinButton.CMDialogChar(var Message: TCMDialogChar);
begin
  with Message do
    if IsAccel(CharCode, Caption) and CanFocus then
    begin
      Click;
      Result := 1;
    end else
      inherited;
end;

procedure TWinButton.SetCaption(value:TCaption);
begin
     if value <> FCaption then
     begin
          Perform(CM_TEXTCHANGED, 0, 0);
          FCaption:=value;
          Repaint;
     end;
end;

procedure TWinButton.SetFTextColor(Color : TColor);
begin
    FTextColor := Color ;
    Repaint ;
end ;

procedure TWinButton.SetHotBitmap(value:TBitmap);
begin
     FHotBitmap.Assign(value);
     if not FHotBitmap.Empty then
        FHotBitmap.Dormant;
     Repaint;
end;

procedure TWinButton.SetDownBitmap(value:TBitmap);
begin
     FDownBitmap.Assign(value);
     if not FDownBitmap.Empty then
        FDownBitmap.Dormant;
     Repaint;
end;

procedure TWinButton.WMMouseLeftDown(var message:TWMLBUTTONDOWN);
begin
    inherited;
    if Enabled and Visible then
    begin
         FPushed:=true;
         repaint;

         if Assigned(FDropDownMenu)
         then begin
             { Active un timer pour vérifier qu'on est plus sur le bouton }
             MouseTimer.Enabled := True ;
         end ;
    end;
end ;


procedure TWinButton.SetShowDropDownArrow(value:boolean);
begin
     if not Assigned(FDropDownMenu)
     then
         FShowDropDownArrow := False
     else
         FShowDropDownArrow := value ;

     Repaint;
end;

procedure TWinButton.SetDropDownArrowBitmap(value:TBitmap);
begin
     FDropDownArrow.Assign(value);
     if not FDropDownArrow.Empty then
        FDropDownArrow.Dormant;
     Repaint;
end;

procedure TWinButton.SetWordWrap(value:boolean);
begin
    FWordWrap := value ;
    Repaint;
end;

procedure TWinButton.OnMouseTimer(Sender : TObject) ;
begin
    FPushed:=False;
    MouseIn := false ;
    FDropDownMenu.Popup(ClientOrigin.X, ClientOrigin.Y + Height);
    MouseTimer.Enabled := False ;
end ;

procedure TWinButton.SetShowFocusRect(value:boolean);
begin
    FShowFocusRect := value ;
    Repaint;
end;

procedure TWinButton.SetInterval(interval:integer) ;
begin
    if Assigned(ToggleTimer)
    then
        ToggleTimer.Interval := interval ; 
end ;

function TWinButton.GetInterval : Integer ;
begin
    if Assigned(ToggleTimer)
    then
        Result := ToggleTimer.Interval
    else
        Result := 1000 ;

end ;

procedure TWinButton.ToggleImageCall(Sender : TOBject) ;
begin
    if Enabled
    then begin
        isToggle := not isToggle ;
        Repaint ;

        if Assigned(FOnTimer)
        then
            FOnTimer(Sender) ;
    end ;
end ;

function TWinButton.GetTimerStatus : boolean ;
begin
    Result := ToggleTimer.Enabled ;
end ;

procedure TWinButton.SetTimerStatus(value:boolean) ;
begin
    ToggleTimer.Enabled := value ;
end ;

procedure Register;
begin
     RegisterComponents('WinEssential', [TWinButton]);
end;

end.
