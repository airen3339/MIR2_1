unit DrawScrn;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  DXDraws, DXClass, DirectX, IntroScn, Actor, cliUtil, clFunc,
  HUtil32;


const
   MAXSYSLINE = 8;

   BOTTOMBOARD = 1;
   VIEWCHATLINE = 9;
   AREASTATEICONBASE = 150;
   HEALTHBAR_BLACK = 0;
   HEALTHBAR_RED = 1;


type
   TDrawScreen = class
   private
      m_dwFrameTime       :LongWord;
      m_dwFrameCount      :LongWord;
      m_dwDrawFrameCount  :LongWord;
      m_SysMsgList        :TStringList;
   public
      CurrentScene: TScene;
      ChatStrs: TStringList;
      ChatBks: TList;
      ChatBoardTop: integer;

      HintList: TStringList;
      HintX, HintY, HintWidth, HintHeight: integer;
      HintUp: Boolean;
      HintColor: TColor;

      constructor Create;
      destructor Destroy; override;
      procedure KeyPress (var Key: Char);
      procedure KeyDown (var Key: Word; Shift: TShiftState);
      procedure MouseMove (Shift: TShiftState; X, Y: Integer);
      procedure MouseDown (Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
      procedure Initialize;
      procedure Finalize;
      procedure ChangeScene (scenetype: TSceneType);
      procedure DrawScreen (MSurface: TDirectDrawSurface);
      procedure DrawScreenTop (MSurface: TDirectDrawSurface);
      procedure AddSysMsg (msg: string);
      procedure AddChatBoardString (str: string; fcolor, bcolor: integer);
      procedure ClearChatBoard;

      procedure ShowHint (x, y: integer; str: string; color: TColor; drawup: Boolean);
      procedure ClearHint;
      procedure DrawHint (MSurface: TDirectDrawSurface);
   end;


implementation

uses
   ClMain, MShare, Share;
   

constructor TDrawScreen.Create;
var
   i: integer;
begin
   CurrentScene := nil;
   m_dwFrameTime := GetTickCount;
   m_dwFrameCount := 0;
   m_SysMsgList := TStringList.Create;
   ChatStrs := TStringList.Create;
   ChatBks := TList.Create;
   ChatBoardTop := 0;

   HintList := TStringList.Create;

end;

destructor TDrawScreen.Destroy;
begin
   m_SysMsgList.Free;
   ChatStrs.Free;
   ChatBks.Free;
   HintList.Free;
   inherited Destroy;
end;

procedure TDrawScreen.Initialize;
begin
end;

procedure TDrawScreen.Finalize;
begin
end;

procedure TDrawScreen.KeyPress (var Key: Char);
begin
   if CurrentScene <> nil then
      CurrentScene.KeyPress (Key);
end;

procedure TDrawScreen.KeyDown (var Key: Word; Shift: TShiftState);
begin
   if CurrentScene <> nil then
      CurrentScene.KeyDown (Key, Shift);
end;

procedure TDrawScreen.MouseMove (Shift: TShiftState; X, Y: Integer);
begin
   if CurrentScene <> nil then
      CurrentScene.MouseMove (Shift, X, Y);
end;

procedure TDrawScreen.MouseDown (Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
   if CurrentScene <> nil then
      CurrentScene.MouseDown (Button, Shift, X, Y);
end;

procedure TDrawScreen.ChangeScene (scenetype: TSceneType);
begin
   if CurrentScene <> nil then
      CurrentScene.CloseScene;
   case scenetype of
      stIntro:  CurrentScene := IntroScene;
      stLogin:  CurrentScene := LoginScene;
      stSelectCountry:  ;
      stSelectChr: CurrentScene := SelectChrScene;
      stNewChr:     ;
      stLoading:    ;
      stLoginNotice: CurrentScene := LoginNoticeScene;
      stPlayGame: CurrentScene := PlayScene;
   end;
   if CurrentScene <> nil then
      CurrentScene.OpenScene;
end;
//????????????
procedure TDrawScreen.AddSysMsg (msg: string);
begin
   if m_SysMsgList.Count >= 10 then m_SysMsgList.Delete (0);
   m_SysMsgList.AddObject (msg, TObject(GetTickCount));
end;
//??????????????
procedure TDrawScreen.AddChatBoardString (str: string; fcolor, bcolor: integer);
var
   i, len, aline: integer;
   dline, temp: string;
const
   BOXWIDTH = (SCREENWIDTH div 2 - 214) * 2{374}; //41 ??????????????
begin
   len := Length (str);
   temp := '';
   i := 1;
   while TRUE do begin
      if i > len then break;
      if byte (str[i]) >= 128 then begin
         temp := temp + str[i];
         Inc (i);
         if i <= len then temp := temp + str[i]
         else break;
      end else
         temp := temp + str[i];

      aline := FrmMain.Canvas.TextWidth (temp);
      if aline > BOXWIDTH then begin
         ChatStrs.AddObject (temp, TObject(fcolor));
         ChatBks.Add (Pointer(bcolor));
         str := Copy (str, i+1, Len-i);
         temp := '';
         break;
      end;
      Inc (i);
   end;
   if temp <> '' then begin
      ChatStrs.AddObject (temp, TObject(fcolor));
      ChatBks.Add (Pointer(bcolor));
      str := '';
   end;
   if ChatStrs.Count > 200 then begin
      ChatStrs.Delete (0);
      ChatBks.Delete (0);
      if ChatStrs.Count - ChatBoardTop < VIEWCHATLINE then Dec(ChatBoardTop);
   end else if (ChatStrs.Count-ChatBoardTop) > VIEWCHATLINE then begin
      Inc (ChatBoardTop);
   end;

   if str <> '' then
      AddChatBoardString (' ' + str, fcolor, bcolor);

end;
//????????????????????????????????????????
procedure TDrawScreen.ShowHint (x, y: integer; str: string; color: TColor; drawup: Boolean);
var
   data: string;
   w, h: integer;
begin
   ClearHint;
   HintX := x;
   HintY := y;
   HintWidth := 0;
   HintHeight := 0;
   HintUp := drawup;
   HintColor := color;
   while TRUE do begin
      if str = '' then break;
      str := GetValidStr3 (str, data, ['\']);
      w := FrmMain.Canvas.TextWidth (data) + 4{????} * 2;
      if w > HintWidth then HintWidth := w;
      if data <> '' then
         HintList.Add (data)
   end;
   HintHeight := (FrmMain.Canvas.TextHeight('A') + 1) * HintList.Count + 3{????} * 2;
   if HintUp then
      HintY := HintY - HintHeight;
end;

procedure TDrawScreen.ClearHint;
begin
   HintList.Clear;
end;

procedure TDrawScreen.ClearChatBoard;
begin
   m_SysMsgList.Clear;
   ChatStrs.Clear;
   ChatBks.Clear;
   ChatBoardTop := 0;
end;


procedure TDrawScreen.DrawScreen (MSurface: TDirectDrawSurface);
   procedure NameTextOut (surface: TDirectDrawSurface; x, y, fcolor, bcolor: integer; namestr: string);
   var
      i, row: integer;
      nstr: string;
   begin
      row := 0;
      for i:=0 to 10 do begin
         if namestr = '' then break;
         namestr := GetValidStr3 (namestr, nstr, ['\']);
         BoldTextOut (surface,
                      x - surface.Canvas.TextWidth(nstr) div 2,
                      y + row * 12,
                      fcolor, bcolor, nstr);
         Inc (row);
      end;
   end;
var
   i, k, line, sx, sy, fcolor, bcolor: integer;
   actor: TActor;
   str, uname: string;
   dsurface: TDirectDrawSurface;
   d: TDirectDrawSurface;
   rc: TRect;
   infoMsg :String;
begin
   MSurface.Fill(0);
   if CurrentScene <> nil then
      CurrentScene.PlayScene (MSurface);

   if GetTickCount - m_dwFrameTime > 1000 then begin
      m_dwFrameTime := GetTickCount;
      m_dwDrawFrameCount := m_dwFrameCount;
      m_dwFrameCount := 0;
   end;
   Inc (m_dwFrameCount);

   if g_MySelf = nil then exit;

   if CurrentScene = PlayScene then begin
      with MSurface do begin
         //???????? ???? ???? ???? ???? ????
         with PlayScene do begin
            for k:=0 to m_ActorList.Count-1 do begin  //????????????????????
               actor := m_ActorList[k];
         //????????????(????????)Jacky
         if g_boShowHPNumber and (actor.m_Abil.MaxHP > 1) and not actor.m_boDeath then begin
           SetBkMode (Canvas.Handle, TRANSPARENT);
           infoMsg:=IntToStr(actor.m_Abil.HP) + '/' + IntToStr(actor.m_Abil.MaxHP);
           BoldTextOut (MSurface,actor.m_nSayX - 15 ,actor.m_nSayY - 5, clWhite, clBlack,infoMsg );
           Canvas.Release;
         end;
             if g_boShowRedHPLable then actor.m_boOpenHealth:=True; //????????
               if (actor.m_boOpenHealth or actor.m_noInstanceOpenHealth) and not actor.m_boDeath then begin
                  if actor.m_noInstanceOpenHealth then
                     if GetTickCount - actor.m_dwOpenHealthStart > actor.m_dwOpenHealthTime then
                        actor.m_noInstanceOpenHealth := True;
                  d := g_WMain2Images.Images[HEALTHBAR_BLACK];
                  if d <> nil then
                     MSurface.Draw (actor.m_nSayX - d.Width div 2, actor.m_nSayY - 10, d.ClientRect, d, TRUE);
                  d := g_WMain2Images.Images[HEALTHBAR_RED];
                  if d <> nil then begin
                     rc := d.ClientRect;
                     if actor.m_Abil.MaxHP > 0 then
                        rc.Right := Round((rc.Right-rc.Left) / actor.m_Abil.MaxHP * actor.m_Abil.HP);
                     MSurface.Draw (actor.m_nSayX - d.Width div 2, actor.m_nSayY - 10, rc, d, TRUE);
                  end;
               end;
            end;
         end;

         //????????????????/??????????
         SetBkMode (Canvas.Handle, TRANSPARENT);
         if (g_FocusCret <> nil) and PlayScene.IsValidActor (g_FocusCret) then begin
            //if FocusCret.Grouped then uname := char(7) + FocusCret.UserName
            //else
            uname := g_FocusCret.m_sDescUserName + '\' + g_FocusCret.m_sUserName;
            NameTextOut (MSurface,
                      g_FocusCret.m_nSayX, // - Canvas.TextWidth(uname) div 2,
                      g_FocusCret.m_nSayY + 30,
                      g_FocusCret.m_nNameColor, clBlack,
                      uname);
         end;
         //????????
         if g_boSelectMyself then begin
            uname := g_MySelf.m_sDescUserName + '\' + g_MySelf.m_sUserName;
            NameTextOut (MSurface,
                      g_MySelf.m_nSayX, // - Canvas.TextWidth(uname) div 2,
                      g_MySelf.m_nSayY + 30,
                      g_MySelf.m_nNameColor, clBlack,
                      uname);
         end;

         Canvas.Font.Color := clWhite;

         //????????????????
         with PlayScene do begin
            for k:=0 to m_ActorList.Count-1 do begin
               actor := m_ActorList[k];
               if actor.m_SayingArr[0] <> '' then begin
                  if GetTickCount - actor.m_dwSayTime < 4 * 1000 then begin
                     for i:=0 to actor.m_nSayLineCount - 1 do  //??????????????????
                        if actor.m_boDeath then                //????????????/????????
                           BoldTextOut (MSurface,
                                     actor.m_nSayX - (actor.m_SayWidthsArr[i] div 2),
                                     actor.m_nSayY - (actor.m_nSayLineCount*16) + i*14,
                                     clGray, clBlack,
                                     actor.m_SayingArr[i])
                        else                      //??????????????/????????
                           BoldTextOut (MSurface,
                                     actor.m_nSayX - (actor.m_SayWidthsArr[i] div 2),
                                     actor.m_nSayY - (actor.m_nSayLineCount*16) + i*14,
                                     clWhite, clBlack,
                                     actor.m_SayingArr[i]);
                  end else                       //??????????4??
                     actor.m_SayingArr[0] := '';
               end;
            end;
         end;

         //BoldTextOut (MSurface, 0, 0, clWhite, clBlack, IntToStr(SendCount) + ' : ' + IntToStr(ReceiveCount));
         //BoldTextOut (MSurface, 0, 0, clWhite, clBlack, 'HITSPEED=' + IntToStr(Myself.HitSpeed));
         //BoldTextOut (MSurface, 0, 0, clWhite, clBlack, 'DupSel=' + IntToStr(DupSelection));
         //BoldTextOut (MSurface, 0, 0, clWhite, clBlack, IntToStr(LastHookKey));
         //BoldTextOut (MSurface, 0, 0, clWhite, clBlack,
         //             IntToStr(
         //                int64(GetTickCount - LatestSpellTime) - int64(700 + MagicDelayTime)
         //                ));
         //BoldTextOut (MSurface, 0, 0, clWhite, clBlack, IntToStr(PlayScene.EffectList.Count));
         //BoldTextOut (MSurface, 0, 0, clWhite, clBlack,
         //                  IntToStr(Myself.XX) + ',' + IntToStr(Myself.m_nCurrY) + '  ' +
         //                  IntToStr(Myself.ShiftX) + ',' + IntToStr(Myself.ShiftY));

         //System Message
         //???? ???? ???? (???? ????)
         if (g_nAreaStateValue and $04) <> 0 then begin
            BoldTextOut (MSurface, 0, 0, clWhite, clBlack, '????????');
         end;

         Canvas.Release;


         //??????????????16????0000000000000000 ????????????1???????????????????????????????? (??????????????????)
         k := 0;
         for i:=0 to 15 do begin
            if g_nAreaStateValue and ($01 shr i) <> 0 then begin
               d := g_WMainImages.Images[AREASTATEICONBASE + i];
               if d <> nil then begin
                  k := k + d.Width;
                  MSurface.Draw (SCREENWIDTH-k, 0, d.ClientRect, d, TRUE);
               end;
            end;
         end;

      end;
   end;
end;
//??????????????????
procedure TDrawScreen.DrawScreenTop (MSurface: TDirectDrawSurface);
var
   i, sx, sy: integer;
begin
   if g_MySelf = nil then exit;
      //??????????????????????????(????????????)
   if CurrentScene = PlayScene then begin
      with MSurface do begin
         SetBkMode (Canvas.Handle, TRANSPARENT);
         if m_SysMsgList.Count > 0 then begin
            sx := 30;
            sy := 40;
            for i:=0 to m_SysMsgList.Count-1 do begin
               BoldTextOut (MSurface, sx, sy, clGreen, clBlack, m_SysMsgList[i]);
               inc (sy, 16);
            end;
            //3??????????????????
            if GetTickCount - longword(m_SysMsgList.Objects[0]) >= 3000 then
               m_SysMsgList.Delete (0);
         end;
         Canvas.Release;
      end;
   end;
end;
//????????????
procedure TDrawScreen.DrawHint (MSurface: TDirectDrawSurface);
var
   d: TDirectDrawSurface;
   i, hx, hy, old: integer;
   str: string;
begin
   hx:=0;
   hy:=0;  //??????????
   if HintList.Count > 0 then begin
      d := g_WMainImages.Images[394];
      if d <> nil then begin
         if HintWidth > d.Width then HintWidth := d.Width;
         if HintHeight > d.Height then HintHeight := d.Height;
         if HintX + HintWidth > SCREENWIDTH then hx := SCREENWIDTH - HintWidth
         else hx := HintX;
         if HintY < 0 then hy := 0
         else hy := HintY;
         if hx < 0 then hx := 0;

         DrawBlendEx (MSurface, hx, hy, d, 0, 0, HintWidth, HintHeight, 0);
      end;
   end;
   //??????????????????????
   with MSurface do begin
      SetBkMode (Canvas.Handle, TRANSPARENT);
      if HintList.Count > 0 then begin
         Canvas.Font.Color := HintColor;
         for i:=0 to HintList.Count-1 do begin
            Canvas.TextOut (hx+4, hy+3+(Canvas.TextHeight('A')+1)*i, HintList[i]);
         end;
      end;

      if g_MySelf <> nil then begin
         
         //????????????
         //BoldTextOut (MSurface, 15, SCREENHEIGHT - 120, clWhite, clBlack, IntToStr(g_MySelf.m_Abil.HP) + '/' + IntToStr(g_MySelf.m_Abil.MaxHP));
         //????MP??
         //BoldTextOut (MSurface, 115, SCREENHEIGHT - 120, clWhite, clBlack, IntToStr(g_MySelf.m_Abil.MP) + '/' + IntToStr(g_MySelf.m_Abil.MaxMP));
         //??????????
         //BoldTextOut (MSurface, 655, SCREENHEIGHT - 55, clWhite, clBlack, IntToStr(g_MySelf.Abil.Exp) + '/' + IntToStr(g_MySelf.Abil.MaxExp));
         //????????????
         //BoldTextOut (MSurface, 655, SCREENHEIGHT - 25, clWhite, clBlack, IntToStr(g_MySelf.Abil.Weight) + '/' + IntToStr(g_MySelf.Abil.MaxWeight));


         if g_boShowGreenHint then begin
          str:= 'Time: ' + TimeToStr(Time) +
                ' Exp: ' + IntToStr(g_MySelf.m_Abil.Exp) + '/' + IntToStr(g_MySelf.m_Abil.MaxExp) +
                ' Weight: ' + IntToStr(g_MySelf.m_Abil.Weight) + '/' + IntToStr(g_MySelf.m_Abil.MaxWeight) +
                ' ' + g_sGoldName + ': ' + IntToStr(g_MySelf.m_nGold) +
                ' Cursor: ' + IntToStr(g_nMouseCurrX) + ':' + IntToStr(g_nMouseCurrY) + '(' + IntToStr(g_nMouseX) + ':' + IntToStr(g_nMouseY) + ')';
          if g_FocusCret <> nil then begin
            str:= str + ' Target: ' + g_FocusCret.m_sUserName + '(' + IntToStr(g_FocusCret.m_Abil.HP) + '/' + IntToStr(g_FocusCret.m_Abil.MaxHP) + ')';
          end else begin
            str:= str + ' Target: -/-';
          end;

          BoldTextOut (MSurface, 10, 0, clLime , clBlack, str);

          str:='';
         end;

         if g_boCheckBadMapMode then begin
              str := IntToStr(m_dwDrawFrameCount) +  ' '
              + '  Mouse ' + IntToStr(g_nMouseX) + ':' + IntToStr(g_nMouseY) + '(' + IntToStr(g_nMouseCurrX) + ':' + IntToStr(g_nMouseCurrY) + ')'
              + '  HP' + IntToStr(g_MySelf.m_Abil.HP) + '/' + IntToStr(g_MySelf.m_Abil.MaxHP)
              + '  D0 ' + IntToStr(g_nDebugCount)
              + ' D1 ' + IntToStr(g_nDebugCount1) + ' D2 '
              + IntToStr(g_nDebugCount2);
              BoldTextOut (MSurface, 10, 0, clWhite, clBlack, str);
         end;

         //old := Canvas.Font.Size;
         //Canvas.Font.Size := 8;
         //BoldTextOut (MSurface, 8, SCREENHEIGHT-42, clWhite, clBlack, ServerName);

         if g_boShowWhiteHint then begin
         if g_MySelf.m_nGameGold > 10 then begin
           BoldTextOut (MSurface, 8, SCREENHEIGHT-42, clWhite, clBlack, g_sGameGoldName + ' ' + IntToStr(g_MySelf.m_nGameGold));
         end else begin
           BoldTextOut (MSurface, 8, SCREENHEIGHT-42, clRed, clBlack, g_sGameGoldName + ' ' + IntToStr(g_MySelf.m_nGameGold));
         end;
         if g_MySelf.m_nGamePoint > 10 then begin
           BoldTextOut (MSurface, 8, SCREENHEIGHT-58, clWhite, clBlack, g_sGamePointName + ' ' + IntToStr(g_MySelf.m_nGamePoint));
         end else begin
           BoldTextOut (MSurface, 8, SCREENHEIGHT-58, clRed, clBlack, g_sGamePointName + ' ' + IntToStr(g_MySelf.m_nGamePoint));
         end;

         //????????????
         BoldTextOut (MSurface, 115, SCREENHEIGHT - 40, clWhite, clBlack, IntToStr(g_nMouseCurrX) + ':' + IntToStr(g_nMouseCurrY));
         //????????
         BoldTextOut (MSurface, 410, SCREENHEIGHT - 147, clWhite, clBlack, FormatDateTime('dddddd hh:mm:ss ampm', Now));
         end;

//         BoldTextOut (MSurface, 8, SCREENHEIGHT- 74, clWhite, clBlack, format('AllocMemCount:%d',[AllocMemCount]));
//         BoldTextOut (MSurface, 8, SCREENHEIGHT- 90, clWhite, clBlack, format('AllocMemSize:%d',[AllocMemSize div 1024]));

         BoldTextOut (MSurface, 8, SCREENHEIGHT-20, clWhite, clBlack, g_sMapTitle + ' ' + IntToStr(g_MySelf.m_nCurrX) + ':' + IntToStr(g_MySelf.m_nCurrY));
         //Canvas.Font.Size := old;
      end;
      //BoldTextOut (MSurface, 10, 20, clWhite, clBlack, IntToStr(DebugCount) + ' / ' + IntToStr(DebugCount1));
      Canvas.Release;
   end;
end;


end.
